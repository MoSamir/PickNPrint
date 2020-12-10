import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';

import '../RegisterScreen.dart';

class OrderSavingConfirmationScreen extends StatelessWidget {

  final String orderNumber;
  final DateTime orderTime ;
  final TextStyle textStyle = TextStyle(
    color: AppColors.white,
  );
  OrderSavingConfirmationScreen({this.orderNumber , this.orderTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.blackBg,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text((LocalKeys.YOUR_ORDER_SAVED).tr() , style: textStyle),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: (50),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text((LocalKeys.ORDER_NUMBER).tr(args: [orderNumber.toString()]) , style: textStyle,),
                    Text(DateFormat.jm().format(orderTime ?? DateTime.now()) , style: textStyle,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text((LocalKeys.YOU_CAN_BACK).tr() , style: textStyle, textAlign: TextAlign.center,),

            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
              },
              child: Text((LocalKeys.CONTINUE_SHOPPING_LABEL).tr() , style: textStyle.copyWith(
                decoration: TextDecoration.underline,
              ) ,),
            ),




          ],
        ),
      ),
    );
  }
}
