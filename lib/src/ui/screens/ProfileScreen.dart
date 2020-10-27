import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';

import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';

import '../BaseScreen.dart';
import 'AddressDeletionConfirmationScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isEditingModeOn = false ;

  TextEditingController _nameEditingController , _userEmailEditingController , _phoneNumberEditingController ;


  @override
  void initState() {
    super.initState();
    initProfileData();

  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: SingleChildScrollView(
        child: BlocConsumer(
          listener: (context , state){
            if (state is UserDataLoadingFailedState) {
              if (state.error.errorCode == HttpStatus.requestTimeout) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return NetworkErrorView();
                    });
              } else if (state.error.errorCode ==
                  HttpStatus.serviceUnavailable) {
                Fluttertoast.showToast(
                    msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                Fluttertoast.showToast(
                    msg: state.error.errorMessage ?? '',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
          },
          cubit: BlocProvider.of<UserBloc>(context),
          builder: (context , state){
            return ModalProgressHUD(
              inAsyncCall: state is UserDataLoadingState,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Center(
                      child: Container(
                        width: (100),
                        height: (100),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: .5,
                            color: AppColors.lightBlack,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: BlocProvider.of<UserBloc>(context).currentLoggedInUser.userProfileImage != null  &&
                                BlocProvider.of<UserBloc>(context).currentLoggedInUser.userProfileImage.length > 0
                                ? NetworkImage(BlocProvider.of<UserBloc>(context).currentLoggedInUser.userProfileImage)
                                : AssetImage(Resources.USER_PLACEHOLDER_IMG),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Center(
                      child: Text(
                        '${(LocalKeys.HELLO_LABEL).tr()} ${BlocProvider.of<UserBloc>(context).currentLoggedInUser.userName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: (){},
                        child: Text(
                          (LocalKeys.EDIT_PROFILE_IMAGE).tr(),
                          style: TextStyle(
                            color: AppColors.lightBlue,
                          ),
                        ),
                      ),
                    ),
                    getBasicInformationUpdateSection(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text((LocalKeys.MY_SAVED_ADDRESSES).tr() ,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                    getAddressBookSection(),
                    SizedBox(height: 5,),
                    getUpdateMyPasswordSection(),
                    SizedBox(height: 5,),
                    getLogoutSection(),
                    SizedBox(height: 5,),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      hasDrawer: true,
    );
  }

  Widget getBasicInformationUpdateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              (LocalKeys.MY_BASIC_DATA).tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),

            ),
            FlatButton(
              onPressed: (){
                setState(() {
                  isEditingModeOn = ! isEditingModeOn;
                });
              },
              padding: EdgeInsets.all(0),
              child: Text(
                isEditingModeOn ? (LocalKeys.SAVE_LABEL).tr() : (LocalKeys.EDIT_LABEL).tr(),
                style: TextStyle(
                  color: AppColors.lightBlue,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 50,

          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    //color: AppColors.offWhite,
                  ),

                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text((LocalKeys.USER_NAME_LABEL).tr(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.black,
                      ),),
                  ),
                ),
              ),
              Container(
                width: 2,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    //color: AppColors.offWhite,
                  ),

                  child: TextFormField(
                    validator: Validator.requiredField,
                    enabled: isEditingModeOn,
                    controller: _nameEditingController,
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      filled: isEditingModeOn,
                      fillColor: AppColors.offWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2,),
        Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    //color: AppColors.offWhite,
                  ),

                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text((LocalKeys.USER_EMAIL_LABEL).tr(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.black,
                      ),),
                  ),
                ),
              ),
              Container(
                width: 2,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    //color: AppColors.offWhite,
                  ),

                  child: TextFormField(
                    validator: Validator.mailValidator,
                    enabled: isEditingModeOn,
                    controller: _userEmailEditingController,
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      filled: isEditingModeOn,
                      fillColor: AppColors.offWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    //color: AppColors.offWhite,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text((LocalKeys.PHONE_NUMBER_LABEL).tr(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.black,
                      ),),
                  ),
                ),
              ),
              Container(
                width: 2,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    //color: AppColors.offWhite,
                  ),

                  child: TextFormField(
                    validator: Validator.phoneValidator,
                    enabled: isEditingModeOn,
                    controller: _phoneNumberEditingController,
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      filled: isEditingModeOn,
                      fillColor: AppColors.offWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getAddressBookSection() {

    List<AddressViewModel> userAddresses = BlocProvider.of<UserBloc>(context).currentLoggedInUser.userSavedAddresses;
    if(userAddresses.length > 0){
      return ListView.builder(itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(userAddresses[index].toString() , textAlign: TextAlign.start, maxLines: 3, softWrap: true,),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddressDeletionConfirmationScreen(addressModel: userAddresses[index],)));
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(0),
                        child: Center(child: Icon(Icons.delete , size: 15 ,color: AppColors.white,)),
                      ),
                    ),
                    SizedBox(width: 4,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(0),
                        child: Center(child: Icon(Icons.edit , size: 15 ,color: AppColors.white,)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } , itemCount: userAddresses.length, shrinkWrap: true, padding: EdgeInsets.all(0), physics: NeverScrollableScrollPhysics(),);
    } else {
      return Container(
        child: GestureDetector(
          onTap: (){},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: 200,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(child: Text((LocalKeys.ADD_NEW_ADDRESS).tr(), style: TextStyle(color: AppColors.white),)),
          ),
        ),
      );
    }

  }

  Widget getUpdateMyPasswordSection() {

    return GestureDetector(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: AppColors.offWhite,
          ),
          height: 50,
          child: Center(
            child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Text((LocalKeys.UPDATE_MY_PASSWORD).tr() , style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            Icon(Icons.more_horiz , color: AppColors.lightBlue,)
        ],
      ),
          )),
    );

  }


  Widget getLogoutSection() {
    return GestureDetector(
      onTap: (){},
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: AppColors.offWhite,
          ),
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text((LocalKeys.LOGOUT).tr() , style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                ImageIcon(AssetImage(Resources.LOGOUT_ICON), color: AppColors.lightBlue,)
              ],
            ),
          )),
    );

  }


  void initProfileData() {
    if(BlocProvider.of<UserBloc>(context).currentLoggedInUser.isAnonymous() == false) {
      _nameEditingController = TextEditingController(text: BlocProvider.of<UserBloc>(context).currentLoggedInUser.userName ?? '');
      _userEmailEditingController = TextEditingController(text: BlocProvider.of<UserBloc>(context).currentLoggedInUser.userMail ?? '');
      _phoneNumberEditingController = TextEditingController(text: BlocProvider.of<UserBloc>(context).currentLoggedInUser.userPhoneNumber ?? '');
    }
    else {
      _nameEditingController = TextEditingController();
      _userEmailEditingController = TextEditingController();
      _phoneNumberEditingController = TextEditingController();
    }
  }

}


