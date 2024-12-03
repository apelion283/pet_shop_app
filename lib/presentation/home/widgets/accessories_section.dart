import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/vertical_merchandise_item.dart';

class AccessoriesSection extends StatelessWidget {
  final List<MerchandiseItem>? accessoryList;
  final bool isShimmer;
  const AccessoriesSection({super.key, required this.accessoryList, required this.isShimmer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(
          iconPath: "assets/icons/ic_pet_accessories.svg",
          cardName: 'pet_accessories',
          onExploreButtonClick: () {
            Navigator.of(context).pushNamed(RouteName.explore);
          },
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: accessoryList != null
                ? Row(
                    children: List.generate(accessoryList!.length, (index) {
                    return Row(
                      children: [
                        VerticalMerchandiseItem(
                          isShimmer: isShimmer,
                            item: accessoryList![index],
                            onItemClick: () {
                              AnalyticsService().viewProductLog(
                                  currency: context.locale.toString() == "vi_VI"
                                      ? "đ"
                                      : context.locale.toString() == "en_EN"
                                          ? "\$"
                                          : "đ",
                                  itemValue: accessoryList![index].price *
                                      (context.locale.toString() == "vi_VI"
                                          ? CurrencyRate.vnd
                                          : context.locale.toString() == "en_EN"
                                              ? 1
                                              : CurrencyRate.vnd),
                                  item: accessoryList![index]);
                              Navigator.pushNamed(
                                  context, RouteName.merchandiseDetail,
                                  arguments: MerchandiseItemPageArguments(
                                      itemId: accessoryList![index].id ?? ""));
                            }),
                        SizedBox(
                          width: 8,
                        )
                      ],
                    );
                  }))
                : SizedBox(
                    height: 50,
                    child: Center(
                        child: Text(
                      'there_is_no_data',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ).tr()),
                  ))
      ],
    );
  }
}
