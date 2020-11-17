import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picknprint/src/resources/AppStyles.dart';

class LoadingWidget extends StatelessWidget {
  final double size ;
  LoadingWidget({this.size});
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: size ?? 40,
      color: AppColors.lightBlue,
    );
  }
}
