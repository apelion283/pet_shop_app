import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardHeader extends StatelessWidget {
  final String iconPath;
  final String cardName;
  final Function onExploreButtonClick;
  const CardHeader(
      {super.key,
      required this.iconPath,
      required this.cardName,
      required this.onExploreButtonClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        TextButton(
            onPressed: () => onExploreButtonClick(),
            child: Text(
              'explore',
              style: TextStyle(color: Colors.black),
            ).tr())
      ],
    );
  }
}
