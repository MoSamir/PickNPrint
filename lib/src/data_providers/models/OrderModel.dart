import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';

class OrderModel {

  PackageModel orderPackage ;
  AddressViewModel orderAddress;
  bool frameWithPath , isWhiteFrame ;
  DateTime orderTime ;
  int orderNumber ;
  OrderStatus statues ;
  List<String> userImages = List();
  OrderModel({this.orderPackage , this.statues ,this.orderNumber , this.orderTime , this.frameWithPath , this.isWhiteFrame , this.userImages , this.orderAddress});

}

enum OrderStatus { PREPARING , SHIPPING, DELIVERED  , CANCELED }