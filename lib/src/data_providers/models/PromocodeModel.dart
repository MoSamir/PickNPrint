import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/utilities/ParserHelpers.dart';

class PromoCodeModel {
  String promoCode ;
  double discount ;
  PromoCodeModel({this.discount , this.promoCode});
  static PromoCodeModel fromJson(Map<String, dynamic> promoCodeResponse, String promoText) {
    print("promoCodeResponse => $promoCodeResponse");

    return PromoCodeModel(
      discount: ParserHelper.parseDouble(promoCodeResponse[ApiParseKeys.DISCOUNT_AMOUNT].toString()),
      promoCode: promoText,
    );

  }

}