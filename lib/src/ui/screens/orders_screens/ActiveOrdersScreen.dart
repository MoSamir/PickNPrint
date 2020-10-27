import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ActiveOrderScreen extends StatefulWidget {
  @override
  _ActiveOrderScreenState createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hasDrawer: true,
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
    );
  }
}
