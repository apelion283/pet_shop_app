import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/vertical_merchandise_item.dart';

class AccessoriesSection extends StatelessWidget {
  final List<MerchandiseItem>? accessoryList;
  const AccessoriesSection({super.key, required this.accessoryList});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.gray.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
          child: Column(
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
                          children:
                              List.generate(accessoryList!.length, (index) {
                          return verticalMerchandiseItem(
                              item: accessoryList![index],
                              onItemClick: () {
                                Navigator.pushNamed(
                                    context, RouteName.merchandiseDetail,
                                    arguments: MerchandiseItemPageArguments(
                                        itemId:
                                            accessoryList![index].id ?? ""));
                              });
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
          ),
        ));
  }
}
