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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 2,
            color: AppColors.addressCardBg,
            child: RadioButtonListTile<AddressViewModel>(
              key: GlobalKey(),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(address.toString() , textAlign: TextAlign.start,),
                ),
                groupValue: isChecked ? address : null,
                value: address,
                selected: isChecked,
                onChanged: (AddressViewModel value){
                onSelectAddress(value);
                return ;
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    onEditAddress(address);
                    return;
                  },
                 child: Text((LocalKeys.EDIT_ADDRESS).tr()),

                ),
                SizedBox(width: 10,),
                Container(
                  height: 10, width: 3,
                  color: AppColors.lightBlack,
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: (){
                    onDeleteAddress(address);
                    return;
                  },
                  child: Text((LocalKeys.DELETE_ADDRESS).tr()),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
