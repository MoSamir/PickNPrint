import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:picknprint/src/resources/instgramImagePicker/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class InstagramAuth with ChangeNotifier {
  Future<String> get accessToken async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("instagram_token");
  }
  static final InstagramAuth _singleton = new InstagramAuth._();

  factory InstagramAuth() => _singleton;

  InstagramAuth._();

  Future<void> signInWithInstagram(BuildContext context) async {
    print("Hello World this Fn is Called");

    final flutterWebViewPlugin = new FlutterWebviewPlugin();
    String _accessToken , userId ;

    flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      if(url.contains('access_token =')){
         _accessToken = url.split("access_token=")[1];
        SharedPreferences prefs = await SharedPreferences.getInstance();
         userId =  prefs.getString("instagram_userId");
        Navigator.pop(context, [_accessToken , userId]);
      }
      if (url.contains('code=')) {
        String authCode = url.split("code=")[1];
        authCode = authCode.split('&')[0];
        if(authCode.contains('#_'))
          authCode = authCode.substring(0, authCode.indexOf('#_'));


        String createTokenURL =  "https://api.instagram.com/oauth/access_token";
        Map<String,dynamic> requestBody = {
          "client_id": "343329190090671",
          "client_secret": "fbde8562227a0deeeca8d6324a881cfa",
          "code": authCode,
            "grant_type": "authorization_code",
          "redirect_uri": "https://dawayerstudio.com/",
        };
        var response = await http.post(createTokenURL , body: requestBody);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if(response.statusCode == 200){
          _accessToken = json.decode(response.body)['access_token'];
          userId = json.decode(response.body)['user_id'].toString();
          prefs.setString("instagram_token", _accessToken);
          prefs.setString("instagram_userId", userId);
        } else {
            await flutterWebViewPlugin.launch(InstagramWebViewLoginPage.url);
        }

        prefs.setString("instagram_token", _accessToken);
        prefs.setString("instagram_userId", userId);

        await flutterWebViewPlugin.cleanCookies();
        await flutterWebViewPlugin.close();
        Navigator.pop(context, [_accessToken , userId]);
      }
    });
  }

  Future<void> logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("instagram_token");
    prefs.remove("instagram_userId");
  }


  @override
  void dispose() {
    super.dispose();
  }
}