import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
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
        appbarColor: AppColors.black,
        actions: [],
        centerTitle: true,
        title: (LocalKeys.PREVIOUS_ORDERS).tr(),
      ),
      child: Visibility(
        visible: BlocProvider.of<UserBloc>(context).userCompletedOrders.length > 0,
        replacement: Container(
          padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - kToolbarHeight) * .35 ,),
          child: Center(
            child: Text((LocalKeys.NO_ORDERS_YET).tr()),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text((LocalKeys.MY_PREVIOUS_ORDERS).tr() , style: TextStyle(fontWeight: FontWeight.bold),),
              ListView.builder(itemBuilder: (context, index){
                return OrderListingCardTile(orderModel: BlocProvider.of<UserBloc>(context).userCompletedOrders[index],);
              },
              itemCount: BlocProvider.of<UserBloc>(context).userCompletedOrders.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
