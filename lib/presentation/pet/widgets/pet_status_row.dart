import 'package:flutter/material.dart';

class PetStatusRow extends StatelessWidget {
  final Widget trailing;
  final String name;
  final Widget value;
  final bool isShowDivider;
  const PetStatusRow(
      {super.key,
      required this.trailing,
      required this.name,
      required this.value,
      this.isShowDivider = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      trailing,
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
              Expanded(flex: 1, child: value),
            ],
          ),
          isShowDivider
              ? Divider(
                  thickness: 2,
                )
              : SizedBox()
        ],
      ),
    );
  }
}
