import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'InstagramAuth.dart';

class InstagramWebViewLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String url = "https://api.instagram.com/oauth/authorize?client_id=343329190090671&scope=user_profile,user_media&redirect_uri=https://dawayerstudio.com/&response_type=code&hl=en";
    InstagramAuth().signInWithInstagram(context);

    return WebviewScaffold(
      url: url,
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
