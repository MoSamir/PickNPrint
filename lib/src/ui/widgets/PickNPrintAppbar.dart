import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserCartBloc.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/screens/LoginScreen.dart';

import 'NetworkErrorView.dart';

class PickNPrintAppbar extends StatefulWidget implements PreferredSizeWidget{
  final List<Widget> actions ;
  final String title ;
  final Color appbarColor ;
  final hasDrawer ;
  final Function onDrawerIconClick;
  final bool centerTitle , autoImplyLeading;
  PickNPrintAppbar({this.actions, this.onDrawerIconClick ,this.hasDrawer , this.appbarColor, this.title , this.autoImplyLeading , this.centerTitle});



  @override
  _PickNPrintAppbarState createState() => _PickNPrintAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _PickNPrintAppbarState extends State<PickNPrintAppbar> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: BlocProvider.of<UserBloc>(context),
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
        return AppBar(
          brightness: Brightness.light,
          backgroundColor: widget.appbarColor ?? AppColors.lightBlack,
          leading: Wrap(
            children: <Widget>[
              Visibility(
                visible: widget.hasDrawer ?? false,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.drag_handle , color: AppColors.white, size: 20,),
                  onPressed: widget.onDrawerIconClick ?? (){},
                ),
              ),
            ],
          ),
          flexibleSpace: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Image.asset(Resources.APPBAR_LOGO_IMG , width: MediaQuery.of(context).size.width * .25 , height: 40,),
            ),
          ),
          title: Text(widget.title ?? ''),
          actions: [
            getCartSize(),
            getUser(state),
          ],
          automaticallyImplyLeading: widget.autoImplyLeading ?? true,
          centerTitle: widget.centerTitle ?? false,
          elevation: 0,
        );
      },
    );
  }

  Widget getUser(UserBlocStates state) {
    if(BlocProvider.of<UserBloc>(context).currentLoggedInUser.isAnonymous() == false)
      return Container(
        color: AppColors.transparent,
        width: 30, height: 30, child: IconButton(
      onPressed: (){},
      padding: EdgeInsets.all(0),
      icon: ImageIcon(AssetImage(Resources.USER_PLACEHOLDER_IMG ) ,color: AppColors.white ,size: 25,),
    ));
    else
      return Container(
          color: AppColors.transparent,
           height: 30, child: FlatButton(
        onPressed: ()async{
          await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
          setState(() {});
        },
        padding: EdgeInsets.all(0),
        child: Text((LocalKeys.SIGN_IN).tr(), style: TextStyle(
          color: AppColors.white,
        ),),
      ));
  }


  Widget getCartSize() {
    return StreamBuilder<int>(
      stream: BlocProvider.of<UserCartBloc>(context).cartItemsStream,
      initialData: 0,
      builder: (context, cartLength){
        return  Container(
            color: AppColors.transparent,
            width: 30, height: 30, child: FlatButton(
          onPressed: (){},
          padding: EdgeInsets.all(0),
          child: Center(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.shopping_cart , color: AppColors.white ,size: 25,),
                ),
                Visibility(
                  visible: cartLength.data > 0,
                  replacement: Container(width: 0, height: 0,),
                  child: Positioned(
                      top: 3,
                      right: 0,
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
                        child: Center(child: Text(cartLength.data.toString() , textScaleFactor: 1 ,style: TextStyle(
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
      },
    );
  }
}
