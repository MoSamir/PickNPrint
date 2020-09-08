import 'package:picknprint/src/bloc/events/ApplicationDataEvents.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';

abstract class ApplicationDataStates {}

class ApplicationDataLoadingState extends ApplicationDataStates{}
class ApplicationDataLoadedState extends ApplicationDataStates{}
class ApplicationDataLoadingFailureState extends ApplicationDataStates{
  final ErrorViewModel error;
  final ApplicationDataEvents failureEvent ;
  ApplicationDataLoadingFailureState({this.error , this.failureEvent});


}
class MoveToState extends ApplicationDataStates{
  final ApplicationDataStates targetAppState ;
  MoveToState({this.targetAppState});

}