import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'OrderPackSizeStackWidget.dart';

class PackListTile extends StatelessWidget {

  final PackageModel package ;
  final Function onBuyPressed , onCardClick;
  final Color backgroundColor ;
  final bool isColoredStack ;
  PackListTile({this.package , this.isColoredStack , this.onBuyPressed , this.onCardClick , this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardClick ?? (){},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max
                  ,children: <Widget>[

                    SvgPicture.network(package.packageIcon),
                  //OrderPackSizeStackWidget(packageSize: package.packageSize, isColored: isColoredStack ?? true),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('${package.packageSize} ${(LocalKeys.PACKAGE_SET).tr()}' , style: TextStyle(
                        color: AppColors.lightBlue,
                      ),),
                      Text((LocalKeys.PRICE_START_FROM).tr(args:[package.packagePrice.toString()]), style: TextStyle(
                        color: (backgroundColor == null || backgroundColor == AppColors.transparent) ? AppColors.white : AppColors.black,
                      ),),
                    ],
                  ),
                ],
                ),
              ),
              Visibility(
                visible: onBuyPressed != null,
                replacement: Container(height: 0, width: 0,),
                child: GestureDetector(
                  onTap: onBuyPressed,
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
              ),
              SizedBox(width: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
