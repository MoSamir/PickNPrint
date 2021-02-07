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
  List<String> originalImages = List();
  List<String> uploadedImages = List();
  String contactPhoneNumber  ;
  double orderNetPrice , orderGrossPrice ;

  int deliveryTime;
  OrderModel({this.orderPackage, this.orderGrossPrice , this.orderNetPrice , this.uploadedImages , this.originalImages ,this.contactPhoneNumber , this.deliveryTime , this.statues ,this.orderNumber , this.orderTime , this.frameWithPath , this.isWhiteFrame , this.userImages , this.orderAddress});
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
    if(orderJson[ApiParseKeys.ORDER_ITEMS_LIST_KEY] != null && orderJson[ApiParseKeys.ORDER_ITEMS_LIST_KEY] is List){
      for(int i = 0 ; i < (orderJson[ApiParseKeys.ORDER_ITEMS_LIST_KEY]).length ; i++)
        orderImages.add(orderJson[ApiParseKeys.ORDER_ITEMS_LIST_KEY][i][ApiParseKeys.ORDER_USER_IMAGE].toString());
    }

    return OrderModel(
      orderGrossPrice: ParserHelper.parseDouble((orderJson[ApiParseKeys.ORDER_CART_GROSS_PRICE]).toString()),
      orderNetPrice: ParserHelper.parseDouble((orderJson[ApiParseKeys.ORDER_CART_NET_PRICE]).toString()),
      orderNumber: int.parse((orderJson[ApiParseKeys.ORDER_ID]).toString()),

      orderPackage: PackageModel(
        packagePrice: ParserHelper.parseDouble(orderJson[ApiParseKeys.ORDER_PACKAGE_PRICE].toString()),
        packageSize: int.parse((orderJson[ApiParseKeys.ORDER_PACKAGE_SIZE] ?? 3).toString()),
        packageMainImage: orderJson[ApiParseKeys.ORDER_PACKAGE_IMAGE].toString(),
        packageIcon: orderJson[ApiParseKeys.ORDER_PACKAGE_ICON].toString(),
        packageSaving: ParserHelper.parseDouble(orderJson[ApiParseKeys.ORDER_PACKAGE_DISCOUNT].toString()),
        priceForExtraFrame: ParserHelper.parseDouble(orderJson[ApiParseKeys.ORDER_EXTRA_FRAME_PRICE].toString()),
      ),
      frameWithPath: int.parse(((orderJson[ApiParseKeys.ORDER_WITH_FRAME]) ?? 0).toString()) == 1 ,
      isWhiteFrame: int.parse(((orderJson[ApiParseKeys.ORDER_WHITE_FRAME] ?? 0)).toString()) == 1 ,
      userImages: orderImages,
      orderAddress: AddressViewModel(
        deliveryFees: ParserHelper.parseDouble((orderJson[ApiParseKeys.ADDRESSES_SHIPPING_FEES]).toString()),
      ),
    );
  }

  static List<OrderModel> fromOrdersList(saveOrderRawResponse) {
    List<OrderModel> ordersList  = List<OrderModel>();
    if(saveOrderRawResponse != null && saveOrderRawResponse is List) {
      for (int i = 0; i < saveOrderRawResponse.length ; i++){
        ordersList.add(fromJson(saveOrderRawResponse[i]));
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
enum OrderStatus { PENDING , PREPARING , SHIPPING, DELIVERED  , CANCELED , SAVED , CART_ORDER}
