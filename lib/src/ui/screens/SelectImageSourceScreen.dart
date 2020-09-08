import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
import 'package:easy_localization/easy_localization.dart';
class SelectImageSourceScreen extends StatefulWidget {
  @override
  _SelectImageSourceScreenState createState() => _SelectImageSourceScreenState();
}

class _SelectImageSourceScreenState extends State<SelectImageSourceScreen> {


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PickNPrintAppbar(hasDrawer: true,appbarColor: AppColors.black,),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 150,
              child: Container(
                color: AppColors.blackBg,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text((LocalKeys.SELECT_YOUR_PHOTOS).tr(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.white,
                        ), textAlign: TextAlign.center,),
                        Text((LocalKeys.SELECT_YOUR_PHOTOS_DESCRIPTION).tr(), style: TextStyle(
                          color: AppColors.white,
                        ), textAlign: TextAlign.center,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: GestureDetector(
                              onTap: (){
                                pickUserPicture(context);
                                return;
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 32,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(child: Text((LocalKeys.UPLOAD_YOUR_OWN_LABEL).tr(), style: TextStyle(color: AppColors.white),)),
                              ),
                            ),
                          ),
                        ),
                        Text((LocalKeys.SELECT_YOUR_PHOTOS_DESCRIPTION).tr(), style: TextStyle(
                          color: AppColors.white,
                        ), textAlign: TextAlign.center,),
                        Text((LocalKeys.UPLOAD_YOUR_MEMORY).tr(), style: TextStyle(
                          color: AppColors.white,
                        ), textAlign: TextAlign.center,),
                        SizedBox(height: 5,),
                        Text((LocalKeys.OR_LABEL).tr(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.white,
                        ), textAlign: TextAlign.center,),
                        Text((LocalKeys.PICK_FROM_SOCIAL_MEDIA).tr(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.white,
                        ), textAlign: TextAlign.center,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 8.0),
                          child: Center(
                            child: GestureDetector(
                              onTap: (){},
                              child: Container(
                                width: MediaQuery.of(context).size.width - 32,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlack,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(Resources.FACEBOOK_LOGO_IMG),
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
                                              child: Text((LocalKeys.FACEBOOK_LABEL).tr(), style: TextStyle(
                                                color: AppColors.white,
                                              ), textAlign: TextAlign.center,),
                                            ),
                                            Expanded(
                                              child: Text((LocalKeys.SELECT_FROM_FACEBOOK).tr(), style: TextStyle(
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 8.0),
                          child: Center(
                            child: GestureDetector(
                              onTap: (){},
                              child: Container(
                                width: MediaQuery.of(context).size.width - 32,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlack,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(Resources.INSTAGRAM_LOGO_IMG),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text((LocalKeys.INSTAGRAM_LABEL).tr(), style: TextStyle(
                                            color: AppColors.white,
                                          ), textAlign: TextAlign.center,),
                                          Text((LocalKeys.SELECT_FROM_INSTAGRAM).tr(), style: TextStyle(
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
              ),
            ),
            Positioned(
              child: Container(
                color: AppColors.blackBg.withOpacity(.5),
                child: PickNPrintFooter(),
              ),
              bottom: 0,
              height: 150,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }






  pickUserPicture(BuildContext context) async{
    _scaffoldKey.currentState.showBottomSheet((context){
      
      return Container(
        decoration: BoxDecoration(
          color:AppColors.black.withOpacity(.4),
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
                  // fontFamily: Constants.FONT_ARIAL,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ).tr(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: FlatButton.icon(
                        onPressed: () {
                          pickUserImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        label: Text(''),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FlatButton.icon(
                        onPressed: () {
                          pickUserImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        label: Text(''),
                      ),
                    ),
                  ), //getAppleLogin(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void pickUserImage(ImageSource source) async{
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: source , imageQuality: 100,);
    if(image != null){
      Navigator.of(context).pop(image.path);
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
