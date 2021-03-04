import 'package:bloc/bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/data_providers/apis/UserDataProvider.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
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
      yield* _checkIfUserLoggedIn();
      return;
    }
    else if(event is LoginUser){
      yield* _loginUser(event.userEmail , event.userPassword , event);
      return ;
    }
    else if(event is Logout){
      yield* _logoutUser(event);
      return;
    }

  }

  Stream<AuthenticationStates> _checkIfUserLoggedIn() async*{
    yield AuthenticationLoading();
    UserViewModel loggedInUser = await Repository.getUser();
    currentUser = loggedInUser;

    if(loggedInUser.isAnonymous() == false){
      ResponseViewModel<List<AddressViewModel>> userAddresses = await Repository.getUserAddresses();
      if(userAddresses.isSuccess){
        if(currentUser.userSavedAddresses != null) {
          currentUser.userSavedAddresses.clear();
          currentUser.userSavedAddresses.addAll(userAddresses.responseData);
        }
      }
    }
    yield UserAuthenticated(currentUser: currentUser);
    return ;
  }


  Stream<AuthenticationStates> _loginUser(String userPhoneNumber, String userPassword ,LoginUser event) async*{
    yield AuthenticationLoading();
    if(currentUser != null ){
      await Repository.signOut();
    }

    ResponseViewModel<UserViewModel> apiResponse;


    if(event.loginMethod == LoginMethod.FACEBOOK){
      apiResponse = await handleFacebookLogin(event);
    } else if(event.loginMethod == LoginMethod.MAIL){
       apiResponse = await handleServerLogin(event);
    }

    if(apiResponse.isSuccess){
      List<ResponseViewModel> userInformationData = await Future.wait([
      Repository.saveUser(apiResponse.responseData),
      Repository.saveEncryptedPassword(userPassword ?? ''),
      ]);

      currentUser = apiResponse.responseData ;
      ResponseViewModel<List<AddressViewModel>> userAddresses = await Repository.getUserAddresses();
      if(userAddresses.isSuccess){
        currentUser.userSavedAddresses.clear();
        currentUser.userSavedAddresses.addAll(userAddresses.responseData);
      }

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

  Future<ResponseViewModel> handleServerLogin(LoginUser event) async{
    return await Repository.signIn(userMail: event.userEmail , userPassword: event.userPassword);
  }

  Future<ResponseViewModel> handleFacebookLogin(LoginUser event) async {
    ResponseViewModel<UserViewModel> facebookUserResult = await UserDataProvider.signInWithFacebook();
    if(facebookUserResult.isSuccess){
      ResponseViewModel<UserViewModel> userLoginTryResponse = await Repository.signIn(userMail: facebookUserResult.responseData.userMail , userPassword: facebookUserResult.responseData.userId);
      if(userLoginTryResponse.isSuccess){
        return userLoginTryResponse;
      } else {
        ResponseViewModel<UserViewModel> userRegisterResponse = await UserDataProvider.registerNewUser(facebookUserResult.responseData, facebookUserResult.responseData.userId , true);
        return userRegisterResponse;
      }
    }
    else {
      return facebookUserResult;
    }




  }

}

