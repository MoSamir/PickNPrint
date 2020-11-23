

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
import 'package:picknprint/src/ui/widgets/PackListTile.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';

import '../PickYourPhotosScreen.dart';
class SavedOrdersScreen extends StatefulWidget {
  @override
  _SavedOrdersScreenState createState() => _SavedOrdersScreenState();
}

class _SavedOrdersScreenState extends State<SavedOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hasDrawer: false,
      hasAppbar: true,
      customAppbar: PickNPrintAppbar(
        appbarColor: AppColors.black,
        actions: [],
        centerTitle: true,
        title: (LocalKeys.MY_SAVED_ORDERS).tr(),
      ),
      child: Visibility(
        visible: BlocProvider.of<UserBloc>(context).userSavedOrders.length > 0,
        replacement: Container(
          padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - kToolbarHeight) * .35 ,),
          child: Text((LocalKeys.NO_ORDERS_YET).tr() , textAlign: TextAlign.center,),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((LocalKeys.MY_SAVED_ORDERS).tr() , style: TextStyle(fontWeight: FontWeight.bold),),
                ListView.builder(itemBuilder: (context, index){
                  OrderModel orderModel = BlocProvider.of<UserBloc>(context).userSavedOrders[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: (){
                        navigateToOrderCreationScreen(orderModel);
                        return;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 15),
                        decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text((LocalKeys.ORDER_NUMBER).tr(args: [(orderModel.orderNumber.toString())]) , style: TextStyle(
                                color: AppColors.white,
                              ),),

                              Text(DateFormat.yMd(Constants.CURRENT_LOCALE).format(orderModel.orderTime).replaceAll('/', ' / ') , style: TextStyle(
                                color: AppColors.white,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                  itemCount: BlocProvider.of<UserBloc>(context).userSavedOrders.length,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: (LocalKeys.OR_LABEL).tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBlue,
                          fontSize: 25,
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: (LocalKeys.CREATE_NEW_ORDER).tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,

                        ),
                      )
                    ]
                  ),
                ),
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
        ),
      ),
    );
  }

  void navigateToOrderCreationScreen(OrderModel userOrderModel) {

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PickYourPhotosScreen(userSelectedPackage: userOrderModel.orderPackage, userOrder: userOrderModel)));
  }
}
