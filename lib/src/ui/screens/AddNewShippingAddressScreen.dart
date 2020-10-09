import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';

import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
class AddNewShippingAddressScreen extends StatefulWidget {

  final bool comingFromRegistration ;
  final AddressViewModel addressModel ;
  AddNewShippingAddressScreen({this.comingFromRegistration , this.addressModel});

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
    return BaseScreen(
      hasDrawer: true,
      child:  BlocConsumer(
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
              Fluttertoast.showToast(
                  msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              Fluttertoast.showToast(
                  msg: state.error.errorMessage ?? '',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
          else if(state is UserDataLoadedState){
            Fluttertoast.showToast(
                msg: (LocalKeys.YOUR_UPDATES_ARE_SUCCESS).tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pop();
          }
        },
        builder: (context , state){
          return ModalProgressHUD(
            inAsyncCall: state is UserDataLoadingState,
            child: SingleChildScrollView(
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
                                  text: BlocProvider.of<AuthenticationBloc>(context).currentUser.userName ?? '  User',
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
                          onTap: (){
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
                          onTap: (){},
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
                      SizedBox(height: 10,),
                      GestureDetector(
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
                          child: Center(child: Text((LocalKeys.SAVE_ADDRESS).tr(), style: TextStyle(color: AppColors.white),)),
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
      ),
    );
  }

  Widget buildTextField({String Function(String text) validator, bool secured, hint, FocusNode nextNode, TextEditingController textController, FocusNode focusNode, bool autoValidate , int maxLines}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        autovalidate: autoValidate ?? false,
        obscureText: secured ?? false,
        validator: Validator.requiredField,
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

