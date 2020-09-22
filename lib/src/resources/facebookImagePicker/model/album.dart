import 'dart:convert';

class Album {
  final String id;
  final int count;
  final String name;
  final String coverPhoto;

  Album(
    this.id,
    this.count,
    this.name,
    this.coverPhoto,
  );

  static Album fromJson(Map jsonAlbum){



    String albumCover = '';
    try{
      albumCover = jsonAlbum['cover_photo']['source'];
    } catch(exception){}

    return Album(
        jsonAlbum['id'],
        jsonAlbum['count'],
        jsonAlbum['name'],
        albumCover
    );
  }

}
