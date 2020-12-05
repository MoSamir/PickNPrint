import 'dart:io';


import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';

import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/screens/LoginScreen.dart';
import 'package:picknprint/src/ui/screens/ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart' as ll;
import 'package:picknprint/src/ui/screens/UserCartScreen.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';

import 'NetworkErrorView.dart';

class PickNPrintAppbar extends StatefulWidget implements PreferredSizeWidget{
  final List<Widget> actions ;
  final String title ;
  final Color appbarColor ;

  final bool centerTitle , autoImplyLeading;
  PickNPrintAppbar({this.actions, this.appbarColor, this.title , this.autoImplyLeading , this.centerTitle});



  @override
  _PickNPrintAppbarState createState() => _PickNPrintAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _PickNPrintAppbarState extends State<PickNPrintAppbar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.CURRENT_LOCALE == "en" ? TextDirection.ltr : TextDirection.rtl ,
      child: BlocConsumer(
        cubit: BlocProvider.of<UserBloc>(context),
        listener: (context , state){
          if (state is UserDataLoadingFailedState) {
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
          return Directionality(
            textDirection: Constants.CURRENT_LOCALE == "en" ? TextDirection.ltr : TextDirection.rtl,
            child: AppBar(
              brightness: Brightness.light,
              backgroundColor: widget.appbarColor ?? AppColors.lightBlack,
              flexibleSpace: widget.title == null || widget.title.length == 0 ? Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset(Resources.APPBAR_LOGO_IMG , width: MediaQuery.of(context).size.width * .25 , height: 40,),
                ),
              ) : Container(width: 0, height: 0,),
              title: Text(widget.title ?? ''),
              actions: widget.actions ?? [
                getCartSize(),
                getUser(state),
              ],
              automaticallyImplyLeading: widget.autoImplyLeading ?? true,
              centerTitle: widget.centerTitle ?? false,
              elevation: 0,
            ),
          );
        },
      ),
    );
  }

  Widget getUser(UserBlocStates state) {

    if(BlocProvider.of<UserBloc>(context).state is UserDataLoadingState){
      return LoadingWidget(
        size : 20.0,
      );
    }

    if(BlocProvider.of<UserBloc>(context).currentLoggedInUser.isAnonymous() == false) {
      return Container(
        color: AppColors.transparent,
        width: 30, height: 30, child: IconButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen()));
      },
      padding: EdgeInsets.all(0),
      icon: ImageIcon(AssetImage(Resources.USER_PLACEHOLDER_IMG ) ,color: AppColors.white ,size: 25,),
    ));
    } else {
      return Container(
          color: AppColors.transparent,
           height: 30, child: FlatButton(
        onPressed: ()async{
          await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
        },
        padding: EdgeInsets.all(0),
        child: Text((LocalKeys.SIGN_IN).tr(), style: TextStyle(
          color: AppColors.white,
        ),),
      ));
    }
  }


  Widget getCartSize() {
    if(BlocProvider.of<UserBloc>(context).currentLoggedInUser.isAnonymous() == false)
      return Container(
          color: AppColors.transparent,
          width: 30, height: 30, child: FlatButton(
        onPressed: goToCartScreen,
        padding: EdgeInsets.all(0),
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.shopping_cart , color: AppColors.white ,size: 25,),
              ),
              Visibility(
                visible: BlocProvider.of<UserBloc>(context).userCart.length > 0,
                replacement: Container(width: 0, height: 0,),
                child: Positioned.directional(
                    textDirection: Constants.CURRENT_LOCALE == "en" ? TextDirection.ltr : TextDirection.rtl,
                    top: 3,
                    start: 0,
                    width: 18,
                    height: 18,
                    //alignment: Alignment.topRight,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(BlocProvider.of<UserBloc>(context).userCart.length.toString() , textScaleFactor: 1 ,style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                      ),)),
                    )
                ),
              ),
            ],
          ),
        ),
      ));
    else
      return Container(width: 0, height: 0,);
  }

  void goToCartScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserCartScreen()));
  }
}
