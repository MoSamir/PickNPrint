import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';
import 'dart:math' as Math;

class OrderStatisticWidget extends StatefulWidget {
  final bool viewOnlyWidget;
  final OrderModel orderModel;
  final Function onCreateOrder;
  final Function(String) onPromoCodeInput;
  OrderStatisticWidget(
      {this.orderModel,
      this.onPromoCodeInput,
      this.onCreateOrder,
      @required this.viewOnlyWidget});

  @override
  _OrderStatisticWidgetState createState() => _OrderStatisticWidgetState();
}

class _OrderStatisticWidgetState extends State<OrderStatisticWidget> {
  TextEditingController promoCodeTextController = TextEditingController();
  OrderModel orderModel;

  @override
  void initState() {
    super.initState();
    orderModel = widget.orderModel;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orderModel.orderPackage == null) {
      widget.orderModel.orderPackage = PackageModel(
        packageId: Math.max(widget.orderModel.uploadedImages ?? 0,
            widget.orderModel.userImages ?? 0),
        packageSize: Math.max(widget.orderModel.uploadedImages ?? 0,
            widget.orderModel.userImages ?? 0),
      );
    }

    double orderSubTotal = widget.orderModel.orderPackage.packagePrice + widget.orderModel.orderAddress.deliveryFees;
    double orderTotal = orderSubTotal -
        (widget.orderModel.promoCode != null ? widget.orderModel.promoCode.discount : 0.0);

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
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      if (widget.orderModel.orderPackage.packageIcon != null)
                        SvgPicture.network(
                          widget.orderModel.orderPackage.packageIcon,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${widget.orderModel.orderPackage.packageSize} ${(LocalKeys.PACKAGE_SET).tr()}',
                            style: TextStyle(
                              color: AppColors.lightBlue,
                            ),
                          ),
                          Text(
                              '${widget.orderModel.isWhiteFrame ? (LocalKeys.WHITE_FRAME).tr() : (LocalKeys.BLACK_FRAME).tr()} - ${widget.orderModel.frameWithPath ? (LocalKeys.WITH_PATH).tr() : (LocalKeys.WITHOUT_PATH).tr()}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: .1,
          color: AppColors.black,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text((LocalKeys.SHIPPING_FEES).tr()),
                Text((LocalKeys.PRICE_TEXT).tr(args: [
                  orderModel.orderAddress.deliveryFees.toString(),
                ])),
              ],
            ),
          ),
        ),
        Container(
          height: .1,
          color: AppColors.black,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: .1,
          color: AppColors.black,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text((LocalKeys.SUBTOTAL_LABEL).tr()),
                Text((LocalKeys.PRICE_TEXT).tr(args: [orderSubTotal.toString(),])),
              ],
            ),
          ),
        ),

        if (widget.viewOnlyWidget == false)
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text((LocalKeys.PROMO_CODE).tr()),
                  Form(
                    key: GlobalKey<FormState>(),
                    child: UIHelpers.buildTextField(
                      context: context,
                      textController: promoCodeTextController,
                      hint: (LocalKeys.PROMO_CODE_HINT).tr(),
                      onEditingCompleted: widget.onPromoCodeInput,
                    ),
                  ),
                ],
              ),
            ),
          ),


        if (widget.orderModel.promoCode != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: .1,
                color: AppColors.black,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text((LocalKeys.DISCOUNT_LABEL).tr()),
                      Text((LocalKeys.PRICE_TEXT).tr(args: [
                        widget.orderModel.promoCode.discount.toString(),
                      ]),
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),


        Container(
          height: .1,
          color: AppColors.black,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (LocalKeys.TOTAL_LABEL).tr(),
                  style: TextStyle(
                    color: AppColors.lightBlue,
                  ),
                ),
                Text(
                  (LocalKeys.PRICE_TEXT).tr(args: [orderTotal.toString(),]),
                  style: TextStyle(color: AppColors.red,),
                ),
              ],
            ),
          ),
        ),


        if (widget.viewOnlyWidget == false)
          GestureDetector(
            onTap: () {
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
              child: Center(
                  child: Text(
                (LocalKeys.PLACE_ORDER).tr(),
                style: TextStyle(color: AppColors.white),
              )),
            ),
          ),
      ],
    );
  }
}
