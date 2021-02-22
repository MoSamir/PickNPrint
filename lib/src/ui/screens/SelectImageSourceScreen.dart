import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/resources/customGalleryPicker/CustomGallery.dart';
import 'package:picknprint/src/resources/facebookImagePicker/flutter_facebook_image_picker.dart';
import 'package:picknprint/src/resources/instgramImagePicker/InstagramAuth.dart';
import 'package:picknprint/src/resources/instgramImagePicker/flutter_instagram_image_picker.dart';
import 'package:picknprint/src/resources/instgramImagePicker/model/photo.dart' as instgramPhoto;
import 'package:picknprint/src/resources/instgramImagePicker/screens.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';
class SelectImageSourceScreen extends StatefulWidget {
  @override
  _SelectImageSourceScreenState createState() => _SelectImageSourceScreenState();
}

class _SelectImageSourceScreenState extends State<SelectImageSourceScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hasDrawer: false,
      customAppbar: PickNPrintAppbar(
        appbarColor: AppColors.black,
        actions: [],
        centerTitle: true,
        //title: (LocalKeys.ABOUT_SCREEN_TITLE).tr(),
      ),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height - 174,
        color: Colors.blue,
        child: Container(
          color: AppColors.blackBg,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text((LocalKeys.SELECT_YOUR_PHOTOS).tr(), style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.white,
              ), textAlign: TextAlign.center,),
              // Text((LocalKeys.SELECT_YOUR_PHOTOS_DESCRIPTION).tr(),
              //   style: TextStyle(
              //     color: AppColors.white,
              //   ), textAlign: TextAlign.center,),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.0),
              //   child: Center(
              //     child: GestureDetector(
              //       onTap: () {
              //         pickUserPicture(context);
              //         return;
              //       },
              //       child: Container(
              //         width: MediaQuery
              //             .of(context)
              //             .size
              //             .width - 32,
              //         height: (50),
              //         decoration: BoxDecoration(
              //           color: AppColors.lightBlue,
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //         ),
              //         child: Center(child: Text((LocalKeys
              //             .UPLOAD_YOUR_OWN_LABEL).tr(), style: TextStyle(
              //             color: AppColors.white),)),
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(height: 10,),

              Text((LocalKeys.SELECT_YOUR_PHOTOS_DESCRIPTION).tr(),
                style: TextStyle(
                  color: AppColors.white,
                ), textAlign: TextAlign.center,),
              Text((LocalKeys.UPLOAD_YOUR_MEMORY).tr(), style: TextStyle(
                color: AppColors.white,
              ), textAlign: TextAlign.center,),
              SizedBox(height: 5,),

              // Text((LocalKeys.OR_LABEL).tr(), style: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   fontSize: 20,
              //   color: AppColors.white,
              // ), textAlign: TextAlign.center,),
              // Text((LocalKeys.PICK_FROM_SOCIAL_MEDIA).tr(), style: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   fontSize: 20,
              //   color: AppColors.white,
              // ), textAlign: TextAlign.center,),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: (){
                      print("Image Source is !");
                      pickUserImage(ImageSource.camera);
                      return;
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 32,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.lightBlack,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Center(child: Icon(Icons.camera , size: 25,color: AppColors.white, ),),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text((LocalKeys.PICK_FROM_CAMERA).tr(),
                                      style: TextStyle(
                                        color: AppColors.white,
                                      ), textAlign: TextAlign.center,),
                                  ),
                                  Expanded(
                                    child: Text(
                                      (LocalKeys.SELECT_FROM_CAMERA).tr(),
                                      style: TextStyle(
                                        color: AppColors.white,
                                      ), textAlign: TextAlign.center,),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: getImageFromPickNPrintGallery,
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 32,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.lightBlack,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Center(child: Icon(Icons.photo , size: 25, color: AppColors.white,),),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text((LocalKeys.PICK_FROM_GALLERY).tr(),
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ), textAlign: TextAlign.center,),
                                Text((LocalKeys.SELECT_FROM_GALLERY).tr(),
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ), textAlign: TextAlign.center,),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  pickUserPicture(BuildContext context) async {
    showModalBottomSheet(context: context, builder: (context) =>
        Container(
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(.4),
            backgroundBlendMode: BlendMode.darken,
          ),

          child: Container(
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  (LocalKeys.CAPTURE_IMAGE_USING).tr(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // fontFamily: Constants.FONT_ARIAL,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: FlatButton(
                          onPressed: getImageFromPickNPrintGallery,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              Text((LocalKeys.PICK_FROM_GALLERY).tr(),
                                style: TextStyle(
                                  color: AppColors.white,

                                ),),
                            ],
                          ),

                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: FlatButton(
                          onPressed: () {
                            pickUserImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              Text((LocalKeys.PICK_FROM_CAMERA).tr(),
                                style: TextStyle(
                                  color: AppColors.white,
                                ),),
                            ],
                          ),
                        ),
                      ),
                    ), //getAppleLogin(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void pickUserImage(ImageSource source) async {
    final _picker = ImagePicker();

    PickedFile image = await _picker.getImage(
        source: source, imageQuality: 80, maxHeight: 150, maxWidth: 150);
    if (image != null) {
      File croppedFilePath = await UIHelpers.cropImage(image.path);
      Navigator.of(context).pop([croppedFilePath.path, image.path]);
    } else {
      Fluttertoast.showToast(
          msg: (LocalKeys.UNABLE_TO_READ_IMAGE).tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  // void _pickImageFromFacebook() async {
  //   ResponseViewModel<UserViewModel> facebookUser = await Repository
  //       .signInWithFacebook();
  //   if (facebookUser.isSuccess) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (_) =>
  //             FacebookImagePicker(
  //               facebookUser.responseData.userToken,
  //               onDone: (items) async {
  //                 Navigator.pop(context);
  //                 if (items != null && items.length > 0) {
  //                   ResponseViewModel<File> imageFile = await Repository
  //                       .getImageFromURL(items[0].source);
  //                   if (imageFile.isSuccess) {
  //                     File croppedFilePath = await UIHelpers.cropImage(
  //                         imageFile.responseData.path);
  //                     Navigator.of(context).pop(
  //                         [croppedFilePath.path, imageFile.responseData.path]);
  //                   }
  //                 }
  //               },
  //               onCancel: () => Navigator.pop(context),
  //             ),
  //       ),
  //     );
  //   }
  // }
  // void _pickImageFromInstagram() async {
  //   String accessToken;
  //   accessToken = await InstagramAuth().accessToken;
  //   if (accessToken == null) {
  //     List<String> loginInfo = await Navigator.push(context, MaterialPageRoute(
  //       builder: (_) => InstagramWebViewLoginPage(),
  //     ));
  //     accessToken = loginInfo[0];
  //     if (accessToken == null) return;
  //   }
  //   Navigator.push(context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           InstagramImagePicker(
  //             accessToken,
  //             showLogoutButton: true,
  //             onDone: (List<instgramPhoto.Photo> items) async {
  //               Navigator.pop(context);
  //               if (items != null && items.length > 0) {
  //                 ResponseViewModel<File> imageFile = await Repository
  //                     .getImageFromURL(items[0].url);
  //                 if (imageFile.isSuccess) {
  //                   File croppedFilePath = await UIHelpers.cropImage(
  //                       imageFile.responseData.path);
  //                   Navigator.pop(context,
  //                       [croppedFilePath.path, imageFile.responseData.path]);
  //                   return;
  //                 }
  //               }
  //               Navigator.pop(context);
  //               return;
  //             },
  //             onCancel: () => Navigator.pop(context),
  //           ),
  //     ),
  //   );
  // }


  void getImageFromPickNPrintGallery() async {
//    Navigator.pop(context);
    String imageFilePath = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CustomGallery()));

    if (imageFilePath != null) {
      File croppedFilePath = await UIHelpers.cropImage(imageFilePath);
      Navigator.of(context).pop([croppedFilePath.path, imageFilePath]);
    } else {
      Fluttertoast.showToast(
          msg: (LocalKeys.UNABLE_TO_READ_IMAGE).tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}
