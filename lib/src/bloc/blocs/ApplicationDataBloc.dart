import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/ApplicationDataEvents.dart';
import 'package:picknprint/src/bloc/states/ApplicationDataState.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';

class ApplicationDataBloc extends Bloc<ApplicationDataEvents , ApplicationDataStates>{

  ApplicationDataBloc(ApplicationDataStates initialState) : super(initialState);


  List<PackageModel> applicationPackages = List();
  int maxPackageSize  = 0 ;
  String contactUsPhone = "01013615170";


  @override
  Stream<ApplicationDataStates> mapEventToState(ApplicationDataEvents event)async* {

    bool isConnected = await NetworkUtilities.isConnected();
    if(isConnected == false){
      yield ApplicationDataLoadingFailureState(
        error: Constants.CONNECTION_TIMEOUT,
        failureEvent: event,
      );
      return ;
    }
    if(event is LoadApplicationData){
      yield* _handleApplicationDataLoading(event);
      return ;
    }
  }

  Stream<ApplicationDataStates> _handleApplicationDataLoading(LoadApplicationData event) async*{
    yield ApplicationDataLoadingState();
    ResponseViewModel<List<PackageModel>> getSystemPackagesResponse = await Repository.getSystemPackages();
    if(getSystemPackagesResponse.isSuccess){
      applicationPackages = getSystemPackagesResponse.responseData;
      maxPackageSize = applicationPackages.reversed.toList()[0].packageSize;
      yield ApplicationDataLoadedState();
      return;
    } else {
      yield ApplicationDataLoadingFailureState(
        failureEvent: event,
        error: getSystemPackagesResponse.errorViewModel
      );
      return ;
    }


  }
}