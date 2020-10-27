import 'dart:convert';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xxtea/xxtea.dart';

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
        userSavedAddresses: [
          AddressViewModel(
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
          AddressViewModel(
            buildingNumber: '27',
            addressName: 'Work',
            additionalInformation: 'Sakalia Street',
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

        ],
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

  static Future<ResponseViewModel<UserViewModel>> registerNewUser(UserViewModel userModel, String userPassword) async{
    
    await Future.delayed(Duration(seconds: 2),(){});
    return ResponseViewModel<UserViewModel>(
      isSuccess: true,
      responseData: UserViewModel(
        userToken: '',
        userId: 1,
        userName: 'Username',
        userPhoneNumber: '+201013615170',
        userMail: 'mohamedsamir731@gmail.com'
      ),
    );
    
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