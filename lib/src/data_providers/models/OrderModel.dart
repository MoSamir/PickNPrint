import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';

class OrderModel {

  PackageModel orderPackage ;
  AddressViewModel orderAddress;
  bool frameWithPath , isWhiteFrame ;
  List<String> userImages = List();
  OrderModel({this.orderPackage , this.frameWithPath , this.isWhiteFrame , this.userImages , this.orderAddress});






}