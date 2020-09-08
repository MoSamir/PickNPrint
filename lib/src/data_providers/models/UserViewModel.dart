class UserViewModel {

  var userId , userName , userMail , userPhoneNumber , userToken;


  UserViewModel({this.userId, this.userName, this.userMail, this.userPhoneNumber , this.userToken});

  static UserViewModel fromAnonymous(){
    return UserViewModel(
      userId: -1,
    );
  }


  static bool isAnonymous(UserViewModel user){
    return user.userId == -1;
  }

  Map<String,dynamic> toJson() {
    return {};
  }

  static UserViewModel fromJson(decode) {
    return UserViewModel.fromAnonymous();
  }





}