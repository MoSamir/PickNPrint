
import 'package:picknprint/src/data_providers/apis/helpers/URL.dart';

class ParserHelper {

  static String parseURL(String url){

try{
  url.replaceFirst('[','');
  url.replaceFirst(']', '');
} catch(exception){}

try{



  url = url.split("\\").join("/");

  String tempURL = "";
  for(int i = 0 ; i <url.length ; i++){
    if(url[i] == '\\') tempURL+="/";
    else tempURL+=url[i];
  }
  url = tempURL;
} catch(exception){

}


    if(url == null) return url;
    if(url.contains(URL.BASE_URL)) return url ;
    return URL.BASE_URL + "/" + url;
  }

}