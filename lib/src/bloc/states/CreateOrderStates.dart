import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';

abstract class CreateOrderStates {}


class OrderCreationLoadingState extends CreateOrderStates{}
class OrderCreationInitialState extends CreateOrderStates{}
class OrderCreationLoadedSuccessState extends CreateOrderStates{
  final String orderNumber ;
  final OrderAction orderAction;
  final String shippingDuration ;
  OrderCreationLoadedSuccessState({this.orderNumber , this.shippingDuration , this.orderAction});

}
class OrderCreationLoadingFailureState extends CreateOrderStates{
  final CreateOrderEvents failureEvent ;
  final ErrorViewModel error ;
  OrderCreationLoadingFailureState({this.failureEvent , this.error});
}

class OrderSavingSuccessState extends CreateOrderStates{
  final String orderNumber ;
  OrderSavingSuccessState({this.orderNumber});
}

class OrderSavingFailedState extends CreateOrderStates{
  final ErrorViewModel error ;
  final CreateOrderEvents failedEvent;
  OrderSavingFailedState({this.failedEvent , this.error});
}



enum OrderAction{
 CREATION,
 SAVING,
}
