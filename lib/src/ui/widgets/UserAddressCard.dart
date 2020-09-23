import 'package:flutter/material.dart';
import 'package:picknprint/src/data_providers/models/AddressViewModel.dart';
import 'package:picknprint/src/resources/AppStyles.dart';
import 'package:picknprint/src/resources/LocalKeys.dart';
import 'package:picknprint/src/ui/widgets/RadioButtonListTile.dart';
import 'package:easy_localization/easy_localization.dart';
class UserAddressCard extends StatelessWidget {

  final AddressViewModel address;
  final bool isChecked ;
  final Function onEditAddress , onDeleteAddress , onSelectAddress;

  UserAddressCard({this.address, this.onEditAddress,this.isChecked ,this.onDeleteAddress,
    this.onSelectAddress});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          elevation: 2,
          color: AppColors.addressCardBg,
          child: RadioButtonListTile<AddressViewModel>(
              title: Text(address.toString()),
              groupValue: address , value: address, selected: isChecked, onChanged: (AddressViewModel value){
              onSelectAddress(value);
              return ;
          }),
        ),
        Row(
          children: <Widget>[

            GestureDetector(
              onTap: (){
                onEditAddress(address);
                return;
              },
             child: Text((LocalKeys.EDIT_ADDRESS).tr()),

            ),
            Container(
              height: 10, width: 1,
              color: AppColors.lightBlack,
            ),
            GestureDetector(
              onTap: (){
                onDeleteAddress(address);
                return;
              },
              child: Text((LocalKeys.DELETE_ADDRESS).tr()),

            ),
          ],
        ),

      ],
    );
  }
}
