import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'InstagramAuth.dart';



class InstagramWebViewLoginPage extends StatefulWidget {
  static String url = "https://api.instagram.com/oauth/authorize?client_id=343329190090671&scope=user_profile,user_media&redirect_uri=https://dawayerstudio.com/&response_type=code&hl=en";

  @override
  _InstagramWebViewLoginPageState createState() => _InstagramWebViewLoginPageState();
}

class _InstagramWebViewLoginPageState extends State<InstagramWebViewLoginPage> {


  @override
  void initState() {
    super.initState();
    InstagramAuth().signInWithInstagram(context);
  }

  @override
  Widget build(BuildContext context) {

    return WebviewScaffold(
      url: InstagramWebViewLoginPage.url,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text('Login to Instagram', style: TextStyle(color: Colors.white),),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
    );
  }
}
