import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';

class UserBloc extends Bloc<UserBlocEvents , UserBlocStates>{
  UserBloc(UserBlocStates initialState) : super(initialState);

  @override
  Stream<UserBlocStates> mapEventToState(UserBlocEvents event) async*{}
}