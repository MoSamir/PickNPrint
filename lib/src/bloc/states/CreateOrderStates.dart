import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';

abstract class CreateOrderStates {}


class OrderCreationLoadingState extends CreateOrderStates{}
class OrderCreationInitialState extends CreateOrderStates{}
class OrderCreationLoadedSuccessState extends CreateOrderStates{
  final String orderNumber ;
  OrderCreationLoadedSuccessState({this.orderNumber});

}
class OrderCreationLoadingFailureState extends CreateOrderStates{
  final CreateOrderEvents failureEvent ;
  final ErrorViewModel error ;
  OrderCreationLoadingFailureState({this.failureEvent , this.error});
}

