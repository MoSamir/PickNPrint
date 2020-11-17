import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/utilities/ParserHelpers.dart';

class AddressViewModel {
  String id ;
  LocationModel city , area ;
  String addressName , buildingNumber , additionalInformation;
  double deliveryFees ;
  AddressViewModel({this.city , this.id ,this.additionalInformation , this.addressName , this.area , this.buildingNumber , this.deliveryFees});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressViewModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '${city.name} , ${area.name} , $buildingNumber $addressName';
  }

  static fromJson(Map<String,dynamic> newAddressResponse) {
    AddressViewModel  address = AddressViewModel(
      deliveryFees: ParserHelper.parseDouble(newAddressResponse[ApiParseKeys.ADDRESSES_SHIPPING_FEES].toString()),
      city: LocationModel.fromJson(newAddressResponse[ApiParseKeys.ADDRESS_CITY]),
      area: LocationModel.fromJson(newAddressResponse[ApiParseKeys.ADDRESS_AREA]),
      id:  (newAddressResponse[ApiParseKeys.ADDRESS_ID] ?? '').toString(),
      addressName: (newAddressResponse[ApiParseKeys.ADDRESS_NAME] ?? '').toString(),
      additionalInformation: (newAddressResponse[ApiParseKeys.ADDRESS_REMARKS] ?? '').toString(),
      buildingNumber: (newAddressResponse[ApiParseKeys.ADDRESS_BUILDING_NO] ?? '').toString(),
    );
    return address;
  }

  static List<AddressViewModel> fromListJson(List<dynamic> addressesJson) {
    List<AddressViewModel> userAddresses = List<AddressViewModel>();
    if(addressesJson != null && addressesJson is List){
      for(int i = 0 ; i  < addressesJson.length ; i ++){
        userAddresses.add(fromJson(addressesJson[i]));
      }
    }
    return userAddresses;
  }


}

class LocationModel {
  int id ;
  String name ;
  List<LocationModel> childLocations ;
  LocationModel({this.id, this.name , this.childLocations});




  static LocationModel fromJson(Map<String,dynamic> cityJson){
    List<LocationModel> cityAreas = List<LocationModel>();
    if(cityJson.containsKey(ApiParseKeys.AREAS_KEY)){
      cityAreas = fromListJson(cityJson[ApiParseKeys.AREAS_KEY]);
    }
    return LocationModel(
      childLocations: cityAreas,
      id: cityJson[ApiParseKeys.LOCATION_ID] ?? 0,
      name: cityJson[ApiParseKeys.LOCATION_NAME] ?? '',
    );
  }


  static List<LocationModel> fromListJson(List<dynamic> locationsListJson) {
    List<LocationModel> citiesList = List<LocationModel>();
    for(int i = 0 ; i < locationsListJson.length ; i++){
      citiesList.add(fromJson(locationsListJson[i]));
    }
    return citiesList;
  }





}