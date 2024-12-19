import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_state.dart';

class OurPetsSection extends StatefulWidget {
  final List<Pet> petList;
  final bool _isShimmer;
  const OurPetsSection({super.key, required this.petList, dynamic isShimmer})
      : _isShimmer = isShimmer;

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
                                  currency: CommonHelper
                                      .getCurrencySymbolBaseOnLocale(
                                          context: context),
                                  itemValue: CommonHelper.getPriceBaseOnLocale(
                                      context: context,
                                      item: widget.petList[index]),
                                  item: widget.petList[index]);
                              Navigator.of(context).pushNamed(
                                  RouteName.petProfile,
                                  arguments: PetProfilePageArguments(
                                      petId: widget.petList[index].id!));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 120),
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: widget._isShimmer
                                        ? CustomShimmer(
                                            child: Container(
                                                color: AppColor.gray,
                                                width: 90,
                                                height: 90),
                                          )
                                        : Image.network(
                                            widget.petList[index].imageUrl,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                widget._isShimmer
                                    ? CustomShimmer(
                                        child: Container(
                                            color: AppColor.gray,
                                            child: Text(
                                              'loading',
                                            ).tr()))
                                    : SizedBox(
                                        width: 120,
                                        child: Row(children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              CommonHelper
                                                  .getPriceStringBaseOnLocale(
                                                      context: context,
                                                      price: widget
                                                          .petList[index]
                                                          .price),
                                            ),
                                          ),
                                          BlocBuilder<WishListCubit,
                                              WishListState>(
                                            builder: (context, state) {
                                              bool isInWishList = context
                                                  .read<WishListCubit>()
                                                  .isItemInWishList(
                                                      itemId: widget
                                                          .petList[index].id!);
                                              return GestureDetector(
                                                  onTap: widget._isShimmer
                                                      ? () {}
                                                      : () {
                                                          if (context
                                                                  .read<
                                                                      AuthCubit>()
                                                                  .state
                                                                  .user !=
                                                              null) {
                                                            if (isInWishList) {
                                                              context.read<WishListCubit>().removeItemFromWishList(
                                                                  userId: context
                                                                      .read<
                                                                          AuthCubit>()
                                                                      .state
                                                                      .user!
                                                                      .id,
                                                                  itemId: widget
                                                                      .petList[
                                                                          index]
                                                                      .id!);
                                                              setState(() {});
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      notifySnackBar(
                                                                          message: "item_removed_from_wish_list"
                                                                              .tr(),
                                                                          onHideSnackBarButtonClick:
                                                                              () {
                                                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                                          }));
                                                            } else {
                                                              context.read<WishListCubit>().addItemToWishList(
                                                                  userId: context
                                                                      .read<
                                                                          AuthCubit>()
                                                                      .state
                                                                      .user!
                                                                      .id,
                                                                  itemId: widget
                                                                      .petList[
                                                                          index]
                                                                      .id!,
                                                                  isMerchandiseItem:
                                                                      false);
                                                              setState(() {});
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      notifySnackBar(
                                                                          message: "item_added_to_wish_list"
                                                                              .tr(),
                                                                          onHideSnackBarButtonClick:
                                                                              () {
                                                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                                          }));
                                                            }
                                                          } else {
                                                            CommonHelper
                                                                .showSignInDialog(
                                                                    context:
                                                                        context,
                                                                    item: widget
                                                                            .petList[
                                                                        index]);
                                                          }
                                                        },
                                                  child: widget._isShimmer
                                                      ? CustomShimmer(
                                                          child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 16),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color:
                                                                      AppColor
                                                                          .gray,
                                                                  shape: BoxShape
                                                                      .circle),
                                                        ))
                                                      : Icon(
                                                          isInWishList
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border_outlined,
                                                          color: isInWishList
                                                              ? AppColor.green
                                                              : AppColor.black,
                                                        ));
                                            },
                                          ),
                                        ])),
                                SizedBox(height: widget._isShimmer ? 4 : 0),
                                widget._isShimmer
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
