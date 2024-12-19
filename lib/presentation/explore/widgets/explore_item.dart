import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/color_box_from_color_hex.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_state.dart';

class ExploreItem extends StatefulWidget {
  final Object item;
  final GlobalKey widgetKey;
  final Function onItemClick;
  final Function onAddToCartButtonClick;
  final bool isShimmer;
  const ExploreItem(
      {super.key,
      required this.item,
      required this.onItemClick,
      required this.onAddToCartButtonClick,
      required this.widgetKey,
      required this.isShimmer});
  @override
  State<ExploreItem> createState() => _ExploreItemState();
}

class _ExploreItemState extends State<ExploreItem> {
  bool _isInWishList = false;
  @override
  Widget build(BuildContext context) {
    bool isMerchandise = widget.item is MerchandiseItem;

    return GestureDetector(
        onTap: () => widget.onItemClick(),
        child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColor.gray.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(16)),
            child: Stack(children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Hero(
                        tag: isMerchandise
                            ? (widget.item as MerchandiseItem).id!
                            : (widget.item as Pet).id!,
                        child: widget.isShimmer
                            ? CustomShimmer(
                                child: Container(
                                color: AppColor.gray,
                                height: 95,
                              ))
                            : Image.network(
                                isMerchandise
                                    ? (widget.item as MerchandiseItem).imageUrl
                                    : (widget.item as Pet).imageUrl,
                                width: 90,
                                height: 95,
                                fit: BoxFit.cover,
                              )),
                    widget.isShimmer
                        ? CustomShimmer(
                            child: Container(
                                color: AppColor.gray, child: Text('loading')),
                          )
                        : Text(
                            MoneyFormatHelper.formatVNCurrency((isMerchandise
                                    ? (widget.item as MerchandiseItem).price
                                    : (widget.item as Pet).price) *
                                CurrencyRate.vnd),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColor.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                    SizedBox(
                      height: 4,
                    ),
                    widget.isShimmer
                        ? CustomShimmer(
                            child: Container(
                                color: AppColor.gray, child: Text('loading')),
                          )
                        : isMerchandise
                            ? Text((widget.item as MerchandiseItem).weight,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppColor.gray))
                            : ColorBoxFromColorHex(
                                colorName: (widget.item as Pet).color,
                                width: 20,
                                height: 20),
                    SizedBox(
                      height: 4,
                    ),
                    widget.isShimmer
                        ? CustomShimmer(
                            child: Container(
                                color: AppColor.gray, child: Text('loading')),
                          )
                        : Text(
                            isMerchandise
                                ? (widget.item as MerchandiseItem).name
                                : (widget.item as Pet).name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: Divider(),
                    ),
                    GestureDetector(
                        onTap: widget.isShimmer
                            ? () {}
                            : () => widget.onAddToCartButtonClick(),
                        child: Stack(
                          children: [
                            Offstage(
                              child: Container(
                                key: widget.widgetKey,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(
                                    isMerchandise
                                        ? (widget.item as MerchandiseItem)
                                            .imageUrl
                                        : (widget.item as Pet).imageUrl,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: AppColor.black,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                    child: Text(
                                  'add_to_cart',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ).tr())
                              ],
                            ),
                          ],
                        ))
                  ],
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
                                  itemId: isMerchandise
                                      ? (widget.item as MerchandiseItem).id!
                                      : (widget.item as Pet).id!);
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
                                                  itemId: isMerchandise
                                                      ? (widget.item
                                                              as MerchandiseItem)
                                                          .id!
                                                      : (widget.item as Pet)
                                                          .id!);
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
                                                  itemId: isMerchandise
                                                      ? (widget.item
                                                              as MerchandiseItem)
                                                          .id!
                                                      : (widget.item as Pet)
                                                          .id!,
                                                  isMerchandiseItem:
                                                      isMerchandise);
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
                              icon: Icon(
                                _isInWishList
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isInWishList
                                    ? AppColor.green
                                    : AppColor.black,
                              ));
                        },
                      ),
              )
            ])));
  }
}
