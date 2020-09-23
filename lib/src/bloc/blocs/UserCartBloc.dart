import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/events/UserCartEvents.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/bloc/states/UserCartStates.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:rxdart/rxdart.dart';

class UserCartBloc extends Bloc<UserCartEvents , UserCartStates>{
  UserCartBloc(UserCartStates initialState) : super(initialState);

  List<PackageModel> _userCart = List();
  List<PackageModel> _userAuctions = List();
  BehaviorSubject<int> _cartHasItems = BehaviorSubject<int>();


  @override
  Future<Function> close() {
    _cartHasItems.close();
    super.close();
  }

  Stream<int> get cartItemsStream => _cartHasItems.stream;

  Function(int) get cartItemsSink => _cartHasItems.sink.add;

  int get cartLength => _userCart != null ? _userCart.length : 0;


  List<PackageModel> get getCart => _userCart;

  List<PackageModel> get getAuctionsCart => _userAuctions;

  @override
  Stream<UserCartStates> mapEventToState(UserCartEvents event) async* {
    bool isConnected = await NetworkUtilities.isConnected();
    if (isConnected == false) {
      return;
    }
    if (event is AddItemToCart) {
      yield* _handleAddItemToCart(event);
      return;
    }
    else if (event is LoadCartEvent) {
      yield* _handleCartItemsLoading(event);
      return;
    }
    else if (event is RemoveItemFromCart) {
      yield* _handleRemoveItemFromCart(event);
      return;
    }
  }


  Stream<UserCartStates> _handleAddItemToCart(AddItemToCart event) async* {
    yield UserCartLoading();
    ResponseViewModel<List<PackageModel>> addToCartResponse =
    await Repository.addToCart(
        advertisementViewModel: event.packageModel);
    if (addToCartResponse.isSuccess) {
      _userCart.clear();
      _userCart = addToCartResponse.responseData;
      cartItemsSink(_userCart.length);
      yield UserCartEventSuccess();
      return;
    } else {
      yield UserCartLoadingFailed(
          failedEvent: event, error: addToCartResponse.errorViewModel);
      return;
    }
  }

  Stream<UserCartStates> _handleRemoveItemFromCart(
      RemoveItemFromCart event) async* {
    yield UserCartLoading();
    ResponseViewModel<List<PackageModel>> addToCartResponse =
    await Repository.removeFromCart(
        advertisementViewModel: event.packageModel);
    if (addToCartResponse.isSuccess) {
      _userCart.clear();
      _userCart = addToCartResponse.responseData;
      cartItemsSink(_userCart.length);
      yield UserCartEventSuccess();
      return;
    } else {
      yield UserCartLoadingFailed(
          failedEvent: event, error: addToCartResponse.errorViewModel);
      return;
    }
  }

  Stream<UserCartStates> _handleCartItemsLoading(LoadCartEvent event) async* {
    yield UserCartLoading();
    ResponseViewModel cartResponse = await Repository.getUserCart();

    if (cartResponse.isSuccess) {
      _userCart = cartResponse.responseData;
      cartItemsSink(_userCart != null ? _userCart.length : 0);

      yield UserCartEventSuccess();
      return;
    } else {
      yield UserCartLoadingFailed(
          error: cartResponse.errorViewModel, failedEvent: event);
      return;
    }
  }

  double calculateCart() {
    double advertisementTotalPrice = 0.0;
    for (int i = 0; i < _userCart.length; i++) {
      advertisementTotalPrice += (_userCart[i].packagePrice);
    }
    return advertisementTotalPrice;
  }

  void clear() {
    _userCart.clear();
  }





}