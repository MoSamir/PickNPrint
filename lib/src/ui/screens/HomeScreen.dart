import 'dart:io';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/states/ApplicationDataState.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/screens/PickYourPhotosScreen.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/NumberedBoxWidget.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../BaseScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  YoutubePlayerController _controller;


  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: 'K18cpp_-gP8',
      params: YoutubePlayerParams(
        startAt: Duration(seconds: 30),
        showControls: false,
        enableCaption: false,
        showVideoAnnotations: false,
        showFullscreenButton: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        listener: (context , state){
          if (state is ApplicationDataLoadingFailureState) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetworkErrorView();
                  });
            } else if (state.error.errorCode ==
                HttpStatus.serviceUnavailable) {
              Fluttertoast.showToast(
                  msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              Fluttertoast.showToast(
                  msg: state.error.errorMessage ?? '',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
        builder: (context , state){
          return ModalProgressHUD(
            inAsyncCall: state is ApplicationDataLoadingState,
            child: BaseScreen(
              hasDrawer: true,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black12,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: <Widget>[
                              SizedBox(
                                height:MediaQuery.of(context).size.height * .5,
                                width: MediaQuery.of(context).size.width,
                                child:YoutubePlayerIFrame(
                                  controller: _controller,
                                  aspectRatio: 16 / 9,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 110,
                                child: Container(
                                  color: Colors.black12.withOpacity(.5),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      NumberedBoxWidget(
                                        passedNumber: '1',
                                        passedText: (LocalKeys.PICK_KEY).tr(),
                                        passedWidget: Icon(Icons.image, color: AppColors.lightBlack.withOpacity(.5), size: 35,),
                                      ),
                                      NumberedBoxWidget(
                                        passedNumber: '2',
                                        passedText: (LocalKeys.PRINT_KEY).tr(),
                                        passedWidget: Icon(Icons.print, color: AppColors.lightBlack.withOpacity(.5), size: 35,),
                                      ),
                                      NumberedBoxWidget(
                                        passedNumber: '3',
                                        passedText: (LocalKeys.DELIVER_KEY).tr(),
                                        passedWidget: Icon(Icons.local_shipping, color: AppColors.lightBlack.withOpacity(.5), size: 35,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: AppColors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8 , vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(text: (LocalKeys.PICK_PHOTOS_KEY).tr(), style: TextStyle(color: AppColors.lightBlue , fontSize: 20)),
                                TextSpan(text:'  '),
                                TextSpan(text: (LocalKeys.AND_PRINT_KEY).tr(), style: TextStyle(color: AppColors.black , fontSize: 20)),
                              ]
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(LocalKeys.PICK_N_PRINT_KEY , textAlign: TextAlign.start,).tr(),
                        SizedBox(height: 10,),
                        Center(
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              width: (200),
                              height: (40),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(child: Text((LocalKeys.READ_MORE_KEY).tr(), style: TextStyle(color: AppColors.white),)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Resources.CHOOSE_PACKAGE_IMG),
                          fit: BoxFit.fill
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 5,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Center(
                                child: Text((LocalKeys.CHOOSE_PACKAGE_KEY).tr(), textAlign: TextAlign.center,style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),),
                              ),
                              SizedBox(height: 5,),
                              Center(
                                child: Text((LocalKeys.WHAT_WE_OFFER).tr(), textAlign: TextAlign.center, style: TextStyle(
                                  color: AppColors.white,
                                ),),
                              ),
                              SizedBox(height: 10,),
                            ],),
                        )
                      ],
                    ),
                  ),
                  getAvailablePackagesView(BlocProvider.of<ApplicationDataBloc>(context).applicationPackages),
                  Visibility(
                    replacement: Container(height: 0, width: 0,),
                    visible: state is ApplicationDataLoadedState ,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Resources.LARGE_PACKAGE_IMG),
                              fit: BoxFit.cover,
                            ),
                            border: Border(
                              bottom: BorderSide(
                                width: 2,
                                color: AppColors.lightBlue,
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 30),
                              child: Text('${BlocProvider.of<ApplicationDataBloc>(context).maxPackageSize}+' , style: TextStyle(
                                color: AppColors.lightBlue,
                                fontSize: 30,
                              ),),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: AppColors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text((LocalKeys.REQUEST_EXTRA_PACKAGES_THAN).tr(args:[BlocProvider.of<ApplicationDataBloc>(context).maxPackageSize.toString()]) , style: TextStyle(
                                color: AppColors.lightBlue,
                              ),),
                              SizedBox(height: 5,),
                              Text((LocalKeys.CHECKOUT_EXTRA_RATE).tr() , style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),),
                              SizedBox(height: 15,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        cubit: BlocProvider.of<ApplicationDataBloc>(context),

    );
  }
  Widget getAvailablePackagesView(List<PackageModel> systemPackages) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(6),
      physics: NeverScrollableScrollPhysics(),
      children: systemPackages.map((PackageModel package){
        return Container(
          color: AppColors.white,
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8,),
              Center(
                child: Text((LocalKeys.PACKAGE_SIZE).tr(args:([package.packageSize.toString()])) , textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 20, color: AppColors.lightBlue, fontWeight: FontWeight.bold,
                ),),
              ),
              SizedBox(height: 8,),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(package.packageSize, (index) => Center(
                  child: Container(
                    width: (70), height: (70), padding: EdgeInsets.all(2),decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        width: 2,
                        color: AppColors.lightBlack.withOpacity(.8),
                      )
                  ),
                  ),
                )),
              ),
              SizedBox(height: 8,),
              Center(
                child: Text((LocalKeys.PRICE_TEXT).tr(args:([package.packagePrice.toString()])) , textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 18, color: AppColors.black,
                ),),
              ),
              SizedBox(height: 2,),
              Center(
                child: Text((LocalKeys.SAVE_TEXT).tr(args:([package.packageSaving.toString()])) , textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 18, color: AppColors.lightBlue,
                ),),
              ),
              SizedBox(height: 8,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PickYourPhotosScreen(userSelectedPackage: package,)));
                  },
                  child: Container(
                    width: (200),
                    height: (40),
//                        padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(child: Text((LocalKeys.GO_LABEL).tr(), style: TextStyle(color: AppColors.white),)),
                  ),
                ),
              ),
              SizedBox(height: 8,),

            ],

          ),
        );
      }).toList(),);

  }

}




