import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserCartBloc.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/events/UserCartEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';

import 'package:picknprint/src/ui/screens/HomeScreen.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticateUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      builder: (context, state){
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Splash Screen goes here"),
                SizedBox(
                  height: 5,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
      listener: (context, state){
        if(state is UserAuthenticated){
          if(state.currentUser.isAnonymous() == false)
            BlocProvider.of<UserCartBloc>(context).add(LoadCartEvent());

          navigateToHomePage();


        }
        else if (state is AuthenticationFailed) {
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
      cubit: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  void navigateToHomePage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
  }
}
