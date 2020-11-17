import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/utilities/ParserHelpers.dart';

class PackageModel {

  int packageSize  , packageId;
  String packageIcon  , packageMainImage;
  double packagePrice , packageSaving  , priceForExtraFrame;
  PackageModel({this.packagePrice ,  this.packageIcon ,this.packageSaving , this.packageId , this.priceForExtraFrame , this.packageMainImage ,this.packageSize});



  static List<PackageModel> fromListJson(List<dynamic> packagesListJson){
    List<PackageModel> packagesList = List<PackageModel>();

    for(int i = 0 ; i <packagesListJson.length ; i++)
      packagesList.add(fromJson(packagesListJson[i]));
    return packagesList;
  }

  static PackageModel fromJson(Map<String,dynamic> packageJson) {
    return PackageModel(
      packageMainImage: packageJson[ApiParseKeys.PACKAGE_IMAGE],
      packageIcon: packageJson[ApiParseKeys.PACKAGE_ICON],
      packageId: int.parse(packageJson[ApiParseKeys.PACKAGE_ID].toString()),
      packageSize: int.parse(packageJson[ApiParseKeys.PACKAGE_SIZE_KEY].toString()),
      packageSaving: ParserHelper.parseDouble(packageJson[ApiParseKeys.PACKAGE_DISCOUNT_PERCENTAGE].toString()),
      packagePrice: ParserHelper.parseDouble(packageJson[ApiParseKeys.PACKAGE_PRICE].toString()),
      priceForExtraFrame: ParserHelper.parseDouble((packageJson[ApiParseKeys.PACKAGE_FRAME_ROOT][ApiParseKeys.PACKAGE_PRICE]).toString()),
    );
  }



}