import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picknprint/src/resources/AppStyles.dart';

class NumberedBoxWidget extends StatelessWidget {

  final String passedText , passedNumber ;
  final Widget passedWidget;
  NumberedBoxWidget({this.passedNumber , this.passedText , this.passedWidget});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 100,
      height: 110,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child:Column(
              children: <Widget>[
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.lightBlack.withOpacity(.8),
                      width: 5,
                    ),
                  ),
                  child: Center(
                    child: passedWidget,
                  ),
                ),
                SizedBox(height: 5,),
                Text(passedText , textScaleFactor: 1 ,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlue,
                ),),
              ],
            ),
          ),
          Positioned(
            //alignment: Alignment.topCenter,
            top: 3,
            left: 40,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(passedNumber , textScaleFactor: 1 ,style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                ),),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
