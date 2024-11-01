import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class AddButton extends StatelessWidget {
  final Function onButtonClick;
  const AddButton({super.key, required this.onButtonClick});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          onButtonClick();
        },
        icon: Icon(
          Icons.add,
          color: AppColor.green,
        ));
  }
}
