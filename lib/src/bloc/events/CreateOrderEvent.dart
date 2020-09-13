import 'package:picknprint/src/data_providers/models/OrderModel.dart';

abstract class CreateOrderEvents {}

class CreateOrder extends CreateOrderEvents{
  final OrderModel orderModel ;
  CreateOrder({this.orderModel});
}