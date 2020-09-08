abstract class AuthenticationEvents {}

class AuthenticateUser extends AuthenticationEvents{}

class LoginUser extends AuthenticationEvents{
  final String userPhoneNumber ;
  final String userPassword ;
  final bool vendorLogin ;
  LoginUser({this.userPhoneNumber , this.userPassword, this.vendorLogin});
}

class Logout extends AuthenticationEvents{}

class ReloadUser extends AuthenticationEvents{}

class ForgetPassword extends AuthenticationEvents{
  final String phoneNumber;
  ForgetPassword({this.phoneNumber});
}

class ResendNewPassword extends AuthenticationEvents{
  final String phoneNumber;
  ResendNewPassword({this.phoneNumber});
}

class ResetPassword extends AuthenticationEvents {
  final String phoneNumber, verificationCode, newPassword, confirmNewPassword;

  ResetPassword({
    this.phoneNumber,
    this.verificationCode,
    this.newPassword,
    this.confirmNewPassword,
  });
}

class VerifyPhoneNumber extends AuthenticationEvents {
  final String authenticationCode ;
  final String phoneNumber ;
  VerifyPhoneNumber({this.authenticationCode,this.phoneNumber});
}