import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
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

    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.onUrlChanged.listen((String url) async {

      print("-----------------------------------------------------------------");
      url.split('/').forEach((element) {print("URL Component => $element");});
      print("-----------------------------------------------------------------");
      print("URL From Instgram Plugin => $url");


      if(url.contains('access_token =')){
        String _accessToken = url.split("access_token=")[1];

        print("Access Token =======================================>");
        print(_accessToken);
        print("Access Token =======================================>");

        //_accessToken = _accessToken.split('&')[0];



        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id =  prefs.getString("instagram_userId");


        Navigator.pop(context, [_accessToken , id]);
      }


      if (url.contains('code=')) {
        // save access token for later logins
        url.split("code=").forEach((element) {
          print(element);
        });
        String authCode = url.split("code=")[1];
        authCode = authCode.split('&')[0];
        if(authCode.contains('#_'))
          authCode = authCode.substring(0, authCode.indexOf('#_'));

        String _accessToken = "";
        print("AUTH CODE --------------------------------");
        print(authCode);
        print("AUTH CODE --------------------------------");


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
        String _userId ;

        if(response.statusCode == 200){
          print("Access Token => ${json.decode(response.body)} ");
          _accessToken = json.decode(response.body)['access_token'];
          _userId = json.decode(response.body)['user_id'].toString();
          prefs.setString("instagram_token", _accessToken);
          prefs.setString("instagram_userId", _userId);
        } else {
          print("Error retrieving token => ${response.statusCode} ");
          print("Error retrieving token => ${response.body}");
        }

        prefs.setString("instagram_token", _accessToken);
        prefs.setString("instagram_userId", _userId);
        await flutterWebviewPlugin.cleanCookies();
        await flutterWebviewPlugin.close();


      // String token = "  https://api.instagram.com/oauth/access_token?client_id=684477648739411 \
      //   -F client_secret=eb8c7... \
      // -F grant_type=authorization_code \
      // -F redirect_uri=https://socialsizzle.herokuapp.com/auth/ \
      // -F code=AQDp3TtBQQ...";





        // pop the webview Scaffold and immediately enter the picker
        Navigator.pop(context, [_accessToken , _userId]);
      }
    });
  }

  Future<void> logout() async{
    // remove access token from prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("instagram_token");
    prefs.remove("instagram_userId");
  }


  @override
  void dispose() {
    super.dispose();
  }
}