import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/RegistrationBloc.dart';
import 'package:picknprint/src/bloc/states/RegistrationStates.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/screens/ShippingAddressScreen.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
import 'package:easy_localization/easy_localization.dart';
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  FocusNode usernameFocusNode , userMailFocusNode ,passwordFocusNode  ,
      confirmPasswordFocusNode , userPhoneNumberFocusNode;

  RegistrationBloc _registrationBloc = RegistrationBloc(RegistrationInitialState());


  TextEditingController usernameTextController , passwordTextController  , userPhoneNumberTextController,
                        confirmPasswordTextController, userEmailTextController , userPasswordTextController;



  @override
  void dispose() {
    _registrationBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    usernameFocusNode = FocusNode();
    userMailFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    userPhoneNumberFocusNode = FocusNode();

    usernameTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
    userEmailTextController = TextEditingController();
    userPhoneNumberTextController = TextEditingController();
    userPasswordTextController = TextEditingController();

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
          body: BlocConsumer(
            listener: (context, state){
              if (state is RegistrationFailedState) {
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
              else if(state is RegistrationSuccessState){
                Navigator.pop(context);
              }
            },
            builder:  (context, state){
              return ModalProgressHUD(
                inAsyncCall: state is RegistrationLoadingState,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: 5,),
                              Text((LocalKeys.REGISTER_NEW_ACCOUNT).tr(), style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ), textAlign: TextAlign.start,),
                              SizedBox(height: 5,),
                              Image(image: AssetImage(Resources.LOGO_BANNER_IMG), width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .25, fit: BoxFit.cover,),
                              Form(
                                key: _registrationFormKey,
                                child: Column(
                                  children: <Widget>[
                                    buildTextField(validator: Validator.requiredField, textController: usernameTextController , focusNode: usernameFocusNode , nextNode: userMailFocusNode , hint : (LocalKeys.USER_NAME_LABEL).tr() , secured : false , autoValidate: false),
                                    buildTextField(validator: Validator.mailValidator, textController: userEmailTextController , focusNode: userMailFocusNode , nextNode: userPhoneNumberFocusNode , hint : (LocalKeys.USER_EMAIL_LABEL).tr() , secured : false , autoValidate: false),
                                    buildTextField(validator: Validator.requiredField, textController: userPhoneNumberTextController , focusNode: userPhoneNumberFocusNode , nextNode: passwordFocusNode , hint : (LocalKeys.PHONE_NUMBER_LABEL).tr() , secured : false , autoValidate: false),
                                    buildTextField(validator: Validator.requiredField, textController: passwordTextController , focusNode: passwordFocusNode , nextNode: confirmPasswordFocusNode , hint : (LocalKeys.PASSWORD_LABEL).tr() , secured : true , autoValidate: false),
                                    buildTextField(validator: (String confirmPasswordText){
                                      if(confirmPasswordText == passwordTextController.text){
                                        return null ;
                                      } else {
                                        return (LocalKeys.PASSWORDS_NOT_MATCH).tr();
                                      }
                                    }, textController: confirmPasswordTextController , focusNode: confirmPasswordFocusNode  , hint : (LocalKeys.CONFIRM_PASSWORD_LABEL).tr() , secured : true),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ShippingAddressScreen(
                                    comingFromRegistration: true,
                                  )));
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
              );
            },
            bloc: _registrationBloc,
          ),
        ),
      ),
    );
  }


  Widget buildTextField({String Function(String text) validator, bool secured, hint, FocusNode nextNode, TextEditingController textController, FocusNode focusNode, bool autoValidate}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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