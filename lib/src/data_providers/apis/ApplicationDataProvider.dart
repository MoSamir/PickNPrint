import 'package:picknprint/src/data_providers/models/PackageModel.dart';
import 'package:picknprint/src/data_providers/models/ResponseViewModel.dart';

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

  
}