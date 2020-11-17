import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';

import 'helpers/NetworkUtilities.dart';
import 'helpers/URL.dart';

class ApplicationDataProvider {

  static Future<ResponseViewModel<List<PackageModel>>> getSystemPackages() async{

    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders();
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_SYSTEM_PACKAGES);
    ResponseViewModel systemSupportedLocationResponse = await NetworkUtilities.handleGetRequest(
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (systemSupportedLocationRawResponse){
        return PackageModel.fromListJson(systemSupportedLocationRawResponse[ApiParseKeys.PACKAGE_LIST_ROOT]);
      },
    );

    return ResponseViewModel<List<PackageModel>>(
      responseData: systemSupportedLocationResponse.responseData,
      isSuccess: systemSupportedLocationResponse.isSuccess,
      errorViewModel: systemSupportedLocationResponse.errorViewModel,
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