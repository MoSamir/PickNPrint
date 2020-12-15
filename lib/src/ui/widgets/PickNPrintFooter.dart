import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';

class PickNPrintFooter extends StatelessWidget {

  final Function onClick ;
  PickNPrintFooter({this.onClick});
  static const TextStyle sliderTextStyle = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );
  final List<List<Widget>> footerSliderWidgets = [
    [
      ImageIcon(AssetImage(Resources.ORDER_ONLINE_SLIDER_ICON) , color: AppColors.white, size: 40,),
      Text((LocalKeys.ORDER_ONLINE_SLIDER_TEXT).tr() , style: sliderTextStyle,),
    ],
    [
      ImageIcon(AssetImage(Resources.CASH_ON_DELIVERY_SLIDER_ICON) , color: AppColors.white, size: 40,),
      Text((LocalKeys.CASH_ON_DELIVERY_SLIDER_TEXT).tr() , style: sliderTextStyle,),
    ],
    [
      ImageIcon(AssetImage(Resources.FAST_DELIVERY_SLIDER_ICON) , color: AppColors.white, size: 35,),
      Text((LocalKeys.FAST_DELIVERY_SLIDER_TEXT).tr() , style: sliderTextStyle,),
    ],
  ];


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Resources.APP_FOOTER_HEART_IMG),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(AppColors.black.withOpacity(.4), BlendMode.darken),
                ),
              ),
              child: Center(child: getSliderView(context)),
            ),
          ],
        ),
      ),
      onTap: onClick ?? (){},
    );
  }

  Widget getSliderView(context) {

    return CarouselSlider(
      options: CarouselOptions(height: 60.0 , autoPlay: true),
      items: footerSliderWidgets.map((List<Widget> viewItems){
        return Container(
          width: 200,
          color: AppColors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: viewItems,
          ),);
      }).toList(),);

    //return Image.asset(Resources.APP_FOOTER_PARACHUTE_IMG , fit: BoxFit.contain, height: 50, width: MediaQuery.of(context).size.width * .6,);
  }
}
