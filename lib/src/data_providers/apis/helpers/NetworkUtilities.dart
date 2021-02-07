import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http ;
import 'package:http/http.dart' show get ;
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picknprint/src/data_providers/models/ErrorViewModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';

class NetworkUtilities {
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static Future<ResponseViewModel<dynamic>> handleGetRequest(
      {String methodURL,
        Map<String, String> requestHeaders,
        Function parserFunction}) async {
    ResponseViewModel getResponse;

    try {
      var serverResponse = await http.get(methodURL, headers: requestHeaders);
      if (serverResponse.statusCode == 200) {
        getResponse = ResponseViewModel(
          isSuccess: true,
          errorViewModel: null,
          responseData: parserFunction(json.decode(serverResponse.body)),
        );
      } else {
        getResponse = handleError(serverResponse);
      }
    } on SocketException {
      getResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: Constants.CONNECTION_TIMEOUT,
        responseData: null,
      );
    } catch (exception) {

      debugPrint("Exception in Get ==>");
      print(exception);
      debugPrint("********************");


      getResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }
    networkLogger(
        url: methodURL,
        body: '',
        headers: requestHeaders,
        response: getResponse);
    return getResponse;
  }

  static Future<ResponseViewModel> handlePostRequest(
      {bool acceptJson = false,
        String methodURL,
        Map<String, String> requestHeaders,
        Map<String, dynamic> requestBody,
        Function parserFunction}) async {
    ResponseViewModel postResponse;
    try {
      http.Response serverResponse = await http.post(methodURL,
          headers: requestHeaders,
          body: acceptJson ? json.encode(requestBody) : requestBody);
      if (serverResponse.statusCode == HttpStatus.ok) {
        postResponse = ResponseViewModel(
          isSuccess: true,
          errorViewModel: null,
          responseData: parserFunction(json.decode(serverResponse.body)),
        );
      } else {
        postResponse = handleError(serverResponse);
      }
    } on SocketException {
      postResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: Constants.CONNECTION_TIMEOUT,
        responseData: null,
      );
    } catch (exception) {
      debugPrint("Exception in Post ==>");
      print(exception);
      debugPrint("********************");
      postResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }
    networkLogger(
        url: methodURL,
        body: requestBody,
        headers: requestHeaders,
        response: postResponse);
    return postResponse;
  }



  static Future<ResponseViewModel> handleUploadSingleFile(
      {String methodURL,
        Map<String, String> requestHeaders,
        Function parserFunction,
        String uploadKey ,
        String fileURL,
        Map<String, dynamic> requestBody,
        bool isBodyJson}) async {
    ResponseViewModel uploadResponse;
    try {
      
      requestHeaders.putIfAbsent('Accept', () => 'multipart/form-data');
      MultipartFile imageFile = await MultipartFile.fromFile(fileURL);
      Map<String, dynamic> requestMap = requestBody ?? Map<String, dynamic>();
      requestMap.putIfAbsent(uploadKey, () => imageFile);




      FormData formData = FormData.fromMap(requestMap);
      Response serverResponse = await Dio().post(methodURL,
          data: formData,
          options: Options(
            headers: requestHeaders,
          ));

      if (serverResponse.statusCode == 200) {
        uploadResponse = ResponseViewModel(
          isSuccess: true,
          errorViewModel: null,
          responseData: parserFunction(serverResponse.data),
        );
      }
      else {
        String serverError = "";
        try {
          serverError = json.decode(serverResponse.data)['error'] ??
              json.decode(serverResponse.data)['message'];
        } catch (exception) {
          serverError = serverResponse.data;
        }
        uploadResponse = ResponseViewModel(
          isSuccess: false,
          errorViewModel: ErrorViewModel(
            errorMessage: serverError,
            errorCode: serverResponse.statusCode,
          ),
          responseData: null,
        );

        if (uploadResponse.errorViewModel.errorCode == HttpStatus.notFound) {
          uploadResponse = ResponseViewModel(
            isSuccess: false,
            errorViewModel: ErrorViewModel(
              errorMessage: (LocalKeys.SERVER_UNREACHABLE).tr(),
              errorCode: serverResponse.statusCode,
            ),
            responseData: null,
          );
        }
      }
    } on SocketException {
      uploadResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: Constants.CONNECTION_TIMEOUT,
        responseData: null,
      );
    } catch (exception) {

      print("*************************************");
      print("Exception in upload => $exception");
      print("Exception Message => ${(exception as DioError).message}");
      print("Exception Error => ${(exception as DioError).error}");
      print("Exception Response => ${(exception as DioError).response}");
      print("*************************************");
      uploadResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }
    return uploadResponse;
  }


  static Future<ResponseViewModel> handlePutRequest(
      {bool acceptJson = false,
        String methodURL,
        Map<String, String> requestHeaders,
        Map<String, dynamic> requestBody,
        Function parserFunction}) async {
    ResponseViewModel postResponse;
    try {
      http.Response serverResponse = await http.put(methodURL,
          headers: requestHeaders,
          body: acceptJson ? json.encode(requestBody) : requestBody);
      if (serverResponse.statusCode == HttpStatus.ok) {
        postResponse = ResponseViewModel(
          isSuccess: true,
          errorViewModel: null,
          responseData: parserFunction(json.decode(serverResponse.body)),
        );
      } else {
        postResponse = handleError(serverResponse);
      }
    } on SocketException {
      postResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: Constants.CONNECTION_TIMEOUT,
        responseData: null,
      );
    } catch (exception) {
      debugPrint("Exception in Put ==>");
      print(exception);
      debugPrint("********************");
      postResponse = ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }
    networkLogger(
        url: methodURL,
        body: requestBody,
        headers: requestHeaders,
        response: postResponse);
    return postResponse;
  }


  static Map<String, String> getHeaders({Map<String, String> customHeaders}) {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };

    if (customHeaders != null) {
      for (int i = 0; i < customHeaders.length; i++) {
        headers.putIfAbsent(customHeaders.keys.toList()[i],
                () => customHeaders[customHeaders.keys.toList()[i]]);
      }
    }
    return headers;
  }

  static void networkLogger({url, headers, body, ResponseViewModel response}) {
    debugPrint('---------------------------------------------------');
    debugPrint('URL => $url');
    debugPrint('headers => $headers');
    debugPrint('Body => $body');
    debugPrint('Response => ${response.toString()}');
    debugPrint('---------------------------------------------------');
  }

  static ResponseViewModel handleError(http.Response serverResponse) {


    print("Error Happened in API => ");
    print(serverResponse.body);
    print("***************************");

    ResponseViewModel responseViewModel;
    if (serverResponse.statusCode == HttpStatus.notFound || serverResponse.statusCode == HttpStatus.internalServerError) {
      responseViewModel = ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorMessage: (LocalKeys.SERVER_UNREACHABLE).tr(),
          errorCode: serverResponse.statusCode,
        ),
        responseData: null,
      );
    }
    else if (serverResponse.statusCode == 422) {
      List<String> errors = List();
      try {
        (json.decode(serverResponse.body)['errors'] as Map<String, dynamic>).forEach((key, value) {
          if (value is List<String>) errors.addAll(value);
          else if (value is List<dynamic>) {
            for (int i = 0; i < value.length; i++)
              errors.add(value[i].toString());
          } else if (value is String) errors.add(value);
        });
      } catch (exception) {
        debugPrint("Exception => $exception");
      }
      responseViewModel = ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorMessage: errors.length > 0
              ? errors.join(',')
              : (LocalKeys.SERVER_UNREACHABLE).tr(),
          errorCode: serverResponse.statusCode,
        ),
        responseData: null,
      );
    } else {
      debugPrint("Server Response not OK => ${serverResponse.body}");
      String serverError = "";
      try {
        serverError = json.decode(serverResponse.body)['error'] ??
            json.decode(serverResponse.body)['message'];
      } catch (exception) {
        serverError = serverResponse.body;
      }
      responseViewModel = ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorMessage: serverError,
          errorCode: serverResponse.statusCode,
        ),
        responseData: null,
      );
    }
    return responseViewModel;
  }

  static Future<ResponseViewModel<File>>getImageFile(String imageURL) async {
    try{
      var response = await get(imageURL);
      var documentDirectory = await getApplicationDocumentsDirectory();
      File file = new File('${documentDirectory.path}/imagetest.png');
      file.writeAsBytesSync(response.bodyBytes);
      return ResponseViewModel(
        responseData: file,
        isSuccess: true,
      ) ;
    } catch(error){
      return ResponseViewModel(
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorCode: 500,
          errorMessage: (LocalKeys.UNABLE_TO_READ_IMAGE).tr(),
        ),
      ) ;
    }
  }
}
