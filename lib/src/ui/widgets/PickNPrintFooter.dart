import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Resources.dart';

class PickNPrintFooter extends StatelessWidget {

  final Function onClick ;
  PickNPrintFooter({this.onClick});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 150,
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
              child: Center(child: Image.asset(Resources.APP_FOOTER_PARACHUTE_IMG , fit: BoxFit.contain, height: 50, width: MediaQuery.of(context).size.width * .6,)),
            ),
            Image.asset(Resources.APP_FOOTER_PACKAGES_IMG , fit: BoxFit.fill, height: 50, width: MediaQuery.of(context).size.width,),
          ],
        ),
      ),
      onTap: onClick ?? (){},
    );
  }
}
