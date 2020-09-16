import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';

class OrderCreationBloc extends Bloc<CreateOrderEvents , CreateOrderStates>{
  OrderCreationBloc(CreateOrderStates initialState) : super(initialState);

  @override
  Stream<CreateOrderStates> mapEventToState(CreateOrderEvents event) async*{

    bool isConnected = await NetworkUtilities.isConnected();
    if(isConnected == false){
      yield OrderCreationLoadingFailureState(error: Constants.CONNECTION_TIMEOUT, failureEvent: event);
      return ;
    }

    if(event is CreateOrder){
      yield* _handleOrderCreation(event);
      return ;
    }


  }

  Stream<CreateOrderStates> _handleOrderCreation(CreateOrder event) async*{
    yield OrderCreationLoadingState();
    ResponseViewModel<List<String>> orderCreationResult = await Repository.createOrder(event.orderModel);

    if(orderCreationResult.isSuccess){
      yield OrderCreationLoadedSuccessState(orderNumber: orderCreationResult.responseData[0].toString(),
        shippingDuration: orderCreationResult.responseData[1].toString(),
      );
      return ;
    } else {
      yield OrderCreationLoadingFailureState(
        error: orderCreationResult.errorViewModel,
        failureEvent: event,
      );
      return ;
    }
  }
}