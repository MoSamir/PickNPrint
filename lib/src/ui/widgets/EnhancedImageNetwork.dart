import 'package:flutter/material.dart';

class EnhancedImageNetwork extends StatelessWidget {

  final ImageProvider  placeHolder;
  final String image;
  final double width , height ;
  final BoxFit fit;
  final bool constrained ;

  EnhancedImageNetwork( this.image ,{this.placeHolder , this.width , this.height , this.fit , this.constrained});

  @override
  Widget build(BuildContext context) {
    return constrained ? SizedBox(width: width ?? 50, height: height ?? 50, child: FadeInImage(
      imageErrorBuilder: (BuildContext context,
          Object exception,
          StackTrace stackTrace) {
        return Image(image: placeHolder,) ??  Image.asset('assets/images/app_logo.png' , width: width ?? 50, height: height ?? 50,);
      },
      fit: fit ?? BoxFit.cover,
      width: width ?? 50,
      height: height ?? 50,
      placeholder: placeHolder ?? AssetImage('assets/images/app_logo.png') ,
      image: NetworkImage(image ?? ''),
    ),) :
    FadeInImage(
      imageErrorBuilder: (BuildContext context,
          Object exception,
          StackTrace stackTrace) {
        return Image(image: placeHolder,) ?? Image.asset(
            'assets/images/app_logo.png');
      },
      fit: fit ?? BoxFit.cover,
      placeholder: placeHolder ?? AssetImage(
          'assets/images/app_logo.png'),
      image:NetworkImage(image ?? ''),
    );
  }
}
