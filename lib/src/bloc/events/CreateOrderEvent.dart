import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';

abstract class CreateOrderEvents {}

class CreateOrder extends CreateOrderEvents{
  final OrderModel orderModel ;
  CreateOrder( {this.orderModel});
}

class CheckPromoCodeValidity extends CreateOrderEvents {
  final String promoText;
  final double orderTotal ;
  CheckPromoCodeValidity({this.promoText , this.orderTotal});
}

class SaveOrder extends CreateOrderEvents{
  final OrderModel order ;
  SaveOrder({this.order});

}


class AddOrderToCart extends CreateOrderEvents{
  final OrderModel order ;
  AddOrderToCart({this.order});

}