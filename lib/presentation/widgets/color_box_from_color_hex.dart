import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class ColorBoxFromColorHex extends StatelessWidget {
  final String colorName;
  final double width;
  final double height;
  const ColorBoxFromColorHex(
      {super.key,
      required this.colorName,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: getColor(colorName), border: Border.all(color: AppColor.gray)),
    );
  }

  Color getColor(String colorName) {
    final buffer = StringBuffer();
    if (colorName.length == 6 || colorName.length == 7) buffer.write('ff');
    buffer.write(colorName.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
