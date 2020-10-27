import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';

class UserViewModel {

  var userId , userName , userMail , userPhoneNumber , userToken , userProfileImage;
  UserViewModel({this.userId, this.userName, this.userMail, this.userSavedAddresses , this.userPhoneNumber , this.userProfileImage ,this.userToken});
  List<AddressViewModel> userSavedAddresses ;






  static UserViewModel fromAnonymous(){
    return UserViewModel(
      userId: -1,
      userSavedAddresses: List<AddressViewModel>(),
    );
  }


   bool isAnonymous(){
    return userId == -1;
  }

  Map<String,dynamic> toJson() {
    return {
    "userId": userId,
    "userName": userName ,
    "userMail" : userMail  ,
    "userPhoneNumber": userPhoneNumber ,
    "userToken": userToken ,
    "userProfileImage": userProfileImage,
    };
  }

  static UserViewModel fromJson(userJson) {
    return UserViewModel(
      userId: userJson['userId'],
      userName: userJson['userName'],
      userPhoneNumber: userJson['userPhoneNumber'],
      userMail: userJson['userMail'],
      userToken: userJson['userToken'],
      userProfileImage: userJson['userProfileImage'],
      userSavedAddresses: List<AddressViewModel>(),
    );
  }
}