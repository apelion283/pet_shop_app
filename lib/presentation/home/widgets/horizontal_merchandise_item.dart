import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

class HorizontalMerchandiseItem extends StatefulWidget {
  final bool isShimmer;
  final MerchandiseItem item;
  final Function onItemClick;
  final Function onCartButtonClick;
  const HorizontalMerchandiseItem({
    super.key,
    required this.isShimmer,
    required this.item,
    required this.onItemClick,
    required this.onCartButtonClick,
  });
  @override
  State<HorizontalMerchandiseItem> createState() =>
      _HorizontalMerchandiseItem();
}

class _HorizontalMerchandiseItem extends State<HorizontalMerchandiseItem> {
  bool _isInWishList = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.5,
        shadowColor: AppColor.gray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: AppColor.gray.withOpacity(0.5)),
        ),
        child: GestureDetector(
          onTap: () => widget.onItemClick(),
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                widget.isShimmer
                    ? CustomShimmer(
                        child: Container(
                            color: AppColor.gray, width: 75, height: 100))
                    : Image.network(
                        widget.item.imageUrl,
                        width: 75,
                        height: 100,
                      ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              widget.item.name,
                              style: TextStyle(
                                  color: AppColor.blue,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(
                        height: widget.isShimmer ? 4 : 0,
                      ),
                      widget.isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              widget.item.description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(
                        height: widget.isShimmer ? 4 : 0,
                      ),
                      widget.isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              widget.item.weight,
                              style: TextStyle(
                                  color: AppColor.gray,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(
                        height: widget.isShimmer ? 4 : 0,
                      ),
                      widget.isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              MoneyFormatHelper.formatVNCurrency(
                                  widget.item.price * CurrencyRate.vnd),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ],
                  ),
                ),
                Expanded(
                    child: SizedBox(
                  width: 1,
                )),
                Column(
                  children: [
                    widget.isShimmer
                        ? CustomShimmer(
                            child: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                                color: AppColor.gray, shape: BoxShape.circle),
                          ))
                        : BlocBuilder<WishListCubit, WishListState>(
                            builder: (context, state) {
                              _isInWishList = context
                                  .read<WishListCubit>()
                                  .isItemInWishList(itemId: widget.item.id!);
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
                                                    itemId: widget.item.id!);
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(notifySnackBar(
                                                    message:
                                                        "item_removed_from_wish_list"
                                                            .tr(),
                                                    onHideSnackBarButtonClick:
                                                        () {
                                                      ScaffoldMessenger.of(
                                                              context)
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
                                                    isMerchandiseItem: true);
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(notifySnackBar(
                                                    message:
                                                        "item_added_to_wish_list"
                                                            .tr(),
                                                    onHideSnackBarButtonClick:
                                                        () {
                                                      ScaffoldMessenger.of(
                                                              context)
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
                          ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: AppColor.green, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () => widget.isShimmer
                                ? () {}
                                : widget.onCartButtonClick(),
                            icon: Icon(
                              Icons.add_shopping_cart_rounded,
                              color: AppColor.black,
                            )))
                  ],
                ),
              ])),
        ));
  }
}
