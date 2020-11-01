
import 'package:picknprint/src/data_providers/apis/helpers/URL.dart';

class ParserHelper {

  static String parseURL(String url){
    if(url == null) return "";
    if(url.contains(URL.BASE_URL)) return url ;
    return URL.BASE_URL + "/" + url;
  }

  static double parseDouble(String number){
    if(number == null) return 0.0;
    if(number.contains('.')) return double.tryParse(number) ?? 0.0;
    return (int.tryParse(number) ?? 0.0) * 1.0;
  }

}