import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';

class AddressViewModel {
  LocationModel city , area ;
  String addressName , buildingNumber , additionalInformation;
  AddressViewModel({this.city , this.additionalInformation , this.addressName , this.area , this.buildingNumber});

  @override
  String toString() {
    return '${city.name} , ${area.name} , $buildingNumber $addressName';
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