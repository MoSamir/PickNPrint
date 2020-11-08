import 'package:picknprint/src/resources/Constants.dart';

class URL{
  static const String BASE_URL = "http://dawayerstudio.com/projects/pickandprint/public/api/"; // server

  static const String POST_REGISTER = "auth/register?locale=";
  static const String POST_LOGIN = "auth/login?locale=";
  static const String GET_LOGOUT = "auth/logout?locale=";
  static const String POST_SAVE_NEW_ADDRESS = "saveAddress";
  static const String GET_RETRIEVE_SUPPORTED_CITIES = "cities?locale=";

  static String getURL({String apiPath}) {
    if(apiPath.endsWith('locale=')){
      return '$BASE_URL$apiPath${Constants.CURRENT_LOCALE}';
    } else {
      return BASE_URL + apiPath;
    }
  }


}