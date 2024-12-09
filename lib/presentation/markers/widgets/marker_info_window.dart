import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/marker.dart';

class MarkerInfoWindow extends StatelessWidget {
  final Marker item;
  final Function onCancelButtonClick;
  final Function onViewDetailButtonClick;
  const MarkerInfoWindow(
      {super.key,
      required this.item,
      required this.onCancelButtonClick,
      required this.onViewDetailButtonClick});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.gray.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 1,
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  IconButton(
                      onPressed: () {
                        onCancelButtonClick();
                      },
                      icon: Icon(Icons.cancel_outlined)),
                ],
              ),
              Text(
                item.description,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                  child: Text(
                "phone_number".tr(args: [item.phoneNumber]),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColor.blue),
              )),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  ElevatedButton(
                      onPressed: () {
                        onViewDetailButtonClick();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: Text(
                        "view_detail".tr(),
                        style: TextStyle(color: AppColor.black),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
