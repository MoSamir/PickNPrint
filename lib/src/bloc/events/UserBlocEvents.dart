import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';

abstract class UserBlocEvents {}

class AddItemsToCart extends UserBlocEvents{}
class RemoveItemsFromCart extends UserBlocEvents {}
class LoadUserInformation extends UserBlocEvents {}
class LoadUserOrders extends UserBlocEvents{}

class SaveAddress extends UserBlocEvents {
  final AddressViewModel address;
  SaveAddress({this.address});
}
class LoadUserAddresses extends UserBlocEvents{}

class DeleteAddress extends UserBlocEvents {
  final AddressViewModel address;
  DeleteAddress({this.address});
}
class UpdateAddress extends UserBlocEvents {
  final AddressViewModel address;
  UpdateAddress({this.address});
}

class UpdateUserInformation extends UserBlocEvents {

  final UserViewModel userViewModel ;
  final  String oldPassword, newPassword ;
  UpdateUserInformation({this.userViewModel , this.oldPassword , this.newPassword});



}


class MoveToState extends UserBlocEvents{
  final UserBlocStates targetUserState ;
  MoveToState({this.targetUserState});

}


class ReloadUser extends UserBlocEvents{}

class ForgetPassword extends UserBlocEvents{
  final String phoneNumber;
  ForgetPassword({this.phoneNumber});
}

class ResendNewPassword extends UserBlocEvents{
  final String phoneNumber;
  ResendNewPassword({this.phoneNumber});
}

class ResetPassword extends UserBlocEvents {
  final String phoneNumber, verificationCode, newPassword, confirmNewPassword;

  ResetPassword({
    this.phoneNumber,
    this.verificationCode,
    this.newPassword,
    this.confirmNewPassword,
  });
}

class VerifyPhoneNumber extends UserBlocEvents {
  final String authenticationCode ;
  final String phoneNumber ;
  VerifyPhoneNumber({this.authenticationCode,this.phoneNumber});
}

class UpdateUserProfile extends UserBlocEvents {
  final String imageLink;
  UpdateUserProfile({this.imageLink});


}