import 'pagination.dart';
import 'photo.dart';

class PhotoPaging {
  List<Photo> data;
  Pagination pagination;

  PhotoPaging.fromJson(Map json){
    data = <Photo>[];

    try {
      (json['data'] as List).forEach((element) {
        data.add(Photo(100,100, element['media_url']));
      });
    } catch(exception){
      print("Exception Parsing Images $exception");
    }


    // if there are more than 20 photos
    pagination = Pagination.fromJson(json['paging']);
  }
//      : data = (json['data'][0]['images'] as Map)
//      .map((key, value) => Photo.fromJson(value))
//      .values.toList(),
        //pagination = Pagination.fromJson(json['paging']);
}
