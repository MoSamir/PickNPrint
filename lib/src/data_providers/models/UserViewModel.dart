class UserViewModel {

  var userId , userName , userMail , userPhoneNumber , userToken , userProfileImage;



  UserViewModel({this.userId, this.userName, this.userMail, this.userPhoneNumber , this.userProfileImage ,this.userToken});

  static UserViewModel fromAnonymous(){
    return UserViewModel(
      userId: -1,
    );
  }


   bool isAnonymous(){
    return userId == -1;
  }

  Map<String,dynamic> toJson() {
    return {};
  }

  static UserViewModel fromJson(decode) {
    return UserViewModel.fromAnonymous();
  }





}