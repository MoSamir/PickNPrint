import 'package:flutter/material.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Resources.dart';

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
    return AppBar(
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
      actions: widget.actions ?? [],
      automaticallyImplyLeading: widget.autoImplyLeading ?? true,
      centerTitle: widget.centerTitle ?? false,
      elevation: 0,
    );
  }
}
