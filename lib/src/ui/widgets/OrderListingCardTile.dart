import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/OrderStatisticWidget.dart';

class OrderListingCardTile extends StatelessWidget {
  final OrderModel orderModel ;

  OrderListingCardTile({this.orderModel});
  @override
  Widget build(BuildContext context) {
    String localeName = Constants.appLocale == "ar" ? "ar_EG" : "en_US";
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: ConfigurableExpansionTile(
        kExpand: Duration(milliseconds: 400),
        headerExpanded: Flexible(child: Container(
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
                Text(DateFormat.yMd(localeName).format(orderModel.orderTime ?? DateTime.now()).replaceAll('/', ' / ') , style: TextStyle(
                  color: AppColors.white,
                )),
              ],
            ),
          ),
        ),),
        header:  Flexible(child: Container(
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
                Text(DateFormat.yMd(localeName).format(orderModel.orderTime ?? DateTime.now()).replaceAll('/', ' / ') , style: TextStyle(
                  color: AppColors.white,
                )),
              ],
            ),
          ),
        ),),
        initiallyExpanded: false,
        children: [
          OrderStatisticWidget(
            viewOnlyWidget: true,
            orderModel: orderModel,
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
    );
  }
  Widget orderStatuesWidget(OrderStatus statues) {

    TextStyle redStyle = TextStyle(
      color: AppColors.red,
    );
    TextStyle greenStyle = TextStyle(
      color: AppColors.green,
    );

     if(statues == OrderStatus.PENDING){
    return Text((LocalKeys.PENDING_STATUES).tr(), style: greenStyle,);
    }
    else if(statues == OrderStatus.CANCELED){
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
