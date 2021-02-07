import 'package:flutter/material.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/widgets/ListViewAnimatorWidget.dart';
import 'package:picknprint/src/ui/widgets/PickNPrintAppbar.dart';
import 'package:easy_localization/easy_localization.dart' as ll;
import 'package:picknprint/src/ui/widgets/RadioButtonListTile.dart';
class LocationSelectionScreen extends StatelessWidget {
  final List<LocationModel> locationsList ;
  const LocationSelectionScreen({Key key, this.locationsList}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PickNPrintAppbar(
       actions: [],
        centerTitle: true,
        title: (LocalKeys.SELECT_SHIPPING_ADDRESS).tr(),
    ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListViewAnimatorWidget(
          placeHolder: Container(width: 0, height: 0,),
          isScrollEnabled: true,
          // ignore: missing_required_param
          listChildrenWidgets: locationsList.map((e) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: Constants.appLocale == "en" ? TextDirection.ltr: TextDirection.rtl,
              child: RadioButtonListTile<LocationModel>(
                title: Text(e.name),
                isThreeLine: false,
                dense: false,
                onChanged: (LocationModel selectedLocation){
                  Navigator.of(context).pop(selectedLocation);
                },
                value: e,
                activeColor: AppColors.lightBlue,

              ),
            ),
          )).toList(),
        ),
      ),


    );
  }
}
