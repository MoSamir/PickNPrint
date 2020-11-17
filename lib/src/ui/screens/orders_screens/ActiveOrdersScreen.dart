import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
class ActiveOrderScreen extends StatefulWidget {
  @override
  _ActiveOrderScreenState createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hasDrawer: false,
      hasAppbar: true,
      customAppbar: PickNPrintAppbar(
        appbarColor: AppColors.black,
        actions: [],
        centerTitle: true,
        title: (LocalKeys.ACTIVE_ORDERS).tr(),
      ),
      child: Visibility(
        visible: BlocProvider.of<UserBloc>(context).userActiveOrders.length > 0,
        replacement: Container(
          padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - kToolbarHeight) * .35 ,),
          child: Text((LocalKeys.NO_ORDERS_YET).tr()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((LocalKeys.ACTIVE_ORDERS).tr() , style: TextStyle(fontWeight: FontWeight.bold),),
                ListView.builder(itemBuilder: (context, index){
                  return OrderListingCardTile(orderModel: BlocProvider.of<UserBloc>(context).userActiveOrders[index],);
                },
                  itemCount: BlocProvider.of<UserBloc>(context).userActiveOrders.length,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
