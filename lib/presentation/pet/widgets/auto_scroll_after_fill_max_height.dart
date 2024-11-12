import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AutoScrollAfterFillMaxHeight extends StatelessWidget {
  final double maxHeight;
  final TextStyle textStyle;
  final int? maxLines;
  final TextDirection? direction;
  final String textToShow;
  const AutoScrollAfterFillMaxHeight(
      {super.key,
      required this.maxHeight,
      required this.textToShow,
      required this.textStyle,
      this.maxLines,
      this.direction = ui.TextDirection.ltr});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
            text: TextSpan(
              text: textToShow,
              style: textStyle, // Đặt style của text
            ),
            maxLines: maxLines,
            textDirection: direction);
        textPainter.layout(maxWidth: constraints.maxWidth);

        if (textPainter.size.height <= maxHeight) {
          return Column(
            children: [
              Text(textToShow),
            ],
          );
        } else {
          return SizedBox(
            height: maxHeight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(textToShow),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
