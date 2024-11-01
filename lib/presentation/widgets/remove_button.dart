import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class RemoveButton extends StatelessWidget {
  final Function onButtonClick;
  const RemoveButton({super.key, required this.onButtonClick});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          onButtonClick();
        },
        icon: Icon(
          Icons.remove,
          color: AppColor.green,
        ));
  }
}
