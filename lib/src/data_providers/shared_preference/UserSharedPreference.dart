import 'dart:convert';

import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xxtea/xxtea.dart';

class UserSharedPreference {


  static getUserToken() async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    return mSharedPreference
        .getString(Constants.SHARED_PREFERENCE_USER_TOKEN_KEY);
  }

  static saveUserToken(String userToken) async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    mSharedPreference.setString(
        Constants.SHARED_PREFERENCE_USER_TOKEN_KEY, userToken);
  }

  static saveUser(UserViewModel userViewModel) async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    mSharedPreference.setString(Constants.SHARED_PREFERENCE_USER_KEY,
        json.encode(userViewModel.toJson()));
    await saveUserToken(userViewModel.userToken);
  }


  static getPassword() async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    String encodedPassword = mSharedPreference
        .getString(Constants.SHARED_PREFERENCE_USER_PASSWORD);
    return xxtea.decryptToString(encodedPassword, Constants.ENCRYPTION_KEY) ??
        '';
  }

  static Future<List<String>> getSilentLoginCredentials() async {
    String userPassword = await getPassword();
    UserViewModel userModel = await getUser();
    return [userModel.userPhoneNumber, userPassword];
  }

  static clearUserCache() async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    await mSharedPreference.clear();
  }

  static saveEncryptedPassword(String userPassword) async {
    String encryptPassword =
    xxtea.encryptToString(userPassword, Constants.ENCRYPTION_KEY);
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    mSharedPreference.setString(
        Constants.SHARED_PREFERENCE_USER_PASSWORD, encryptPassword);
  }

  static Future<UserViewModel> getUser() async {
    try {
      SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
      var userJson = mSharedPreference.getString(Constants.SHARED_PREFERENCE_USER_KEY);
      if (userJson == null) {
        UserViewModel userModel =  UserViewModel.fromAnonymous();
        return userModel;
      } else {
        UserViewModel userViewModel =
        UserViewModel.fromJson(json.decode(userJson));
        return userViewModel;
      }
    } catch(exception){
      print("Exception while reading Empty Preference => $exception");
      UserViewModel userModel =  UserViewModel.fromAnonymous();
      return userModel;
    }
  }



}