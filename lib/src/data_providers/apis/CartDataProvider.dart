import 'dart:io';

import 'package:picknprint/src/data_providers/apis/UserDataProvider.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';

import 'helpers/ApiParseKeys.dart';
import 'helpers/NetworkUtilities.dart';
import 'helpers/URL.dart';

class CartDataProvider {

  static Future<ResponseViewModel<List<OrderModel>>> saveOrderToCart(OrderModel order) async {
    String token = await UserDataProvider.getUserToken();

    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
      "Content-Type": "application/json"
    });
    Map<String,dynamic> requestBody = {
      'package_id' : order.orderPackage.packageId.toString(),
      'color': order.isWhiteFrame ? 1.toString() : 0.toString(),
      'selection': order.frameWithPath ? 1.toString() : 0.toString(),
      'images': order.userImages,
    };
    if(order.userImages.length > order.orderPackage.packageSize){
      requestBody.putIfAbsent('additionalFramesQty', () => (order.userImages.length - order.orderPackage.packageSize).toString());
    }
    String apiURL = URL.getURL(apiPath: URL.POST_ADD_ORDER_TO_CART);
    ResponseViewModel saveOrderResponse = await NetworkUtilities.handlePostRequest(
        methodURL: apiURL,
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        acceptJson: true,
        parserFunction: (saveOrderRawResponse){
          return OrderModel.fromListJson(saveOrderRawResponse[ApiParseKeys.ORDER_CART_ROOT_KEY][ApiParseKeys.ORDER_ITEMS_LIST_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );
  }
  static Future<ResponseViewModel<List<OrderModel>>> saveOrderToLater(OrderModel order) async {

    String token = await UserDataProvider.getUserToken();

    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token'
    });
    Map<String,dynamic> requestBody = {
      'order_status' : 'saved',
      'package_id' : order.orderPackage.packageId.toString(),
      'color': order.isWhiteFrame ? 1.toString() : 0.toString(),
      'selection': order.frameWithPath ? 1.toString() : 0.toString(),
      'address_id': order.orderAddress.id.toString(),
    };
    List<String> socialMediaImages = List<String>();
    for(int i = 0 ; i < order.userImages.length ; i++){
      if(order.userImages[i].startsWith('https') || order.userImages[i].startsWith('http')){
        socialMediaImages.add(order.userImages[i]);
      }
    }
    if(socialMediaImages.length > 0){
      requestBody.putIfAbsent('imagesViaSocialMedia', () => socialMediaImages);
    }

    if(order.userImages.length > order.orderPackage.packageSize){
      requestBody.putIfAbsent('additionalFramesQty', () => (order.userImages.length - order.orderPackage.packageSize).toString());
    }
    String apiURL = URL.getURL(apiPath: URL.POST_SAVE_ORDER_FOR_LATER);

    ResponseViewModel saveOrderResponse = await NetworkUtilities.handleUploadFiles(
        methodURL: apiURL,
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        files: order.userImages,
        isBodyJson: true,
        parserFunction: (saveOrderRawResponse){
          return OrderModel.fromOrdersList(saveOrderRawResponse[ApiParseKeys.ORDER_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );
  }



  static Future<ResponseViewModel<List<OrderModel>>> createOrder(OrderModel order) async {
    String token = await UserDataProvider.getUserToken();
    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token'
    });
    Map<String,dynamic> requestBody = {
      'address_id' : order.orderAddress.id,
    };
    String apiURL = URL.getURL(apiPath: URL.POST_CREATE_ORDER);
    ResponseViewModel saveOrderResponse = await NetworkUtilities.handlePostRequest(
        methodURL: apiURL,
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        parserFunction: (createOrderRawResponse){
          return OrderModel.fromOrdersList(createOrderRawResponse[ApiParseKeys.ORDER_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );
  }


  static Future<ResponseViewModel<List<OrderModel>>> getUserCart() async {
    String token = await UserDataProvider.getUserToken();

    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token'
    });
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_USER_CART);
    ResponseViewModel saveOrderResponse = await NetworkUtilities.handleGetRequest(
        methodURL: apiURL,
        requestHeaders: requestHeaders,
        parserFunction: (saveOrderRawResponse){
          return OrderModel.fromListJson(saveOrderRawResponse[ApiParseKeys.ORDER_CART_ROOT_KEY][ApiParseKeys.ORDER_ITEMS_LIST_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );
  }
  static Future<ResponseViewModel<List<OrderModel>>> loadSavedOrders() async{
    String token = await UserDataProvider.getUserToken();
    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token'
    });
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_SAVED_ORDERS);
    ResponseViewModel saveOrderResponse = await NetworkUtilities.handleGetRequest(
        methodURL: apiURL,
        requestHeaders: requestHeaders,
        parserFunction: (saveOrderRawResponse){
          return OrderModel.fromOrdersList(saveOrderRawResponse[ApiParseKeys.ORDERS_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );
  }
  static Future<ResponseViewModel<List<OrderModel>>> loadClosedOrders() async{
    String token = await UserDataProvider.getUserToken();
    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token'
    });
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_PAST_ORDERS);
    ResponseViewModel saveOrderResponse = await NetworkUtilities.handleGetRequest(
        methodURL: apiURL,
        requestHeaders: requestHeaders,
        parserFunction: (saveOrderRawResponse){
          return OrderModel.fromOrdersList(saveOrderRawResponse[ApiParseKeys.ORDERS_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );

  }
  static Future<ResponseViewModel<List<OrderModel>>> loadActiveOrders() async{
    String token = await UserDataProvider.getUserToken();
    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token'
    });
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_ACTIVE_ORDERS);
    ResponseViewModel saveOrderResponse = await NetworkUtilities.handleGetRequest(
        methodURL: apiURL,
        requestHeaders: requestHeaders,
        parserFunction: (saveOrderRawResponse){
          return OrderModel.fromOrdersList(saveOrderRawResponse[ApiParseKeys.ORDERS_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );

  }

  static Future<ResponseViewModel<List<OrderModel>>> createSavedOrder(OrderModel orderModel) async{

    String token = await UserDataProvider.getUserToken();
    Map<String,String> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token'
    });
    Map<String,dynamic> requestBody = {
      'address_id' : orderModel.orderAddress.id.toString(),
      'order_id' : orderModel.orderNumber.toString(),
    };
    String apiURL = URL.getURL(apiPath: URL.POST_CREATE_SAVED_ORDER);
    ResponseViewModel saveOrderResponse = await NetworkUtilities.handlePostRequest(
        methodURL: apiURL,
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        parserFunction: (createOrderRawResponse){
          return OrderModel.fromOrdersList(createOrderRawResponse[ApiParseKeys.ORDER_KEY]);
        }
    );
    return ResponseViewModel<List<OrderModel>>(
      responseData: saveOrderResponse.responseData,
      isSuccess: saveOrderResponse.isSuccess,
      errorViewModel: saveOrderResponse.errorViewModel,
    );


  }




}