import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';

abstract class UserBlocStates{}


class UserDataLoadingState extends UserBlocStates{}
class UserDataLoadedState extends UserBlocStates{}
class UserDataLoadingFailedState extends UserBlocStates{

  final UserBlocEvents failedEvent ;
  final ErrorViewModel error ;
  UserDataLoadingFailedState({this.failedEvent , this.error});


}


class WaitingNewPassword extends UserBlocStates {
  final String phoneNumber;

  WaitingNewPassword({this.phoneNumber});
}

class PhoneVerificationSuccess extends UserBlocStates {
  final String verificationCode;

  PhoneVerificationSuccess({this.verificationCode});
}

class ResetPasswordSuccess extends UserBlocStates {}


