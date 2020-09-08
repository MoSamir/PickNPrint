import 'dart:convert';

import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xxtea/xxtea.dart';

import 'helpers/NetworkUtilities.dart';
import 'helpers/URL.dart';

class UserDataProvider{



  static getUserToken() async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    return mSharedPreference
        .getString(Constants.SHARED_PREFERENCE_USER_TOKEN_KEY);
  }


  static signOut() async {
    String token = await getUserToken();

//    ResponseViewModel responseViewModel =
//    await NetworkUtilities.handleGetRequest(
//        methodURL: URL.getURL(functionName: URL.GET_LOGOUT),
//        requestHeaders: NetworkUtilities.getHeaders(
//            customHeaders: {'Authorization': 'Bearer $token'}),
//        parserFunction: (responseJson) => true);
//
//    // special handling for logout
//    // if logout returned 401 it means that the user is forced logged out , so logout is assumed to be called and returned success
//    if (!responseViewModel.isSuccess &&
//        responseViewModel.errorViewModel.errorCode == 401) {
//      responseViewModel = ResponseViewModel<bool>(
//        responseData: true,
//        isSuccess: true,
//        errorViewModel: null,
//      );
//    }
    return ResponseViewModel<bool>(
        errorViewModel: null,
        isSuccess: true,
        responseData: true);
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



  static Future<ResponseViewModel<UserViewModel>> signIn(
      String userPhoneNumber, String userPassword) async {

//    ResponseViewModel login = await NetworkUtilities.handlePostRequest(
//        methodURL: '${URL.getURL(functionName: URL.POST_LOGIN)}?token=true',
//        requestHeaders: NetworkUtilities.getHeaders(),
//        requestBody: {
//          "phone": userPhoneNumber,
//          "password": userPassword,
//          "notification_token": pushNotificationsToken
//        },
//        parserFunction: UserViewModel.fromJson);
    ResponseViewModel<UserViewModel> userResponse =
    ResponseViewModel<UserViewModel>(
      errorViewModel: null,
      isSuccess: true,
      responseData: UserViewModel(
        userId: 1,
        userMail: 'mohamedsamir731@gmai.com',
        userToken: '',
        userName: 'Mohamed Samir',
        userPhoneNumber: '+201013615170'
      ),
    );
    return userResponse;
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
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    var userJson =
    mSharedPreference.getString(Constants.SHARED_PREFERENCE_USER_KEY);
    if (userJson == null) {
      return UserViewModel.fromAnonymous();
    } else {
      UserViewModel userViewModel =
      UserViewModel.fromJson(json.decode(userJson));
      return userViewModel;
    }
  }



}