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





}