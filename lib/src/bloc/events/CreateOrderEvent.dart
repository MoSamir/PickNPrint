import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';

abstract class CreateOrderEvents {}

class CreateOrder extends CreateOrderEvents{
  final OrderModel orderModel ;
  CreateOrder({this.orderModel});
}


class SaveOrder extends CreateOrderEvents{
  final OrderModel order ;
  SaveOrder({this.order});

}