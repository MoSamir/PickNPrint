class ApiParseKeys {

  static const String RESPONSE_SUCCESS_ROOT = "success";


  // ------------------------- REGISTER USER ---------------------------------


  static const String REGISTER_USER_TOKEN = "access_token";
  static const String REGISTER_USER_DATA = "user";
  static const String REGISTER_USER_ID = "id";
  static const String REGISTER_USER_NAME = "name";
  static const String REGISTER_USER_EMAIL = "email";
  static const String REGISTER_USER_PHONE_NUMBER = "phone";
  static const String REGISTER_USER_IMAGE = "image";


 //------------------------------ GET SYSTEM LOCATIONS ------------------------

  static const String SYSTEM_LOCATIONS_ROOT = "cities";
  static const String AREAS_KEY = "areas";
  static const String LOCATION_ID = "id";
  static const String LOCATION_NAME = "name";


 //------------------------- SAVE ADDRESS -------------------------------------
  static const String ADDRESS_ROOT_KEY = "address";
  static const String ADDRESS_CITY = "city";
  static const String ADDRESS_AREA = "area";
  static const String ADDRESS_ID = "id";
  static const String ADDRESS_NAME = "streetName";
  static const String ADDRESS_REMARKS = "remarks";
  static const String ADDRESS_BUILDING_NO = "buildingNumber";


  // ---------------------- GET USER ADDRESSES ----------------------------------
  static const String ADDRESSES_LIST_ROOT = "addresses";
  static const String ADDRESSES_SHIPPING_FEES = "shippingFees";



// ---------------------------- GET PACKAGES SIZE -----------------------------

  static const String PACKAGE_SIZE_KEY = "quantity";
  static const String PACKAGE_PRICE = "price";
  static const String PACKAGE_DISCOUNT_PERCENTAGE = "discountPercentage";
  static const String PACKAGE_ID = "id";
  static const String PACKAGE_FRAME_ROOT = "frame";
  static const String PACKAGE_LIST_ROOT = "framePackages";
  static const String PACKAGE_ICON = "icon";
  static const String PACKAGE_IMAGE = "image";

  static const String NORMAL_FRAME_PRICE = "framePrice";
  static const String EXTRA_FRAME_PRICE = "framePriceAfterDiscount";
  static const String DISCOUNT_AFTER_FRAME = "frameDiscountQty";




//---------------------------- GET CART ITEMS ---------------------------------

  static const String ORDER_ID = "id";
  static const String ORDER_KEY = "order";
  static const String ORDERS_KEY = "orders";
  static const String ORDER_PACKAGE_SIZE = "itemsQty";
  static const String ORDER_PACKAGE_PRICE = "packagePrice";
  static const String ORDER_TOTAL_PRICE = "totalPrice";
  static const String ORDER_SUBTOTAL = "subTotal";
  static const String ORDER_PACKAGE_DISCOUNT = "packageDiscountPercentage";
  static const String ORDER_PACKAGE_IMAGE = "packageImage";
  static const String ORDER_PACKAGE_ICON = "packageIcon";
  static const String ORDER_ADDITIONAL = "additionalFramesQty";
  static const String ORDER_EXTRA_FRAME_PRICE = "framePrice";
  static const String ORDER_WHITE_FRAME = "color";
  static const String ORDER_WITH_FRAME = "selection";
  static const String ORDER_USER_IMAGE = "image";
  static const String ORDER_SOCIAL_IMAGES = "imagesViaSocialMedia";
  static const String ORDER_CREATED_AT = "created_at";
  static const String ORDER_ITEMS_LIST_KEY = "items";
  static const String ORDER_CART_ROOT_KEY = "cart";
  static const String ORDER_ITEM_STATUS = "status";
  static const String ORDER_ITEM_STATUS_KEY = "key";



  static const String ORDER_CART_GROSS_PRICE = "totalPrice";
  static const String ORDER_CART_NET_PRICE = "subTotal";

  //------------------- GET SYSTEM CONTACT INFO ---------------------------

  static const String SYSTEM_SETTINGS_KEY = "settings";
  static const String SYSTEM_PHONE_KEY = "phone";

//- ------------------- GET TESTIMONIALS -----------------------------------

  static const String TESTIMONIAL_COMMENT_KEY = "comment";
  static const String TESTIMONIAL_IMAGE_KEY = "image";
  static const String TESTIMONIAL_ID_KEY = "id";
















}
