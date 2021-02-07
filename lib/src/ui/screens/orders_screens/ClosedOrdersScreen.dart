import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/ListViewAnimatorWidget.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';

import '../HomeScreen.dart';
class ClosedOrderScreen extends StatefulWidget {
  @override
  _ClosedOrderScreenState createState() => _ClosedOrderScreenState();
}

class _ClosedOrderScreenState extends State<ClosedOrderScreen> {
  @override
  Widget build(BuildContext context) {
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
        appbarColor: AppColors.black,
        actions: [],
        centerTitle: true,
        title: (LocalKeys.PREVIOUS_ORDERS).tr(),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text((LocalKeys.MY_PREVIOUS_ORDERS).tr() , style: TextStyle(fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListViewAnimatorWidget(
                placeHolder: Center(child: Text((LocalKeys.CLOSED_ORDERS_PLACEHOLDER).tr() , textAlign: TextAlign.center,),),
                isScrollEnabled: false,
                listChildrenWidgets: BlocProvider.of<UserBloc>(context).userCompletedOrders.map((OrderModel order) => OrderListingCardTile(orderModel: order,)).toList(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
