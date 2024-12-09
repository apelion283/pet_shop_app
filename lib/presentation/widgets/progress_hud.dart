import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class ProgressHUD {
  static void show() {
    EasyLoading.isShow ? dismiss() : () {};
    EasyLoading.show(
        status: Text('loading').tr().data ?? "Loading ...",
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: false);
  }

  static void showError(String status) {
    EasyLoading.isShow ? dismiss() : () {};
    EasyLoading.showError(status,
        duration: Duration(milliseconds: 500),
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: false);
  }

  static void showSuccess(String status) {
    EasyLoading.isShow ? dismiss() : () {};
    EasyLoading.showSuccess(status,
        duration: Duration(milliseconds: 500),
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: true);
  }

  static void dismiss() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
  }
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..displayDuration = const Duration(milliseconds: 1000)
    ..backgroundColor = AppColor.green
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..indicatorColor = AppColor.black
    ..textColor = AppColor.black
    ..maskColor = AppColor.black.withOpacity(0.3)
    ..userInteractions = false;
}
