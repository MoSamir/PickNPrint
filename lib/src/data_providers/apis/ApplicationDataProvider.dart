import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';

import 'helpers/NetworkUtilities.dart';
import 'helpers/URL.dart';

class ApplicationDataProvider {

  static Future<ResponseViewModel<List<PackageModel>>> getSystemPackages() async{
    await Future.delayed(Duration(seconds:2),(){});
    return ResponseViewModel<List<PackageModel>>(
      isSuccess:true,
      responseData: [
        PackageModel(
          packagePrice: 120,
          packageSaving: 30,
          packageSize: 3,
        ),
        PackageModel(
          packagePrice: 120,
          packageSaving: 30,
          packageSize: 4,
        ),
        PackageModel(
          packagePrice: 120,
          packageSaving: 30,
          packageSize: 6,
        ),
      ],
      errorViewModel: null,
    );
  }

  static Future<ResponseViewModel<List<LocationModel>>> getSystemSupportedAreas() async {

    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders();
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_SUPPORTED_CITIES);
    ResponseViewModel systemSupportedLocationResponse = await NetworkUtilities.handleGetRequest(
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (systemSupportedLocationRawResponse){
        return LocationModel.fromListJson(systemSupportedLocationRawResponse[ApiParseKeys.SYSTEM_LOCATIONS_ROOT]);
      },
    );

    return ResponseViewModel<List<LocationModel>>(
      responseData: systemSupportedLocationResponse.responseData,
      isSuccess: systemSupportedLocationResponse.isSuccess,
      errorViewModel: systemSupportedLocationResponse.errorViewModel,
    );


  }

  
}