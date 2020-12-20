import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:picknprint/src/utilities/UIHelpers.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {


  TextEditingController passwordTextController , confirmPasswordTextController , oldPasswordTextController;
  FocusNode passwordFocusNode , confirmPasswordFocusNode , oldPasswordFocusNode ;
  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    oldPasswordTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();

    oldPasswordFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.appLocale == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.blackBg,
        body: BlocConsumer(
          listener: (context, state){
            if (state is UserInformationUpdateFailedState) {
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
            else if(state is UserDataLoadedState){
              UIHelpers.showToast((LocalKeys.SUCCESSFULLY_UPDATED).tr(), false, true);
              Navigator.pop(context);
            }
          },
          builder: (context, state){
            return SingleChildScrollView(
              child: Form(
                key: _passwordFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .25,
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 1,
                                    )
                                  ),
                                  child: Center(child: Icon(Icons.close , color: AppColors.white, size: 25,)),

                                ),
                                Text((LocalKeys.CANCEL_LABEL).tr() , style: TextStyle(
                                  color: AppColors.white,
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text((LocalKeys.UPDATE_MY_PASSWORD).tr(), style: TextStyle(
                        color: AppColors.white,
                      ),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          validator: Validator.requiredField,
                          controller: oldPasswordTextController,
                          focusNode: oldPasswordFocusNode,
                          onFieldSubmitted: (text){
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          },
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
                            hintText: (LocalKeys.OLD_PASSWORD_LABEL).tr(),
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
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          validator: Validator.requiredField,
                          controller: passwordTextController,
                          focusNode: passwordFocusNode,
                          onFieldSubmitted: (text){
                            FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                          },
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
                            hintText: (LocalKeys.NEW_PASSWORD_LABEL).tr(),
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
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          validator: Validator.requiredField,
                          controller: confirmPasswordTextController,
                          focusNode: confirmPasswordFocusNode,
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
                            hintText: (LocalKeys.RETYPE_NEW_PASSWORD_LABEL).tr(),
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
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: _updateUserInformation,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(child: Text((LocalKeys.UPDATE_MY_PASSWORD).tr(), style: TextStyle(color: AppColors.white),)),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            );
          },
          cubit: BlocProvider.of<UserBloc>(context),
        ),
      ),
    );
  }

  void _updateUserInformation() {
    if(_passwordFormKey.currentState.validate())
      BlocProvider.of<UserBloc>(context).add(
      UpdateUserInformation(
        userViewModel: BlocProvider.of<UserBloc>(context).currentLoggedInUser,
        oldPassword: oldPasswordTextController.text , newPassword: passwordTextController.text,));
  }
}
