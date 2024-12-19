import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_state.dart';

class VerticalMerchandiseItem extends StatefulWidget {
  final bool isShimmer;
  final MerchandiseItem item;
  final Function onItemClick;
  const VerticalMerchandiseItem(
      {super.key,
      required this.isShimmer,
      required this.item,
      required this.onItemClick});

  @override
  State<VerticalMerchandiseItem> createState() =>
      _VerticalMerchandiseItemState();
}

class _VerticalMerchandiseItemState extends State<VerticalMerchandiseItem> {
  bool _isInWishList = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onItemClick();
        },
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: widget.isShimmer
                          ? CustomShimmer(
                              child: Container(
                              color: AppColor.gray,
                              child: Image.asset('assets/images/app_icon.png'),
                            ))
                          : Image.network(
                              widget.item.imageUrl,
                            ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: widget.isShimmer
                            ? CustomShimmer(child: SizedBox())
                            : BlocBuilder<WishListCubit, WishListState>(
                                builder: (context, state) {
                                  _isInWishList = context
                                      .read<WishListCubit>()
                                      .isItemInWishList(
                                          itemId: widget.item.id!);
                                  return IconButton(
                                    onPressed: widget.isShimmer
                                        ? () {}
                                        : () {
                                            if (context
                                                    .read<AuthCubit>()
                                                    .state
                                                    .user !=
                                                null) {
                                              if (_isInWishList) {
                                                context
                                                    .read<WishListCubit>()
                                                    .removeItemFromWishList(
                                                        userId: context
                                                            .read<AuthCubit>()
                                                            .state
                                                            .user!
                                                            .id,
                                                        itemId:
                                                            widget.item.id!);
                                                setState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        notifySnackBar(
                                                            message:
                                                                "item_removed_from_wish_list"
                                                                    .tr(),
                                                            onHideSnackBarButtonClick:
                                                                () {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                            }));
                                              } else {
                                                context
                                                    .read<WishListCubit>()
                                                    .addItemToWishList(
                                                        userId: context
                                                            .read<AuthCubit>()
                                                            .state
                                                            .user!
                                                            .id,
                                                        itemId: widget.item.id!,
                                                        isMerchandiseItem:
                                                            true);
                                                setState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        notifySnackBar(
                                                            message:
                                                                "item_added_to_wish_list"
                                                                    .tr(),
                                                            onHideSnackBarButtonClick:
                                                                () {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                            }));
                                              }
                                            } else {
                                              CommonHelper.showSignInDialog(
                                                  context: context,
                                                  item: widget.item);
                                            }
                                          },
                                    icon: Icon(_isInWishList
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined),
                                    color: _isInWishList
                                        ? AppColor.green
                                        : AppColor.black,
                                  );
                                },
                              ))
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                widget.isShimmer
                    ? CustomShimmer(
                        child: Container(
                            color: AppColor.gray, child: Text('loading')))
                    : Text(
                        "${widget.item.name.split(' ').first} ${widget.item.name.split(' ')[1]}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColor.black, fontWeight: FontWeight.w500),
                      ),
                SizedBox(
                  height: widget.isShimmer ? 4 : 0,
                ),
                widget.isShimmer
                    ? CustomShimmer(
                        child: Container(
                            color: AppColor.gray, child: Text('loading')))
                    : Text(
                        MoneyFormatHelper.formatVNCurrency(
                            widget.item.price * CurrencyRate.vnd),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColor.gray, fontWeight: FontWeight.w400),
                      )
              ],
            )));
  }
}
