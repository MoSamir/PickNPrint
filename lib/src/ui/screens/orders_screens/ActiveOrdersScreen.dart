import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';
import 'package:picknprint/src/ui/widgets/ListViewAnimatorWidget.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
class ActiveOrderScreen extends StatefulWidget {
  @override
  _ActiveOrderScreenState createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {

  String localeName = "en_US";

  @override
  Widget build(BuildContext context) {







    if(Constants.appLocale == "ar")
      localeName = "ar_EG";

    return BaseScreen(
      hasDrawer: false,
      hasAppbar: true,
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
        autoImplyLeading: true,
        appbarColor: AppColors.black,
        actions: [],
        centerTitle: true,
        title: (LocalKeys.ACTIVE_ORDERS).tr(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text((LocalKeys.ACTIVE_ORDERS).tr() , style: TextStyle(fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListViewAnimatorWidget(
                  placeHolder: Center(child: Text((LocalKeys.ACTIVE_ORDERS_PLACEHOLDER).tr() , textAlign: TextAlign.center,),),
                  isScrollEnabled: false,
                  listChildrenWidgets: BlocProvider.of<UserBloc>(context).userActiveOrders.map((OrderModel order) => OrderListingCardTile(orderModel: order,)).toList(),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
