import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/utilities/ParserHelpers.dart';

class PackageModel {

  int packageSize  , packageId;
  String packageIcon  , packageMainImage;
  double packagePrice , packageAfterDiscountPrice , packageSaving  , priceForExtraFrame;
  PackageModel({this.packagePrice , this.packageAfterDiscountPrice ,  this.packageIcon ,this.packageSaving , this.packageId , this.priceForExtraFrame , this.packageMainImage ,this.packageSize});


  @override
  String toString() {
    return 'PackageModel{packageSize: $packageSize, packageId: $packageId, packagePrice: $packagePrice, packageAfterDiscountPrice: $packageAfterDiscountPrice, packageSaving: $packageSaving, priceForExtraFrame: $priceForExtraFrame}';
  }
  static List<PackageModel> fromListJson(List<dynamic> packagesListJson ,  double frameAfterDiscount , double frameBeforeDiscount , int discountStartFrom){
    List<PackageModel> packagesList = List<PackageModel>();
    for(int i = 0 ; i <packagesListJson.length ; i++)
      packagesList.add(fromJson(packagesListJson[i] , frameAfterDiscount ?? 0.0 , frameBeforeDiscount ?? 0.0 , discountStartFrom ?? 0.0));
    return packagesList;
  }
  static PackageModel fromJson(Map<String,dynamic> packageJson , double frameAfterDiscount , double frameBeforeDiscount , int discountStartFrom) {

    int packageSize = int.parse(packageJson[ApiParseKeys.PACKAGE_SIZE_KEY].toString());

    double savePerFrame = frameBeforeDiscount - frameAfterDiscount;
    int framesWithDiscount = (packageSize - discountStartFrom);
    double packageSaving = savePerFrame * framesWithDiscount;
    double packageGrossPrice = packageSize * frameBeforeDiscount;
    double packageNetPrice = packageGrossPrice - packageSaving;




    return PackageModel(
      packageMainImage: ParserHelper.parseURL(packageJson[ApiParseKeys.PACKAGE_IMAGE]),
      packageIcon: ParserHelper.parseURL(packageJson[ApiParseKeys.PACKAGE_ICON]),
      packageId: int.parse(packageJson[ApiParseKeys.PACKAGE_ID].toString()),
      packageSize: int.parse(packageJson[ApiParseKeys.PACKAGE_SIZE_KEY].toString()),
      packageSaving: packageSaving,
      packagePrice: packageGrossPrice,
      packageAfterDiscountPrice: packageNetPrice,
      priceForExtraFrame: frameAfterDiscount,
    );
  }



}