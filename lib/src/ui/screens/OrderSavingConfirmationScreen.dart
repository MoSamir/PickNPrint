import 'package:flutter/material.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
class OrderSavingConfirmationScreen extends StatelessWidget {

  final String orderNumber;
  final DateTime orderTime ;
  OrderSavingConfirmationScreen({this.orderNumber , this.orderTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text((LocalKeys.YOUR_ORDER_SAVED).tr()),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text((LocalKeys.ORDER_NUMBER).tr(args: [orderNumber.toString()])),
                Text(DateFormat.jm().format(orderTime ?? DateTime.now()))
              ],
            ),
          ),
          Text((LocalKeys.YOU_CAN_BACK).tr()),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: (){
              print("Hello World");
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RegisterScreen()));
            },
            child: Text((LocalKeys.CONTINUE_SHOPPING_LABEL).tr() , style: TextStyle(
              color: AppColors.white,
              decoration: TextDecoration.underline,
            ) ,),
          ),




        ],
      ),
    );
  }
}
