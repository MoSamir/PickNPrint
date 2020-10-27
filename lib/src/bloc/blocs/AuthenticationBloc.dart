import 'package:bloc/bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/data_providers/apis/UserDataProvider.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvents , AuthenticationStates>{
  AuthenticationBloc(AuthenticationStates initialState) : super(initialState);
  UserViewModel currentUser = UserViewModel.fromAnonymous();
  String phoneNumber ;


  @override
  Stream<AuthenticationStates> mapEventToState(AuthenticationEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();

    if(isUserConnected == false){
      yield AuthenticationFailed(
        failedEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
    if(event is AuthenticateUser){
      yield AuthenticationLoading();
      yield* _checkIfUserLoggedIn();
      return;
    }
    else if(event is LoginUser){
      yield AuthenticationLoading();
      yield* _loginUser(event.userEmail , event.userPassword , event);
      return ;
    }
    else if(event is Logout){
      yield AuthenticationLoading();
      yield* _logoutUser(event);
      return;
    }

  }

  Stream<AuthenticationStates> _checkIfUserLoggedIn() async*{
    yield AuthenticationLoading();

    UserViewModel loggedInUser = await Repository.getUser();
    currentUser = loggedInUser;
    yield UserAuthenticated(currentUser: loggedInUser);
    return ;
  }
  Stream<AuthenticationStates> _loginUser(String userPhoneNumber, String userPassword ,LoginUser event) async*{
    yield AuthenticationLoading();
    if(currentUser != null ){
      await Repository.signOut();
    }
    ResponseViewModel<UserViewModel> apiResponse = await Repository.signIn(userPhoneNumber:userPhoneNumber , userPassword:userPassword);
    if(apiResponse.isSuccess){
      await Repository.saveUser(apiResponse.responseData);
      await Repository.saveEncryptedPassword(userPassword);
      currentUser = apiResponse.responseData ;
      yield UserAuthenticated(currentUser: currentUser);
      return;
    } else {
      yield AuthenticationFailed(error: apiResponse.errorViewModel , failedEvent: event);
      return;
    }
  }
  Stream<AuthenticationStates> _logoutUser(event) async*{
    yield AuthenticationLoading();
    ResponseViewModel responseViewModel = await Repository.signOut();
    if(responseViewModel.isSuccess){
      currentUser = UserViewModel.fromAnonymous();
      await Repository.clearCache();
      yield UserAuthenticated(
          currentUser: UserViewModel.fromAnonymous());
    } else {
      yield AuthenticationFailed(failedEvent: event , error: responseViewModel.errorViewModel);
    }
  }

}

