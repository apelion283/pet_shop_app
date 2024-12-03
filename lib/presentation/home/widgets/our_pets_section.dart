import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';

class OurPetsSection extends StatefulWidget {
  final List<Pet> petList;
  final isShimmer;
  const OurPetsSection({super.key, required this.petList, this.isShimmer});

  @override
  State<OurPetsSection> createState() => _OurPetsSectionState();
}

class _OurPetsSectionState extends State<OurPetsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, top: 0),
      child: Column(
        children: [
          CardHeader(
            iconPath: "assets/icons/ic_pets.svg",
            cardName: 'our_pet',
            onExploreButtonClick: () {
              Navigator.of(context).pushNamed(RouteName.explore);
            },
          ),
          SizedBox(
            height: 8,
          ),
          widget.petList.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(widget.petList.length, (index) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              AnalyticsService().viewProductLog(
                                  currency: context.locale.toString() == "vi_VI"
                                      ? "đ"
                                      : context.locale.toString() == "en_EN"
                                          ? "\$"
                                          : "đ",
                                  itemValue: widget.petList[index].price *
                                      (context.locale.toString() == "vi_VI"
                                          ? CurrencyRate.vnd
                                          : context.locale.toString() == "en_EN"
                                              ? 1
                                              : CurrencyRate.vnd),
                                  item: widget.petList[index]);
                              Navigator.of(context).pushNamed(
                                  RouteName.petProfile,
                                  arguments: PetProfilePageArguments(
                                      petId: widget.petList[index].id!));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: -2.0,
                                      blurRadius: 4.0,
                                      offset: Offset(0, 3),
                                    ),
                                  ], borderRadius: BorderRadius.circular(16)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: widget.isShimmer
                                        ? CustomShimmer(
                                            child: Container(
                                                color: AppColor.gray,
                                                width: 90,
                                                height: 90),
                                          )
                                        : Image.network(
                                            widget.petList[index].imageUrl,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                widget.isShimmer
                                    ? CustomShimmer(
                                        child: Container(
                                            color: AppColor.gray,
                                            child: Text(
                                              'loading',
                                            ).tr()))
                                    : Text(
                                        context.locale.toString() == "vi-VI"
                                            ? MoneyFormatHelper
                                                .formatVNCurrency(widget
                                                        .petList[index].price *
                                                    CurrencyRate.vnd)
                                            : "\$${widget.petList[index].price}",
                                      ),
                                widget.isShimmer
                                    ? CustomShimmer(
                                        child: Container(
                                            color: AppColor.gray,
                                            child: Text(
                                              'loading',
                                            ).tr()))
                                    : Text(
                                        widget.petList[index].name,
                                        style: TextStyle(
                                            color: AppColor.gray,
                                            fontWeight: FontWeight.w500),
                                      )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          )
                        ],
                      );
                    }),
                  ),
                )
              : SizedBox(
                  height: 50,
                  child: Center(
                    child: Text('there_is_no_data').tr(),
                  ),
                )
        ],
      ),
    );
  }
}
