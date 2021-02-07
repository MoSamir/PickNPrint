import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';
class PackageHomeScreenListing extends StatelessWidget {
  final PackageModel package;
  final Function onPackageTap ;
  PackageHomeScreenListing({this.package , this.onPackageTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 8,),
          Center(
            child: Text((LocalKeys.PACKAGE_SIZE).tr(args:([package.packageSize.toString()])) , textAlign: TextAlign.center, style: TextStyle(
              fontSize: 20, color: AppColors.lightBlue, fontWeight: FontWeight.bold,
            ),),
          ),
          SizedBox(height: 8,),
          Center(
            child: package.packageMainImage.toLowerCase().endsWith('.svg') ? SvgPicture.network(
              package.packageMainImage,
            ) : Image.network(
              package.packageMainImage,
            ),
          ),
          SizedBox(height: 8,),
          Center(
            child: getDiscountText(),
          ),
          SizedBox(height: 2,),
          Center(
            child: Text((LocalKeys.SAVE_TEXT).tr(args:([package.packageSaving.toString()])) , textAlign: TextAlign.center, style: TextStyle(
              fontSize: 18, color: AppColors.lightBlue,
            ),),
          ),
          SizedBox(height: 8,),
          Center(
            child: GestureDetector(
              onTap: onPackageTap,
              child: Container(
                width: (200),
                height: (40),
//                        padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(child: Text((LocalKeys.GO_LABEL).tr(), style: TextStyle(color: AppColors.white),)),
              ),
            ),
          ),
          SizedBox(height: 8,),
        ],

      ),
    );
  }

  Widget getDiscountText() {
    if(package.packageAfterDiscountPrice == package.packagePrice){
      return Text(
        (LocalKeys.PRICE_TEXT).tr(args:([package.packageAfterDiscountPrice.toString()])),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
            children: [
              TextSpan(
                text: (LocalKeys.PRICE_TEXT).tr(args:([package.packagePrice.toString()])),
                style: TextStyle(
                  color: Colors.black38,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              TextSpan(text: '  '),
              TextSpan(
                text: (LocalKeys.PRICE_TEXT).tr(args:([package.packageAfterDiscountPrice.toString()])),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )
            ]
        ),
      );
    }



  }
}
