import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/apis/helpers/URL.dart';
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
      }  else {
        OrderModel eventOrder = event.orderModel;

        if(eventOrder.uploadedImages == null)
          eventOrder.uploadedImages = List<String>();

      if(event.orderModel.statues == OrderStatus.CART_ORDER){
        for(int i = 0 ; i < eventOrder.userImages.length ; i++) {
          if (eventOrder.userImages[i].contains(URL.SERVER_LINK))
            eventOrder.uploadedImages.add(eventOrder.userImages[i]);
        }
      }
        yield* _handleOrderCreation(CreateOrder(orderModel: eventOrder));
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

    ResponseViewModel<List<String>> uploadCartImages;
    if(event.order.uploadedImages == null || event.order.uploadedImages.length < event.order.userImages.length) {
      uploadCartImages = await Repository.uploadMultipleFiles(event.order.userImages);
      if(uploadCartImages.isSuccess){
        event.order.uploadedImages.addAll(uploadCartImages.responseData);
      }
    }
    else {
      uploadCartImages = ResponseViewModel(
          isSuccess: true
      );
    }

    if(uploadCartImages.isSuccess){
      ResponseViewModel<OrderModel> saveOrderResponse = await Repository.saveOrderToCart(orderModel: event.order);
      if(saveOrderResponse.isSuccess){

        await Repository.removeCachedImages();
        yield OrderAddedToCartSuccessState(
          cartOrders : [saveOrderResponse.responseData],
        );
        return;
      } else {
        yield OrderSavingFailedState(failedEvent: event, error: saveOrderResponse.errorViewModel,);
        return ;
      }
    } else {
      yield OrderSavingFailedState(failedEvent: event, error: uploadCartImages.errorViewModel,);
      return ;
    }

  }

  Stream<CreateOrderStates> _handleOrderCreation(CreateOrder event) async*{
    yield OrderCreationLoadingState();

    // filter the images if there's new images to be uploaded
    ResponseViewModel<List<String>> uploadCartImages = ResponseViewModel(isSuccess: true);
    List<String> tobeUploaded = List<String>();
    for(int i = 0 ; i < event.orderModel.userImages.length ; i++){
      if(event.orderModel.userImages[i].contains('https://cdn.filestackcontent.com') == false)
        tobeUploaded.add(event.orderModel.userImages[i]);
      else
        event.orderModel.uploadedImages.add(event.orderModel.userImages[i]);
    }


    if(tobeUploaded != null && tobeUploaded.length > 0){
      uploadCartImages = await Repository.uploadMultipleFiles(event.orderModel.userImages);
      if(uploadCartImages.isSuccess){
        event.orderModel.uploadedImages.addAll(uploadCartImages.responseData);
      }
    }

    if(uploadCartImages.isSuccess){
      ResponseViewModel<OrderModel> saveOrderResponse = ResponseViewModel<OrderModel>(isSuccess: true);
      if(event.orderModel.statues != OrderStatus.CART_ORDER) {
        saveOrderResponse = await Repository.saveOrderToCart(orderModel: event.orderModel);
      }

      if(saveOrderResponse.isSuccess){
        ResponseViewModel<List<OrderModel>> orderCreationResult = await Repository.createOrder(event.orderModel);
        if(orderCreationResult.isSuccess){
          await Repository.removeCachedImages();
          yield OrderCreationLoadedSuccessState(
            orderNumber: orderCreationResult.responseData.length > 0 ? orderCreationResult.responseData[0].orderNumber.toString() : '',
            shippingDuration: orderCreationResult.responseData.length > 0 ? orderCreationResult.responseData[0].deliveryTime.toString() : '',
          );
          return ;
        }
        else {
          event.orderModel.uploadedImages = List();
          yield OrderCreationLoadingFailureState(
            error: orderCreationResult.errorViewModel,
            failureEvent: event,
          );
          return ;
        }
      } else {
        event.orderModel.uploadedImages = List();
        yield OrderSavingFailedState(failedEvent: event, error: saveOrderResponse.errorViewModel,);
        return ;
      }
    }
    else {
      yield OrderSavingFailedState(failedEvent: event, error: uploadCartImages.errorViewModel,);
      return ;
    }


  }

  Stream<CreateOrderStates> _handleSaveOrder(SaveOrder event) async*{
    yield OrderCreationLoadingState();

    event.order.userImages.removeWhere((element) => element== null || element.isEmpty);
    ResponseViewModel<List<String>> uploadCartImages;
    if(event.order.uploadedImages == null || event.order.uploadedImages.length < event.order.userImages.length) {
      uploadCartImages = await Repository.uploadMultipleFiles(event.order.userImages);
      if(uploadCartImages.isSuccess){
        event.order.uploadedImages.addAll(uploadCartImages.responseData);
      }
    }
    else {
      uploadCartImages = ResponseViewModel(
          isSuccess: true
      );
    }
    if(uploadCartImages.isSuccess){
      ResponseViewModel<List<OrderModel>> saveUserCart = await Repository.saveOrderForLater(event.order);
      if(saveUserCart.isSuccess){
        await Repository.removeCachedImages();
        yield OrderSavingSuccessState(
          cartOrders : saveUserCart.responseData,
        );
        return;
      }
      else {
        event.order.uploadedImages = List();
        yield OrderSavingFailedState(failedEvent: event, error: saveUserCart.errorViewModel,);
        return ;
      }
    } else {
      event.order.uploadedImages = List();
      yield OrderSavingFailedState(failedEvent: event, error: uploadCartImages.errorViewModel,);
      return ;
    }


  }
  Stream<CreateOrderStates> _handleSavedOrderCreation(CreateOrder event) async*{
    yield OrderCreationLoadingState();
    ResponseViewModel<List<OrderModel>> savedOrderCreationResult = await Repository.createSavedOrder(event.orderModel);
    if(savedOrderCreationResult.isSuccess){
      await Repository.removeCachedImages();
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