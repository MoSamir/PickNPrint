import 'package:bloc/bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';

class UserBloc extends Bloc<UserBlocEvents , UserBlocStates>{
  UserBloc(UserBlocStates initialState , AuthenticationBloc authenticationBloc) : super(initialState){

    authenticationBloc.listen((authenticationState) {
      if(authenticationState is UserAuthenticated){
        currentLoggedInUser = authenticationState.currentUser;
        //add(MoveToState(targetUserState: UserDataLoadedState()));
        add(LoadUserOrders());
        return ;
      }
    });
  }


  UserViewModel currentLoggedInUser = UserViewModel.fromAnonymous();
  List<OrderModel> userActiveOrders = List<OrderModel>() ,
      userSavedOrders = List<OrderModel>(),
      userCompletedOrders = List<OrderModel>() ;



  @override
  Stream<UserBlocStates> mapEventToState(UserBlocEvents event) async*{

    if(event is MoveToState){
      yield event.targetUserState;
      return;
    }
    else if(event is ReloadUser){
    _handleUserReloading(event);
    return ;
    }
    else if(event is ForgetPassword){
    yield* _handleForgetPassword(event);
    return ;
    } else if(event is VerifyPhoneNumber){
    yield* _handleVerifyPhoneNumber(event);
    return ;
    } else if(event is ResetPassword){
    yield* _handleResetPassword(event);
    return ;
    } else if(event is LoadUserOrders){
     yield* _handleLoadingUserOrders(event);
      return ;
    }

  }





  Stream<UserBlocStates> _handleForgetPassword(ForgetPassword event) async*{
    yield UserDataLoadingState();
    ResponseViewModel<bool> responseViewModel = await Repository.resendCodeForPhone(phoneNumber: event.phoneNumber);
    this.currentLoggedInUser.userPhoneNumber = event.phoneNumber;
    if(responseViewModel.isSuccess){
      yield WaitingNewPassword(phoneNumber: event.phoneNumber);
      return ;
    } else {
      yield UserDataLoadingFailedState(error: responseViewModel.errorViewModel , failedEvent: event);
      return ;
    }
  }

  Stream<UserBlocStates> _handleVerifyPhoneNumber(
      VerifyPhoneNumber event) async* {
    yield UserDataLoadingState();
    ResponseViewModel<bool> responseViewModel = await Repository.verifyUser(
        verificationCode: event.authenticationCode,
        userPhoneNumber: event.phoneNumber);

    if (responseViewModel.isSuccess) {
      yield PhoneVerificationSuccess(
          verificationCode: event.authenticationCode);
      return;
    } else {
      yield UserDataLoadingFailedState(
          error: responseViewModel.errorViewModel, failedEvent: event);
      return;
    }
  }

  Stream<UserBlocStates> _handleResetPassword(
      ResetPassword event) async* {
    yield UserDataLoadingState();
    ResponseViewModel<bool> responseViewModel = await Repository.resetPassword(
        phoneNumber: event.phoneNumber ,
        verificationCode: event.verificationCode,
        password: event.newPassword,
        confirmPassword: event.confirmNewPassword);

    if (responseViewModel.isSuccess) {
      yield ResetPasswordSuccess();
      return;
    } else {
      yield UserDataLoadingFailedState(
          error: responseViewModel.errorViewModel, failedEvent: event);
      return;
    }
  }

  void _handleUserReloading(ReloadUser event) async{
    UserViewModel loginResponse = await Repository.makeSilentLogin();
    if(loginResponse != null) {
      this.currentLoggedInUser = loginResponse;
    }
  }

  Stream<UserBlocStates> _handleLoadingUserOrders(LoadUserOrders event) async*{
    yield UserDataLoadingState();

    List<ResponseViewModel<List<OrderModel>>> userOrders = await Future.wait([
      Repository.loadActiveOrders(),
      Repository.loadClosedOrders(),
      Repository.loadSavedOrders(),
    ]);

    // active orders listing
    if(userOrders[0].isSuccess){
      userActiveOrders = List<OrderModel>();
      userActiveOrders.addAll(userOrders[0].responseData);
    }

    // closed orders listing
    if(userOrders[1].isSuccess){
      userCompletedOrders = List<OrderModel>();
      userCompletedOrders.addAll(userOrders[1].responseData);
    }

    // saved orders listing
    if(userOrders[2].isSuccess){
      userSavedOrders = List<OrderModel>();
      userSavedOrders.addAll(userOrders[2].responseData);
    }



  }

}