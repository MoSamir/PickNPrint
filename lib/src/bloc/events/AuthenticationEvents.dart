abstract class AuthenticationEvents {}

class AuthenticateUser extends AuthenticationEvents{}

class LoginUser extends AuthenticationEvents{
  final String userEmail ;
  final String userPassword ;
  LoginUser({this.userEmail , this.userPassword});
}

class Logout extends AuthenticationEvents{}

