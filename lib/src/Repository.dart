import 'dart:io';

import 'package:picknprint/src/data_providers/apis/ApplicationDataProvider.dart';
import 'package:picknprint/src/data_providers/apis/CartDataProvider.dart';
import 'package:picknprint/src/data_providers/apis/UserDataProvider.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';

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


  static Future<void> clearCache() async {
    return await UserDataProvider.clearUserCache();
  }


  static Future<ResponseViewModel<void>> saveEncryptedPassword(String userPassword) async {
    return await UserDataProvider.saveEncryptedPassword(userPassword);
  }


  static Future<UserViewModel> getUser() async {
     UserViewModel userModel = await UserDataProvider.getUser();
     return userModel;
  }


  static Future<ResponseViewModel<List<PackageModel>>> getSystemPackages () async{
    ResponseViewModel<List<PackageModel>> apiResponse = await ApplicationDataProvider.getSystemPackages();
    if(apiResponse.isSuccess && apiResponse.responseData != null)
      apiResponse.responseData.sort((a,b)=> a.packageSize > b.packageSize ? 1 : 0);
      return apiResponse;
  }
  static Future<ResponseViewModel<List<LocationModel>>> getSystemSupportedAreas() async {
    return await ApplicationDataProvider.getSystemSupportedAreas();
  }
  static Future<ResponseViewModel<String>> getSystemContactInfo() async {
    return await ApplicationDataProvider.getSystemContactInfo();
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

  static Future<ResponseViewModel<void>> saveUser(UserViewModel userViewModel) async {
   return await UserDataProvider.saveUser(userViewModel);
  }
  static signIn({String userMail, String userPassword}) async {
    return await UserDataProvider.signIn(userMail, userPassword);
  }

  static signOut() async {
    return await UserDataProvider.signOut();
  }



  static Future<ResponseViewModel<UserViewModel>>registerNewUser({UserViewModel userModel, String userPassword , bool withSocialMedia} ) async{
    return UserDataProvider.registerNewUser(userModel,  userPassword , withSocialMedia);
  }




  static Future<ResponseViewModel<AddressViewModel>> saveNewAddress({AddressViewModel newAddress}) async {
    return await UserDataProvider.saveUserAddress(newAddress);
  }

  static Future<ResponseViewModel<List<AddressViewModel>>> getUserAddresses() async {
    return await UserDataProvider.getUserAddresses();
  }

  static Future<ResponseViewModel<UserViewModel>> updateProfileImage({String imageLink}) async {
    return await UserDataProvider.updateUserProfile(imageLink);
  }

  static Future<ResponseViewModel<UserViewModel>> updateUserProfile({UserViewModel updatedUser, String oldPassword, String newPassword}) async {
    return await UserDataProvider.updateUser(updatedUser , oldPassword , newPassword);
  }

  static Future<ResponseViewModel<UserViewModel>> signInWithFacebook() async {
    return  await UserDataProvider.signInWithFacebook();
  }

  static Future<ResponseViewModel> saveOrderToCart({OrderModel orderModel}) async {
    return await CartDataProvider.saveOrderToCart(orderModel);
  }

  static Future<ResponseViewModel<List<OrderModel>>> getUserCart() async{
    return CartDataProvider.getUserCart();
  }

  static Future<ResponseViewModel<List<OrderModel>>> createOrder(OrderModel orderModel) async{
    return CartDataProvider.createOrder(orderModel);
  }




  static Future<ResponseViewModel<List<String>>> uploadMultipleFiles(List<String> filesToBeUploaded) async{
    ResponseViewModel<List<String>> uploadFiles = await ApplicationDataProvider.uploadMultipleFiles(filesToBeUploaded);
    return uploadFiles;
  }


  static Future<ResponseViewModel<List<OrderModel>>> createSavedOrder(OrderModel orderModel) async{
    return CartDataProvider.createSavedOrder(orderModel);
  }


  static Future<ResponseViewModel<List<OrderModel>>>loadActiveOrders() async {
    return CartDataProvider.loadActiveOrders();
  }
  static Future<ResponseViewModel<List<OrderModel>>>loadClosedOrders() async {
    return CartDataProvider.loadClosedOrders();
  }
  static Future<ResponseViewModel<List<OrderModel>>>loadSavedOrders() async {
    return CartDataProvider.loadSavedOrders();
  }

  static Future<ResponseViewModel<bool>> deleteAddress({AddressViewModel address}) async {
    return UserDataProvider.deleteUserAddress(address);
  }

  static Future<ResponseViewModel<AddressViewModel>> updateUserAddress({AddressViewModel newAddress}) async {
    return UserDataProvider.updateUserAddress(newAddress);
  }

  static saveOrderForLater(OrderModel order) async {
    return CartDataProvider.saveOrderToLater(order);
  }


   static Future<ResponseViewModel<File>> getImageFromURL(String imageURL) async {
    return NetworkUtilities.getImageFile(imageURL);
   }




}