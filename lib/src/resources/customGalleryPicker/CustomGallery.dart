import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picknprint/src/ui/widgets/LoadingWidget.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import '../AppStyles.dart';
import '../LocalKeys.dart';

class CustomGallery extends StatefulWidget {
  @override
  _CustomGalleryState createState() => _CustomGalleryState();
}
class _CustomGalleryState extends State<CustomGallery> {
  List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage;
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }
  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(onlyAll: true , filterOption: FilterOptionGroup());
      print(albums);
      List<AssetEntity> media =
      await albums[0].getAssetListPaged(currentPage, 60);
      List<Widget> temp = [];
      for (var asset in media) {
        if(asset.typeInt == 1) {

          temp.add(
            FutureBuilder(
              future: asset.thumbDataWithSize(200, 200),
              builder: (BuildContext context, snapshot) {
                bool largerThanMinimumSize = asset.width >= 1024 && asset.height >= 1024;
                bool smallerThanMaximumSize = asset.width < 4096 && asset.height < 4096;

                if (snapshot.connectionState == ConnectionState.done)
                  return GestureDetector(
                    onTap: () async{
                      if(largerThanMinimumSize && smallerThanMaximumSize){
                        File file = await asset.file;
                        Navigator.pop(context , file.path);
                      } else {
                        String imageFilePath = await showDialog(context: context, builder: (context)=> AlertDialog(
                          title: Text((LocalKeys.LOW_QUALITY_HEADER).tr()),
                          actions: [
                            FlatButton(
                              child: Text((LocalKeys.SELECT_ANYWAY).tr()),
                              onPressed: ()async{
                                File file = await asset.file;
                                Navigator.pop(context , file.path);
                              },
                            ),
                            FlatButton(
                              child: Text((LocalKeys.DONT_SELECT).tr()),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((LocalKeys.LOW_QUALITY_IMAGE_MESSAGE).tr()),
                          ),
                        ));
                        if(imageFilePath != null){
                          Navigator.pop(context, imageFilePath);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Material(
                          elevation: 2,
                          type: MaterialType.card,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Image.memory(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if((largerThanMinimumSize == false) || (smallerThanMaximumSize == false))
                                Positioned.fill(child: Container(
                                  color: AppColors.lightBlack.withOpacity(.8),
                                )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                return Container(
                  child: Center(child: LoadingWidget(),),
                );
              },
            ),
          );
        }
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PickNPrintAppbar(
          actions: [],
          autoImplyLeading: true,
          appbarColor: AppColors.lightBlack,
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            _handleScrollEvent(scroll);
            return;
          },
          child: GridView.builder(
              itemCount: _mediaList.length,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return _mediaList[index];
              }),
        ),
      ),
    );
  }
}

