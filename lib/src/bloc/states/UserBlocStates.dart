/// extending from state is dangerous operation and needs to be handled carefully

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


/// states to handle saving new address after user loading
class UserAddressSavedSuccessfully extends UserDataLoadedState{}
class UserAddressSavingFailedState extends UserDataLoadedState{
  final UserBlocEvents failedEvent ;
  final ErrorViewModel error ;
  UserAddressSavingFailedState({this.failedEvent , this.error});
}


/// states to handle the failure of updating user
class UserInformationUpdateFailedState extends UserDataLoadedState{
  final UserBlocEvents failedEvent ;
  final ErrorViewModel error ;
  UserInformationUpdateFailedState({this.failedEvent , this.error});
}


/// state to handle failure in updating Image

class UserProfileImageUpdatingFailed extends UserDataLoadedState{
  final UserBlocEvents failedEvent ;
  final ErrorViewModel error ;
  UserProfileImageUpdatingFailed({this.failedEvent , this.error});
}
