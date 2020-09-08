import 'package:picknprint/src/bloc/events/UserCartEvents.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';

abstract class UserCartStates {}

class UserCartLoaded extends UserCartStates {}
class UserCartLoading extends UserCartStates {}
class UserCartLoadingFailed extends UserCartStates{
  final ErrorViewModel error ;
  final UserCartEvents failedEvent;

  UserCartLoadingFailed({this.error, this.failedEvent});
}
class UserCartEventSuccess extends UserCartStates{}
