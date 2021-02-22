import 'dart:io';

import 'package:picknprint/src/data_providers/apis/UserDataProvider.dart';
import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/data_providers/models/TestimonialViewModel.dart';
import 'package:picknprint/src/data_providers/shared_preference/UserSharedPreference.dart';
import 'package:picknprint/src/utilities/ParserHelpers.dart';
import 'package:picknprint/src/data_providers/apis/helpers/NetworkUtilities.dart';
import 'package:picknprint/src/data_providers/apis/helpers/URL.dart';

class ApplicationDataProvider {

  static Future<ResponseViewModel<List<PackageModel>>> getSystemPackages() async{

    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders();
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_SYSTEM_PACKAGES);
    ResponseViewModel systemSupportedLocationResponse = await NetworkUtilities.handleGetRequest(
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (systemSupportedLocationRawResponse){
        double framePriceBeforeDiscount = ParserHelper.parseDouble(systemSupportedLocationRawResponse[ApiParseKeys.NORMAL_FRAME_PRICE].toString());
        double framePriceAfterDiscount = ParserHelper.parseDouble(systemSupportedLocationRawResponse[ApiParseKeys.EXTRA_FRAME_PRICE].toString());
        int discountStartFrom = int.parse((systemSupportedLocationRawResponse[ApiParseKeys.DISCOUNT_AFTER_FRAME]).toString());
       discountStartFrom -=1;
        return PackageModel.fromListJson(systemSupportedLocationRawResponse[ApiParseKeys.PACKAGE_LIST_ROOT] , framePriceAfterDiscount , framePriceBeforeDiscount , discountStartFrom);
      },
    );

    ResponseViewModel<List<PackageModel>> packages = ResponseViewModel<List<PackageModel>>(
      responseData: systemSupportedLocationResponse.responseData,
      isSuccess: systemSupportedLocationResponse.isSuccess,
      errorViewModel: systemSupportedLocationResponse.errorViewModel,
    );

    return packages;



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
  static Future<ResponseViewModel<String>> getSystemContactInfo() async {

    Map<String,dynamic> requestHeader = NetworkUtilities.getHeaders();
    String apiURL = URL.getURL(apiPath: URL.GET_RETRIEVE_SYSTEM_INFO);
    ResponseViewModel systemSupportedLocationResponse = await NetworkUtilities.handleGetRequest(
      requestHeaders: requestHeader,
      methodURL: apiURL,
      parserFunction: (systemContactInfoRawResponse){
        return systemContactInfoRawResponse[ApiParseKeys.SYSTEM_SETTINGS_KEY][ApiParseKeys.SYSTEM_PHONE_KEY];
      },
    );
    return ResponseViewModel<String>(
      responseData: systemSupportedLocationResponse.responseData,
      isSuccess: systemSupportedLocationResponse.isSuccess,
      errorViewModel: systemSupportedLocationResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<String>>> uploadMultipleFiles(List<String> filesToBeUploaded) async{
    String token = await UserSharedPreference.getUserToken();
    Map<String,dynamic> requestHeaders = NetworkUtilities.getHeaders(customHeaders: {
      HttpHeaders.authorizationHeader : 'Bearer $token',
    });


    print("************************************************");
    for(int i = 0 ; i < filesToBeUploaded.length ; i++){
      print("File => ${filesToBeUploaded[i]}");
    }
    print("************************************************");

    List<Future<ResponseViewModel>> uploadFileTasks = filesToBeUploaded.map((e) => NetworkUtilities.handleUploadBinaryFile(
      fileURL: e,
      methodURL: '${URL.POST_UPLOAD_IMAGE}${DateTime.now().toString()}',
      requestHeaders: {},
      uploadKey: 'image',
      parserFunction: (Map<String,dynamic> jsonResponse){
        print("JsonResponse => $jsonResponse");
        return jsonResponse['url'];
      }
    )).toList();



    List<ResponseViewModel> responses =  await Future.wait(uploadFileTasks);
    List<String> urls = List<String>();

    for(int i = 0 ; i < responses.length ; i++){
      if(responses[i].isSuccess){
        urls.add(responses[i].responseData);
      } else {
        return ResponseViewModel<List<String>>(
          isSuccess: false,
          errorViewModel: responses[i].errorViewModel,
        );
      }
    }
    return ResponseViewModel<List<String>>(
      isSuccess: true,
      responseData: urls,
    );
  }

  static Future<ResponseViewModel<List<TestimonialViewModel>>> getTestimonials() async{

    String url = URL.getURL(apiPath: URL.GET_APPLICATION_TESTIMONIALS);
    Map<String,dynamic> requestHeaders = NetworkUtilities.getHeaders();
    ResponseViewModel testimonialsListResponse = await NetworkUtilities.handleGetRequest(
      methodURL: url,
      requestHeaders: requestHeaders,
      parserFunction: (Map<String,dynamic> testimonialsResponse){
        return TestimonialViewModel.fromListJson(testimonialsResponse['testimonials']);
      }
    );

    return ResponseViewModel<List<TestimonialViewModel>>(
      isSuccess: testimonialsListResponse.isSuccess,
      errorViewModel: testimonialsListResponse.errorViewModel,
      responseData: testimonialsListResponse.responseData,
    );
  }

  
}