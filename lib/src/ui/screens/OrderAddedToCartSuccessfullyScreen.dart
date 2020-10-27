import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/PackListTile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'PickYourPhotosScreen.dart';
class OrderAddedToCartSuccessfullyScreen extends StatefulWidget {
  @override
  _OrderAddedToCartSuccessfullyScreenState createState() => _OrderAddedToCartSuccessfullyScreenState();
}

class _OrderAddedToCartSuccessfullyScreenState extends State<OrderAddedToCartSuccessfullyScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hasDrawer: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightBlue,
                  ),
                  child: Center(child: Icon(Icons.shopping_cart , color: AppColors.white, size: 40,))),
              Text((LocalKeys.YOUR_ORDER_ADDED_TO_CART).tr() ,
                softWrap: true,
                maxLines: 3,

                style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), ),
              Wrap(
                //mainAxisAlignment: MainAxisAlignment.center,
                alignment: WrapAlignment.center,
                  direction: Axis.horizontal,

                  children: [
                    Text((LocalKeys.YOU_CAN_PROCEED).tr(),),
                    GestureDetector(
                      onTap: _gotoCartScreen,
                      child: Text((LocalKeys.CART_LABEL).tr(),
                        style: TextStyle(
                          color: AppColors.lightBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text((LocalKeys.ICON_LABEL).tr(),),
                  ]

              ),
              Text((LocalKeys.CONTINUE_SHOPPING_LABEL).tr() , style: TextStyle(
                color: AppColors.black,
                decoration: TextDecoration.underline,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), ),
              SizedBox(height: 20,),
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
            ],
          ),
        ),
      ),
    );
  }

  _gotoCartScreen() {}
}
