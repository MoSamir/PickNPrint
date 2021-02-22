
import 'dart:io';

import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';
class Constants {

  static final ErrorViewModel CONNECTION_TIMEOUT = ErrorViewModel(
    errorMessage: '',
    errorCode: HttpStatus.requestTimeout,
  );
  static const String SHARED_PREFERENCE_USER_TOKEN_KEY = "PICKNPRINT_PREF_pref";
  static const String SHARED_PREFERENCE_USER_KEY = "PRINT_NPRINT_USER_pref";
  static const String SHARED_PREFERENCE_USER_PASSWORD = "PRINT_NPRINT_PASSWORD_pref";
  static  String appLocale = "ar-EG/";
  static const String ENCRYPTION_KEY = "NMTqSkzCE64OtCFWfyy062Qhp469KO9RA6N2ucCsCYdkoWT1M3L6bT17vm1L3z+HOdIF6SKx4BCCf863DlXDn1VObrHdCRhip2/wg5ooagwrP2GVA6pfYRco2+DSIP0o";
  static const String SHARED_PREFERENCE_CROPPED_ORDER_KEY = "SHARED_PREFERENCE_CROPPED_ORDER_KEY";
  static const String SHARED_PREFERENCE_ORIGINAL_ORDER_KEY = "SHARED_PREFERENCE_ORIGINAL_ORDER_KEY";

  static const String FILE_STACK_API_KEY =  "AspW9mDCPREWfktPAU5O4z";


}
