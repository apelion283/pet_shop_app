import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';

class PetStatusRow extends StatelessWidget {
  final Widget trailing;
  final String name;
  final Widget value;
  final bool isShowDivider;
  final bool isShimmer;
  const PetStatusRow(
      {super.key,
      required this.trailing,
      required this.name,
      required this.value,
      this.isShowDivider = true,
      required this.isShimmer});

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
                  child: isShimmer
                      ? CustomShimmer(
                          child: Container(
                            color: AppColor.gray,
                            child: Text("loading".tr()),
                          ),
                        )
                      : Row(
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
              Expanded(
                  flex: 1,
                  child: isShimmer
                      ? CustomShimmer(
                          child: Container(
                            color: AppColor.gray,
                            child: Text("loading".tr()),
                          ),
                        )
                      : value),
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
