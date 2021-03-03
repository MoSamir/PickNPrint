import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/states/ApplicationDataState.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/TestimonialViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/screens/AboutScreen.dart';
import 'package:picknprint/src/ui/screens/PickYourPhotosScreen.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';
import 'package:picknprint/src/ui/widgets/NumberedBoxWidget.dart';
import 'package:picknprint/src/ui/widgets/PackageHomeScreenListing.dart';
import 'package:picknprint/src/ui/widgets/TestimonialCard.dart';
import 'package:picknprint/src/utilities/UIHelpers.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../BaseScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {



  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        listener: (context , state){
          if (state is ApplicationDataLoadingFailureState) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              UIHelpers.showNetworkError(context);
              resolveAutoDispatch(state);
              return;
            }
            else if (state.error.errorCode == HttpStatus.serviceUnavailable) {
              UIHelpers.showToast((LocalKeys.SERVER_UNREACHABLE).tr(), true, true);
              return;
            }
            else {
              UIHelpers.showToast(state.error.errorMessage ?? '', true, true);
              return;
            }
          }
        },
        builder: (context , state){
          return ModalProgressHUD(
            progressIndicator: LoadingWidget(),
            inAsyncCall: state is ApplicationDataLoadingState,
            child: BaseScreen(
              hasDrawer: true,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black12,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:MediaQuery.of(context).size.height * .5,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(Resources.HOME_SCREEN_BANNER , fit: BoxFit.contain, alignment: Alignment.topCenter , height: MediaQuery.of(context).size.height * .4,),
                                alignment: Alignment.topCenter,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 110,
                                child: Container(
                                  color: Colors.black12.withOpacity(.5),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      NumberedBoxWidget(
                                        passedNumber: '1',
                                        passedText: (LocalKeys.PICK_KEY).tr(),
                                        passedWidget: Icon(Icons.image, color: AppColors.lightBlack.withOpacity(.5), size: 35,),
                                      ),
                                      NumberedBoxWidget(
                                        passedNumber: '2',
                                        passedText: (LocalKeys.PRINT_KEY).tr(),
                                        passedWidget: Icon(Icons.print, color: AppColors.lightBlack.withOpacity(.5), size: 35,),
                                      ),
                                      NumberedBoxWidget(
                                        passedNumber: '3',
                                        passedText: (LocalKeys.DELIVER_KEY).tr(),
                                        passedWidget: Icon(Icons.local_shipping, color: AppColors.lightBlack.withOpacity(.5), size: 35,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: AppColors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8 , vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: (LocalKeys.PICK_PHOTOS_KEY).tr(), style: TextStyle(color: AppColors.lightBlue , fontSize: 20)),
                                    TextSpan(text:'  '),
                                    TextSpan(text: (LocalKeys.AND_PRINT_KEY).tr(), style: TextStyle(color: AppColors.black , fontSize: 20)),
                                  ]
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(LocalKeys.PICK_N_PRINT_KEY , textAlign: TextAlign.start,).tr(),
                        SizedBox(height: 10,),
                        Center(
                          child: GestureDetector(
                            onTap: (){
                             PackageModel package =  BlocProvider.of<ApplicationDataBloc>(context).applicationPackages[0];
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PickYourPhotosScreen(userSelectedPackage: package,)));
                            },
                            child: Container(
                              width: (200),
                              height: (40),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(child: Text((LocalKeys.GO_LABEL).tr(), style: TextStyle(color: AppColors.white),)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Resources.CHOOSE_PACKAGE_IMG),
                          fit: BoxFit.fill
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 5,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Center(
                                child: Text((LocalKeys.CHOOSE_PACKAGE_KEY).tr(), textAlign: TextAlign.center,style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),),
                              ),
                              SizedBox(height: 5,),
                              Center(
                                child: Text((LocalKeys.WHAT_WE_OFFER).tr(), textAlign: TextAlign.center, style: TextStyle(
                                  color: AppColors.white,
                                ),),
                              ),
                              SizedBox(height: 10,),
                            ],),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: getAvailablePackagesView(BlocProvider.of<ApplicationDataBloc>(context).applicationPackages),
                  ),
                  Visibility(
                    replacement: Container(height: 0, width: 0,),
                    visible: state is ApplicationDataLoadedState ,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: getTestimonialSlider(BlocProvider.of<ApplicationDataBloc>(context).testimonials),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        cubit: BlocProvider.of<ApplicationDataBloc>(context),

    );
  }
  Widget getAvailablePackagesView(List<PackageModel> systemPackages) {
    return SizedBox(
      height: 400,
      child: CarouselSlider(
        options: CarouselOptions(height: 400.0 , autoPlay: false , viewportFraction: .7 ),
        //physics: NeverScrollableScrollPhysics(),
        items: systemPackages.map((PackageModel package){
         return PackageHomeScreenListing(package: package , onPackageTap: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PickYourPhotosScreen(userSelectedPackage: package,)));
         },);
        }).toList(),),
    );

  }
  Widget getTestimonialSlider(List<TestimonialViewModel> testimonials) {
         return CarouselSlider(
      options: CarouselOptions(height: 335.0 , autoPlay: true , viewportFraction: .7 ),
      items: testimonials.map((TestimonialViewModel testimonial){
        return TestimonialCard(testimonialViewModel: testimonial,);
      }).toList(),);

  }
  void resolveAutoDispatch(ApplicationDataLoadingFailureState state) {
    if(state.error.errorCode == HttpStatus.requestTimeout){
      BlocProvider.of<ApplicationDataBloc>(context).add(state.failureEvent);
      return;
    }

  }

}




