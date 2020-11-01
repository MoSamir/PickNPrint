import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';

class UIHelpers {


  static showToast(String message , bool isError , bool useDefaultDecoration ,{Color fontColor, Color backgroundColor ,double textSize , Toast toastLength , ToastGravity gravity }){

    if(useDefaultDecoration ?? true){
      Fluttertoast.showToast(
          msg: message,
          toastLength: toastLength ?? Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: (isError ?? false) ? Colors.red : Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: (isError ?? false) ? Colors.red : Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }


  }

  static void showNetworkError(BuildContext context) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NetworkErrorView();
        });
    await Future.delayed(Duration(seconds: 2),(){});
    Navigator.pop(context);
  }



}