
import 'package:picknprint/src/resources/facebookImagePicker/model/pagination.dart';

import '../flutter_facebook_image_picker.dart';

class PhotoPaging {
  List<Photo> data;
  Pagination pagination;

  PhotoPaging.fromJson(Map json)
      : data = (json['data'] as List)
            .map((photo) => Photo.fromJson(photo))
            .toList(),
        pagination = Pagination.fromJson(json['paging']);
}
