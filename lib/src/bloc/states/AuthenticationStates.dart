import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';

abstract class AuthenticationStates {}

class AuthenticationInitiated extends AuthenticationStates {}

class UserAuthenticated extends AuthenticationStates {
  final UserViewModel currentUser;

  UserAuthenticated({this.currentUser});
}

class AuthenticationLoading extends AuthenticationStates {}

class AuthenticationFailed extends AuthenticationStates {
  final AuthenticationEvents failedEvent;

  final ErrorViewModel error;

  AuthenticationFailed({this.error, this.failedEvent});
}

