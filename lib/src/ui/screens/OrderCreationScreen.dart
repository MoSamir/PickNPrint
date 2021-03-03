import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/OrderCreationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/screens/confirmation_screens/OrderConfirmationScreen.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';
import 'package:picknprint/src/ui/widgets/OrderStatisticWidget.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';
class OrderCreationScreen extends StatefulWidget {

  final OrderModel orderModel ;
  OrderCreationScreen({this.orderModel});



  @override
  _OrderCreationScreenState createState() => _OrderCreationScreenState();
}

class _OrderCreationScreenState extends State<OrderCreationScreen> {

  OrderCreationBloc orderBloc ;
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void dispose() {
    orderBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    orderBloc = OrderCreationBloc(OrderCreationInitialState());

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer(
        listener: (context, state){
          if (state is OrderCreationLoadingFailureState) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              UIHelpers.showNetworkError(context);
              return;
            }
            else if (state.error.errorCode == HttpStatus.serviceUnavailable) {
              UIHelpers.showToast((LocalKeys.SERVER_UNREACHABLE).tr(), true, true);
              return;
            }
            else {
              UIHelpers.showToast(state.error.errorMessage ?? '', true, true);
              return;
            }
          }
          else if(state is OrderCreationLoadedSuccessState){
            BlocProvider.of<UserBloc>(context).add(LoadUserOrders());
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> OrderConfirmationScreen(
              orderNumber: state.orderNumber,
              orderShippingDuration: state.shippingDuration,
            )));
          }
          else if(state is OrderCreationInitialStateWithPromoStatus){
            if(state.orderPromoCodeModel != null){
              widget.orderModel.promoCode = state.orderPromoCodeModel;
            } else {
              UIHelpers.showToast( (LocalKeys.INVALID_PROMO_CODE).tr(), true, true);
              widget.orderModel.promoCode = null;
            }
          }
        },
        builder:  (context, state){
          return ModalProgressHUD(
            progressIndicator: LoadingWidget(),
            inAsyncCall: state is OrderCreationLoadingState,
            child: BaseScreen(
              hasDrawer: true,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 5,),
                        Text((LocalKeys.ORDER_DETAILS).tr(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ), textAlign: TextAlign.start,),
                        Text((LocalKeys.PLEASE_CHECK_ORDER).tr(), style: TextStyle(
                          color: AppColors.lightBlue,
                          fontSize: 20,
                        ), textAlign: TextAlign.start,),
                        SizedBox(height: 5,),
                        Image(image: AssetImage(Resources.LOGO_BANNER_IMG), width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .25, fit: BoxFit.cover,),
                        SizedBox(height: 5,),
                       getStatisticsWidget(),
                        SizedBox(height: 25,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        cubit: orderBloc,
      ),
    );
  }


  Widget getStatisticsWidget() {

    return OrderStatisticWidget(
      viewOnlyWidget: false,
      orderModel: widget.orderModel,
      onCreateOrder: (OrderModel order){
        if(order.orderPackage == null || order.orderPackage.packageId == null){
          try {
            order.orderPackage.packageId = BlocProvider.of<ApplicationDataBloc>(context).applicationPackages.firstWhere((element) =>
            order.orderPackage.packageSize == element.packageSize).packageId;
          } catch(exception){
            debugPrint("Exception while trying to find suitable package => $exception");

            order.orderPackage = PackageModel(
              packageSize: order.uploadedImages.length,
              packageId: order.uploadedImages.length,
            );


          }
        }
        orderBloc.add(CreateOrder(orderModel: widget.orderModel));
        return;
      },
      onPromoCodeInput: (String promoCodeText){

        if(promoCodeText.length == 0){
          setState(() {
            widget.orderModel.promoCode = null;
          });
          return;
        }

        orderBloc.add(CheckPromoCodeValidity(promoText: promoCodeText , orderTotal: widget.orderModel.calculateOrderTotal()));
      },
    );
  }

}