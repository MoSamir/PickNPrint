import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/ApplicationDataState.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';

import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/screens/LocationSelectionScreen.dart';
import 'package:picknprint/src/ui/screens/OrderCreationScreen.dart';
import 'package:picknprint/src/ui/screens/ShippingAddressScreen.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';
class AddNewShippingAddressScreen extends StatefulWidget {

  final bool comingFromRegistration ;

  // in case of new address the user should be directed to the shipping Location screen not back home
  final OrderModel userOrderModel ;
  final AddressViewModel addressModel ;
  AddNewShippingAddressScreen(this.userOrderModel , {this.comingFromRegistration , this.addressModel});
  @override
  _AddNewShippingAddressScreenState createState() => _AddNewShippingAddressScreenState();
}

class _AddNewShippingAddressScreenState extends State<AddNewShippingAddressScreen> {


  TextEditingController addressTextController , buildingNumberTextController , addressLandmarkTextController;
  FocusNode addressFocusNode , buildingNumberFocusNode , addressLandmarkFocusNode;
  LocationModel selectedCity , selectedArea ;
  GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initFormData();

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      listener: (context , state){

        if (state is UserDataLoadingFailedState) {
          if (state.error.errorCode == HttpStatus.requestTimeout) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return NetworkErrorView();
                });
          } else if (state.error.errorCode ==
              HttpStatus.serviceUnavailable) {
            UIHelpers.showToast((LocalKeys.SERVER_UNREACHABLE).tr(), true , true);
          } else {
            UIHelpers.showToast(state.error.errorMessage ?? '', true , true);

          }
        }
        else if(state is UserDataLoadedState){
          UIHelpers.showToast((LocalKeys.YOUR_UPDATES_ARE_SUCCESS).tr(), false , true);

          if(widget.userOrderModel == null){
            Navigator.pop(context);
          }

          UserViewModel loggedInUser = BlocProvider.of<UserBloc>(context).currentLoggedInUser;
          AddressViewModel newAddress ;
          List<AddressViewModel> userAddress = loggedInUser.userSavedAddresses;
          OrderModel order = widget.userOrderModel;

          try{
            newAddress = userAddress.where((AddressViewModel element){
              bool sameArea = element.area.id == selectedArea.id;
              bool sameCity = element.city.id == selectedCity.id;
              bool sameStreet = element.addressName == addressTextController.text;
              return sameArea && sameCity && sameStreet;
            }).first;
            order.orderAddress = newAddress;
          } catch(exception){}

          if(loggedInUser.userPhoneNumber == null || loggedInUser.userPhoneNumber.toString().isEmpty || newAddress == null){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ShippingAddressScreen(order)
            ));
          }
          else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OrderCreationScreen(orderModel: order,)
            ));
          }
        }
      },
      builder: (context , state){
        return ModalProgressHUD(
          inAsyncCall: state is UserDataLoadingState,
          progressIndicator: LoadingWidget(),
          child: BaseScreen(
            hasDrawer: true,
            child: Form(
              key: _addressFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Center(
                      child: Container(
                        width: (100),
                        height: (100),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: .5,
                            color: AppColors.lightBlack,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(BlocProvider.of<AuthenticationBloc>(context).currentUser.userProfileImage ?? ''),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.comingFromRegistration ?? false ? (LocalKeys.THANKS_LABEL).tr(): '',
                                style: TextStyle(
                                  color: AppColors.black,
                                ),
                              ),
                              TextSpan(
                                text: BlocProvider.of<UserBloc>(context).currentLoggedInUser.userName ?? '  User',
                                style: TextStyle(
                                  color: AppColors.black,
                                ),
                              ),

                            ]
                        ),
                      ),
                    ),
                    Center(
                      child: Visibility(
                        replacement: Container(width: 0, height: 0,),
                        visible: widget.comingFromRegistration ?? false ,
                        child: Text((LocalKeys.NEW_ACCOUNT_CREATION_MESSAGE).tr() , style: TextStyle(
                          color: AppColors.lightBlue,
                        ),),
                      ),
                    ),
                    Text((LocalKeys.PICK_SHIPPING_ADDRESS).tr(), style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GestureDetector(
                        onTap: () async{
                          selectedCity = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LocationSelectionScreen(
                            locationsList: BlocProvider.of<ApplicationDataBloc>(context).systemSupportedLocations,
                          )));
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                              color: AppColors.lightBlack,
                              width: .5,
                            ),
                            color: AppColors.offWhite,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text( selectedCity != null ? selectedCity.name ?? (LocalKeys.SELECT_CITY_LABEL).tr() : (LocalKeys.SELECT_CITY_LABEL).tr(), ),
                                Icon(Icons.arrow_drop_down_circle , color: AppColors.lightBlue,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GestureDetector(
                        onTap: () async {
                          selectedArea = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LocationSelectionScreen(
                            locationsList: selectedCity.childLocations,
                          )));
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                              color: AppColors.lightBlack,
                              width: .5,
                            ),
                            color: AppColors.offWhite,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(selectedArea != null ? selectedArea.name ?? (LocalKeys.SELECT_AREA_LABEL).tr() : (LocalKeys.SELECT_AREA_LABEL).tr(),),
                                Icon(Icons.arrow_drop_down_circle , color: AppColors.lightBlue,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    buildTextField(
                      autoValidate: false,
                      focusNode: addressFocusNode,
                      textController: addressTextController,
                      nextNode: buildingNumberFocusNode,
                      validator: Validator.requiredField,
                      hint: (LocalKeys.SELECT_ADDRESS).tr(),
                      secured: false,
                      maxLines: 1,
                    ),
                    buildTextField(
                      autoValidate: false,
                      focusNode: buildingNumberFocusNode,
                      textController: buildingNumberTextController,
                      nextNode: addressLandmarkFocusNode,
                      validator: Validator.requiredField,
                      hint: (LocalKeys.SELECT_BUILDING).tr(),
                      secured: false,
                      maxLines: 1,
                    ),
                    buildTextField(
                      autoValidate: false,
                      focusNode: addressLandmarkFocusNode,
                      textController: addressLandmarkTextController,
                      nextNode: null,
                      hint: (LocalKeys.SELECT_ADDRESS_LANDMARK).tr(),
                      secured: false,
                      maxLines: 5,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: (){
                          if(_addressFormKey.currentState.validate()){
                            AddressViewModel userAddress = AddressViewModel(
                              city: selectedCity,
                              area: selectedArea,
                              additionalInformation: addressLandmarkTextController.text,
                              addressName: addressTextController.text,
                              buildingNumber: buildingNumberTextController.text,
                            );
                            if(widget.addressModel != null){
                              userAddress.deliveryFees = widget.addressModel.deliveryFees;
                              userAddress.id = widget.addressModel.id;

                              BlocProvider.of<UserBloc>(context).add(UpdateAddress(address: userAddress));
                            } else {
                              BlocProvider.of<UserBloc>(context).add(SaveAddress(address: userAddress));
                            }
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: (50),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(child: Text(widget.addressModel == null ?  (LocalKeys.SAVE_ADDRESS).tr() : (LocalKeys.EDIT_ADDRESS).tr(), style: TextStyle(color: AppColors.white),)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      cubit: BlocProvider.of<UserBloc>(context),
    );
  }

  Widget buildTextField({String Function(String text) validator, bool secured, hint, FocusNode nextNode, TextEditingController textController, FocusNode focusNode, bool autoValidate , int maxLines}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        autovalidate: autoValidate ?? false,
        obscureText: secured ?? false,
        validator: validator ?? (String text) => null,
        controller: textController,
        onFieldSubmitted: (text){
          if(nextNode != null)
            FocusScope.of(context).requestFocus(nextNode);
        },
        focusNode: focusNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: .5,
              color: AppColors.lightBlue,
            ),
          ),
          fillColor: AppColors.offWhite,
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: .5,
              color: AppColors.lightBlue,
            ),
          ),
          alignLabelWithHint: true,
        ),
        textInputAction: nextNode != null ? TextInputAction.next : TextInputAction.done,
      ),
    );
  }

  void initFormData() {
    addressTextController = TextEditingController();
    buildingNumberTextController = TextEditingController();
    addressLandmarkTextController = TextEditingController();
    addressFocusNode = FocusNode();
    buildingNumberFocusNode = FocusNode();
    addressLandmarkFocusNode = FocusNode();
    if(widget.addressModel != null){
      addressTextController.text = widget.addressModel.addressName.toString();
      buildingNumberTextController.text = widget.addressModel.buildingNumber.toString();
      addressLandmarkTextController.text = widget.addressModel.additionalInformation.toString();
      selectedArea = widget.addressModel.area;
      selectedCity = widget.addressModel.city;
    }
  }


}

