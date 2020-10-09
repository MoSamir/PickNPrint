import 'package:flutter/material.dart';
import 'package:picknprint/src/resources/AppStyles.dart';

class OrderPackSizeStackWidget extends StatelessWidget {


  final int packageSize ;
  final bool isColored;
  OrderPackSizeStackWidget({ this.packageSize, this.isColored });


  @override
  Widget build(BuildContext context) {
    return Container(
//      color: AppColors.lightBlue,
      height: 50,
      width: 42 + (packageSize * 7.5),
      child: Stack(
        children: getStackChildren(),
      ),
    );
  }


  List<Widget> getStackChildren(){


    List<Color> colorsList = [ Colors.white , Colors.pinkAccent , Colors.blue , Colors.green , Colors.amberAccent , AppColors.black ];

    List<Widget> childrenWidget = List();
    for(int i = (packageSize-1) ; i >= 0  ; i--){
      childrenWidget.add(Positioned(top: 0, left: 0, child:  Material(
        color: AppColors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
            height: 50,
            width: (50 + (i * 7.5)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: isColored ? colorsList[i] : AppColors.white,
              border: Border.all(
                width: 2,
                color: AppColors.black,
              ),
            ),
            child: Center(child: Text(i == 0 ? packageSize.toString() : '' , style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.black,
            ),)),
          ),
      ),));
    }

    return childrenWidget;

  }


}
