import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_state.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/widgets/wish_list_item.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Map<String, GlobalKey> _itemKeys = {};
  final GlobalKey<CartIconKey> _cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  GlobalKey _getKeyForItem(Object item) {
    String itemId = item is MerchandiseItem ? item.id! : (item as Pet).id!;
    if (!_itemKeys.containsKey(itemId)) {
      _itemKeys[itemId] = GlobalKey();
    }
    return _itemKeys[itemId]!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: AddToCartAnimation(
          cartKey: _cartKey,
          height: 30,
          width: 30,
          opacity: 0.85,
          dragAnimation: const DragToCartAnimationOptions(
            duration: Duration(milliseconds: 100),
            rotation: true,
          ),
          jumpAnimation: const JumpAnimationOptions(),
          createAddToCartAnimation: (runAddToCartAnimation) {
            this.runAddToCartAnimation = runAddToCartAnimation;
          },
          child: BlocBuilder<WishListCubit, WishListState>(
            builder: (context, state) {
              return RefreshIndicator(
                backgroundColor: AppColor.green,
                color: AppColor.black,
                onRefresh: () async {},
                child: Scaffold(
                  backgroundColor: AppColor.white,
                  appBar: AppBar(
                    backgroundColor: AppColor.white,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColor.black,
                            )),
                        Text(
                          'your_wish_list',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        AddToCartIcon(
                            key: _cartKey,
                            badgeOptions: BadgeOptions(
                              active: false,
                            ),
                            icon: BlocBuilder<CartCubit, CartState>(
                                builder: (context, cartState) {
                              return IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.pushNamed(
                                        context, RouteName.cart);
                                  },
                                  icon: cartState.cartList.isNotEmpty
                                      ? Badge(
                                          backgroundColor: AppColor.green,
                                          textColor: AppColor.black,
                                          label: Text(context
                                                      .read<CartCubit>()
                                                      .state
                                                      .getQuantity() >
                                                  AppConfig.maxBadgeQuantity
                                              ? "${AppConfig.maxBadgeQuantity}+"
                                              : cartState
                                                  .getQuantity()
                                                  .toString()),
                                          child: Icon(
                                            Icons.shopping_cart_outlined,
                                          ),
                                        )
                                      : Icon(
                                          Icons.shopping_cart_outlined,
                                        ));
                            })),
                      ],
                    ),
                  ),
                  body: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: Column(
                            children: state.wishList.isEmpty
                                ? [
                                    Center(
                                      child: Text("there_is_nothing_here").tr(),
                                    )
                                  ]
                                : List.generate(state.wishList.length, (index) {
                                    return WishListItem(
                                      widgetKey: _getKeyForItem(
                                          state.wishList[index].isLeft
                                              ? state.wishList[index].left
                                              : state.wishList[index].right),
                                      item: state.wishList[index].isLeft
                                          ? state.wishList[index].left
                                          : state.wishList[index].right,
                                      onItemClick: () {
                                        Navigator.of(context).pushNamed(
                                            RouteName.merchandiseDetail,
                                            arguments:
                                                MerchandiseItemPageArguments(
                                                    itemId: state
                                                            .wishList[index]
                                                            .isLeft
                                                        ? state.wishList[index]
                                                            .left.id!
                                                        : state.wishList[index]
                                                            .right.id!));
                                      },
                                      onAddToCartButtonClick: () {
                                        addProduct(state.wishList[index].isLeft
                                            ? state.wishList[index].left
                                            : state.wishList[index].right);
                                      },
                                      onFavoriteButtonClick: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomAlertDialog(
                                                  icon: Icons
                                                      .question_mark_outlined,
                                                  title:
                                                      'remove_item_from_wish_list',
                                                  message:
                                                      'item_will_be_removed_from_wish_list',
                                                  positiveButtonText: 'confirm',
                                                  negativeButtonText: 'cancel',
                                                  onPositiveButtonClick: () {
                                                    context
                                                        .read<WishListCubit>()
                                                        .removeItemFromWishList(
                                                            itemId:
                                                                state
                                                                        .wishList[
                                                                            index]
                                                                        .isLeft
                                                                    ? state
                                                                        .wishList[
                                                                            index]
                                                                        .left
                                                                        .id!
                                                                    : state
                                                                        .wishList[
                                                                            index]
                                                                        .right
                                                                        .id!,
                                                            userId: context
                                                                .read<
                                                                    AuthCubit>()
                                                                .state
                                                                .user!
                                                                .id);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            notifySnackBar(
                                                                message:
                                                                    "item_removed_from_wish_list"
                                                                        .tr(),
                                                                onHideSnackBarButtonClick:
                                                                    () {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .hideCurrentSnackBar();
                                                                }));
                                                  },
                                                  onNegativeButtonClick: () {
                                                    Navigator.of(context).pop();
                                                  });
                                            });
                                      },
                                    );
                                  }),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  void addProduct(Object item) async {
    if (context.read<AuthCubit>().state.authState ==
        AuthenticationState.unAuthenticated) {
      CommonHelper.showSignInDialog(context: context, item: item);
    } else {
      if (item is MerchandiseItem) {
        await CommonHelper.addButtonClickAnimation(
            context: context,
            widgetKey: _getKeyForItem(item),
            runAddToCartAnimation: runAddToCartAnimation,
            cartKey: _cartKey);
        // ignore: use_build_context_synchronously
        context.read<CartCubit>().addProduct(item, 1);
      } else if (item is Pet) {
        if (!context.read<CartCubit>().isPetExistInCart(item)) {
          await CommonHelper.addButtonClickAnimation(
              context: context,
              widgetKey: _getKeyForItem(item),
              runAddToCartAnimation: runAddToCartAnimation,
              cartKey: _cartKey);
          // ignore: use_build_context_synchronously
          context.read<CartCubit>().addProduct(item, 1);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(notifySnackBar(
              message: "you_can_only_add_one".tr(),
              onHideSnackBarButtonClick: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }));
          return;
        }
      } else {}
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(notifySnackBar(
          message: "add_item_to_cart_successfully".tr(),
          onHideSnackBarButtonClick: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }));
    }
  }
}
