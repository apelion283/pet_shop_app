import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class MarkerInfoHeader extends StatelessWidget {
  final IconData headerIcon;
  final String sectionName;
  const MarkerInfoHeader(
      {super.key, required this.sectionName, required this.headerIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              headerIcon,
              color: AppColor.blue,
            ),
            SizedBox(
              width: 8,
            ),
            Text(sectionName,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.blue))
          ],
        )
      ],
    );
  }
}
