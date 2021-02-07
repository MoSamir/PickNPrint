import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';

class OrderStatisticWidget extends StatefulWidget {

  final OrderModel orderModel;
  final Function onCreateOrder;

  OrderStatisticWidget({this.orderModel, this.onCreateOrder});

  @override
  _OrderStatisticWidgetState createState() => _OrderStatisticWidgetState();
}

class _OrderStatisticWidgetState extends State<OrderStatisticWidget> {

  TextEditingController promoCodeTextController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                    if(widget.orderModel.orderPackage.packageIcon != null)
                      SvgPicture.network(widget.orderModel.orderPackage.packageIcon,),
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
                  widget.orderModel.orderAddress.deliveryFees.toString(),
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
                  (widget.orderModel.orderPackage.packagePrice + widget.orderModel.orderAddress.deliveryFees).toString(),
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
        Card(
          margin: EdgeInsets.symmetric(vertical: 2),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10,),
                Text((LocalKeys.PROMO_CODE).tr()),
                UIHelpers.buildTextField(
                  context: context,
                  textController: promoCodeTextController,
                  hint: (LocalKeys.PROMO_CODE_HINT).tr(),
                ),
              ],
            ),
          ),
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
                  (widget.orderModel.orderPackage.packagePrice + widget.orderModel.orderAddress.deliveryFees).toString(),
                ]) , style: TextStyle(
                  color: AppColors.red,
                ),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
              widget.onCreateOrder(widget.orderModel);
            return;
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
    );
  }




}
