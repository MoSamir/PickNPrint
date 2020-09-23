import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/main.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/OrderCreationBloc.dart';
import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';
import 'package:picknprint/src/ui/screens/LoginScreen.dart';
import 'package:picknprint/src/ui/screens/OrderSavingErrorScreen.dart';
import 'package:picknprint/src/ui/widgets/CheckBoxListTile.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintFooter.dart';

import 'OrderSavingConfirmationScreen.dart';
import 'SelectImageSourceScreen.dart';
import 'AddNewShippingAddressScreen.dart';
class PickYourPhotosScreen extends StatefulWidget {

  final PackageModel userSelectedPackage;
  PickYourPhotosScreen({this.userSelectedPackage});

  @override
  _PickYourPhotosScreenState createState() => _PickYourPhotosScreenState();
}

class _PickYourPhotosScreenState extends State<PickYourPhotosScreen> {
  OrderModel userOrder = OrderModel();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderCreationBloc createOrderBloc ;

  @override
  void initState() {
    super.initState();
    createOrderBloc = OrderCreationBloc(OrderCreationInitialState());
    List<String> imagesList = List();
    for(int i = 0 ; i < widget.userSelectedPackage.packageSize; i++)
      imagesList.add('');
    userOrder = OrderModel(orderPackage: widget.userSelectedPackage , isWhiteFrame: true , frameWithPath: false, userImages: imagesList , orderTime: DateTime.now());
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen())),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PickNPrintAppbar(hasDrawer: true,appbarColor: AppColors.black,),
          body: BlocConsumer(
            listener: (context , state){

              print("State is $state");

              if (state is OrderCreationLoadingFailureState) {
                if (state.error.errorCode == HttpStatus.requestTimeout) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return NetworkErrorView();
                      });
                } else if (state.error.errorCode ==
                    HttpStatus.serviceUnavailable) {
                  Fluttertoast.showToast(
                      msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Fluttertoast.showToast(
                      msg: state.error.errorMessage ?? '',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }
              else if(state is OrderSavingSuccessState){
              }
            },
            builder: (context , state){
              return ModalProgressHUD(
                inAsyncCall: state is OrderCreationLoadingState,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: AppColors.offWhite,
                        padding: EdgeInsets.symmetric(vertical: 16 , horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text((LocalKeys.PICK_YOUR_PHOTOS_KEY).tr(), style: TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                            ), ),
                            Text((LocalKeys.SELECT_PHOTOS_TO_BE_PRINTED).tr(), style: TextStyle(
                              fontSize: 14,
                              color: AppColors.lightBlue,
                            ), ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      frameOptionsWidget(),
                      Container(height: 170,
                        color: AppColors.white,
                        child: Center(
                          child: getFramesList(),),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(child: Text((LocalKeys.SAVE_ORDER_AND_CONTINUE_LATER).tr() , textAlign: TextAlign.center, ) , onTap: _saveOrderForLater,),
                      SizedBox(height: 5,),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            if(BlocProvider.of<AuthenticationBloc>(context).currentUser.isAnonymous()){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
                            } else {

                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewShippingAddressScreen(
                                comingFromRegistration: false,
                              )));

                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(child: Text((LocalKeys.PROCEED_TO_CHECKOUT).tr(), style: TextStyle(color: AppColors.white),)),
                          ),
                        ),
                        // i love you
                      ),
                      SizedBox(height: 5,),
                      GestureDetector(child: Text((LocalKeys.SAVE_ORDER_AND_CONTINUE_SHOPPING).tr() , textAlign: TextAlign.center, ) , onTap: _saveOrderAndContinueShopping,),
                      SizedBox(height: 5,),
                      GestureDetector(child: Text((LocalKeys.CHOOSE_DIFFERENT_SET).tr() , textAlign: TextAlign.center, style: TextStyle(
                        decoration: TextDecoration.underline,
                      ), ) , onTap: (){
                        Navigator.of(context).pop();
                      },),
                      SizedBox(height: 10,),
                      PickNPrintFooter(),
                    ],
                  ),
                ),
              );
            },
            bloc: createOrderBloc,
          ),
        ),
      ),
    );
  }

  frameOptionsWidget() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text((LocalKeys.SELECT_FRAME_OPTIONS).tr(),),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              userOrder.isWhiteFrame = true ;
              setState(() {});
            },
            child: Material(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            color: userOrder.isWhiteFrame ? AppColors.lightBlue : AppColors.white,
                            width: 3,
                          ),
                        ),

                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text((LocalKeys.WHITE_FRAME).tr() , style: TextStyle(
                          color: AppColors.black,
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              userOrder.isWhiteFrame = false ;
              setState(() {});
            },
            child: Material(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.black,
                          border: Border.all(
                            color: !userOrder.isWhiteFrame ? AppColors.lightBlue : AppColors.black,
                            width: 3,
                          ),
                        ),

                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text((LocalKeys.BLACK_FRAME).tr() , style: TextStyle(
                          color: AppColors.black,
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),

          CustomizedCheckboxListTile(
            dense: false,
            activeColor: AppColors.lightBlue,
            selected: userOrder.frameWithPath,
            value: userOrder.frameWithPath,
            onChanged: (value){
              userOrder.frameWithPath = value ;
              setState(() {});
            },
            title: Text((LocalKeys.WITH_PATH).tr()),
          ),



        ],
      ),
    );


  }
  getFramesList() {
    List<Widget> pictures = List();
    for(int i = 0 ; i < widget.userSelectedPackage.packageSize ; i++){
      pictures.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 8.0),
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: userOrder.frameWithPath ? AppColors.black : AppColors.white,

            border: Border.all(
              color: userOrder.isWhiteFrame ? AppColors.offWhite.withOpacity(.8) : AppColors.black,
              width: 5,
            ),
          ),
          child: AnimatedContainer(
            margin: EdgeInsets.all(8),
            duration: Duration(seconds: 2),

            child: userOrder.userImages[i].isEmpty ?  Center(
              child: IconButton(
                icon: Icon(Icons.add_circle  , color: AppColors.lightBlue , size: 35,),
                onPressed: ()async{
                  String imagePath = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SelectImageSourceScreen()));
                  userOrder.userImages[i] = imagePath ?? '';
                  setState(() {});
                },
              ),
            ) :  getImageFromPath(userOrder.userImages[i]),
          ),
        ),
      ),
      );
    }
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: pictures,
    );
  }

  getImageFromPath(String userImage) {


    
    
    if(userImage.toLowerCase().contains('http') || userImage.toLowerCase().contains('https')){
      return Image.network(userImage , fit: BoxFit.contain,);
    } else {
      return Image.file(File(userImage) , fit: BoxFit.contain,);
    }
  }
  void _saveOrderForLater() async{
    if(authenticationBloc.currentUser != null && authenticationBloc.currentUser.isAnonymous() == false) {
      String errorMessageIfExist = await validaOrder();
      if(errorMessageIfExist != null){
       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderSavingErrorScreen(error: errorMessageIfExist,)));
      }
      createOrderBloc.add(SaveOrder(order: userOrder));
    }
    else
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
  }




  Future<String> validaOrder() async{
    for(int i = 0 ; i < userOrder.userImages.length ; i++){
      String imagePath = userOrder.userImages[i];
      if(imagePath == null || imagePath.isEmpty){
        return (LocalKeys.SOME_IMAGES_IS_MISSING).tr();
      }
      File imageFile = File(imagePath);
      var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
      if(decodedImage.width < 50  || decodedImage.height < 50){
        return (LocalKeys.IMAGE_IS_TOO_SMALL).tr();
      }
    }
    return null;
  }

  void _saveOrderAndContinueShopping() async{
    if(authenticationBloc.currentUser != null && authenticationBloc.currentUser.isAnonymous() == false) {
      String errorMessageIfExist = await validaOrder();
      if(errorMessageIfExist != null){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderSavingErrorScreen(error: errorMessageIfExist,)));
      }
      createOrderBloc.add(SaveOrder(order: userOrder));
    }
    else
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
}


