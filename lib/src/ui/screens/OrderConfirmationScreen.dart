import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';

import 'package:picknprint/src/ui/screens/PickYourPhotosScreen.dart';
import 'package:picknprint/src/ui/widgets/PackListTile.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../BaseScreen.dart';
class OrderConfirmationScreen extends StatelessWidget {

  final String orderNumber ;
  final String orderShippingDuration ;
  OrderConfirmationScreen({this.orderNumber , this.orderShippingDuration});



  @override
  Widget build(BuildContext context) {

    return BaseScreen(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20,),
            Text((LocalKeys.THANKS_FOR_ORDERING).tr(), style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), textAlign: TextAlign.center,),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Center(
                child: Text((LocalKeys.ORDER_NUMBER).tr(args: [orderNumber.toString()]) , textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlue,
                ),),
              ),
            ),
            SizedBox(height: 5,),
            Center(
              child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: (LocalKeys.ORDER_WILL_BE_SHIPPED).tr(),
                        style: TextStyle(
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' ${(orderShippingDuration.toString())} ',
                        style: TextStyle(
                          color: AppColors.lightBlue,
                        ),
                      ),
                      TextSpan(
                        text: ' ${(LocalKeys.DAYS_LABEL).tr()}',
                        style: TextStyle(
                          color: AppColors.black,
                        ),
                      )

                    ]
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text((LocalKeys.CHECK_YOUR_ORDERS).tr()),
                  GestureDetector(
                    onTap: (){},
                    child: Text((LocalKeys.HERE_LABEL).tr(), style: TextStyle(
                      color: AppColors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Container(
              height: MediaQuery.of(context).size.height * .25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Resources.INFORMATION_BANNER_IMG,
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54.withOpacity(.6), BlendMode.darken),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(AssetImage(Resources.INFORMATION_ICON_IMG), color: AppColors.lightBlue, size: 35,),
                    SizedBox(height: 5,),
                    Text((LocalKeys.INQUIRY_HELP_MESSAGE).tr() , style: TextStyle(
                      color: AppColors.white,
                    ),),
                    GestureDetector(child: Text(BlocProvider.of<ApplicationDataBloc>(context).contactUsPhone , style: TextStyle(
                      color: AppColors.white,
                    ),) , onTap: ()=> _callForHelp(context),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text((LocalKeys.START_COLLECTION).tr() , textAlign: TextAlign.start, style: TextStyle(
                color: AppColors.lightBlue,
              ),),
            ),
            ListView.builder(itemBuilder: (context, index){
              return PackListTile(
                isColoredStack: false,
                backgroundColor: AppColors.offWhite,
                onBuyPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> PickYourPhotosScreen(userSelectedPackage: BlocProvider.of<ApplicationDataBloc>(context).applicationPackages[index],)), (route) => false);
                },
                package: BlocProvider.of<ApplicationDataBloc>(context).applicationPackages[index],
              );
            } , physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0), shrinkWrap: true, itemCount: BlocProvider.of<ApplicationDataBloc>(context).applicationPackages.length,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 8),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text((LocalKeys.REQUEST_EXTRA_PACKAGES_THAN).tr(args:[BlocProvider.of<ApplicationDataBloc>(context).maxPackageSize.toString()]) , style: TextStyle(
                    color: AppColors.lightBlue,
                  ),),
                  GestureDetector(
                    onTap: (){},
                    child: Row(
                      children: <Widget>[
                        Text((LocalKeys.CHECKOUT_EXTRA_RATE).tr() , style: TextStyle(
                        ),),
                        Text((LocalKeys.HERE_LABEL).tr() , style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.lightBlue,
                        ),),


                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          ],
        ),
      ),
      hasDrawer: true,
    );
  }

  void _callForHelp(context) {
    String supportPhoneNumber = BlocProvider.of<ApplicationDataBloc>(context).contactUsPhone;
    launch("tel://$supportPhoneNumber");
  }
}
