import 'dart:io';

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
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';

import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/screens/OrderConfirmationScreen.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/OrderPackSizeStackWidget.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
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
    return BaseScreen(
      hasDrawer: true,
      child: BlocConsumer(
        listener: (context, state){
          if (state is OrderCreationLoadingFailureState) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetworkErrorView();
                  });
            } else if (state.error.errorCode ==
                HttpStatus.serviceUnavailable) {
              Fluttertoast.showToast(
                  msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              Fluttertoast.showToast(
                  msg: state.error.errorMessage ?? '',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
          else if(state is OrderCreationLoadedSuccessState){
            // Navigate to Order Confirmation

            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> OrderConfirmationScreen(
              orderNumber: state.orderNumber,
              orderShippingDuration: state.shippingDuration,
            )));

          }
        },
        builder:  (context, state){
          return ModalProgressHUD(
            inAsyncCall: state is OrderCreationLoadingState,
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
                    Container(
                      height: 70,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max
                                ,children: <Widget>[
                                OrderPackSizeStackWidget(packageSize: widget.orderModel.orderPackage.packageSize,),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text('${widget.orderModel.orderPackage.packageSize} ${(LocalKeys.PACKAGE_SET).tr()}' , style: TextStyle(
                                      color: AppColors.lightBlue,
                                    ),),
                                    Text('${widget.orderModel.isWhiteFrame ? (LocalKeys.WHITE_FRAME).tr() : (LocalKeys.BLACK_FRAME).tr()} - ${ widget.orderModel.frameWithPath ? (LocalKeys.WITH_PATH).tr() : (LocalKeys.WITHOUT_PATH).tr()}'),
                                  ],
                                ),
                              ],
                              ),
                            ),
                            Text((LocalKeys.PRICE_TEXT).tr(args: [widget.orderModel.orderPackage.packagePrice.toString()])),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.lightBlack,
                    ),

                    SizedBox(height: 5,),
                    Container(
                      height: 70,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text((LocalKeys.SHIPPING_FEES).tr()),
                            Text((LocalKeys.PRICE_TEXT).tr(args: [
                              40.toString(),
                            ])),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: .5,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.lightBlack,
                    ),



                    SizedBox(height: 5,),
                    Container(
                      height: 70,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text((LocalKeys.SUBTOTAL_LABEL).tr()),
                            Text((LocalKeys.PRICE_TEXT).tr(args: [
                              (widget.orderModel.orderPackage.packagePrice + 40).toString(),
                            ])),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: .5,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.lightBlack,
                    ),

                    SizedBox(height: 10,),
                    Text((LocalKeys.PROMO_CODE).tr()),
                    buildTextField(
                      textController: promoCodeTextController,
                      hint: (LocalKeys.PROMO_CODE_HINT).tr(),
                      focusNode: promoCodeFocusNode,
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.lightBlack,
                    ),
                    Container(
                      height: 50,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text((LocalKeys.TOTAL_LABEL).tr() , style: TextStyle(
                              color: AppColors.lightBlue,
                            ),),
                            Text((LocalKeys.PRICE_TEXT).tr(args: [
                              (widget.orderModel.orderPackage.packagePrice + 40).toString(),
                            ]) , style: TextStyle(
                              color: AppColors.red,
                            ),),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        orderBloc.add(CreateOrder(orderModel: widget.orderModel));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: (50),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(child: Text((LocalKeys.PLACE_ORDER).tr(), style: TextStyle(color: AppColors.white),)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        cubit: orderBloc,
      ),
    );
  }


  Widget buildTextField({String Function(String text) validator, bool secured, hint, FocusNode nextNode, TextEditingController textController, FocusNode focusNode, bool autoValidate}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autovalidate: autoValidate ?? false,
        obscureText: secured ?? false,
        validator: Validator.requiredField,
        controller: textController,
        onFieldSubmitted: (text){
          if(nextNode != null)
          FocusScope.of(context).requestFocus(nextNode);
        },
        focusNode: focusNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: .5,
              color: AppColors.lightBlue,
            ),
          ),
          fillColor: AppColors.offWhite,
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: .5,
              color: AppColors.lightBlue,
            ),
          ),
          alignLabelWithHint: true,
        ),
        textInputAction: nextNode != null ? TextInputAction.next : TextInputAction.done,
      ),
    );
  }





}