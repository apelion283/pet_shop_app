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
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              cardHeader(
                  "assets/icons/ic_pet_accessories.svg", "Pet Accessories"),
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
                                        accessoryList![index].id ?? ""));
                              });
                        }))
                      : SizedBox(
                          height: 50,
                          child: Center(
                              child: Text(
                            "There is no data here",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          )),
                        ))
            ],
          ),
        ));
  }
}
