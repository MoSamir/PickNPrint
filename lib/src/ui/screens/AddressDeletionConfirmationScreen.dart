import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';
import 'package:picknprint/src/bloc/events/UserBlocEvents.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/widgets/NetworkErrorView.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:picknprint/src/utilities/UIHelpers.dart';

class AddressDeletionConfirmationScreen extends StatefulWidget {

  final AddressViewModel addressModel ;
  AddressDeletionConfirmationScreen({this.addressModel});

  @override
  _AddressDeletionConfirmationScreenState createState() => _AddressDeletionConfirmationScreenState();
}

class _AddressDeletionConfirmationScreenState extends State<AddressDeletionConfirmationScreen> {



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.CURRENT_LOCALE == 'en' ? TextDirection.ltr : TextDirection.rtl,

      child: Scaffold(
        backgroundColor: AppColors.blackBg,
        body: BlocConsumer(
          listener: (context, state) async{
            if (state is UserDataLoadingFailedState)  {
              if (state.error.errorCode == HttpStatus.requestTimeout) {
                UIHelpers.showNetworkError(context);
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
          builder: (context, state){
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .25,
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 1,
                              )
                            ),
                            child: Center(child: Icon(Icons.close , color: AppColors.white, size: 25,)),

                          ),
                          Text((LocalKeys.CANCEL_LABEL).tr() , style: TextStyle(
                            color: AppColors.white,
                          ),)
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((LocalKeys.DELETION_CONFIRMATION_MESSAGE).tr(), style: TextStyle(
                          color: AppColors.white,
                        ),),
                        SizedBox(height: 5,),
                        Material(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          type: MaterialType.card,
                          elevation: 2,
                          color: AppColors.offWhite,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0 , horizontal: 8.0),
                              child: Text(widget.addressModel.toString() , style: TextStyle(
                                color: AppColors.black,
                              ),),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: _deleteAddress,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                            ),
                            child: Center(child: Text((LocalKeys.DELETE_ADDRESS).tr(), style: TextStyle(color: AppColors.white),)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



              ],
            );
          },
          cubit: BlocProvider.of<UserBloc>(context),
        ),
      ),
    );
  }

  void _deleteAddress() {
    BlocProvider.of<UserBloc>(context).add(DeleteAddress(address: widget.addressModel));

  }
}
