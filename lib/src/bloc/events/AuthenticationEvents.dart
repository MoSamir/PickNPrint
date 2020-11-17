abstract class AuthenticationEvents {}

class AuthenticateUser extends AuthenticationEvents{}

class LoginUser extends AuthenticationEvents{
  final LoginMethod loginMethod ;
  final String userEmail ;
  final String userPassword ;
  LoginUser({this.userEmail , this.userPassword , this.loginMethod});
}

class Logout extends AuthenticationEvents{}

enum LoginMethod {MAIL , FACEBOOK}