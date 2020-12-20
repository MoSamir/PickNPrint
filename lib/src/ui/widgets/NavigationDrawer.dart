import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';
import 'package:picknprint/src/ui/screens/LoginScreen.dart';
import 'package:picknprint/src/ui/screens/PickYourPhotosScreen.dart';
import 'package:picknprint/src/ui/screens/ProfileScreen.dart';
import 'package:picknprint/src/ui/screens/UpdatePasswordScreen.dart';
import 'package:picknprint/src/ui/screens/orders_screens/ActiveOrdersScreen.dart';
import 'package:picknprint/src/ui/screens/orders_screens/ClosedOrdersScreen.dart';
import 'package:picknprint/src/ui/screens/orders_screens/SavedOrdersScreen.dart';

import 'LoadingWidget.dart';
import 'PackListTile.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {

  double profilesSectionHeight = 160;
  double cartSectionHeight = 160;

  double padding = 4.0;
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<AuthenticationBloc>(context),
      listener: (context , authenticationBlocState){
        if(authenticationBlocState is UserAuthenticated && authenticationBlocState.currentUser.isAnonymous()){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomeScreen()), (route) => false);
          return;
        }
      },
      child: ModalProgressHUD(
        progressIndicator: LoadingWidget(),
        inAsyncCall: BlocProvider.of<AuthenticationBloc>(context).state is AuthenticationLoading,
        child: BlocConsumer(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.blackBg,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: getPackagesSection(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getProfileSection(),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                          visible: BlocProvider.of<UserBloc>(context)
                                  .currentLoggedInUser
                                  .isAnonymous() ==
                              false,
                          replacement: Container(
                            width: 0,
                            height: 0,
                          ),
                          child: getCartSection()),
                      SizedBox(
                        height: 10,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: getLanguageSection(),
                      // ),
                      getHaveIssueSection()

                    ],
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {},
          cubit: BlocProvider.of<UserBloc>(context),
        ),
      ),
    );
  }

  Widget getPackagesSection() {
    List<PackageModel> systemPackages =
        BlocProvider.of<ApplicationDataBloc>(context).applicationPackages;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (LocalKeys.SELECT_PACKAGE).tr(),
          style: TextStyle(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return PackListTile(
              isColoredStack: true,
              onCardClick: () {
                cardClicked(systemPackages[index]);
                return;
              },
              backgroundColor: AppColors.transparent,
              package: systemPackages[index],
            );
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          itemCount: systemPackages.length,
        ),
      ],
    );
  }
  Widget getProfileSection() {
    return ConfigurableExpansionTile(
      kExpand: Duration(milliseconds: 600),
      headerExpanded: Flexible(child: Visibility(
        replacement: Container(width: 0, height: 0,),
        visible: BlocProvider.of<UserBloc>(context)
            .currentLoggedInUser
            .isAnonymous() ==
            false,
        child: Container(
          color: AppColors.lightBlack,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Center(
                    child: ImageIcon(
                      AssetImage(Resources.USER_PLACEHOLDER_IMG),
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  height: 30,
                  width: 30,
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (LocalKeys.MY_PROFILE).tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: padding),
                      child: Text(
                        (LocalKeys.MANAGE_YOUR_INFORMATION).tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),),
      header:  Flexible(child: Visibility(
        replacement: Container(width: 0, height: 0,),
        visible: BlocProvider.of<UserBloc>(context)
            .currentLoggedInUser
            .isAnonymous() ==
            false,
        child: Container(
          color: AppColors.lightBlack,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Center(
                    child: ImageIcon(
                      AssetImage(Resources.USER_PLACEHOLDER_IMG),
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  height: 30,
                  width: 30,
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (LocalKeys.MY_PROFILE).tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: padding),
                      child: Text(
                        (LocalKeys.MANAGE_YOUR_INFORMATION).tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: BlocProvider.of<UserBloc>(context)
                    .currentLoggedInUser
                    .isAnonymous() ==
                    false,
                replacement: GestureDetector(
                  onTap: _performLogin,
                  child: Text(
                    (LocalKeys.SIGN_IN).tr(),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      replacement: Container(width: 0, height: 0,),
                      visible: false ,
                      child: GestureDetector(
                        onTap: _gotoShippingAddresses,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: padding),
                          child: Text(
                            (LocalKeys.MY_SHIPPING_ADDRESSES).tr(),
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _gotoBasicData,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: padding),
                        child: Text(
                          (LocalKeys.MY_BASIC_DATA).tr(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _gotoUpdatePassword,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: padding),
                        child: Text(
                          (LocalKeys.UPDATE_MY_PASSWORD).tr(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _performLogout,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: padding),
                        child: Text(
                          (LocalKeys.LOGOUT).tr(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }
  Widget getCartSection() {

   return ConfigurableExpansionTile(
     initiallyExpanded: true,
     kExpand: Duration(milliseconds: 600),
      headerExpanded: Flexible(child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: AppColors.lightBlack,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Center(
                    child: Icon(
                      Icons.shopping_cart,
                      color: AppColors.white,
                      size: 15,
                    )),
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (LocalKeys.MY_CART).tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    (LocalKeys.MY_CART_DESCRIPTION).tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),),
      header: Flexible(child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: AppColors.lightBlack,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Center(
                    child: Icon(
                      Icons.shopping_cart,
                      color: AppColors.white,
                      size: 15,
                    )),
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (LocalKeys.MY_CART).tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    (LocalKeys.MY_CART_DESCRIPTION).tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),),
      children: [
       Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.stretch,
         mainAxisSize: MainAxisSize.min,
         children: [
           SizedBox(
             height: 10,
           ),
           Visibility(
             visible: BlocProvider.of<UserBloc>(context)
                 .currentLoggedInUser
                 .isAnonymous() ==
                 false,
             replacement: Container(
               width: 0,
               height: 0,
             ),
             child: Padding(
               padding:
               const EdgeInsets.symmetric(horizontal: 5.0),
               child: getMyOrderSection(),
             ),
           ),
         ],

       ),
      ],
    );

  }
  Widget getMyOrderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.lightBlue,
                  width: 5,
                ),
                shape: BoxShape.rectangle,
              ),
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              height: 30,
              width: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (LocalKeys.MY_ORDER).tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    (LocalKeys.MY_ORDER_DESCRIPTION).tr(),
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _gotoSavedUncompletedPage,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (LocalKeys.SAVED_UNCOMPLETED).tr(),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Visibility(
                      visible: BlocProvider.of<UserBloc>(context).userSavedOrders.length > 0,
                      replacement: Container(width: 0, height: 0,),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text(BlocProvider.of<UserBloc>(context).userSavedOrders.length.toString() , textScaleFactor: 1 ,style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),)),
                      ),

                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _gotoPreviousOrders,
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (LocalKeys.PREVIOUS_ORDERS).tr(),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Visibility(
                      visible: BlocProvider.of<UserBloc>(context).userCompletedOrders.length > 0,
                      replacement: Container(width: 0, height: 0,),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text(BlocProvider.of<UserBloc>(context).userCompletedOrders.length.toString() , textScaleFactor: 1 ,style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),)),
                      ),

                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _gotoCurrentOrders,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (LocalKeys.ACTIVE_ORDERS).tr(),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Visibility(
                      visible: BlocProvider.of<UserBloc>(context).userActiveOrders.length > 0,
                      replacement: Container(width: 0, height: 0,),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text(BlocProvider.of<UserBloc>(context).userActiveOrders.length.toString() , textScaleFactor: 1 ,style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),)),
                      ),

                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget getHaveIssueSection() {
    return GestureDetector(
      onTap: _gotToIssuesPage,
      child: Container(
        height: 70,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(vertical: 10),
        color: AppColors.lightBlack,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.white,
                  ),
                  color: AppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Center(
                    child: Text(
                  '!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                )),
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (LocalKeys.HAVE_PROBLEM).tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    (LocalKeys.HAVE_PROBLEM_DESCRIPTION).tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _performLogout() {
    BlocProvider.of<AuthenticationBloc>(context).add(Logout());
    return ;
  }
  void _gotoUpdatePassword() {
    //Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UpdatePasswordScreen()));
  }
  void _gotoBasicData() {
    // Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen()));
  }
  void _gotoShippingAddresses() {}
  void cardClicked(PackageModel systemPackage) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => PickYourPhotosScreen(
                  userSelectedPackage: systemPackage,
                )),
        (route) => false);
  }



  void _gotoSavedUncompletedPage() {
    // Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SavedOrdersScreen()));
  }

  void _gotoPreviousOrders() {
    // Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClosedOrderScreen()));
  }

  void _gotoCurrentOrders() {
    // Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ActiveOrderScreen()));
  }

  void _gotToIssuesPage() {
    String supportPhoneNumber = BlocProvider.of<ApplicationDataBloc>(context).contactUsPhone;
    launch("tel://$supportPhoneNumber");

    return ;
  }

  void _performLogin() {
    // Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

  Widget getLanguageSection() {

    return GestureDetector(
      onTap: (){
        String newLocale = "en";
        newLocale = (Constants.appLocale == "en") ? "ar": "en";
        Constants.appLocale = newLocale;
        EasyLocalization.of(context).locale = Locale(newLocale);
        setState(() {});
        Navigator.pop(context);
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: padding),
        child: Text((LocalKeys.APP_LANGUAGE).tr(), style: TextStyle(
          color: AppColors.white,
        ),),
      ),
    );
  }
}
