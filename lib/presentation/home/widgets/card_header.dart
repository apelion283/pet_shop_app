import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget cardHeader(String iconPath, String cardName) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgPicture.asset(
        iconPath,
        width: 30,
        height: 30,
      ),
      SizedBox(
        width: 8,
      ),
      Text(
        cardName,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ).tr()
    ],
  );
}
