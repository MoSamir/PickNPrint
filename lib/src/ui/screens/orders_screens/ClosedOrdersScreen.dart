import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
class ClosedOrderScreen extends StatefulWidget {
  @override
  _ClosedOrderScreenState createState() => _ClosedOrderScreenState();
}

class _ClosedOrderScreenState extends State<ClosedOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hasDrawer: true,
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
    );
  }
}
