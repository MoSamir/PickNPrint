import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picknprint/src/data_providers/models/TestimonialViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/ui/widgets/EnhancedImageNetwork.dart';

class TestimonialCard extends StatelessWidget {
  final TestimonialViewModel testimonialViewModel;
  TestimonialCard({this.testimonialViewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: AppColors.lightGrey,
          spreadRadius: 2.5,
          blurRadius: 5.0,
        ),]
      ),
      height: 300,
      width: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Card(
          elevation: 2,
          //padding: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(testimonialViewModel.testimonialImage) , fit: BoxFit.fill),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Text(testimonialViewModel.testimonialComment , textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
