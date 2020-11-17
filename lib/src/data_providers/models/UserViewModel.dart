import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
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


    Map<String,dynamic> userJson = Map<String,dynamic>();
    Map<String,dynamic> userDataMap = Map<String,dynamic>();

    userDataMap.putIfAbsent(ApiParseKeys.REGISTER_USER_ID, () => userId);
    userDataMap.putIfAbsent(ApiParseKeys.REGISTER_USER_NAME, () => userName);
    userDataMap.putIfAbsent(ApiParseKeys.REGISTER_USER_PHONE_NUMBER, () => userPhoneNumber);
    userDataMap.putIfAbsent(ApiParseKeys.REGISTER_USER_EMAIL, () => userMail);
    userDataMap.putIfAbsent(ApiParseKeys.REGISTER_USER_IMAGE, () => userProfileImage);
    userJson.putIfAbsent(ApiParseKeys.REGISTER_USER_DATA, () => userDataMap);
    userJson.putIfAbsent(ApiParseKeys.REGISTER_USER_TOKEN, () => userToken);

    return userJson;

  }

  static UserViewModel fromJson(userJson) {

    String userTokenInformation = userJson[ApiParseKeys.REGISTER_USER_TOKEN];
    Map<String,dynamic> userDataInformation = userJson[ApiParseKeys.REGISTER_USER_DATA];
    return UserViewModel(
      userId: userDataInformation[ApiParseKeys.REGISTER_USER_ID] ?? '',
      userName:userDataInformation[ApiParseKeys.REGISTER_USER_NAME] ,
      userPhoneNumber: userDataInformation[ApiParseKeys.REGISTER_USER_PHONE_NUMBER] ?? '',
      userMail: userDataInformation[ApiParseKeys.REGISTER_USER_EMAIL] ?? '',
      userToken: userTokenInformation ?? '',
      userProfileImage: userDataInformation[ApiParseKeys.REGISTER_USER_IMAGE] ?? '',
      userSavedAddresses: List<AddressViewModel>(),
    );
  }

  @override
  String toString() {
    return 'UserViewModel{userId: $userId, userName: $userName, userMail: $userMail, userPhoneNumber: $userPhoneNumber, userProfileImage: $userProfileImage}';
  }
}