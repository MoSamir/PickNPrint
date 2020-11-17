import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderListingCardTile extends StatelessWidget {

  final OrderModel orderModel ;
  final Function onCardTapped ;
  OrderListingCardTile({this.orderModel , this.onCardTapped});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped ?? (){},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 15),
              decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text((LocalKeys.ORDER_NUMBER).tr(args: [(orderModel.orderNumber.toString())]) , style: TextStyle(
                      color: AppColors.white,
                    ),),
                    Text(DateFormat.yMd(Constants.CURRENT_LOCALE).format(orderModel.orderTime ?? DateTime.now()).replaceAll('/', ' / ') , style: TextStyle(
                      color: AppColors.white,
                    )),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max
                        ,children: <Widget>[

                        SvgPicture.network(
                          orderModel.orderPackage.packageIcon,
                        ),
                        //OrderPackSizeStackWidget(packageSize: orderModel.orderPackage.packageSize, isColored: false,),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('${orderModel.orderPackage.packageSize} ${(LocalKeys.PACKAGE_SET).tr()}' , style: TextStyle(
                              color: AppColors.lightBlue,
                            ),),
                            Text('${orderModel.isWhiteFrame ? (LocalKeys.WHITE_FRAME).tr() : (LocalKeys.BLACK_FRAME).tr()} - ${ orderModel.frameWithPath ? (LocalKeys.WITH_PATH).tr() : (LocalKeys.WITHOUT_PATH).tr()}'),
                          ],
                        ),
                      ],
                      ),
                    ),
                    Text((LocalKeys.PRICE_TEXT).tr(args: [orderModel.orderPackage.packagePrice.toString()])),
                  ],
                ),
              ),
            ),
            Container(height: .1 , color: AppColors.black, width: MediaQuery.of(context).size.width,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
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
            Container(height: .1 , color: AppColors.black, width: MediaQuery.of(context).size.width,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text((LocalKeys.SUBTOTAL_LABEL).tr()),
                    Text((LocalKeys.PRICE_TEXT).tr(args: [(orderModel.orderPackage.packagePrice + 40).toString(),
                    ])),
                  ],
                ),
              ),
            ),
            Container(height: .1 , color: AppColors.black, width: MediaQuery.of(context).size.width,),
            Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text((LocalKeys.TOTAL_LABEL).tr() , style: TextStyle(
                      color: AppColors.lightBlue,
                    ),),
                    Text((LocalKeys.PRICE_TEXT).tr(args: [
                      (orderModel.orderPackage.packagePrice + 40).toString(),
                    ]) , style: TextStyle(
                      color: AppColors.red,
                    ),),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 15),
              decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text( (LocalKeys.ORDER_STATUES).tr() , style: TextStyle(
                      color: AppColors.white,
                    ),),
                    orderStatuesWidget(orderModel.statues),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderStatuesWidget(OrderStatus statues) {

    TextStyle redStyle = TextStyle(
      color: AppColors.red,
    );
    TextStyle greenStyle = TextStyle(
      color: AppColors.green,
    );


    if(statues == OrderStatus.CANCELED){
      return Text((LocalKeys.CANCELED_STATUES).tr(), style: redStyle,);
    }
    else if(statues == OrderStatus.PREPARING){
      return Text((LocalKeys.PREPARING_STATUES).tr(), style: greenStyle,);
    }
    else if(statues == OrderStatus.SHIPPING){
      return Text((LocalKeys.SHIPPING_STATUES).tr(), style: greenStyle,);
    }
    else if(statues == OrderStatus.DELIVERED){
      return Text((LocalKeys.DELIVERED_STATUES).tr(), style: greenStyle,);
    }
    return Container();
  }
}
