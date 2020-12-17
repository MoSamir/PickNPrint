
import 'cursors.dart';

class Pagination {
  final Cursors cursor;
  final String next;

  Pagination(
    this.cursor,
    this.next,
  );

  static Pagination fromJson(Map json){
    if(json == null) return null ;
    return Pagination(json['cursors'], json['next']);
  }
}
