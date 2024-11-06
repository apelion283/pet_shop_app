import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

SnackBar notifySnackBar(String message, Function onHideSnackBarButtonClick) {
  return SnackBar(
    content: Text(message,
        style: TextStyle(
          color: AppColor.white,
        )).tr(),
    backgroundColor: AppColor.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    duration: Duration(seconds: 2),
    action: SnackBarAction(
        label: Text('hide').tr().data!,
        textColor: AppColor.white,
        onPressed: () {
          onHideSnackBarButtonClick();
        }),
  );
}
