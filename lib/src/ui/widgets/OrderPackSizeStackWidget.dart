import 'package:flutter/material.dart';
import 'package:picknprint/src/resources/AppStyles.dart';

class OrderPackSizeStackWidget extends StatelessWidget {


  final int packageSize ;
  OrderPackSizeStackWidget({this.packageSize});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 60 + (packageSize * 7.5),
//      color: Colors.blue,
      child: Stack(
        children: getStackChildren(),
      ),
    );
  }


  List<Widget> getStackChildren(){
    List<Widget> childrenWidget = List();
    for(int i = 0 ; i < packageSize ; i++){
      childrenWidget.add(Positioned(
        top: 0,
        left: 0,
        child:  Container(
          height: 50,
          width: (50 + (i * 7.5)),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: AppColors.black,
            ),
          ),
          child: Center(child: Text(i == 1 ? packageSize.toString() : '' , style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.black,
          ),)),
        ),
      ));
    }

    return childrenWidget;

  }


}
