import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final Function onCardClick;

  const ProfileCard(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.onCardClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.green,
      child: ListTile(
        leading: Icon(leadingIcon, color: AppColor.white),
        title: Text(
          title,
          style: TextStyle(color: AppColor.white),
        ).tr(),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColor.white),
        onTap: () {
          onCardClick();
        },
      ),
    );
  }
}
