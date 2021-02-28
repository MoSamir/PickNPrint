import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/PromocodeModel.dart';

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
  PromoCodeModel promoCode ;

  int deliveryTime;
  OrderModel({this.orderPackage, this.promoCode , this.orderGrossPrice , this.orderNetPrice , this.uploadedImages , this.originalImages ,this.contactPhoneNumber , this.deliveryTime , this.statues ,this.orderNumber , this.orderTime , this.frameWithPath , this.isWhiteFrame , this.userImages , this.orderAddress});
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

    String itemStatus = orderJson[ApiParseKeys.ORDER_ITEM_STATUS] != null ?
    orderJson[ApiParseKeys.ORDER_ITEM_STATUS][ApiParseKeys.ORDER_ITEM_STATUS_KEY] : null;


    AddressViewModel orderAddress = AddressViewModel(deliveryFees: ParserHelper.parseDouble((orderJson[ApiParseKeys.ADDRESSES_SHIPPING_FEES]).toString()),);

    try{
      if(orderJson[ApiParseKeys.ADDRESS_ROOT_KEY] != null && orderJson[ApiParseKeys.ADDRESS_ROOT_KEY] is Map ) {
        Map<String,dynamic> addressMap = orderJson[ApiParseKeys.ADDRESS_ROOT_KEY];
        addressMap.putIfAbsent( ApiParseKeys.ADDRESSES_SHIPPING_FEES , () => orderJson[ApiParseKeys.ADDRESSES_SHIPPING_FEES]);
        orderAddress = AddressViewModel.getOrderAddressFromJson(addressMap);
      }
    } catch(_){}



    int deliveryExpectedTime = 5 ;
    try{
      deliveryExpectedTime =  int.parse(orderJson[ApiParseKeys.ORDER_SHIPPING_TIME].toString());
    } catch(_){}

    return OrderModel(
      statues: getOrderStatus(itemStatus),
     deliveryTime: deliveryExpectedTime,
      orderTime:  DateTime.parse(orderJson[ApiParseKeys.ORDER_CREATED_AT] ?? DateTime.now().toString()),
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
      orderAddress: orderAddress,
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

    print("Order Statues => $orderStatus");
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

  calculateOrderTotal() {
    double total = 0.0;

    if(orderPackage != null){
      total = orderPackage.packagePrice + ((userImages.length - orderPackage.packageSize) * orderPackage.priceForExtraFrame);
    }
    return total;
  }
}
enum OrderStatus { PENDING , PREPARING , SHIPPING, DELIVERED  , CANCELED , SAVED , CART_ORDER}
