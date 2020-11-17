import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/OrderCreationBloc.dart';
import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'file:///E:/Testing/pick_n_print/lib/src/ui/screens/confirmation_screens/OrderConfirmationScreen.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/OrderPackSizeStackWidget.dart';
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
  TextEditingController promoCodeTextController ;
  FocusNode promoCodeFocusNode;



  @override
  void dispose() {
    orderBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    orderBloc = OrderCreationBloc(OrderCreationInitialState());
    promoCodeTextController = TextEditingController();
    promoCodeFocusNode = FocusNode();
  }





  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
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

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> OrderConfirmationScreen(
            orderNumber: state.orderNumber,
            orderShippingDuration: state.shippingDuration,
          )));

        }
      },
      builder:  (context, state){
        return ModalProgressHUD(
          progressIndicator: LoadingWidget(),
          inAsyncCall: state is OrderCreationLoadingState,
          child: BaseScreen(
            hasDrawer: true,
            child: SingleChildScrollView(
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
                    OrderStatisticWidget(
                      orderModel: widget.orderModel,
                      onCreateOrder: (OrderModel order){
                        orderBloc.add(CreateOrder(
                            isCartItem : BlocProvider.of<UserBloc>(context).userCart.contains(widget.orderModel),
                            orderModel : widget.orderModel));
                        return;
                      },
                    ),
                    SizedBox(height: 25,),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      cubit: orderBloc,
    );
  }






}