
import 'package:picknprint/src/resources/facebookImagePicker/model/pagination.dart';

import 'album.dart';

class AlbumPaging {
  List<Album> data;
  Pagination pagination;

  AlbumPaging.fromJson(Map json)
      : data = (json['data'] as List)
            .map((album) => Album.fromJson(album))
            .toList(),
        pagination = Pagination.fromJson(json['paging']);
}
