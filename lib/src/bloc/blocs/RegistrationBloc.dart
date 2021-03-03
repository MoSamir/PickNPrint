import 'package:bloc/bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/RegistrationEvents.dart';
import 'package:picknprint/src/bloc/states/RegistrationStates.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';

class RegistrationBloc extends Bloc<RegistrationEvents , RegistrationStates>{
  RegistrationBloc(RegistrationStates initialState) : super(initialState);

  UserViewModel userModel ;
  String password ;

  void setUser(UserViewModel userModel , String password){
    this.password = password;
    this.userModel = userModel ;
  }


  @override
  Stream<RegistrationStates> mapEventToState(RegistrationEvents event) async*{
    bool isConnected = await NetworkUtilities.isConnected();
    if(isConnected == false){
      yield RegistrationFailedState(error: Constants.CONNECTION_TIMEOUT, failureEvent: event);
      return ;
    }

    if(event is RegisterUser){
      yield* _handleUserRegistration(event);
      return ;
    }

  }

  Stream<RegistrationStates> _handleUserRegistration(RegisterUser event) async*{
    yield RegistrationLoadingState();
    ResponseViewModel<UserViewModel> responseViewModel = await Repository.registerNewUser(withSocialMedia: false , userModel: event.userModel , userPassword:event.password);
    if(responseViewModel.isSuccess){

      Repository.saveUser(responseViewModel.responseData);
      Repository.saveEncryptedPassword(event.password);
      userModel = responseViewModel.responseData;
      yield RegistrationSuccessState(userModel: userModel , userPassword: event.password);
      return ;
    } else {
      yield RegistrationFailedState(error: responseViewModel.errorViewModel , failureEvent: event);
      return ;
    }
  }

}