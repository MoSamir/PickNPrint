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



          BlocProvider.of<UserBloc>(context).add(LoadUserOrders());
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
            child: Form(
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
        );
      },
      cubit: orderBloc,
    );
  }

  Widget buildTextField({String Function(String text) validator, bool secured, hint, FocusNode nextNode, TextEditingController textController, FocusNode focusNode, bool autoValidate}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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

  Widget getStatisticsWidget() {
    return OrderStatisticWidget(
      orderModel: widget.orderModel,
      onCreateOrder: (OrderModel order){
        if(order.orderPackage.packageId == null){
          try {
            order.orderPackage.packageId = BlocProvider
                .of<ApplicationDataBloc>(context)
                .applicationPackages
                .firstWhere((element) =>
            order.orderPackage.packageSize == element.packageSize)
                .packageId;
          } catch(exception){
            debugPrint("Exception while trying to find suitable package => $exception");
          }
        }
        orderBloc.add(CreateOrder(orderModel: widget.orderModel));
        return;
      },
    );
  }

}