import 'package:flutter/material.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart';
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hasDrawer: false,
      hasAppbar: true,
      customAppbar: PickNPrintAppbar(
        title: (LocalKeys.ABOUT_SCREEN_TITLE).tr(),
      ),

      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Resources.SHIPPING_ADDRESS_BANNER_IMG),
                fit: BoxFit.fill
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",),
        ],
      ),
    );
  }
}
