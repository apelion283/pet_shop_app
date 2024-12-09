import 'package:add_to_cart_animation/add_to_cart_animation.dart';
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
import 'package:flutter_pet_shop_app/presentation/explore/cubit/explore_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/explore/cubit/explore_state.dart';
import 'package:flutter_pet_shop_app/presentation/explore/widgets/explore_item.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:share_plus/share_plus.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool _isShimmer = true;
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

  void handleClick(int item) {
    switch (item) {
      case 0:
        _isShimmer
            ? {}
            : {
                Share.share("explore_more_fantastic_products"
                    .tr(args: ["${AppConfig.customUri}${RouteName.explore}"]))
              };
        break;
      case 1:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
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
      child: SafeArea(
          child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColor.green,
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: (Navigator.of(context).pop),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColor.black,
                          )),
                      Text(context.tr('explore'),
                          style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                      AddToCartIcon(
                          key: _cartKey,
                          badgeOptions: BadgeOptions(
                            active: false,
                          ),
                          icon: BlocBuilder<CartCubit, CartState>(
                              builder: (context, cartState) {
                            return IconButton(
                                onPressed: _isShimmer
                                    ? () {}
                                    : () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        Navigator.pushNamed(
                                            context, RouteName.cart);
                                      },
                                icon: cartState.cartList.isNotEmpty
                                    ? Badge(
                                        backgroundColor: AppColor.black,
                                        textColor: AppColor.green,
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
                          }))
                    ]),
                actions: [
                  PopupMenuButton<int>(
                    color: AppColor.green,
                    surfaceTintColor: AppColor.black,
                    iconColor: AppColor.black,
                    onSelected: (item) => (handleClick(item)),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.share_outlined,
                              color: AppColor.black,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'share',
                              style: TextStyle(color: AppColor.black),
                            ).tr()
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              body: BlocProvider(
                create: (context) => ExploreCubit()..initData(),
                child: BlocConsumer<ExploreCubit, ExploreState>(
                  builder: (context, state) {
                    var data = {
                      context.tr('our_pet'): state.petList,
                      context.tr('pet_accessories'): state.accessoryList,
                      context.tr('pet_food'): state.foodList
                    };
                    return RefreshIndicator(
                        color: AppColor.black,
                        backgroundColor: AppColor.green,
                        onRefresh: () async {
                          context.read<ExploreCubit>().initData();
                        },
                        child: ScrollableListTabScroller(
                          itemCount: data.length,
                          tabBuilder:
                              (BuildContext context, int index, bool active) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                data.keys.elementAt(index),
                                style: !active
                                    ? TextStyle(fontWeight: FontWeight.w400)
                                    : TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.blue),
                              ),
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Text(
                                  data.keys.elementAt(index),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                _isShimmer
                                    ? CustomShimmer(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              children:
                                                  List.generate(2, (index) {
                                                return Expanded(
                                                    child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColor.gray,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      top: 8,
                                                      left: 8,
                                                      right: 8),
                                                  height: 200,
                                                ));
                                              }),
                                            )))
                                    : Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            for (int i = 0;
                                                i <
                                                    data.values
                                                        .elementAt(index)
                                                        .length;
                                                i += 2)
                                              Row(children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: ExploreItem(
                                                      widgetKey: _getKeyForItem(
                                                          data.values.elementAt(
                                                              index)[i]),
                                                      item: data.values
                                                          .elementAt(index)[i],
                                                      onAddToCartButtonClick:
                                                          () {
                                                        addProduct(data.values
                                                            .elementAt(
                                                                index)[i]);
                                                      },
                                                      onItemClick: () {
                                                        checkAndNavigateToItemDetailPage(
                                                            data
                                                                .values
                                                                .elementAt(
                                                                    index)[i]);
                                                      },
                                                    )),
                                                i + 1 <
                                                        data.values
                                                            .elementAt(index)
                                                            .length
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: ExploreItem(
                                                          widgetKey:
                                                              _getKeyForItem(data
                                                                  .values
                                                                  .elementAt(
                                                                      index)[i +
                                                                  1]),
                                                          item: data.values
                                                              .elementAt(
                                                                  index)[i + 1],
                                                          onAddToCartButtonClick:
                                                              () {
                                                            addProduct(data
                                                                    .values
                                                                    .elementAt(
                                                                        index)[
                                                                i + 1]);
                                                          },
                                                          onItemClick: () {
                                                            checkAndNavigateToItemDetailPage(
                                                                data
                                                                    .values
                                                                    .elementAt(
                                                                        index)[i +
                                                                    1]);
                                                          },
                                                        ),
                                                      )
                                                    : Expanded(
                                                        flex: 1,
                                                        child: SizedBox(),
                                                      )
                                              ])
                                          ],
                                        ),
                                      )
                              ],
                            );
                          },
                        ));
                  },
                  listener: (context, state) {
                    if (state.accessoryList.isNotEmpty &&
                        state.foodList.isNotEmpty &&
                        state.petList.isNotEmpty) {
                      setState(() {
                        _isShimmer = false;
                      });
                      _cartKey.currentState!.updateBadge(context
                                  .read<CartCubit>()
                                  .state
                                  .getQuantity() >
                              AppConfig.maxBadgeQuantity
                          ? "${AppConfig.maxBadgeQuantity}+"
                          : "${context.read<CartCubit>().state.getQuantity()}");
                    }
                  },
                ),
              ))),
    );
  }

  void checkAndNavigateToItemDetailPage(Object item) {
    if (item is MerchandiseItem) {
      Navigator.of(context).pushNamed(RouteName.merchandiseDetail,
          arguments: MerchandiseItemPageArguments(itemId: item.id!));
    } else if (item is Pet) {
      Navigator.of(context).pushNamed(RouteName.petProfile,
          arguments: PetProfilePageArguments(petId: item.id!));
    } else {}
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
