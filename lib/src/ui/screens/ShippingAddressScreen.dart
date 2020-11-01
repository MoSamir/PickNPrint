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
import 'package:picknprint/src/ui/BaseScreen.dart';

import 'package:picknprint/src/ui/screens/AddNewShippingAddressScreen.dart';
import 'package:picknprint/src/ui/screens/AddressDeletionConfirmationScreen.dart';
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

  @override
  void initState() {
    super.initState();


    order = widget.userOrder;
    if(order.orderAddress == null &&  BlocProvider.of<UserBloc>(context).currentLoggedInUser.userSavedAddresses != null && BlocProvider.of<UserBloc>(context).currentLoggedInUser.userSavedAddresses.length > 0)
        order.orderAddress = BlocProvider.of<UserBloc>(context).currentLoggedInUser.userSavedAddresses[0];
  }


  @override
  Widget build(BuildContext context) {

    UserViewModel currentUser = BlocProvider.of<UserBloc>(context).currentLoggedInUser;

    return BaseScreen(
      hasDrawer: true,
      child: BlocConsumer(
        builder: (context , state){
          return ModalProgressHUD(
            inAsyncCall: state is UserDataLoadingState,
            child: SingleChildScrollView(
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
                    ListView.builder(
                      itemBuilder: (context , index){
                        return UserAddressCard(
                          address: currentUser.userSavedAddresses[index],
                          onEditAddress : _onEditAddress,
                          onDeleteAddress: _onRemoveAddress,
                          onSelectAddress : _onSelectAddress,
                          isChecked: order.orderAddress == currentUser.userSavedAddresses[index],
                        );
                      }
                      , physics: NeverScrollableScrollPhysics()
                      , itemCount: currentUser.userSavedAddresses.length ,
                      shrinkWrap: true,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderCreationScreen(orderModel: order,)));
                      },
                      child: Container(
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
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewShippingAddressScreen(comingFromRegistration: false,)));
                      },
                      child: Text((LocalKeys.ADD_NEW_ADDRESS).tr() , style: TextStyle(
                        color: AppColors.lightBlue,
                        decoration: TextDecoration.underline,
                      )  , textAlign: TextAlign.center,),
                    ),




                  ],
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
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewShippingAddressScreen(comingFromRegistration: false , addressModel: userSavedAddress,)));
    setState(() {});
  }
  void _onRemoveAddress(AddressViewModel userSavedAddress) async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddressDeletionConfirmationScreen(addressModel: userSavedAddress,)));
    setState(() {});
  }
  void _onSelectAddress(AddressViewModel userSavedAddress) {
    setState(() {
      order.orderAddress = userSavedAddress;
    });
  }
}
