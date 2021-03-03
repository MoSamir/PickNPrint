import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';

import 'package:picknprint/src/ui/screens/AddNewShippingAddressScreen.dart';
import 'package:picknprint/src/ui/screens/confirmation_screens/AddressDeletionConfirmationScreen.dart';

import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/UserAddressCard.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';

import 'OrderCreationScreen.dart';
class ShippingAddressScreen extends StatefulWidget {

  final OrderModel userOrder ;
  ShippingAddressScreen(this.userOrder);

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {


  OrderModel order ;
  TextEditingController phoneNumberController = TextEditingController();
  GlobalKey<FormState> _phoneNumberFormGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(BlocProvider.of<UserBloc>(context).currentLoggedInUser.userPhoneNumber != null){
      phoneNumberController.text = BlocProvider.of<UserBloc>(context).currentLoggedInUser.userPhoneNumber;
    }

    order = widget.userOrder;
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel currentUser = BlocProvider.of<UserBloc>(context).currentLoggedInUser;

    if(order != null && (order.orderAddress == null || order.orderAddress.id == null) &&  currentUser.userSavedAddresses != null && currentUser.userSavedAddresses.length > 0){
      order.orderAddress = currentUser.userSavedAddresses[0];
    }



    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer(
        listenWhen: (current,previous) => current != previous,
        buildWhen: (current,previous) => current != previous,
        builder: (context , state){
          return BaseScreen(
            hasDrawer: true,
            child: SingleChildScrollView(
              child: Form(
                key: _phoneNumberFormGlobalKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text((LocalKeys.SELECT_SHIPPING_ADDRESS).tr(), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.black,
                      ), textAlign: TextAlign.start,),
                      Text((LocalKeys.SOMEONE_WILL_CALL_YOU).tr(), style: TextStyle(
                        color: AppColors.lightBlue,
                      ), textAlign: TextAlign.start,),
                      Image(image: AssetImage(Resources.SHIPPING_ADDRESS_BANNER_IMG), width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .25, fit: BoxFit.cover,),


                      Card(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 10,),
                              Text((LocalKeys.CONFIRM_PHONE_NUMBER).tr()),
                              UIHelpers.buildTextField(
                                context: context,
                                validator: Validator.phoneValidator,
                                textController: phoneNumberController,
                                hint: (LocalKeys.CONFIRM_PHONE_NUMBER).tr(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ListView.builder(
                        itemBuilder: (context , index){
                          return UserAddressCard(
                            address: currentUser.userSavedAddresses[index],
                            onEditAddress : _onEditAddress,
                            onDeleteAddress: _onRemoveAddress,
                            onSelectAddress : _onSelectAddress,
                            isChecked:  order != null && order.orderAddress == currentUser.userSavedAddresses[index],
                          );
                        }
                        , physics: NeverScrollableScrollPhysics()
                        , itemCount: currentUser.userSavedAddresses.length ,
                        shrinkWrap: true,),
                      GestureDetector(
                        onTap: (){

                          if(order.orderAddress != null){
                          if(_phoneNumberFormGlobalKey.currentState.validate()) {
                            order.contactPhoneNumber = phoneNumberController.text;
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderCreationScreen(orderModel: order,)));
                          } } else {
                            UIHelpers.showToast((LocalKeys.PLEASE_ADD_ADDRESS_FIRST).tr(), true, true);
                            return;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          height: (50),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(child: Text((LocalKeys.SELECT_ADDRESS_AND_CONTINUE).tr(), style: TextStyle(color: AppColors.white),)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewShippingAddressScreen(order , comingFromRegistration: false, )));
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text((LocalKeys.ADD_NEW_ADDRESS).tr() , style: TextStyle(
                            color: AppColors.lightBlue,
                            decoration: TextDecoration.underline,
                          )  , textAlign: TextAlign.center,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context,  state){
          if (state is UserDataLoadingFailedState) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              UIHelpers.showNetworkError(context);
              return;
            }
            else if (state.error.errorCode == HttpStatus.serviceUnavailable) {
              UIHelpers.showToast((LocalKeys.SERVER_UNREACHABLE).tr(), true, true);
              return;
            }
            else {
              UIHelpers.showToast(state.error.errorMessage ?? '', true, true);
              return;
            }
          }
        },
        cubit: BlocProvider.of<UserBloc>(context),
      ),
    );
  }

  void _onEditAddress(AddressViewModel userSavedAddress) async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewShippingAddressScreen(order , comingFromRegistration: false , addressModel: userSavedAddress,)));
    setState(() {});
  }
  void _onRemoveAddress(AddressViewModel userSavedAddress) async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddressDeletionConfirmationScreen(addressModel: userSavedAddress,)));
    setState(() {});
  }
  void _onSelectAddress(AddressViewModel userSavedAddress) {
    setState(() {
      if(order == null) {
        order = widget.userOrder;
      }
      order.orderAddress = userSavedAddress;
    });
  }
}
