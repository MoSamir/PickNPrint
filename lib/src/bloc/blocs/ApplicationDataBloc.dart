
import 'package:bloc/bloc.dart';
import 'package:picknprint/src/Repository.dart';
import 'package:picknprint/src/bloc/events/ApplicationDataEvents.dart';
import 'package:picknprint/src/bloc/states/ApplicationDataState.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';

class ApplicationDataBloc extends Bloc<ApplicationDataEvents , ApplicationDataStates>{

  ApplicationDataBloc(ApplicationDataStates initialState) : super(initialState);


  List<PackageModel> applicationPackages = List();
  int maxPackageSize  = 0 ;
  String contactUsPhone = "01013615170";
  List<LocationModel> systemSupportedLocations = List<LocationModel>();


  @override
  Stream<ApplicationDataStates> mapEventToState(ApplicationDataEvents event)async* {

    bool isConnected =  await NetworkUtilities.isConnected();
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


    List<ResponseViewModel> applicationData = await Future.wait([
      Repository.getSystemPackages(),
      Repository.getSystemSupportedAreas(),
    ]);
    if(applicationData[0].isSuccess){
      applicationPackages = applicationData[0].responseData;
      maxPackageSize = applicationPackages.reversed.toList()[0].packageSize;
    }
    if(applicationData[1].isSuccess){
      systemSupportedLocations = applicationData[1].responseData;
    }

    if(applicationData[0].isSuccess == false){
      yield ApplicationDataLoadingFailureState(error: applicationData[0].errorViewModel , failureEvent: event);
      return;
    }
    if(applicationData[1].isSuccess == false){
      yield ApplicationDataLoadingFailureState(error: applicationData[1].errorViewModel , failureEvent: event);
      return;
    }

    yield ApplicationDataLoadedState();
    return;
  }
}