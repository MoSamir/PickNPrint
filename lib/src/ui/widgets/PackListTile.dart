import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'OrderPackSizeStackWidget.dart';

class PackListTile extends StatelessWidget {

  final PackageModel package ;
  final Function onBuyPressed ;
  PackListTile({this.package , this.onBuyPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      child: Container(
//      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 2),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max
                  ,children: <Widget>[
                  OrderPackSizeStackWidget(packageSize: package.packageSize,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('${package.packageSize} ${(LocalKeys.PACKAGE_SET).tr()}' , style: TextStyle(
                        color: AppColors.lightBlue,
                      ),),
                      Text((LocalKeys.PRICE_START_FROM).tr(args:[package.packagePrice.toString()])),
                    ],
                  ),
                ],
                ),
              ),
              GestureDetector(onTap: onBuyPressed,
                child: Container(
                  width: 70,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                        (LocalKeys.BUY_NOW).tr(),
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),

              ),
              SizedBox(width: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
