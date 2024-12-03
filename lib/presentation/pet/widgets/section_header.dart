import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionHeader extends StatelessWidget {
  final String svgIconPath;
  final String sectionName;
  const SectionHeader(
      {super.key, required this.svgIconPath, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: Divider(
            thickness: 2,
            color: AppColor.black,
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(svgIconPath),
            SizedBox(
              width: 8,
            ),
            Text(sectionName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
          ],
        )
      ],
    );
  }
}
