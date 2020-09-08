import 'package:flutter_bloc/flutter_bloc.dart';
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
      yield* _loginUser(event.userPhoneNumber , event.userPassword , event);
      return ;
    }
    else if(event is Logout){
      yield AuthenticationLoading();
      yield* _logoutUser(event);
      return;
    }
    else if(event is ReloadUser){
      _handleUserReloading(event);
    }
    else if(event is ForgetPassword){
      yield* _handleForgetPassword(event);
      return ;
    } else if(event is VerifyPhoneNumber){
      yield* _handleVerifyPhoneNumber(event);

    } else if(event is ResetPassword){
      yield* _handleResetPassword(event);

    }
  }

  Stream<AuthenticationStates> _checkIfUserLoggedIn() async*{
    UserViewModel loggedInUser = await Repository.getUser();
    currentUser = loggedInUser;
    yield UserAuthenticated(currentUser: loggedInUser);
    return ;
  }
  Stream<AuthenticationStates> _loginUser(String userPhoneNumber, String userPassword ,LoginUser event) async*{
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
  Stream<AuthenticationStates> _handleForgetPassword(ForgetPassword event) async*{
    yield AuthenticationLoading();
    ResponseViewModel<bool> responseViewModel = await Repository.resendCodeForPhone(phoneNumber: event.phoneNumber);
    this.phoneNumber = event.phoneNumber;
    if(responseViewModel.isSuccess){
      yield WaitingNewPassword(phoneNumber: event.phoneNumber);
      return ;
    } else {
      yield AuthenticationFailed(error: responseViewModel.errorViewModel , failedEvent: event);
      return ;
    }
  }





  Stream<AuthenticationStates> _handleVerifyPhoneNumber(
      VerifyPhoneNumber event) async* {
    yield AuthenticationLoading();
    ResponseViewModel<bool> responseViewModel = await Repository.verifyUser(
        verificationCode: event.authenticationCode,
        userPhoneNumber: event.phoneNumber);

    if (responseViewModel.isSuccess) {
      yield PhoneVerificationSuccess(
          verificationCode: event.authenticationCode);
      return;
    } else {
      yield AuthenticationFailed(
          error: responseViewModel.errorViewModel, failedEvent: event);
      return;
    }
  }

  Stream<AuthenticationStates> _handleResetPassword(
      ResetPassword event) async* {
    yield AuthenticationLoading();
    ResponseViewModel<bool> responseViewModel = await Repository.resetPassword(
        phoneNumber: event.phoneNumber ,
        verificationCode: event.verificationCode,
        password: event.newPassword,
        confirmPassword: event.confirmNewPassword);

    if (responseViewModel.isSuccess) {
      yield ResetPasswordSuccess();
      return;
    } else {
      yield AuthenticationFailed(
          error: responseViewModel.errorViewModel, failedEvent: event);
      return;
    }
  }

  void _handleUserReloading(ReloadUser event) async{
    UserViewModel loginResponse = await Repository.makeSilentLogin();
    if(loginResponse != null) {
      this.currentUser = loginResponse;
    }
  }



}

