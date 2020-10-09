import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/screens/PickYourPhotosScreen.dart';
import 'package:picknprint/src/ui/screens/UpdatePasswordScreen.dart';

import 'PackListTile.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppColors.blackBg,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: getPackagesSection(),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: getProfileSection(),
                  ),
                  SizedBox(height: 10,),
                  getCartSection(),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: getMyOrderSection(),
                  ),
                  SizedBox(height: 10,),
                  getHaveIssueSection(),
                  SizedBox(height: 25,),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
      cubit: BlocProvider.of<UserBloc>(context),
    );
  }

  Widget getPackagesSection() {
    List<PackageModel> systemPackages = BlocProvider.of<ApplicationDataBloc>(context).applicationPackages;
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
              onCardClick: (){
                cardClicked(systemPackages[index]);
                return ;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
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
              child: Center(child:ImageIcon(AssetImage(Resources.USER_PLACEHOLDER_IMG), color: AppColors.white, size: 20,),),
              height: 30,
              width: 30,
            ),
            SizedBox(width: 5,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text((LocalKeys.MY_PROFILE).tr(), style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 16,
                ),),
                Text((LocalKeys.MANAGE_YOUR_INFORMATION).tr(), style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightBlue,
                ),),
              ],
            ),
          ],
        ),
        SizedBox(height: 10,),

        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _gotoShippingAddresses,
              child: Text((LocalKeys.MY_SHIPPING_ADDRESSES).tr(), style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),),
            ),
            GestureDetector(
              onTap: _gotoBasicData,
              child: Text((LocalKeys.MY_BASIC_DATA).tr(), style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),),
            ),
            GestureDetector(
              onTap: _gotoUpdatePassword,
              child: Text((LocalKeys.UPDATE_MY_PASSWORD).tr(), style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),),
            ),
            GestureDetector(
              onTap: _performLogout,
              child: Text((LocalKeys.LOGOUT).tr(), style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),),
            ),
          ],
        ),
      ],
    );

  }
  Widget getCartSection() {
    return GestureDetector(
      onTap: gotoCartSection,
      child: Container(
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
                child: Center(child: Icon(Icons.shopping_cart , color: AppColors.white, size: 15,)),
               height: 30,
               width: 30,
              ),
              SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text((LocalKeys.MY_CART).tr(), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 16,
                  ),),
                  Text((LocalKeys.MY_CART_DESCRIPTION).tr(), style: TextStyle(
                    fontSize: 14,
                    color: AppColors.lightBlue,
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),);
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
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text((LocalKeys.MY_ORDER).tr(), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 16,
                  ),),
                  Text((LocalKeys.MY_ORDER_DESCRIPTION).tr(), maxLines: 2 ,style: TextStyle(
                    fontSize: 14,
                    color: AppColors.lightBlue,
                  ),),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),


        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            GestureDetector(
              onTap: _gotoSavedUncompletedPage,
              child: Text((LocalKeys.SAVED_UNCOMPLETED).tr(), style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),),
            ),
            GestureDetector(
              onTap: _gotoPreviousOrders,
              child: Text((LocalKeys.PREVIOUS_ORDERS).tr(), style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),),
            ),
            GestureDetector(
              onTap: _gotoCurrentOrders,
              child: Text((LocalKeys.ACTIVE_ORDERS).tr(), style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),),
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
                child: Center(child: Text( '!' , style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),)),
                height: 30,
                width: 30,
              ),
              SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text((LocalKeys.HAVE_PROBLEM).tr(), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 16,
                  ),),
                  Text((LocalKeys.HAVE_PROBLEM_DESCRIPTION).tr(), style: TextStyle(
                    fontSize: 14,
                    color: AppColors.lightBlue,
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),);
  }



  void _performLogout() {
  }
  void _gotoUpdatePassword() {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UpdatePasswordScreen()));
  }
  void _gotoBasicData() {
  }
  void _gotoShippingAddresses() {}
  void cardClicked(PackageModel systemPackage) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => PickYourPhotosScreen(userSelectedPackage: systemPackage,)),
            (route) => false);
  }
  void gotoCartSection() {
  }
  void _gotoSavedUncompletedPage() {
  }
  void _gotoPreviousOrders() {
  }
  void _gotoCurrentOrders() {
  }
  void _gotToIssuesPage() {
  }

}




