import 'package:picknprint/src/resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSharedPreference {

  static Future<void> saveImageToKey(String imageString , String preferenceKey) async{
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    List<String> getPreviousImages = await getImagesList(preferenceKey);
    getPreviousImages.add(imageString);
    await mSharedPreference.setStringList(preferenceKey, getPreviousImages);
  }
  static Future<List<String>> getImagesList(String preferenceKey) async{
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    if(mSharedPreference.containsKey(preferenceKey)){
      return mSharedPreference.getStringList(preferenceKey);
    } else {
      return [];
    }
  }

}