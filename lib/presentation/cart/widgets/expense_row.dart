import 'package:flutter/material.dart';

class ExpenseRow extends StatelessWidget {
  final String rowName;
  final String rowValue;
  final TextStyle rowTextStyle;
  const ExpenseRow(
      {super.key,
      required this.rowName,
      required this.rowValue,
      required this.rowTextStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          rowName,
          style: rowTextStyle,
        ),
        Text(
          "\$$rowValue",
          style: rowTextStyle,
        )
      ],
    );
  }
}
