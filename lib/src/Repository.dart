import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_providers/apis/ApplicationDataProvider.dart';
import 'data_providers/apis/UserDataProvider.dart';
import 'data_providers/models/PackageModel.dart';
import 'data_providers/models/UserViewModel.dart';

class Repository {


  static Future<ResponseViewModel<List<PackageModel>>>
  getUserCart() async {
    return ResponseViewModel<List<PackageModel>>(responseData: [],isSuccess: true ,errorViewModel: null);
  }



  static Future<ResponseViewModel<bool>> verifyUser(
      {String verificationCode, String userPhoneNumber}) async{

    return ResponseViewModel<bool>(
      isSuccess: true,
      responseData: true,
    );

  }


  static Future<ResponseViewModel<bool>> resetPassword(
      {String phoneNumber,
        String verificationCode,
        String password,
        String confirmPassword}) async {
    return ResponseViewModel<bool>(
      isSuccess: true,
      responseData: true,
    );
  }



  static resendCodeForPhone({String phoneNumber}) async {}


  static Future<void> clearCache() async =>
      await UserDataProvider.clearUserCache();


  static Future<void> saveEncryptedPassword(String userPassword) async =>
      await UserDataProvider.saveEncryptedPassword(userPassword);


  static Future<UserViewModel> getUser() async =>
      await UserDataProvider.getUser();


  static Future<ResponseViewModel<List<PackageModel>>> getSystemPackages () async{
    ResponseViewModel<List<PackageModel>> apiResponse = await ApplicationDataProvider.getSystemPackages();
    if(apiResponse.isSuccess && apiResponse.responseData != null)
      apiResponse.responseData.sort((a,b)=> a.packageSize > b.packageSize ? 1 : 0);

      return apiResponse;
  }

  static Future<UserViewModel> makeSilentLogin() async {
    bool tokenRefreshed = await refreshToken();
    return await UserDataProvider.getUser();
  }

  static Future<bool> refreshToken() async {
    try {
      List<String> userCredentials =
      await UserDataProvider.getSilentLoginCredentials();
      ResponseViewModel<UserViewModel> reLoginResponse =
      await UserDataProvider.signIn(userCredentials[0], userCredentials[1]);
      if (reLoginResponse.isSuccess) {
        await UserDataProvider.saveUser(reLoginResponse.responseData);
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }

  static Future<void> saveUser(UserViewModel userViewModel) async =>
      await UserDataProvider.saveUser(userViewModel);
  static signIn({String userPhoneNumber, String userPassword}) async =>
      await UserDataProvider.signIn(userPhoneNumber, userPassword);
  static signOut() async => await UserDataProvider.signOut();
  static addToCart({PackageModel advertisementViewModel}) {}
  static removeFromCart({PackageModel advertisementViewModel}) {}

  static Future<ResponseViewModel<UserViewModel>>registerNewUser({UserViewModel userModel, String userPassword}) async{
    return UserDataProvider.registerNewUser(userModel,  userPassword);
  }

  static Future<ResponseViewModel<List<String>>> createOrder(OrderModel orderModel) async{
    return UserDataProvider.createOrder(orderModel);
  }


}