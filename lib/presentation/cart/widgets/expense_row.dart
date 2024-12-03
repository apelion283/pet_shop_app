import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExpenseRow extends StatelessWidget {
  final String rowName;
  final String rowValue;
  final TextStyle? rowTextStyle;
  const ExpenseRow(
      {super.key,
      required this.rowName,
      required this.rowValue,
      this.rowTextStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          rowName,
          style: rowTextStyle,
        ).tr(),
        Text(
          rowValue,
          style: rowTextStyle,
        )
      ],
    );
  }
}
