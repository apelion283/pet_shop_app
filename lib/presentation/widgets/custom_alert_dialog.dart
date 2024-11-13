import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class CustomAlertDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String positiveButtonText;
  final String negativeButtonText;
  final Function onPositiveButtonClick;
  final Function onNegativeButtonClick;
  const CustomAlertDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.positiveButtonText,
    required this.negativeButtonText,
    required this.onPositiveButtonClick,
    required this.onNegativeButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColor.green,
          ),
          Flexible(
              child: Text(
            title,
            style: TextStyle(color: AppColor.green),
          ).tr())
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message).tr(),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    onNegativeButtonClick();
                  },
                  child: Text(
                    negativeButtonText,
                    style: TextStyle(color: Colors.black),
                  ).tr()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPositiveButtonClick();
                  },
                  child: Text(
                    positiveButtonText,
                    style: TextStyle(color: AppColor.white),
                  ).tr())
            ],
          )
        ],
      ),
    );
  }
}
