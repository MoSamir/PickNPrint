import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;
import 'package:easy_localization/easy_localization.dart' as ll;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/main.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/OrderCreationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';

import 'package:picknprint/src/bloc/events/CreateOrderEvent.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/CreateOrderStates.dart';
import 'package:picknprint/src/data_providers/apis/ApplicationDataProvider.dart';
import 'package:picknprint/src/data_providers/apis/helpers/URL.dart';
import 'package:picknprint/src/data_providers/models/OrderModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/UserViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/BaseScreen.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';
import 'package:picknprint/src/ui/screens/LoginScreen.dart';
import 'package:picknprint/src/ui/screens/SelectImageSourceScreen.dart';
import 'package:picknprint/src/ui/screens/confirmation_screens/OrderAddedToCartSuccessfullyScreen.dart';
import '../../Repository.dart';
import 'confirmation_screens/OrderSavingConfirmationScreen.dart';
import 'package:picknprint/src/ui/screens/ShippingAddressScreen.dart';
import 'package:picknprint/src/ui/widgets/CheckBoxListTile.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';
import 'AddNewShippingAddressScreen.dart';

class PickYourPhotosScreen extends StatefulWidget {
  final PackageModel userSelectedPackage;
  final OrderModel userOrder;

  PickYourPhotosScreen({this.userSelectedPackage, this.userOrder});

  @override
  _PickYourPhotosScreenState createState() => _PickYourPhotosScreenState();
}

class _PickYourPhotosScreenState extends State<PickYourPhotosScreen> {
  OrderModel userOrder = OrderModel();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OrderCreationBloc createOrderBloc;
  ScrollController _scrollController =  ScrollController();
  double padding = 7.0;
  double frameDimension = 225;

  @override
  void initState() {
    super.initState();
    createOrderBloc = OrderCreationBloc(OrderCreationInitialState());
    if (widget.userOrder == null) {
      List<String> imagesList = List(), originalsList = List();
      for (int i = 0; i < widget.userSelectedPackage.packageSize; i++) {
        imagesList.add('');
        originalsList.add('');
      }
      userOrder = OrderModel(
          orderPackage: widget.userSelectedPackage,
          isWhiteFrame: false,
          frameWithPath: false,
          uploadedImages: List<String>(),
          userImages: imagesList,
          originalImages: originalsList,
          orderTime: DateTime.now());
      restoreCache();
    }
    else {
      userOrder = widget.userOrder;
      if (userOrder.originalImages == null ||
          userOrder.originalImages.isEmpty) {
        userOrder.originalImages = List<String>();
        for (int i = 0; i < userOrder.userImages.length; i++)
          userOrder.originalImages.add(userOrder.userImages[i]);
      }
    }
  }


