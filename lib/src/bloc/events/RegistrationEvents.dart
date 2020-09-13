import 'package:picknprint/src/data_providers/models/UserViewModel.dart';

abstract class RegistrationEvents {}



class RegisterUser extends RegistrationEvents{
  final UserViewModel userModel ;
  final String password ;
  RegisterUser({this.userModel , this.password});

}