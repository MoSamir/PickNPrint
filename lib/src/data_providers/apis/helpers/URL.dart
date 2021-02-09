import 'package:picknprint/src/resources/Constants.dart';

class URL{

  static const String SERVER_LINK = "http://dawayerstudio.com";

  static const String BASE_URL = "$SERVER_LINK/projects/pickandprint/public/api/"; // server
  static const String POST_REGISTER = "auth/register?locale=";
  static const String GET_RETRIEVE_SYSTEM_INFO = "getSystemSettings";
  static const String POST_LOGIN = "auth/login?locale=";
  static const String GET_LOGOUT = "auth/logout?locale=";
  static const String POST_SAVE_NEW_ADDRESS = "saveAddress";
  static const String GET_RETRIEVE_SUPPORTED_CITIES = "cities?locale=";
  static const String GET_RETRIEVE_USER_ADDRESSES = "getAllUserAddresses?locale=";
  static const String UPLOAD_UPDATE_PROFILE_IMAGE = "user/uploadUserImage?locale=";
  static const String PUT_UPDATE_USER_PROFILE = "user/edit?locale=";
  static const String GET_RETRIEVE_SYSTEM_PACKAGES = "getAllFramePackages";
  static const String POST_ADD_ORDER_TO_CART = "cart/addItemToCart";
  static const String GET_RETRIEVE_USER_CART = "cart/getCart";

  static const String POST_SAVE_ORDER_FOR_LATER = "order/saveOrder";
  static const String POST_CREATE_ORDER = "order/createOrder";
  static const String POST_CREATE_SAVED_ORDER = "order/placeSavedOrder";
  static const String POST_UPLOAD_IMAGE = "uploadImage";


  static const String GET_RETRIEVE_ACTIVE_ORDERS = "order/getCurrentOrders";
  static const String GET_RETRIEVE_SAVED_ORDERS = "order/getUnCompletedOrders";
  static const String GET_RETRIEVE_PAST_ORDERS = "order/getPreviousOrders";

  static const String GET_DELETE_ADDRESS_BY_ID = "deleteAddressById/";
  static const String PUT_EDIT_USER_ADDRESS = "editAddress?locale=";

  static const String GET_APPLICATION_TESTIMONIALS = "getAllTestimonials";



  static String getURL({String apiPath}) {
    if(apiPath.endsWith('locale=')){
      return '$BASE_URL$apiPath${Constants.appLocale}';
    } else {
      return BASE_URL + apiPath;
    }
  }

  static String getFileStackImageURL(String imageHandle) {
    return "https://cdn.filestackcontent.com/" + imageHandle + "?policy="  + Constants.FILE_STACK_ENCODE_POLICY +
    "&signature=" + Constants.FILE_STACK_SIGNATURE;

  }


}