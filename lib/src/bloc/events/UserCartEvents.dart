
import 'package:picknprint/src/data_providers/models/PackageModel.dart';

abstract class UserCartEvents {}

class LoadCartEvent extends UserCartEvents{}


class RemoveItemFromCart extends UserCartEvents{
  final PackageModel packageModel ;
  RemoveItemFromCart({this.packageModel});
}
class AddItemToCart extends UserCartEvents{
  final PackageModel packageModel ;
  AddItemToCart({this.packageModel});
}



class CheckoutCart extends UserCartEvents{}