import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'graph_api_exception.dart';
import 'model/album.dart';
import 'model/album_paging.dart';
import 'model/photo_paging.dart';

class GraphApi {
  static const String _graphApiEndpoint = 'https://graph.facebook.com/v3.1';

  final String _accessToken;

  GraphApi(this._accessToken);

  Future<AlbumPaging> fetchAlbums([String nextUrl]) async {
    String url = nextUrl ??
        '$_graphApiEndpoint/me/albums?fields=cover_photo{source},id,name,count&format=json';
    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer $_accessToken'});
    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode != 200) {
      throw GraphApiException(body['error']['message'].toString());
    }

    return AlbumPaging.fromJson(body);
  }

  Future<PhotoPaging> fetchPhotos(Album album, [String nextUrl]) async {
    String url = nextUrl ??
        '$_graphApiEndpoint/${album.id}/photos?fields=id,name,width,height,photo,source&format=json';
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $_accessToken',
    });
    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode != 200) {
      throw GraphApiException(body['error']['message'].toString());
    }

    return PhotoPaging.fromJson(body);
  }
}
