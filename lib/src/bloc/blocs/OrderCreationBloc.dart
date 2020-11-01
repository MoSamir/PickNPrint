import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';

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
    if(event is SaveOrder){
      yield* _handleSaveOrder(event);
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

  Stream<CreateOrderStates> _handleSaveOrder(SaveOrder event) async*{
    yield OrderCreationLoadingState();
    ResponseViewModel<String> saveOrderResponse = await Repository.saveOrderToLater(event.order);
    if(saveOrderResponse.isSuccess){
      yield OrderSavingSuccessState(
        orderNumber: saveOrderResponse.responseData,
      );
      return;
    } else {
      OrderSavingFailedState(
        failedEvent: event,
        error: saveOrderResponse.errorViewModel,
      );
      return ;
    }
  }




  Future<String> validateOrder(OrderModel userOrder) async{
    for(int i = 0 ; i < userOrder.userImages.length ; i++){
      String imagePath = userOrder.userImages[i];

      if(imagePath == null || imagePath.isEmpty){
        return (LocalKeys.SOME_IMAGES_IS_MISSING).tr();
      }

      try{
        File imageFile = File(imagePath);
        var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
        if(decodedImage.width < 50  || decodedImage.height < 50){
          return (LocalKeys.IMAGE_IS_TOO_SMALL).tr();
        }
      } catch(exception){

        ResponseViewModel isValidImage = await NetworkUtilities.handleGetRequest(
          methodURL: imagePath,
          parserFunction: (json){},
        );
        if(isValidImage.isSuccess == false && isValidImage.errorViewModel.errorCode == 404){
          return (LocalKeys.IMAGE_IS_TOO_SMALL).tr();
        }
      }
    }
    return null;
  }

}