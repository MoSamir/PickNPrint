import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/ui/widgets/NavigationDrawer.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';


class BaseScreen extends StatelessWidget {
  final Widget child;
  final bool hasDrawer , hasAppbar;
  final PickNPrintAppbar customAppbar;
  final String screenTitle ;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BaseScreen({this.child, this.hasDrawer , this.customAppbar , this.hasAppbar, this.screenTitle});


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.appLocale == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: true,
            resizeToAvoidBottomPadding: true,
            primary: true,
            key: scaffoldKey,
            drawer: resolveDrawer(),
            appBar: resolveAppbar(),
            body: CustomScrollView(
              shrinkWrap: true,
              anchor: 0.0,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(0),
                  sliver: SliverToBoxAdapter(
                    child: SingleChildScrollView(
                        child: child,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(0),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 100,
                      child: PickNPrintFooter(),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget resolveAppbar() {
    Widget appBar = PickNPrintAppbar(
      autoImplyLeading: hasDrawer,
      appbarColor: AppColors.black,
      title: screenTitle ?? '',
    ) ;
    if((hasAppbar ?? true)) {
      if(customAppbar != null) {
        appBar = customAppbar;
      }
    }
    else {
      appBar = PreferredSize(
        preferredSize: Size.zero,
        child: Container(),
      );
    }
    return appBar ;
  }

  Widget resolveDrawer() {
    return hasDrawer ? NavigationDrawer() : null;
  }
}