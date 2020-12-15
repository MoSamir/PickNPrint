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
    } catch(_){}
    if(isLocalImages) {
      uploadCartImages = await Repository.uploadMultipleFiles(event.orderModel.userImages);
      event.orderModel.userImages.clear();
      if(uploadCartImages.isSuccess){
        event.orderModel.userImages.addAll(uploadCartImages.responseData);
      }
    }
    else {
      uploadCartImages = ResponseViewModel(
          responseData: event.orderModel.userImages,
          isSuccess: true
      );
    }
    if(uploadCartImages.isSuccess){

      ResponseViewModel<List<OrderModel>> saveOrderResponse = ResponseViewModel<List<OrderModel>>(isSuccess: true);
      if(event.orderModel.statues == OrderStatus.CART_ORDER)
        saveOrderResponse = await Repository.saveOrderToCart(orderModel: event.orderModel);

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

    event.order.userImages.removeWhere((element) => element== null || element.isEmpty);
    ResponseViewModel<List<String>> uploadCartImages;
    bool isLocalImages = false ;
    try{
      isLocalImages = await File.fromUri(Uri.parse(event.order.userImages[0])).exists();
    } catch(_){}
    if(isLocalImages) {
      uploadCartImages = await Repository.uploadMultipleFiles(event.order.userImages);
      event.order.userImages.clear();
      if(uploadCartImages.isSuccess){
        event.order.userImages.addAll(uploadCartImages.responseData);
      }
    }
    else {
      uploadCartImages = ResponseViewModel(
          responseData: event.order.userImages,
          isSuccess: true
      );
    }
    if(uploadCartImages.isSuccess){
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
    } else {
      yield OrderSavingFailedState(failedEvent: event, error: uploadCartImages.errorViewModel,);
      return ;
    }


  }

  Future<String> validateOrder(OrderModel userOrder) async{
    int filledImages = 0 , notFilledImages = 0;
    for(int i = 0 ; i < userOrder.userImages.length ; i++){
      if(userOrder.userImages[i] == null || userOrder.userImages[i].isEmpty ){
        notFilledImages++;
      } else {
        filledImages++;
      }
    }

    if(filledImages < 3){
      return (LocalKeys.SOME_IMAGES_IS_MISSING).tr();
    }
    else if(notFilledImages > 1){
      return (LocalKeys.PROCEED_WITH_CURRENT_AMOUNT_WARNING).tr();
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