import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';

class UIHelpers {


  static showToast(String message , bool isError , bool useDefaultDecoration ,{Color fontColor, Color backgroundColor ,double textSize , Toast toastLength , ToastGravity gravity }){

    if(useDefaultDecoration ?? true){
      Fluttertoast.showToast(
          msg: message,
          toastLength: toastLength ?? Toast.LENGTH_LONG,
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

  static Future<File> cropImage(String imagePath) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        maxHeight: 4096,
        maxWidth: 4096,
        cropStyle: CropStyle.rectangle,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.png,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          hideBottomControls: true,
            toolbarTitle: (LocalKeys.CUSTOMIZE_YOUR_IMAGE).tr(),
            toolbarColor: AppColors.lightBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,),
        iosUiSettings: IOSUiSettings(
          title: (LocalKeys.CUSTOMIZE_YOUR_IMAGE).tr(),
        ));

    return croppedFile;
  }
  static  Widget buildTextField({BuildContext context , String Function(String text) validator, bool secured, hint, FocusNode nextNode, TextEditingController textController, FocusNode focusNode, bool autoValidate , Function(String) onEditingCompleted}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        key: GlobalKey(),
        obscureText: secured ?? false,
        validator: validator ?? Validator.requiredField,
        controller: textController,
        onFieldSubmitted: onEditingCompleted,
        //focusNode: focusNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: .5,
              color: AppColors.lightBlue,
            ),
          ),
          fillColor: AppColors.offWhite,
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: .5,
              color: AppColors.lightBlue,
            ),
          ),
          alignLabelWithHint: true,
        ),
        //textInputAction: nextNode != null ? TextInputAction.next : TextInputAction.done,
      ),
    );
  }





}