import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';

import 'OrderCreationScreen.dart';
class ShippingAddressScreen extends StatefulWidget {

  final bool comingFromRegistration ;
  ShippingAddressScreen({this.comingFromRegistration});

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {


  TextEditingController addressTextController , buildingNumberTextController , addressLandmarkTextController;
  FocusNode addressFocusNode , buildingNumberFocusNode , addressLandmarkFocusNode;
  String selectedCity , selectedArea ;



  @override
  void initState() {
    super.initState();
    addressTextController = TextEditingController();
    buildingNumberTextController = TextEditingController();
    addressLandmarkTextController = TextEditingController();

    addressFocusNode = FocusNode();
    buildingNumberFocusNode = FocusNode();
    addressLandmarkFocusNode = FocusNode();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PickNPrintAppbar(hasDrawer: true,appbarColor: AppColors.black,),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 15,),
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
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
                                    Text( selectedCity ?? (LocalKeys.SELECT_CITY_LABEL).tr(), ),
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
                                    Text(selectedArea ?? (LocalKeys.SELECT_AREA_LABEL).tr(), ),
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderCreationScreen(orderModel: OrderModel(
                              frameWithPath: true,
                              isWhiteFrame: true,
                              orderPackage: PackageModel(
                                packageSize: 3,
                                packageSaving: 30,
                                packagePrice: 150,
                              ),
                            ),)));

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(child: Text((LocalKeys.SIGN_IN).tr(), style: TextStyle(color: AppColors.white),)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                PickNPrintFooter(),
              ],
            ),
          ),
        ),
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

}
