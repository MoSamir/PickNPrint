import 'package:picknprint/src/bloc/events/RegistrationEvents.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';

abstract class RegistrationStates {}

class RegistrationInitialState extends RegistrationStates{}
class RegistrationLoadingState extends RegistrationStates{}
class RegistrationSuccessState extends RegistrationStates{
  final UserViewModel userModel ;
  RegistrationSuccessState({this.userModel});
}
class RegistrationFailedState extends RegistrationStates{
  final RegistrationEvents failureEvent;
  final ErrorViewModel error;
  RegistrationFailedState({this.failureEvent , this.error});


}
