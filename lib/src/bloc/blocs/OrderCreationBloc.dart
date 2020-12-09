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
      if(event.orderModel.statues == OrderStatus.SAVED){
        yield* _handleSavedOrderCreation(event);
        return ;
      }
      else {
        yield* _handleOrderCreation(event);
        return ;
      }

    }
    if(event is SaveOrder){
      yield* _handleSaveOrder(event);
      return ;
    }
    if(event is AddOrderToCart){
      yield* _handleAddOrderToCart(event);
      return;
    }


  }

  Stream<CreateOrderStates> _handleOrderCreation(CreateOrder event) async*{
    yield OrderCreationLoadingState();

    ResponseViewModel<List<String>> uploadCartImages;
    bool isLocalImages = false ;
    try{
      isLocalImages = await File.fromUri(Uri.parse(event.orderModel.userImages[0])).exists();
    } catch(_){

    }

    print(isLocalImages);
    if(isLocalImages)
      uploadCartImages = await Repository.uploadMultipleFiles(event.orderModel.userImages);
    else
      uploadCartImages = ResponseViewModel(
        responseData: event.orderModel.userImages,
        isSuccess: true
      );
    if(uploadCartImages.isSuccess){
      event.orderModel.userImages.clear();
      event.orderModel.userImages.addAll(uploadCartImages.responseData);
      ResponseViewModel<List<OrderModel>> saveOrderResponse = await Repository.saveOrderToCart(orderModel: event.orderModel);
      if(saveOrderResponse.isSuccess){
        ResponseViewModel<List<OrderModel>> orderCreationResult = await Repository.createOrder(event.orderModel);
        if(orderCreationResult.isSuccess){
          yield OrderCreationLoadedSuccessState(
            orderNumber: orderCreationResult.responseData.length > 0 ? orderCreationResult.responseData[0].orderNumber.toString() : '',
            shippingDuration: orderCreationResult.responseData.length > 0 ? orderCreationResult.responseData[0].deliveryTime.toString() : '',
          );
          return ;
        }
        else {
          yield OrderCreationLoadingFailureState(
            error: orderCreationResult.errorViewModel,
            failureEvent: event,
          );
          return ;
        }
      } else {
        yield OrderSavingFailedState(failedEvent: event, error: saveOrderResponse.errorViewModel,);
        return ;
      }
    }
    else {
      yield OrderSavingFailedState(failedEvent: event, error: uploadCartImages.errorViewModel,);
      return ;
      return;
    }


  }

  Stream<CreateOrderStates> _handleSaveOrder(SaveOrder event) async*{
    yield OrderCreationLoadingState();
    ResponseViewModel<List<OrderModel>> saveUserCart = await Repository.saveOrderForLater(event.order);
    if(saveUserCart.isSuccess){
      yield OrderSavingSuccessState(
        cartOrders : saveUserCart.responseData,
      );
      return;
    }
    else {
      yield OrderSavingFailedState(failedEvent: event, error: saveUserCart.errorViewModel,);
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

  Stream<CreateOrderStates> _handleAddOrderToCart(AddOrderToCart event) async*{
    yield OrderCreationLoadingState();
    ResponseViewModel<List<OrderModel>> saveOrderResponse = await Repository.saveOrderToCart(orderModel: event.order);
    if(saveOrderResponse.isSuccess){
      yield OrderAddedToCartSuccessState(
        cartOrders : saveOrderResponse.responseData,
      );
      return;
    } else {
     yield OrderSavingFailedState(failedEvent: event, error: saveOrderResponse.errorViewModel,);
      return ;
    }
  }

  Stream<CreateOrderStates> _handleSavedOrderCreation(CreateOrder event) async*{
    yield OrderCreationLoadingState();

    ResponseViewModel<List<OrderModel>> savedOrderCreationResult = await Repository.createSavedOrder(event.orderModel);
    if(savedOrderCreationResult.isSuccess){
      yield OrderCreationLoadedSuccessState(
        orderNumber: savedOrderCreationResult.responseData.length > 0 ? savedOrderCreationResult.responseData[0].orderNumber.toString() : '',
        shippingDuration: "5",
      );
      return ;
    }
    else {
      yield OrderCreationLoadingFailureState(
        error: savedOrderCreationResult.errorViewModel,
        failureEvent: event,
      );
      return ;
    }




  }

}