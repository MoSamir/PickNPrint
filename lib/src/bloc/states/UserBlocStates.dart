import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';

abstract class UserBlocStates{}


class UserDataLoadingState extends UserBlocStates{}
class UserDataLoadedState extends UserBlocStates{}

class UserDataLoadingFailedState extends UserBlocStates{

  final UserBlocEvents failureEvent ;
  final ErrorViewModel error ;
  UserDataLoadingFailedState({this.failureEvent , this.error});


}




