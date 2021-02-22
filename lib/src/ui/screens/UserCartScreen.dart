import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/OrderCreationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/screens/PickYourPhotosScreen.dart';
import 'package:picknprint/src/ui/screens/ShippingAddressScreen.dart';
import 'package:picknprint/src/ui/widgets/ListViewAnimatorWidget.dart';
import 'package:picknprint/src/ui/widgets/OrderListingCardTile.dart';
import 'package:picknprint/src/ui/widgets/OrderStatisticWidget.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart';

import 'HomeScreen.dart';
class UserCartScreen extends StatefulWidget {
  @override
  _UserCartScreenState createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {

  OrderCreationBloc createOrderBloc = OrderCreationBloc(OrderCreationInitialState());
  String localeName = "en_US";


  @override
  void dispose() {
    createOrderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(Constants.appLocale == "ar")
      localeName = "ar_EG";
    return BlocConsumer(
      cubit: createOrderBloc,
      listener: (context , state){},
      builder: (context , state){
        return BaseScreen(
          hasDrawer: false,
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
            title: (LocalKeys.MY_CART).tr(),
            centerTitle: true,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListViewAnimatorWidget(
              placeHolder: Center(
                child: Text((LocalKeys.EMPTY_CART_PLACEHOLDER).tr()),
              ),
              isScrollEnabled: true,
              listChildrenWidgets: BlocProvider.of<UserBloc>(context).userCart.map((OrderModel order){
                print("Order Status => ${order.statues}");
                return  GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PickYourPhotosScreen(userOrder: order,)));
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
                          Text((LocalKeys.ORDER_NUMBER).tr(args: [(order.orderNumber.toString())]) , style: TextStyle(
                            color: AppColors.white,
                          ),),
                          Text(DateFormat.yMd(localeName).format(order.orderTime ?? DateTime.now()).replaceAll('/', ' / ') , style: TextStyle(
                            color: AppColors.white,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
