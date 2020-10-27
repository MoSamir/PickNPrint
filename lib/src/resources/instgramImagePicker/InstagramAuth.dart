import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InstagramAuth with ChangeNotifier {
  Future<String> get accessToken async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("instagram_token");
  }

  static final InstagramAuth _singleton = new InstagramAuth._();

  factory InstagramAuth() => _singleton;

  InstagramAuth._();

  Future<void> signInWithInstagram(BuildContext context) async {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();


    flutterWebviewPlugin.onUrlChanged.listen((String url) async {

      print("-----------------------------------------------------------------");
      url.split('/').forEach((element) {print("URL Component => $element");});
      print("-----------------------------------------------------------------");


      print("URL From Instgram Plugin => $url");
      if (url.contains('code=')) {
        // save access token for later logins
        var _accessToken = url.split("code=")[0];

        String createTokenURL =  "https://api.instagram.com/oauth/access_token?client_id=1677ed07ddd54db0a70f14f9b1435579&client_secret=eb8c7&grant_type=authorization_code&redirect_uri=http://instagram.pixelunion.netcode=$_accessToken&hl=en";
        var response = await http.post(createTokenURL);

        if(response.statusCode == 200){
          print("Access Token => ${json.decode(response.body)} ");
          _accessToken = json.decode(response.body)['access_token'];
        } else {
          print("Error retrieving token => ${response.statusCode} ");
          print("Error retrieving token => ${response.body}");
        }




        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("instagram_token", _accessToken);
        await flutterWebviewPlugin.cleanCookies();
        await flutterWebviewPlugin.close();


      // String token = "  https://api.instagram.com/oauth/access_token?client_id=684477648739411 \
      //   -F client_secret=eb8c7... \
      // -F grant_type=authorization_code \
      // -F redirect_uri=https://socialsizzle.herokuapp.com/auth/ \
      // -F code=AQDp3TtBQQ...";





        // pop the webview Scaffold and immediately enter the picker
        Navigator.pop(context, _accessToken);
      }
    });
  }

  Future<void> logout() async{
    // remove access token from prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("instagram_token");
  }
}