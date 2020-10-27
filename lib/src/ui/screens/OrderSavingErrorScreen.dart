import 'package:flutter/material.dart';

import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:picknprint/src/resources/LocalKeys.dart';



class OrderSavingErrorScreen extends StatelessWidget {

  final String error ;
  OrderSavingErrorScreen({this.error});



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: AppColors.lightBlack,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.error_outline , size: 30, color: AppColors.lightBlue,),
                    SizedBox(height: 10,),
                    Text(error , textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: (50),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text((LocalKeys.BACK_TO_ORDER).tr(), style: TextStyle(
                            color: AppColors.white,
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 180,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Center(
                      child: Container(
                        color: AppColors.lightBlue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Text((LocalKeys.DO_NOT_HAVE_IMAGES_YET).tr() , textAlign: TextAlign.center, style: TextStyle(
                              color: AppColors.white,
                            ),),
                            FlatButton(
                              onPressed: (){},
                              color: AppColors.white,
                              child: Text((LocalKeys.ADD_TO_CART_AND_CONTINUE_SHOPPING).tr() , textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                      ),
                    ),
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 25,
                  ),
                  Positioned(
                    //alignment: Alignment.topCenter,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        height: (50),
                        width: (50),
                        child: Center(child: Icon(Icons.save , color: AppColors.white, size: 35,),),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



