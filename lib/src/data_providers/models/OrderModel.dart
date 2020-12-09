import 'package:flutter/material.dart';
import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/utilities/ParserHelpers.dart';

class OrderModel {

  PackageModel orderPackage ;
  AddressViewModel orderAddress;
  bool frameWithPath , isWhiteFrame ;
  DateTime orderTime ;
  int orderNumber ;
  OrderStatus statues ;
  List<String> userImages = List();
  String contactPhoneNumber  ;

  int deliveryTime;
  OrderModel({this.orderPackage , this.contactPhoneNumber , this.deliveryTime , this.statues ,this.orderNumber , this.orderTime , this.frameWithPath , this.isWhiteFrame , this.userImages , this.orderAddress});

  static List<OrderModel> fromListJson(saveOrderRawResponse) {
    List<OrderModel> ordersList = List<OrderModel>();
    if(saveOrderRawResponse != null && saveOrderRawResponse is List){
      for(int i = 0 ; i < saveOrderRawResponse.length ; i++){
        ordersList.add(fromJson(saveOrderRawResponse[i]));
      }
    }
    return ordersList;
  }




  static OrderModel fromJson(orderJson){

    List<String> orderImages = List<String>();
    if(orderJson[ApiParseKeys.ORDER_USER_IMAGES] != null && orderJson[ApiParseKeys.ORDER_USER_IMAGES] is List){
      for(int i = 0 ; i < (orderJson[ApiParseKeys.ORDER_USER_IMAGES]).length ; i++)
        orderImages.add(orderJson[ApiParseKeys.ORDER_USER_IMAGES][i].toString());
    }


    if(orderJson[ApiParseKeys.ORDER_SOCIAL_IMAGES] != null && orderJson[ApiParseKeys.ORDER_SOCIAL_IMAGES] is List){
      for(int i = 0 ; i < (orderJson[ApiParseKeys.ORDER_SOCIAL_IMAGES]).length ; i++)
        orderImages.add(orderJson[ApiParseKeys.ORDER_SOCIAL_IMAGES][i].toString());
    }

    return OrderModel(

      orderNumber: int.parse((orderJson[ApiParseKeys.ORDER_ID]).toString()),
      orderPackage: PackageModel(
        packagePrice: ParserHelper.parseDouble(orderJson[ApiParseKeys.ORDER_PACKAGE_PRICE].toString()),
        packageSize: int.parse((orderJson[ApiParseKeys.ORDER_PACKAGE_SIZE] ?? 3).toString()),
        packageMainImage: orderJson[ApiParseKeys.ORDER_PACKAGE_IMAGE].toString(),
        packageIcon: orderJson[ApiParseKeys.ORDER_PACKAGE_ICON].toString(),
        packageSaving: ParserHelper.parseDouble(orderJson[ApiParseKeys.ORDER_PACKAGE_DISCOUNT].toString()),
        priceForExtraFrame: ParserHelper.parseDouble(orderJson[ApiParseKeys.ORDER_EXTRA_FRAME_PRICE].toString()),
      ),
      frameWithPath: int.parse((orderJson[ApiParseKeys.ORDER_WITH_FRAME]).toString()) == 1 ,
      isWhiteFrame: int.parse((orderJson[ApiParseKeys.ORDER_WHITE_FRAME]).toString()) == 1 ,
      userImages: orderImages,
    );
  }

  static List<OrderModel> fromOrdersList(saveOrderRawResponse) {



    List<OrderModel> ordersList  = List<OrderModel>();
    if(saveOrderRawResponse != null && saveOrderRawResponse is List) {
      for (int i = 0; i < saveOrderRawResponse.length; i++) {
        OrderStatus status = getOrderStatus(saveOrderRawResponse[i]['status']['key']);
        int deliveryTime = int.parse((saveOrderRawResponse[i]['shippingDurationTo'] ?? 1).toString());
        int orderId = int.parse((saveOrderRawResponse[i][ApiParseKeys.ORDER_ID] ?? 1).toString());

        DateTime orderTime = DateTime.parse(saveOrderRawResponse[i][ApiParseKeys.ORDER_CREATED_AT]);
        List<OrderModel> subOrder = fromListJson(saveOrderRawResponse[i][ApiParseKeys.ORDER_ITEMS_LIST_KEY]);
        for (OrderModel model in subOrder) {
          model.statues = status;
          model.orderTime = orderTime ?? DateTime.now();
          model.deliveryTime = deliveryTime;
          model.orderNumber = orderId;
          ordersList.add(model);
        }
      }
    } else {
      try{
        OrderStatus status = getOrderStatus(saveOrderRawResponse['status']['key']);
        DateTime orderTime = DateTime.parse(saveOrderRawResponse[ApiParseKeys.ORDER_CREATED_AT]);
        int deliveryTime = int.parse((saveOrderRawResponse['shippingDurationTo'] ?? 1).toString());

        List<OrderModel> subOrder = fromListJson(saveOrderRawResponse[ApiParseKeys.ORDER_ITEMS_LIST_KEY]);
        for(OrderModel model in subOrder){
          model.statues = status;
          model.orderTime = orderTime ?? DateTime.now();
          model.deliveryTime = deliveryTime;
          ordersList.add(model);
        }
      } catch(exception){
        debugPrint("Exception while creating the order => $exception");
      }
    }
    return ordersList;
  }

  static OrderStatus getOrderStatus(String orderStatus) {

    if(orderStatus == 'preparing'){
      return OrderStatus.PREPARING;
    } else if(orderStatus == 'delivered') {
      return OrderStatus.DELIVERED;
    } else if(orderStatus == 'cancelled') {
      return OrderStatus.CANCELED;
    } else if(orderStatus == 'shipping') {
      return OrderStatus.SHIPPING;
    } else if(orderStatus == 'saved') {
      return OrderStatus.SAVED;
    } else {
      return OrderStatus.PENDING;
    }
  }
}
enum OrderStatus { PENDING , PREPARING , SHIPPING, DELIVERED  , CANCELED , SAVED}



/*

            // Current Orders  => [, "preparing", ""]
            // Unsaved Orders  => [""]
 */