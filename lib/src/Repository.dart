import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:picknprint/src/data_providers/apis/CartDataProvider.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:http/http.dart' as http;
import 'data_providers/apis/ApplicationDataProvider.dart';
import 'data_providers/apis/UserDataProvider.dart';
import 'data_providers/models/PackageModel.dart';
import 'data_providers/models/UserViewModel.dart';

class Repository {






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


  static Future<ResponseViewModel<void>> saveEncryptedPassword(String userPassword) async =>
      await UserDataProvider.saveEncryptedPassword(userPassword);


  static Future<UserViewModel> getUser() async =>
      await UserDataProvider.getUser();


  static Future<ResponseViewModel<List<PackageModel>>> getSystemPackages () async{
    ResponseViewModel<List<PackageModel>> apiResponse = await ApplicationDataProvider.getSystemPackages();
    if(apiResponse.isSuccess && apiResponse.responseData != null)
      apiResponse.responseData.sort((a,b)=> a.packageSize > b.packageSize ? 1 : 0);
      return apiResponse;
  }
  static Future<ResponseViewModel<List<LocationModel>>> getSystemSupportedAreas() async => await ApplicationDataProvider.getSystemSupportedAreas();


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

  static Future<ResponseViewModel<void>> saveUser(UserViewModel userViewModel) async =>
      await UserDataProvider.saveUser(userViewModel);
  static signIn({String userMail, String userPassword}) async =>
      await UserDataProvider.signIn(userMail, userPassword);
  static signOut() async => await UserDataProvider.signOut();
  static addToCart({PackageModel advertisementViewModel}) {}
  static removeFromCart({PackageModel advertisementViewModel}) {}

  static Future<ResponseViewModel<UserViewModel>>registerNewUser({UserViewModel userModel, String userPassword , bool withSocialMedia} ) async{
    return UserDataProvider.registerNewUser(userModel,  userPassword , withSocialMedia);
  }




  static Future<ResponseViewModel<AddressViewModel>> saveNewAddress({AddressViewModel newAddress}) async
  => await UserDataProvider.saveUserAddress(newAddress);

  static Future<ResponseViewModel<List<AddressViewModel>>> getUserAddresses() async => await UserDataProvider.getUserAddresses();

  static Future<ResponseViewModel<UserViewModel>> updateProfileImage({String imageLink}) async => await UserDataProvider.updateUserProfile(imageLink);

  static Future<ResponseViewModel<UserViewModel>> updateUserProfile({UserViewModel updatedUser, String oldPassword, String newPassword})
  async => await UserDataProvider.updateUser(updatedUser , oldPassword , newPassword);

  static Future<ResponseViewModel<UserViewModel>> signInWithFacebook() async => await UserDataProvider.signInWithFacebook();

  static Future<ResponseViewModel> saveOrderToCart({OrderModel orderModel}) async => await CartDataProvider.saveOrderToCart(orderModel);
  static Future<ResponseViewModel<List<OrderModel>>> saveUserCartForLater() async{
    return CartDataProvider.saveUserCartForLater();
  }
  static Future<ResponseViewModel<List<OrderModel>>> getUserCart() async{
    return CartDataProvider.getUserCart();
  }

  static Future<ResponseViewModel<List<OrderModel>>> createOrder(OrderModel orderModel) async{
    return CartDataProvider.createOrder(orderModel);
  }

  static Future<ResponseViewModel<List<OrderModel>>>loadActiveOrders() async => CartDataProvider.loadActiveOrders();
  static Future<ResponseViewModel<List<OrderModel>>>loadClosedOrders() async => CartDataProvider.loadClosedOrders();
  static Future<ResponseViewModel<List<OrderModel>>>loadSavedOrders() async => CartDataProvider.loadSavedOrders();

  static Future<ResponseViewModel<bool>> deleteAddress({AddressViewModel address}) async => UserDataProvider.deleteUserAddress(address);

  static Future<ResponseViewModel<AddressViewModel>> updateUserAddress({AddressViewModel newAddress}) async => UserDataProvider.updateUserAddress(newAddress);



}