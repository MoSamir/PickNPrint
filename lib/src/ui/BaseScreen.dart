import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/ui/widgets/NavigationDrawer.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';

import '../../main.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final bool hasDrawer;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  BaseScreen({this.child, this.hasDrawer});


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.CURRENT_LOCALE == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            drawer: NavigationDrawer(),
            appBar: PickNPrintAppbar(
              hasDrawer: hasDrawer,
              appbarColor: AppColors.black,
            ),
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
                      height: 150,
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
}