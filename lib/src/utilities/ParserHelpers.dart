
import 'package:picknprint/src/data_providers/apis/helpers/URL.dart';

class ParserHelper {
  static String parseURL(String url){
    if(url == null) return "";
    if(url.contains("https") || url.contains("http") || url.contains('https://cdn.filestackcontent.com')) return url ;
    return URL.BASE_URL.replaceAll('api/', '') + "/" + url;
  }
  static double parseDouble(String number){
    if(number == null || number == "null" || number.isEmpty) return 0.0;
    if(number.contains('.')) return double.tryParse(number) ?? 0.0;
    return (int.tryParse(number) ?? 0.0) * 1.0;
  }
  static int parseNumber(String number){
    if(number == null || number.toLowerCase() == "null") return 0;
    try{
      return int.tryParse(number);
    } catch(_){
      return 0;
    }
  }

}