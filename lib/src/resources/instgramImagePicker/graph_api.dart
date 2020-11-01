import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/photo_paging.dart';

class GraphApi {


  final String _accessToken;

  GraphApi(this._accessToken);

  Future<PhotoPaging> fetchPhotos({String pagingUrl}) async {
     String url = "https://graph.instagram.com/me/media?fields=id,media_url,caption&access_token=$_accessToken";
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode != 200) {
      //throw GraphApiException(body['error']['message'].toString());
    }
    return PhotoPaging.fromJson(body);
  }
}
