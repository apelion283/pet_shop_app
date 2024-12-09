import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

SnackBar notifySnackBar(
    {required String message, required Function onHideSnackBarButtonClick}) {
  return SnackBar(
    content: Text(message,
        style: TextStyle(
          color: AppColor.black,
        )),
    backgroundColor: AppColor.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    duration: Duration(seconds: 1),
    action: SnackBarAction(
        label: "hide".tr(),
        textColor: AppColor.black,
        onPressed: () {
          onHideSnackBarButtonClick();
        }),
  );
}
