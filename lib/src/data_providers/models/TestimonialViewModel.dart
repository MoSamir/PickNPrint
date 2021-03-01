import 'package:picknprint/src/data_providers/apis/helpers/ApiParseKeys.dart';
import 'package:picknprint/src/utilities/ParserHelpers.dart';
class TestimonialViewModel {
  String testimonialId , testimonialComment , testimonialImage , testimonialOwner;
  TestimonialViewModel({this.testimonialId, this.testimonialComment, this.testimonialOwner ,this.testimonialImage});

  static TestimonialViewModel fromJson (Map<String,dynamic> testimonialJson){
    return TestimonialViewModel(
      testimonialOwner: testimonialJson[ApiParseKeys.TESTIMONIAL_HEADER_KEY].toString(),
      testimonialComment: testimonialJson[ApiParseKeys.TESTIMONIAL_COMMENT_KEY].toString(),
      testimonialId: testimonialJson[ApiParseKeys.TESTIMONIAL_ID_KEY].toString(),
      testimonialImage: ParserHelper.parseURL(testimonialJson[ApiParseKeys.TESTIMONIAL_IMAGE_KEY].toString()),
    );
  }
  static List<TestimonialViewModel> fromListJson(List<dynamic> testimonialsList){
    List<TestimonialViewModel> testimonials = List<TestimonialViewModel>();
    if(testimonialsList != null && testimonialsList is List){
      for(int i = 0 ; i < testimonialsList.length ; i++){
        testimonials.add(fromJson(testimonialsList[i]));
      }
    }
    return testimonials;
  }


}