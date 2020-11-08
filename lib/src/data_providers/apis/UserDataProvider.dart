import 'dart:convert';
import 'dart:io';
import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xxtea/xxtea.dart';

import 'helpers/URL.dart';

class UserDataProvider{

  static Future<ResponseViewModel<UserViewModel>> registerNewUser(UserViewModel userModel, String userPassword) async{

    Map<String,dynamic> requestBody = {
      'name': userModel.userName ?? '',
      'phone': userModel.userPhoneNumber,
      'email': userModel.userMail,
      'password': userPassword,
      'password_confirmation': userPassword,
    };
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders();
    String apiURL = URL.getURL(apiPath: URL.POST_REGISTER);
    ResponseViewModel registerUserResponse = await NetworkUtilities.handlePostRequest(
      requestBody: requestBody,
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (registerUserRawResponse){
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
    String token = await getUserToken();
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
    return ResponseViewModel<UserViewModel>(
      responseData: signOutResponse.responseData,
      isSuccess: signOutResponse.isSuccess ||
      (signOutResponse.errorViewModel != null && signOutResponse.errorViewModel.errorCode == 401),
      errorViewModel: signOutResponse.errorViewModel,
    );
  }

  static saveUserAddress(AddressViewModel newAddress) async{
    Map<String,dynamic> requestBody = {
      'buildingNumber': newAddress.buildingNumber ?? 0,
      'streetName': newAddress.addressName ?? '',
      'city_id': newAddress.city.id ?? 0,
      'area_id': newAddress.area.id ?? 0,
    };
    if(newAddress.additionalInformation != null && newAddress.additionalInformation.length > 0){
      requestBody.putIfAbsent('remarks', () => newAddress.additionalInformation);
    }

    String token = await getUserToken();
    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
    });
    String apiURL = URL.getURL(apiPath: URL.POST_SAVE_NEW_ADDRESS);
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


  static Future<ResponseViewModel<List<String>>> createOrder(OrderModel orderModel) async{

    await Future.delayed(Duration(seconds: 2),(){});
    return ResponseViewModel<List<String>>(
      responseData: ['123456','5'],
      isSuccess: true,
    );
  }

  static Future<ResponseViewModel<List<OrderModel>>> addToCart(OrderModel orderItem) async {
    await Future.delayed(Duration(seconds:2),(){});
    return ResponseViewModel<List<OrderModel>>(
      responseData: [
        OrderModel(
          orderPackage: PackageModel(
            packagePrice: 150,
            packageSaving: 20,
            packageSize: 3
          ),
        ),
        OrderModel(
          orderPackage: PackageModel(
              packagePrice: 180,
              packageSaving: 30,
              packageSize: 4
          ),
        ),
        OrderModel(
          orderPackage: PackageModel(
              packagePrice: 150,
              packageSaving: 20,
              packageSize: 3
          ),
        ),
      ],
      isSuccess: true,
    );
  }

  static Future<ResponseViewModel<List<OrderModel>>> syncCart(List<OrderModel>  ordersList) async {
    await Future.delayed(Duration(seconds:2),(){});
    return ResponseViewModel<List<OrderModel>>(
      responseData: [
        OrderModel(
          orderPackage: PackageModel(
              packagePrice: 150,
              packageSaving: 20,
              packageSize: 3
          ),
        ),
        OrderModel(
          orderPackage: PackageModel(
              packagePrice: 180,
              packageSaving: 30,
              packageSize: 4
          ),
        ),
        OrderModel(
          orderPackage: PackageModel(
              packagePrice: 150,
              packageSaving: 20,
              packageSize: 3
          ),
        ),
      ],
      isSuccess: true,
    );
  }

  static Future<ResponseViewModel<String>> saveOrder(OrderModel order) async{
    await Future.delayed(Duration(seconds:2),(){});
    return ResponseViewModel<String>(
      responseData: "501233",
      isSuccess: true,
    );
  }


  
  static Future<ResponseViewModel<List<OrderModel>>> loadSavedOrders() async{

    await Future.delayed(Duration(seconds: 2),(){});
    return ResponseViewModel<List<OrderModel>>(
      isSuccess: true,
      responseData: [
        OrderModel(
          orderTime: DateTime.now(),
          orderNumber: 123,
          isWhiteFrame: true,
          userImages: [],
          frameWithPath: false,
          orderPackage: PackageModel(
            packagePrice: 500,
            packageSaving: 20,
            packageSize: 3,
          ),
          orderAddress: AddressViewModel(
            buildingNumber: '1',
            addressName: 'My Apartment',

            additionalInformation: '',
            area: LocationModel(
              name: 'Ain shams',
              id: 1,
              childLocations: [],
            ),
            city: LocationModel(
              name: 'Cairo',
              id: 1,
              childLocations: [],
            ),
          ),
          statues: null,
        ),
        OrderModel(
          orderTime: DateTime.now(),
          orderNumber: 124,
          isWhiteFrame: true,
          userImages: [],
          frameWithPath: false,
          orderPackage: PackageModel(
            packagePrice: 520,
            packageSaving: 30,
            packageSize: 4,
          ),
          orderAddress: AddressViewModel(
            buildingNumber: '1',
            addressName: 'My Apartment',

            additionalInformation: '',
            area: LocationModel(
              name: 'Ain shams',
              id: 1,
              childLocations: [],
            ),
            city: LocationModel(
              name: 'Cairo',
              id: 1,
              childLocations: [],
            ),
          ),
          statues: null,
        ),
      ],
    );


  }
  static Future<ResponseViewModel<List<OrderModel>>> loadClosedOrders() async{

    await Future.delayed(Duration(seconds: 2),(){});
    return ResponseViewModel<List<OrderModel>>(
      isSuccess: true,
      responseData: [
        OrderModel(
          orderTime: DateTime.now(),
          orderNumber: 123,
          isWhiteFrame: true,
          userImages: [],
          frameWithPath: false,
          orderPackage: PackageModel(
            packagePrice: 500,
            packageSaving: 20,
            packageSize: 3,
          ),
          orderAddress: AddressViewModel(
            buildingNumber: '1',
            addressName: 'My Apartment',

            additionalInformation: '',
            area: LocationModel(
              name: 'Ain shams',
              id: 1,
              childLocations: [],
            ),
            city: LocationModel(
              name: 'Cairo',
              id: 1,
              childLocations: [],
            ),
          ),
          statues: OrderStatus.CANCELED,
        ),
        OrderModel(
          orderTime: DateTime.now(),
          orderNumber: 124,
          isWhiteFrame: true,
          userImages: [],
          frameWithPath: false,
          orderPackage: PackageModel(
            packagePrice: 520,
            packageSaving: 30,
            packageSize: 4,
          ),
          orderAddress: AddressViewModel(
            buildingNumber: '1',
            addressName: 'My Apartment',

            additionalInformation: '',
            area: LocationModel(
              name: 'Ain shams',
              id: 1,
              childLocations: [],
            ),
            city: LocationModel(
              name: 'Cairo',
              id: 1,
              childLocations: [],
            ),
          ),
          statues: OrderStatus.DELIVERED,
        ),
      ],
    );


  }
  static Future<ResponseViewModel<List<OrderModel>>> loadActiveOrders() async{

    await Future.delayed(Duration(seconds: 2),(){});
    return ResponseViewModel<List<OrderModel>>(
      isSuccess: true,
      responseData: [
        OrderModel(
          orderTime: DateTime.now(),
          orderNumber: 123,
          isWhiteFrame: true,
          userImages: [],
          frameWithPath: false,
          orderPackage: PackageModel(
            packagePrice: 500,
            packageSaving: 20,
            packageSize: 3,
          ),
          orderAddress: AddressViewModel(
            buildingNumber: '1',
            addressName: 'My Apartment',

            additionalInformation: '',
            area: LocationModel(
              name: 'Ain shams',
              id: 1,
              childLocations: [],
            ),
            city: LocationModel(
              name: 'Cairo',
              id: 1,
              childLocations: [],
            ),
          ),
          statues: OrderStatus.SHIPPING,
        ),
        OrderModel(
          orderTime: DateTime.now(),
          orderNumber: 124,
          isWhiteFrame: true,
          userImages: [],
          frameWithPath: false,
          orderPackage: PackageModel(
            packagePrice: 520,
            packageSaving: 30,
            packageSize: 4,
          ),
          orderAddress: AddressViewModel(
            buildingNumber: '1',
            addressName: 'My Apartment',

            additionalInformation: '',
            area: LocationModel(
              name: 'Ain shams',
              id: 1,
              childLocations: [],
            ),
            city: LocationModel(
              name: 'Cairo',
              id: 1,
              childLocations: [],
            ),
          ),
          statues: OrderStatus.PREPARING,
        ),
      ],
    );
  }





}