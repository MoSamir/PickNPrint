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
import 'package:picknprint/src/data_providers/models/PromocodeModel.dart';
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
          if (eventOrder.userImages[i].contains("http") || eventOrder.userImages[i].contains("https"))
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
    if(event is CheckPromoCodeValidity){
      yield* _handlePromoCodeEntering(event);
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

    if(event.order.userImages != null)
      for(int i = 0 ; i < event.order.userImages.length ; i++){
        if(event.order.uploadedImages.contains(event.order.userImages[i]) == false && isNetworkError(event.order.userImages[i])){
          event.order.uploadedImages.add(event.order.userImages[i]);
        }
      }
    List<String> tobeUploadedFiles = getFilesToBeUploaded(event.order.userImages);
    ResponseViewModel<List<String>> uploadCartImages;
    if(tobeUploadedFiles != null && tobeUploadedFiles.length > 0) {
      uploadCartImages = await Repository.uploadMultipleFiles(tobeUploadedFiles);
      if(uploadCartImages.isSuccess){
        if(event.order.uploadedImages == null)
        event.order.uploadedImages= new List<String>();
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

    List<String> tobeUploadedFiles = getFilesToBeUploaded(event.orderModel.userImages);
    ResponseViewModel<List<String>> uploadCartImages;
    if(tobeUploadedFiles != null && tobeUploadedFiles.length > 0) {
      uploadCartImages = await Repository.uploadMultipleFiles(tobeUploadedFiles);
      if(uploadCartImages.isSuccess){
        event.orderModel.uploadedImages.addAll(uploadCartImages.responseData);
      }
    }
    else {
      uploadCartImages = ResponseViewModel(
          isSuccess: true
      );
    }

    if(uploadCartImages.isSuccess){
      ResponseViewModel<OrderModel> saveOrderResponse = ResponseViewModel<OrderModel>(isSuccess: true);
      if(event.orderModel.statues != OrderStatus.CART_ORDER && event.orderModel.uploadedImages.length > 0) {
        saveOrderResponse = await Repository.saveOrderToCart(orderModel: event.orderModel);
      }

      if(saveOrderResponse.isSuccess){
        ResponseViewModel<OrderModel> orderCreationResult = await Repository.createOrder(event.orderModel);
        if(orderCreationResult.isSuccess){
          await Repository.removeCachedImages();
          yield OrderCreationLoadedSuccessState(
            orderNumber: orderCreationResult.responseData .orderNumber.toString(),
            shippingDuration: (orderCreationResult.responseData.deliveryTime ?? 5).toString(),
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
    if(event.order.userImages != null)
    for(int i = 0 ; i < event.order.userImages.length ; i++){
      if(event.order.uploadedImages.contains(event.order.userImages[i]) == false && isNetworkError(event.order.userImages[i]) ){
        event.order.uploadedImages.add(event.order.userImages[i]);
      }
    }
    List<String> tobeUploadedFiles = getFilesToBeUploaded(event.order.userImages);
    ResponseViewModel<List<String>> uploadCartImages;

    if(tobeUploadedFiles != null && tobeUploadedFiles.length > 0) {
      uploadCartImages = await Repository.uploadMultipleFiles(tobeUploadedFiles);
      if(uploadCartImages.isSuccess){
        if(event.order.uploadedImages == null)
          event.order.uploadedImages= new List<String>();
        event.order.uploadedImages.addAll(uploadCartImages.responseData);
      }
    }
    else {
      uploadCartImages = ResponseViewModel(
          isSuccess: true
      );
    }

    if(uploadCartImages.isSuccess){
      ResponseViewModel<OrderModel> saveUserCart = await Repository.saveOrderForLater(event.order);
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
    ResponseViewModel<OrderModel> savedOrderCreationResult = await Repository.createSavedOrder(event.orderModel);
    if(savedOrderCreationResult.isSuccess){
      await Repository.removeCachedImages();
      yield OrderCreationLoadedSuccessState(
        orderNumber:  savedOrderCreationResult.responseData.orderNumber.toString(),
        shippingDuration: (savedOrderCreationResult.responseData.deliveryTime ?? 5).toString(),
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

  Stream<CreateOrderStates> _handlePromoCodeEntering(CheckPromoCodeValidity event) async*{
    yield OrderCreationLoadingState();
    ResponseViewModel<PromoCodeModel> promoCode = await Repository.checkPromoCode(event.promoText , event.orderTotal);
    yield OrderCreationInitialStateWithPromoStatus(orderPromoCodeModel: promoCode.responseData ?? null);
    return;
  }

  List<String> getFilesToBeUploaded(List<String> filesLinks){
    List<String> localFiles = List<String>();
    filesLinks.removeWhere((element) => element== null || element.isEmpty);
    localFiles = filesLinks.where((element) => (element.startsWith('http') && element.startsWith('https')) == false).toList();
    return localFiles;
  }

  bool isNetworkError(String url) {
    return url.contains('http') || url.contains('https');
  }



}