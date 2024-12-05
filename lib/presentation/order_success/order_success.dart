import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/core/static/payment_successful_animation.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentSuccessfulAnimation(),
            Text(
              "successful".tr(),
              style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Text("your_purchase_was_done").tr(),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: AppColor.black),
                  onPressed: () {
                    CommonPageController.controller
                        .jumpToPage(ScreenInBottomBarOfMainScreen.home.index);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, color: AppColor.green),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "back_to_home".tr(),
                        style: TextStyle(color: AppColor.green),
                      )
                    ],
                  )),
            )
          ],
        )),
      ),
    );
  }
}
