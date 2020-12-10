import 'package:bloc/bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';

class UserBloc extends Bloc<UserBlocEvents , UserBlocStates>{
  UserBloc(UserBlocStates initialState , AuthenticationBloc authenticationBloc) : super(initialState){
    authenticationBloc.listen((authenticationState) {
      if(authenticationState is UserAuthenticated){
        currentLoggedInUser = authenticationState.currentUser;
        add(LoadUserOrders());
        return ;
      }
    });
  }


  UserViewModel currentLoggedInUser = UserViewModel.fromAnonymous();
  List<OrderModel> userActiveOrders = List<OrderModel>() ,
      userSavedOrders = List<OrderModel>(),
      userCompletedOrders = List<OrderModel>()  ,
      userCart = List<OrderModel>();




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
    }
    else if(event is VerifyPhoneNumber){
    yield* _handleVerifyPhoneNumber(event);
    return ;
    }
    else if(event is ResetPassword){
    yield* _handleResetPassword(event);
    return ;
    }
    else if(event is LoadUserOrders){
     yield* _handleLoadingUserOrders(event);
      return ;
    }
    else if(event is SaveAddress){
      yield* _handleAddressAdditionEvent(event);
      return ;
    }
    else if(event is UpdateUserProfile){
      yield* _handleProfileImageUpdate(event);
      return;
    }
    else if(event is UpdateUserInformation){
      yield* _handleUserInformationUpdate(event);
      return ;
    }
    else if(event is DeleteAddress){
      yield* _handleAddressDeletionEvent(event);
      return;
    }
    else if(event is UpdateAddress){
      yield* _handleAddressUpdate(event);
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
      Repository.getUserCart(),
    ]);

    // active orders listing
    if(userOrders[0].isSuccess){
      userActiveOrders = List<OrderModel>();
      userActiveOrders.addAll(userOrders[0].responseData);
    } else {
      userCompletedOrders = List<OrderModel>();
    }

    // closed orders listing
    if(userOrders[1].isSuccess){
      userCompletedOrders = List<OrderModel>();
      userCompletedOrders.addAll(userOrders[1].responseData);
    } else {
      userCompletedOrders = List<OrderModel>();
    }

    // saved orders listing
    if(userOrders[2].isSuccess){
      userSavedOrders = List<OrderModel>();
      userSavedOrders.addAll(userOrders[2].responseData);
    } else {
      userSavedOrders = List<OrderModel>();
    }

    // User Cart listing
    if(userOrders[3].isSuccess){
      userCart = List<OrderModel>();
      userCart.addAll(userOrders[3].responseData);
    } else {
      userCart = List<OrderModel>();
    }

    yield UserDataLoadedState();
    return ;
  }

  Stream<UserBlocStates> _handleAddressAdditionEvent(SaveAddress event) async*{
    yield UserDataLoadingState();
    ResponseViewModel<AddressViewModel> saveAddressResponse = await Repository.saveNewAddress(newAddress : event.address);
    if(saveAddressResponse.isSuccess){
      currentLoggedInUser.userSavedAddresses.add(saveAddressResponse.responseData);
      yield UserAddressSavedSuccessfully();
      return;
    } else {
      yield UserAddressSavingFailedState(failedEvent: event , error: saveAddressResponse.errorViewModel);
      return;
    }
  }

  Stream<UserBlocStates> _handleProfileImageUpdate(UpdateUserProfile event) async*{
    yield UserDataLoadingState();
    ResponseViewModel<UserViewModel> uploadImageResponse = await Repository.updateProfileImage(imageLink: event.imageLink);
    if(uploadImageResponse.isSuccess){
      await Repository.saveUser(uploadImageResponse.responseData);
      currentLoggedInUser = uploadImageResponse.responseData;
      yield UserDataLoadedState();
      return ;
    } else {
      yield UserProfileImageUpdatingFailed(error: uploadImageResponse.errorViewModel , failedEvent: event);

      return ;
    }

  }

  Stream<UserBlocStates> _handleUserInformationUpdate(UpdateUserInformation event) async*{
    yield UserDataLoadingState();
    ResponseViewModel<UserViewModel> updateUserInformationResponse = await Repository.updateUserProfile(updatedUser: event.userViewModel , oldPassword: event.oldPassword , newPassword : event.newPassword);
    if(updateUserInformationResponse.isSuccess){
      currentLoggedInUser = updateUserInformationResponse.responseData;
      await Repository.saveUser(currentLoggedInUser);
      if(event.newPassword != null) await Repository.saveEncryptedPassword(event.newPassword);
      yield UserDataLoadedState();
      return;
    } else {
      yield UserInformationUpdateFailedState(failedEvent: event , error: updateUserInformationResponse.errorViewModel);
      return;
    }
  }

  Stream<UserBlocStates> _handleAddressDeletionEvent(DeleteAddress event) async*{
    yield UserDataLoadingState();
    ResponseViewModel<bool> saveAddressResponse = await Repository.deleteAddress(address : event.address);
    if(saveAddressResponse.isSuccess){
      currentLoggedInUser.userSavedAddresses.remove(event.address);
      yield UserAddressSavedSuccessfully();
      return;
    } else {
      yield UserAddressSavingFailedState(failedEvent: event , error: saveAddressResponse.errorViewModel);
      return;
    }

  }

  Stream<UserBlocStates> _handleAddressUpdate(UpdateAddress event) async* {
    yield UserDataLoadingState();
    ResponseViewModel<AddressViewModel> saveAddressResponse = await Repository.updateUserAddress(newAddress : event.address);
    if(saveAddressResponse.isSuccess){
      currentLoggedInUser.userSavedAddresses.remove(saveAddressResponse.responseData);
      currentLoggedInUser.userSavedAddresses.add(saveAddressResponse.responseData);

      yield UserAddressSavedSuccessfully();
      return;
    } else {
      yield UserAddressSavingFailedState(failedEvent: event , error: saveAddressResponse.errorViewModel);
      return;
    }
  }

}