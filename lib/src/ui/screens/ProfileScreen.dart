import 'dart:io';
import 'package:picknprint/src/ui/screens/UpdatePasswordScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';

import 'package:picknprint/src/resources/Validators.dart';
import 'package:picknprint/src/ui/screens/AddNewShippingAddressScreen.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';
import 'package:picknprint/src/ui/screens/EditProfileScreen.dart';
import 'package:picknprint/src/ui/widgets/EnhancedImageNetwork.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';

import '../BaseScreen.dart';
import 'confirmation_screens/AddressDeletionConfirmationScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isEditingModeOn = false ;
  TextEditingController _nameEditingController , _userEmailEditingController , _phoneNumberEditingController ;
  File userImageFile ;


  @override
  void initState() {
    super.initState();
    initProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit : BlocProvider.of<AuthenticationBloc>(context),
      listener: (context, state){
        if(state is UserAuthenticated){
          if(state.currentUser.isAnonymous()){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);          }
        }
      },
      child: BlocConsumer(
        listener: (context , state){

          if(state is UserDataLoadingState){
            userImageFile = null ;
          }
          else if(state is UserProfileImageUpdatingFailed){
            isEditingModeOn = true ;
            UIHelpers.showToast(state.error.errorMessage ?? '', true, true);
            return;

          }
          else if (state is UserDataLoadingFailedState) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              UIHelpers.showNetworkError(context);
              return;
            }
            else if (state.error.errorCode == HttpStatus.serviceUnavailable) {
              UIHelpers.showToast((LocalKeys.SERVER_UNREACHABLE).tr(), true, true);
              return;
            }
            else {
              UIHelpers.showToast(state.error.errorMessage ?? '', true, true);
              return;
            }
          }
        },
        cubit: BlocProvider.of<UserBloc>(context),
        builder: (context , state){
          return ModalProgressHUD(
            progressIndicator: LoadingWidget(),
            inAsyncCall: state is UserDataLoadingState,
            child: BaseScreen(
              hasDrawer: false,



              customAppbar: PickNPrintAppbar(
                leadAction: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    if(Navigator.canPop(context)){
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
                    }
                  },
                ),
                appbarColor: AppColors.black,
                actions: [],
                centerTitle: true,
                title: (LocalKeys.MY_PROFILE).tr(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: .5,
                              color: AppColors.lightBlack,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: getUserImage(),
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
                        onTap: _editProfileImage,
                        child: Text(
                          isEditingModeOn ? (LocalKeys.SAVE_LABEL).tr() : (LocalKeys.EDIT_PROFILE_IMAGE).tr(),
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
            ),
          );
        },
      ),
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
              onPressed: _navigateToEditProfileScreen,
              padding: EdgeInsets.all(0),
              child: Text(
                (LocalKeys.EDIT_LABEL).tr(),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0 , vertical: 2),
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
                    enabled: false,
                    controller: _nameEditingController,
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      filled: false,
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
                    enabled: false,
                    controller: _userEmailEditingController,
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      filled: false,
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
                    enabled: false,
                    controller: _phoneNumberEditingController,
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      filled: false,
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
                      onTap: () async{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewShippingAddressScreen(addressModel: userAddresses[index],)));
                        setState(() {});
                      },
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
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewShippingAddressScreen(comingFromRegistration: false, )));
          },
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
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UpdatePasswordScreen()));
      },
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
      onTap: (){
        BlocProvider.of<AuthenticationBloc>(context).add(Logout());
        return;
      },
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


  void _editProfileImage() {
    setState(() {
      isEditingModeOn = !isEditingModeOn;
    });
    if(isEditingModeOn){
      pickUserPicture(context);
      return;
    } else {
      if(userImageFile != null)
        BlocProvider.of<UserBloc>(context).add(UpdateUserProfile(imageLink: userImageFile.path));
    }

  }


  void pickUserPicture(BuildContext context) async{
    showModalBottomSheet(context: context, builder: (context)=> Container(
      decoration: BoxDecoration(
        color:AppColors.black.withOpacity(.4),
        backgroundBlendMode: BlendMode.darken,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              (LocalKeys.CAPTURE_IMAGE_USING).tr(),
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 18,
                // fontFamily: Constants.FONT_ARIAL,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ).tr(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: FlatButton.icon(
                      onPressed: () {
                        pickUserImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      label: Text(''),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FlatButton.icon(
                      onPressed: () {
                        pickUserImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      label: Text(''),
                    ),
                  ),
                ), //getAppleLogin(),
              ],
            ),
          ],
        ),
      ),
    ));

  }
  void pickUserImage(ImageSource source) async{
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: source , imageQuality: 100,);
    if(image != null){
      userImageFile = File.fromUri(Uri.parse(image.path)) ;
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: (LocalKeys.UNABLE_TO_READ_IMAGE).tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Widget getUserImage() {

    print(" Hello => ${BlocProvider.of<UserBloc>(context).currentLoggedInUser.userProfileImage}");
    if(isEditingModeOn && userImageFile != null)
      return Image.file(userImageFile,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    return EnhancedImageNetwork(
      BlocProvider.of<UserBloc>(context).currentLoggedInUser.userProfileImage,
      height: 100,
      width: 100,
      fit: BoxFit.cover,
      constrained: true,
      placeHolder: AssetImage(Resources.USER_PROFILE_PLACEHOLDER_IMG),
    );
  }


  void _navigateToEditProfileScreen() async{
    await  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
    initProfileData();
    setState(() {});
  }
}