  GlobalKey<FormState> _globalFormState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen())),
      child: Scaffold(
        body: BlocConsumer(
          listener: (context, state) async {
            if (state is OrderCreationLoadingFailureState) {
              if (state.error.errorCode == HttpStatus.requestTimeout) {
                UIHelpers.showNetworkError(context);
                return;
              } else if (state.error.errorCode ==
                  HttpStatus.serviceUnavailable) {
                UIHelpers.showToast(
                    (LocalKeys.SERVER_UNREACHABLE).tr(), true, true);
                return;
              } else {
                UIHelpers.showToast(state.error.errorMessage ?? '', true, true);
                return;
              }
            } else if (state is OrderSavingFailedState) {
              if (state.error.errorCode == HttpStatus.requestTimeout) {
                UIHelpers.showNetworkError(context);
                return;
              } else if (state.error.errorCode ==
                  HttpStatus.serviceUnavailable) {
                UIHelpers.showToast(
                    (LocalKeys.SERVER_UNREACHABLE).tr(), true, true);
                return;
              } else {
                UIHelpers.showToast(state.error.errorMessage ?? '', true, true);
                return;
              }
            } else if (state is OrderAddedToCartSuccessState) {
              BlocProvider.of<UserBloc>(context).add(LoadUserOrders());

              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OrderAddedToCartSuccessfullyScreen(),
              ));
              return;
            } else if (state is OrderSavingSuccessState) {
              BlocProvider.of<UserBloc>(context).add(LoadUserOrders());
              await Future.delayed(Duration(seconds: 2));
              int length = BlocProvider.of<UserBloc>(context).userSavedOrders.length > 0 ? BlocProvider.of<UserBloc>(context).userSavedOrders.length - 1 : 0 ;
              String orderNumber = BlocProvider.of<UserBloc>(context).userSavedOrders.length > 0 ? BlocProvider.of<UserBloc>(context).userSavedOrders[length].orderNumber.toString() : '';
              DateTime orderTime = BlocProvider.of<UserBloc>(context).userSavedOrders.length > 0 ? BlocProvider.of<UserBloc>(context).userSavedOrders[length].orderTime : DateTime.now();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OrderSavingConfirmationScreen(
                  orderNumber:  orderNumber , //state.cartOrders[0].orderNumber.toString(),
                  orderTime: orderTime,
                ),
              ));
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is OrderCreationLoadingState,
              progressIndicator: LoadingWidget(),
              child: BaseScreen(
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
                  centerTitle: true,
                  title: (LocalKeys.PICK_PHOTOS_KEY).tr(),
                ),
                hasDrawer: false,
                child: Form(
                  key: _globalFormState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: AppColors.offWhite,
                        padding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              (LocalKeys.PICK_YOUR_PHOTOS_KEY).tr(),
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              (LocalKeys.SELECT_PHOTOS_TO_BE_PRINTED).tr(),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.lightBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      frameOptionsWidget(),
                      Container(
                        height: 245,
                        color: AppColors.white,
                        child: Center(
                          child: getFramesList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        replacement: Container(
                          width: 0,
                          height: 0,
                        ),
                        visible: (widget.userOrder == null) ||
                            (widget.userOrder.statues != OrderStatus.SAVED),
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: padding),
                            child: Text(
                              (LocalKeys.SAVE_ORDER_AND_CONTINUE_LATER).tr(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: _saveOrderAndContinueShopping,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: _proceedToCheckout,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            height: (45),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                                child: Text(
                                  (LocalKeys.PROCEED_TO_CHECKOUT).tr(),
                                  style: TextStyle(color: AppColors.white),
                                )),
                          ),
                        ),
                        // i love you
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        replacement: Container(
                          width: 0,
                          height: 0,
                        ),
                        visible: (widget.userOrder == null) ||
                            (widget.userOrder.statues != OrderStatus.SAVED),
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: padding),
                            child: Text(
                              (LocalKeys.ADD_TO_CART_AND_CONTINUE_SHOPPING).tr(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: _addToCartAndContinueShopping,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: false,
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: padding),
                            child: Text(
                              (LocalKeys.CHOOSE_DIFFERENT_SET).tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          cubit: createOrderBloc,
        ),
      ),
    );
  }

  frameOptionsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            (LocalKeys.SELECT_FRAME_OPTIONS).tr(),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              userOrder.isWhiteFrame = true;
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
                        width: (25),
                        height: (25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            color: userOrder.isWhiteFrame
                                ? AppColors.lightBlue
                                : AppColors.white,
                            width: 3,
                          ),
                        ),
                        child: Image.asset(
                          Resources.WHITE_FRAME_OPTION_ICON,
                          height: 25,
                          width: 25,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          (LocalKeys.WHITE_FRAME).tr(),
                          style: TextStyle(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              userOrder.isWhiteFrame = false;
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
                        child: Image.asset(
                          Resources.BLACK_FRAME_OPTION_ICON,
                          height: 25,
                          width: 25,
                          fit: BoxFit.contain,
                        ),
                        width: (25),
                        height: (25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.black,
                          border: Border.all(
                            color: !userOrder.isWhiteFrame
                                ? AppColors.lightBlue
                                : AppColors.black,
                            width: 3,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          (LocalKeys.BLACK_FRAME).tr(),
                          style: TextStyle(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomizedCheckboxListTile(
            dense: false,
            activeColor: AppColors.lightBlue,
            selected: userOrder.frameWithPath,
            value: userOrder.frameWithPath,
            onChanged: (value) {
              userOrder.frameWithPath = value;
              setState(() {});
            },
            title: Text((LocalKeys.WITH_PATH).tr()),
          ),
        ],
      ),
    );
  }

  getFramesList() {

    try{
      userOrder.orderPackage =  BlocProvider.of<ApplicationDataBloc>(context)
          .applicationPackages.firstWhere((element) => element.packageSize == 3);
    } catch(exception){
      debugPrint("Exception happened while parsing the package ! => $exception");
      try{
        userOrder.orderPackage =  BlocProvider.of<ApplicationDataBloc>(context)
            .applicationPackages.first;
      } catch(innerException){
        userOrder.orderPackage.packageSize = 3;
      }
    }

    if (userOrder.userImages.length < userOrder.orderPackage.packageSize) {
      int remainingImages = userOrder.orderPackage.packageSize - userOrder.userImages.length;
      for (int i = 0; i < remainingImages; i++) userOrder.userImages.add('');
    }


    List<Widget> pictures = List();
    int currentFrames = Math.max(3, userOrder.userImages.length);






    for (int i = 0; i < currentFrames; i++) {
      Widget child = userOrder.userImages[i] == null || userOrder.userImages[i].isEmpty
          ? Center(
        child: Icon(
          Icons.photo,
          color: AppColors.lightBlue,
          size: 35,
        ),
      )
          : getImageFromPath(userOrder.userImages[i],);

      pictures.add(
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: GestureDetector(
              onTap: ()=> onSelectImagePressed(i),
              child: getFrameDecoration( child , i > 3 ? (){
                deleteFrameAt(i);
              } : null ),
            ),
          ),);
    }
    pictures.add(
      GestureDetector(
        onTap: () {_addExtraFrame();},
        child: getFrameDecoration( Center(
          child: Icon(Icons.add_circle_outline_rounded , color: AppColors.lightBlue, size: 35,),
        ) , null ),
      ),
    );
    return ListView(
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: pictures,
    );
  }

  void _saveOrderAndContinueShopping() async {
    UserViewModel currentUser =
        BlocProvider.of<AuthenticationBloc>(context).currentUser;

    if (currentUser != null && currentUser.isAnonymous() == false) {

      if(userOrder.userImages != null && userOrder.userImages.length > 0) {
        createOrderBloc.add(SaveOrder(order: userOrder));
      } else {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              elevation: 2,
              content: Container(
                width: MediaQuery.of(context).size.width * .7,
                height: 150,
                child: Center(
                  child: Text((LocalKeys.SOME_IMAGES_IS_MISSING).tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ));
        return;
      }
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void _proceedToCheckout() async {
    String errorMessageIfExist = await createOrderBloc.validateOrder(userOrder);
    if (errorMessageIfExist == (LocalKeys.SOME_IMAGES_IS_MISSING).tr()) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            elevation: 2,
            content: Container(
              width: MediaQuery.of(context).size.width * .7,
              height: 150,
              child: Center(
                child: Text(
                  errorMessageIfExist,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ));
      return;
    } else if (errorMessageIfExist == (LocalKeys.PROCEED_WITH_CURRENT_AMOUNT_WARNING).tr()) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            elevation: 2,
            content: Container(
              width: MediaQuery.of(context).size.width * .7,
              height: 150,
              child: Center(
                child: Text(
                  errorMessageIfExist,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  _checkoutOrder();
                  Navigator.pop(context);
                },
                child: Text((LocalKeys.PROCEED_LABEL).tr()),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text((LocalKeys.CANCEL_LABEL).tr()),
              ),
            ],
          ));
      return;
    } else {
      _checkoutOrder();
      return;
    }
  }

  void _addToCartAndContinueShopping() async {
    if (BlocProvider.of<AuthenticationBloc>(context).currentUser.isAnonymous()) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }


    if (userOrder.userImages != null && userOrder.userImages.length > 0) {
      createOrderBloc.add(AddOrderToCart(order: userOrder));
    } else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            elevation: 2,
            content: Container(
              width: MediaQuery.of(context).size.width * .7,
              height: 150,
              child: Center(
                child: Text((LocalKeys.SOME_IMAGES_IS_MISSING).tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ));
      return;
    }
  }

  Widget getImageFromPath(String userImage) {

    if(userImage.lastIndexOf("https://cdn.filestackcontent.com") > 0){
      userImage = userImage.replaceFirst("https://cdn.filestackcontent.com", "");
    }

    if (userImage.toLowerCase().contains('/http') ||
        userImage.toLowerCase().contains('/https')) {
      return Image.network(
        userImage.replaceFirst('/', ''),
        fit: BoxFit.fill,
      );
    } else {
      return Image.file(
        File(userImage),
        fit: BoxFit.fill,
      );
    }
  }

  Future<void> _addExtraFrame() async {
    setState(() {
      print("User Images => ${userOrder.userImages.length}");
      userOrder.userImages.add('');
      print("User Images => ${userOrder.userImages.length}");
      userOrder.originalImages.add('');
      print("User Images => ${userOrder.userImages.length}");
    });
  }

  void removeSelectionImage(int index, {bool needPop}) {
    try {
      userOrder.userImages[index] = '';
      userOrder.originalImages[index] = '';
    } catch (exception) {
      print("EXCEPTION -> $exception");
    }
    setState(() {});

    if (needPop != null && needPop) {
      Navigator.pop(context);
    }
  }

  void _openEditImage(String imageFilePath, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    (LocalKeys.CUSTOMIZE_YOUR_IMAGE).tr(),
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // fontFamily: Constants.FONT_ARIAL,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ).tr(),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            onPressed: () {
                              removeSelectionImage(index, needPop: true);
                              return;
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cleaning_services_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  (LocalKeys.REMOVE_IMAGE).tr(),
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            onPressed: () async {
                              File croppedFilePath =
                              await UIHelpers.cropImage(imageFilePath);
                              if (croppedFilePath != null) {
                                userOrder.userImages.removeAt(index);
                                userOrder.userImages
                                    .insert(index, croppedFilePath.path);
                              }
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                Text(
                                  (LocalKeys.EDIT_IMAGE).tr(),
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _checkoutOrder() async {
    if (BlocProvider.of<AuthenticationBloc>(context).currentUser.isAnonymous()) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    } else if (BlocProvider.of<AuthenticationBloc>(context).currentUser.userSavedAddresses.length == 0) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddNewShippingAddressScreen(
            userOrder,
            comingFromRegistration: false,
          )));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShippingAddressScreen(userOrder)));
    }
  }

  void cacheImages({String croppedVersion, String originalVersion}) async{
    await Repository.cacheCroppedImage(croppedVersion);
    await Repository.cacheOriginalImage(originalVersion);
  }

  void restoreCache() async{
    List<String> originalOrderItems = await Repository.getCachedOriginalOrderImages();
    List<String> cachedCroppedOrderItems = await Repository.getCachedCroppedOrderImages();
    setState(() {
      if(originalOrderItems != null){
        for(int i = 0 ; i < originalOrderItems.length ; i++){
          userOrder.originalImages[i] = originalOrderItems[i];
        }
      }
      if(cachedCroppedOrderItems != null){
        for(int i = 0 ; i < cachedCroppedOrderItems.length ; i++){
          userOrder.userImages[i] = cachedCroppedOrderItems[i];
        }
      }
    });
  }

  void deleteFrameAt(int i) {
    setState(() {
      try {
        userOrder.userImages.removeAt(i);
      } catch(exception){}

      try {
        userOrder.originalImages.removeAt(i);
      } catch(exception){}

      try {
        userOrder.uploadedImages.removeAt(i);
      } catch(exception){}

    });

  }

  void onSelectImagePressed(int i) async{
    if (userOrder.userImages[i] != null &&
        userOrder.userImages[i].length > 0) {
      _openEditImage(userOrder.originalImages[i], i);
    } else {
      List<String> imagePath = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SelectImageSourceScreen()));
      try{
        userOrder.userImages[i] = imagePath[0] ?? '';
        userOrder.originalImages[i] = imagePath[1] ?? '';
        cacheImages(croppedVersion: imagePath[0],originalVersion: imagePath[1]);
        setState(() {});
        double animationIndex = (frameDimension * (userOrder.userImages.indexWhere((element) => element == '')));
        _scrollController.animateTo(animationIndex, duration: Duration(seconds: 2), curve: Curves.decelerate);
      } catch(exception){}
    }
    return;

  }


  Widget getFrameDecoration(Widget child ,Function deleteAction){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Stack(
        children: [
          ClipRect(
            child: AnimatedContainer(
              width: frameDimension,
              height: frameDimension,
              alignment: Alignment.center,
              padding: userOrder.frameWithPath
                  ? EdgeInsets.all(28)
                  : EdgeInsets.all(4),
              duration: Duration(milliseconds: 200),
              child: child,
            ),
          ),
          Container(
            width: frameDimension,
            height: frameDimension,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(userOrder.isWhiteFrame ? Resources.WHITE_FRAME_IMG : Resources.BLACK_FRAME_IMG),
              ),
            ),

          ),
          Visibility(
            visible: deleteAction != null,
            child: Positioned.directional(
              textDirection: Constants.appLocale == "en"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              top: 6,
              start: 6,
              child: GestureDetector(
                onTap: deleteAction,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.clear,
                      color: AppColors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
            replacement: Container(
              width: 0,
              height: 0,
            ),
          ),
        ],
      ),
    );

  }


}
