import 'dart:convert';
import 'dart:io';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/data_providers/shared_preference/UserSharedPreference.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xxtea/xxtea.dart';

import 'helpers/URL.dart';

class UserDataProvider{

  static Future<ResponseViewModel<UserViewModel>> registerNewUser(UserViewModel userModel, String userPassword , bool withSocialMedia) async{

    Map<String,dynamic> requestBody = {
      'name': userModel.userName ?? '',
      'email': userModel.userMail,
      'password': userPassword,
      'password_confirmation': userPassword,
      'viaSocialMedia' : withSocialMedia ?? false ? 1.toString() : 0.toString()
    };

    if(userModel.userPhoneNumber != null){
      requestBody.putIfAbsent('phone', () =>  userModel.userPhoneNumber);
    }
    if(userModel.userProfileImage != null){
      requestBody.putIfAbsent('image', () => userModel.userProfileImage);
    }

    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders();
    String apiURL = URL.getURL(apiPath: URL.POST_REGISTER);
    ResponseViewModel registerUserResponse = await NetworkUtilities.handlePostRequest(
      requestBody: requestBody,
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (registerUserRawResponse){
        print("Register Raw Response => $registerUserRawResponse");
        return UserViewModel.fromJson(registerUserRawResponse[ApiParseKeys.RESPONSE_SUCCESS_ROOT]);
      },
    );
    return ResponseViewModel<UserViewModel>(
      responseData: registerUserResponse.responseData,
      isSuccess: registerUserResponse.isSuccess,
      errorViewModel: registerUserResponse.errorViewModel,
    );

  }
  static Future<ResponseViewModel<UserViewModel>> signIn(String userMail, String userPassword) async {

    Map<String,dynamic> requestBody = {
      'email': userMail,
      'password': userPassword,
    };
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders();
    String apiURL = URL.getURL(apiPath: URL.POST_LOGIN);
    ResponseViewModel signInResponse = await NetworkUtilities.handlePostRequest(
      requestBody: requestBody,
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (signInRawResponse){
        return UserViewModel.fromJson(signInRawResponse[ApiParseKeys.RESPONSE_SUCCESS_ROOT]);
      },
    );
    return ResponseViewModel<UserViewModel>(
      responseData: signInResponse.responseData,
      isSuccess: signInResponse.isSuccess,
      errorViewModel: signInResponse.errorViewModel,
    );

  }
  static signOut() async {
    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
    });
    String apiURL = URL.getURL(apiPath: URL.GET_LOGOUT);
    ResponseViewModel signOutResponse = await NetworkUtilities.handleGetRequest(
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (signOutResponse){
        return true ;
      },
    );
    return ResponseViewModel<bool>(
      responseData: signOutResponse.responseData,
      isSuccess: signOutResponse.isSuccess ||
      (signOutResponse.errorViewModel != null && signOutResponse.errorViewModel.errorCode == 401),
      errorViewModel: signOutResponse.errorViewModel,
    );
  }

  static saveUserAddress(AddressViewModel newAddress) async{
    Map<String,dynamic> requestBody = {
      'buildingNumber': (newAddress.buildingNumber ?? 0).toString(),
      'streetName': newAddress.addressName ?? '',
      'city_id': (newAddress.city.id ?? 0).toString(),
      'area_id': (newAddress.area.id ?? 0).toString(),
    };
    if(newAddress.additionalInformation != null && newAddress.additionalInformation.length > 0){
      requestBody.putIfAbsent('remarks', () => newAddress.additionalInformation);
    }

    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
    });
    String apiURL = URL.getURL(apiPath: URL.POST_SAVE_NEW_ADDRESS);
    ResponseViewModel signInResponse = await NetworkUtilities.handlePostRequest(
      requestBody: requestBody,
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (saveAddressRawResponse){
         return AddressViewModel.fromJson(saveAddressRawResponse[ApiParseKeys.ADDRESS_ROOT_KEY]);
      },
    );
    return ResponseViewModel<AddressViewModel>(
      responseData: signInResponse.responseData,
      isSuccess: signInResponse.isSuccess,
      errorViewModel: signInResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<AddressViewModel>>> getUserAddresses() async {
    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
    });
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_USER_ADDRESSES);
    ResponseViewModel getAddressesResponse = await NetworkUtilities.handleGetRequest(
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (signOutResponse){
        return AddressViewModel.fromListJson(signOutResponse[ApiParseKeys.ADDRESSES_LIST_ROOT]);
      },
    );
    return ResponseViewModel<List<AddressViewModel>>(
      responseData: getAddressesResponse.responseData,
      isSuccess: getAddressesResponse.isSuccess,
      errorViewModel: getAddressesResponse.errorViewModel,
    );
  }





  static Future<ResponseViewModel<UserViewModel>> updateUserProfile(String imageLink) async{
    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',});
    String apiURL = URL.getURL(apiPath: URL.UPLOAD_UPDATE_PROFILE_IMAGE);

    ResponseViewModel uploadResponse = await NetworkUtilities.handleUploadSingleFile(
      requestHeaders: requestHeaders,
      methodURL: apiURL,
      fileURL: imageLink,
      uploadKey: 'image',
      parserFunction: (uploadFileRawResponse){
        Map<String,dynamic> response = uploadFileRawResponse;
        response.putIfAbsent(ApiParseKeys.REGISTER_USER_TOKEN, () => token);
        return UserViewModel.fromJson(response);
      }
    );
    return ResponseViewModel<UserViewModel>(
      errorViewModel: uploadResponse.errorViewModel,
      isSuccess: uploadResponse.isSuccess,
      responseData: uploadResponse.responseData,
    );
  }

  static Future<ResponseViewModel<UserViewModel>> updateUser(UserViewModel updatedUser, String oldPassword, String newPassword) async{

    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders(customHeaders: {HttpHeaders.authorizationHeader : 'Bearer $token',});
    String apiURL = URL.getURL(apiPath: URL.PUT_UPDATE_USER_PROFILE);

    Map<String,dynamic> requestBody = {};
    if(updatedUser.userName != null){
      requestBody.putIfAbsent( 'name', () => updatedUser.userName);
    }
    if(updatedUser.userMail != null){
      requestBody.putIfAbsent( 'email', () => updatedUser.userMail);
    }
    if(updatedUser.userPhoneNumber != null){
      requestBody.putIfAbsent( 'phone', () => updatedUser.userPhoneNumber);
    }
    if(oldPassword != null && newPassword != null){
      requestBody.putIfAbsent( 'old_password', () => oldPassword);
      requestBody.putIfAbsent( 'new_password', () => newPassword);
      requestBody.putIfAbsent( 'new_password_confirmation', () => newPassword);
    }

    ResponseViewModel updateUserProfile = await NetworkUtilities.handlePutRequest(
      parserFunction: (updateProfileRawResponse){
        Map<String,dynamic> response = updateProfileRawResponse;
        response.putIfAbsent(ApiParseKeys.REGISTER_USER_TOKEN, () => token);
        return UserViewModel.fromJson(response);
      },
      methodURL: apiURL,
      requestHeaders: requestHeader,
      requestBody: requestBody,
    );
    ResponseViewModel<UserViewModel> updateUserData = ResponseViewModel<UserViewModel>(
        responseData: updateUserProfile.responseData,
        isSuccess: updateUserProfile.isSuccess,
        errorViewModel: updateUserProfile.errorViewModel
    );
    return updateUserData;
  }

  static Future<ResponseViewModel<UserViewModel>> signInWithFacebook() async{
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    ResponseViewModel facebookGraphResponse = await NetworkUtilities.handleGetRequest(
      parserFunction: (graphResponse){
        return UserViewModel(
          userName: graphResponse['name'],
          userMail: graphResponse['email'],
          userId: graphResponse['id'],
          userProfileImage: graphResponse['picture']['data']['url'],
          userToken: token,
        );
      },
      methodURL: 'https://graph.facebook.com/v9.0/me?fields=name,first_name,last_name,email,picture&access_token=$token',
    );

    return ResponseViewModel<UserViewModel>(
      errorViewModel: facebookGraphResponse.errorViewModel,
      isSuccess: facebookGraphResponse.isSuccess,
      responseData: facebookGraphResponse.responseData,
    );

  }

  static Future<ResponseViewModel<bool>> deleteUserAddress(AddressViewModel address) async {


    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
    });
    String apiURL = URL.getURL(apiPath: '${URL.GET_DELETE_ADDRESS_BY_ID}${address.id}?locale=${Constants.appLocale}');
    ResponseViewModel getAddressesResponse = await NetworkUtilities.handleGetRequest(
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (removeAddress){
        return true;
      },
    );
    return ResponseViewModel<bool>(
      responseData: getAddressesResponse.isSuccess,
      isSuccess: getAddressesResponse.isSuccess,
      errorViewModel: getAddressesResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<AddressViewModel>> updateUserAddress(AddressViewModel newAddress) async{
    Map<String,dynamic> requestBody = {
      'address_id': newAddress.id ?? '',
      'buildingNumber': (newAddress.buildingNumber ?? 0).toString(),
      'streetName': newAddress.addressName ?? '',
      'city_id': (newAddress.city.id ?? 0).toString(),
      'area_id': (newAddress.area.id ?? 0).toString(),
    };
    if(newAddress.additionalInformation != null && newAddress.additionalInformation.length > 0){
      requestBody.putIfAbsent('remarks', () => newAddress.additionalInformation);
    }

    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
    });
    String apiURL = URL.getURL(apiPath: URL.PUT_EDIT_USER_ADDRESS);
    ResponseViewModel signInResponse = await NetworkUtilities.handlePutRequest(
      requestBody: requestBody,
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (saveAddressRawResponse){
        return AddressViewModel.fromJson(saveAddressRawResponse[ApiParseKeys.ADDRESS_ROOT_KEY]);
      },
    );
    return ResponseViewModel<AddressViewModel>(
      responseData: signInResponse.responseData,
      isSuccess: signInResponse.isSuccess,
      errorViewModel: signInResponse.errorViewModel,
    );
  }





}