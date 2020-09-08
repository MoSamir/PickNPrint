
import 'package:easy_localization/easy_localization.dart';

import 'LocalKeys.dart';
class Validator{




static String phoneValidator(String phoneNumber){

  String isEmptyCheck = requiredField(phoneNumber);
  if(isEmptyCheck != null){
    return isEmptyCheck;
  }

  if(phoneNumber[0] == '0'){
    String preFix = phoneNumber.substring(0,3);
    int phoneNumberLength = phoneNumber.length ;
    bool validPreFix = preFix == '011' || preFix == '010' || preFix == '012' || preFix == '015';
    bool validPhoneLength = phoneNumberLength == 11;
    return (validPreFix && validPhoneLength) ? null : (LocalKeys.INVALID_PHONE_NUMBER_KEY).tr();
  } else {
    String preFix = phoneNumber.substring(0,2);
    int phoneNumberLength = phoneNumber.length ;
    bool validPreFix = preFix == '11' || preFix == '10' || preFix == '12' || preFix == '15';
    bool validPhoneLength = phoneNumberLength == 10;
    return (validPreFix && validPhoneLength) ? null : (LocalKeys.INVALID_PHONE_NUMBER_KEY).tr();
  }


}

static String requiredField(String text){
  return (text == null || text.trim().length == 0) ?  (LocalKeys.REQUIRED_FIELD_ERROR_MESSAGE_KEY).tr() : null ;
}

static String mailValidator(String text){
    String isEmptyCheck = requiredField(text);
    if(isEmptyCheck != null){
      return isEmptyCheck;
    }

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(text) ? null : (LocalKeys.INVALID_MAIL_ADDRESS).tr();

  }

}