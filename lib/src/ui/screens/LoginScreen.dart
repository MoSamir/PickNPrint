import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserCartBloc.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/events/UserCartEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/screens/RegisterScreen.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
import 'package:easy_localization/easy_localization.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  FocusNode passwordFocusNode ;
  TextEditingController usernameTextController , passwordTextController ;
  AuthenticationBloc authenticationBloc ;


  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    usernameTextController = TextEditingController();
    passwordTextController = TextEditingController();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: authenticationBloc,
      builder: (context, state){
        return ModalProgressHUD(
          inAsyncCall: state is AuthenticationLoading,
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Scaffold(
                appBar: PickNPrintAppbar(hasDrawer: true,appbarColor: AppColors.black,),
                body: BlocConsumer(
                  listener: (context, state){
                    if (state is AuthenticationFailed) {
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
                    else if(state is UserAuthenticated){
                      BlocProvider.of<UserCartBloc>(context).add(LoadCartEvent());

                      Navigator.pop(context);
                    }
                  },
                  bloc: authenticationBloc,
                  builder: (context, state){
                    return ModalProgressHUD(
                      inAsyncCall: state is AuthenticationLoading,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      SizedBox(height: 5,),
                                      Text((LocalKeys.SIGN_IN).tr(), style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ), textAlign: TextAlign.start,),
                                      SizedBox(height: 5,),
                                      Image(image: AssetImage(Resources.LOGO_BANNER_IMG), width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .25, fit: BoxFit.cover,),
                                      Form(
                                        key: _loginFormKey,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: TextFormField(
                                                validator: Validator.mailValidator,
                                                controller: usernameTextController,
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
                                                  hintText: (LocalKeys.MAIL_ADDRESS).tr(),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                    borderSide: BorderSide(
                                                      width: .5,
                                                      color: AppColors.lightBlue,
                                                    ),
                                                  ),
                                                  alignLabelWithHint: true,
                                                ),
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.emailAddress,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: TextFormField(
                                                validator: Validator.requiredField,
                                                controller: passwordTextController,
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
                                                  hintText: (LocalKeys.PASSWORD_LABEL).tr(),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                    borderSide: BorderSide(
                                                      width: .5,
                                                      color: AppColors.lightBlue,
                                                    ),
                                                  ),
                                                  alignLabelWithHint: true,
                                                ),
                                                textInputAction: TextInputAction.done,
                                                obscureText: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          if(_loginFormKey.currentState.validate()) {
                                            authenticationBloc.add(LoginUser(
                                              userEmail: usernameTextController
                                                  .text,
                                              userPassword: passwordTextController
                                                  .text,
                                            ));
                                          }
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
                                      Container(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text((LocalKeys.DONT_HAVE_ACCOUNT_YET).tr()),
                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: (){
                                                    print("Hello World");
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RegisterScreen()));
                                                  },
                                                  child: Text((LocalKeys.SIGN_UP).tr() , style: TextStyle(
                                                    color: AppColors.lightBlue,
                                                    decoration: TextDecoration.underline,
                                                  ) ,),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: (){},
                                              child: Text((LocalKeys.FORGET_YOUR_PASSWORD).tr(),),
                                            ),
                                          ],
                                        ),),
                                      Text((LocalKeys.OR_LABEL).tr(), style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 8.0),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: (){},
                                            child: Container(
                                              width: MediaQuery.of(context).size.width - 32,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                color: AppColors.lightBlack,
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    child: Image.asset(Resources.FACEBOOK_LOGO_IMG),
                                                  ),
                                                  SizedBox(width: 8,),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text((LocalKeys.FACEBOOK_LABEL).tr(), style: TextStyle(
                                                              color: AppColors.white,
                                                            ), textAlign: TextAlign.center,),
                                                          ),
                                                          Expanded(
                                                            child: Text((LocalKeys.SIGN_UP_WITH_FACEBOOK).tr(), style: TextStyle(
                                                              color: AppColors.white,
                                                            ), textAlign: TextAlign.center,),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PickNPrintFooter(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state){
       if (state is AuthenticationFailed) {
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
      },
    );
  }
}