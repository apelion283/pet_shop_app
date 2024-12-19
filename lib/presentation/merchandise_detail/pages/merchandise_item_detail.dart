import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/cubit/merchandise_detail_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/cubit/merchandise_detail_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/clip_path.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/add_button.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/remove_button.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_state.dart';
import 'package:share_plus/share_plus.dart';

class MerchandiseItemDetailPage extends StatefulWidget {
  const MerchandiseItemDetailPage({super.key});

  @override
  State<MerchandiseItemDetailPage> createState() =>
      _MerchandiseItemDetailPageState();
}

class _MerchandiseItemDetailPageState extends State<MerchandiseItemDetailPage> {
  final TextEditingController _quantityController = TextEditingController();
  bool _isShimmer = true;
  final GlobalKey<CartIconKey> _cartKey = GlobalKey<CartIconKey>();
  final GlobalKey _widgetKey = GlobalKey();
  late Function(GlobalKey) runAddToCartAnimation;

  @override
  void initState() {
    super.initState();
    _quantityController.text = "1";
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final arg = ModalRoute.of(context)!.settings.arguments
        as MerchandiseItemPageArguments;

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
      child: BlocProvider(
          create: (context) =>
              MerchandiseDetailCubit()..getMerchandiseDataById(arg.itemId),
          child: BlocConsumer<MerchandiseDetailCubit, MerchandiseDetailState>(
            builder: (context, state) => RefreshIndicator(
                color: AppColor.black,
                backgroundColor: AppColor.green,
                onRefresh: () async {
                  context
                      .read<MerchandiseDetailCubit>()
                      .getMerchandiseDataById(arg.itemId);
                },
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
                            _isShimmer
                                ? CustomShimmer(
                                    child: Container(
                                    color: AppColor.gray,
                                    child: Text(
                                      context.tr('loading'),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ))
                                : Flexible(
                                    flex: 1,
                                    child: Text(
                                        state.item?.name ??
                                            context.tr('loading'),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: AppColor.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18))),
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
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
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
                                })),
                          ]),
                      actions: [
                        PopupMenuButton<int>(
                          color: AppColor.green,
                          surfaceTintColor: AppColor.black,
                          iconColor: AppColor.black,
                          onSelected: (item) => _isShimmer
                              ? {}
                              : (handleClick(item, state.item!.id!)),
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
                    body: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: size.height * 0.3,
                          backgroundColor: AppColor.white,
                          flexibleSpace: FlexibleSpaceBar(
                            background: ClipPath(
                              clipper: ClipPathOnBoard(),
                              child: Hero(
                                  tag: _isShimmer ? "" : state.item!.id!,
                                  child: Container(
                                    key: _widgetKey,
                                    child: _isShimmer
                                        ? CustomShimmer(
                                            child: Container(
                                                color: AppColor.gray,
                                                child: Image.asset(
                                                    "assets/images/app_icon.png")),
                                          )
                                        : Image.network(
                                            state.item!.imageUrl,
                                            height: size.height * 0.3,
                                            width: size.width,
                                            fit: BoxFit.contain,
                                          ),
                                  )),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            _isShimmer
                                                ? CustomShimmer(
                                                    child: Container(
                                                      color: AppColor.gray,
                                                      child:
                                                          Text("loading".tr(),
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                              )),
                                                    ),
                                                  )
                                                : Text(
                                                    "${state.item!.name} - ${state.item!.weight}",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _isShimmer
                                                    ? CustomShimmer(
                                                        child: Container(
                                                          color: AppColor.gray,
                                                          child: Text(
                                                              "loading".tr()),
                                                        ),
                                                      )
                                                    : Text(
                                                        'brand',
                                                        style: TextStyle(
                                                            color:
                                                                AppColor.blue,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ).tr(args: [
                                                        state.brandName!
                                                      ]),
                                                _isShimmer
                                                    ? CustomShimmer(
                                                        child: Container(
                                                          color: AppColor.gray,
                                                          child: Text(
                                                              "loading".tr()),
                                                        ),
                                                      )
                                                    : Text(
                                                        MoneyFormatHelper
                                                            .formatVNCurrency(
                                                                state.item!
                                                                        .price *
                                                                    CurrencyRate
                                                                        .vnd),
                                                        style: TextStyle(
                                                            color:
                                                                AppColor.blue,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    _isShimmer
                                        ? CustomShimmer(
                                            child: Container(
                                              color: AppColor.gray,
                                              child: Text("loading".tr()),
                                            ),
                                          )
                                        : Text(
                                            state.item!.description,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal),
                                            textAlign: TextAlign.start,
                                          ),
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                    bottomNavigationBar: Container(
                      color: AppColor.white,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'quantity',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.gray),
                              ).tr(),
                              Row(
                                children: [
                                  RemoveButton(
                                      onButtonClick: _isShimmer
                                          ? () {}
                                          : () {
                                              setState(() {
                                                _quantityController
                                                    .text = _quantityController
                                                            .text.isNotEmpty &&
                                                        int.parse(
                                                                _quantityController
                                                                    .text) >
                                                            1
                                                    ? (int.parse(
                                                                _quantityController
                                                                    .text) -
                                                            1)
                                                        .toString()
                                                    : "1";
                                              });
                                            }),
                                  Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  width: 1,
                                                  color: AppColor.gray),
                                              right: BorderSide(
                                                  width: 1,
                                                  color: AppColor.gray))),
                                      width: 50,
                                      child: TextField(
                                        controller: _quantityController,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        textInputAction: TextInputAction.done,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^[1-9][0-9]*'))
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _quantityController.text =
                                                value.toString();
                                          });
                                        },
                                        cursorColor: AppColor.gray,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0),
                                          ),
                                        ),
                                      )),
                                  AddButton(
                                      onButtonClick: _isShimmer
                                          ? () {}
                                          : () {
                                              setState(() {
                                                _quantityController
                                                    .text = _quantityController
                                                        .text.isNotEmpty
                                                    ? (int.parse(
                                                                _quantityController
                                                                    .text) +
                                                            1)
                                                        .toString()
                                                    : "1";
                                              });
                                            }),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _isShimmer
                                  ? CustomShimmer(
                                      child: IconButton(
                                          style: IconButton.styleFrom(
                                              backgroundColor: AppColor.green),
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.share_outlined,
                                            color: AppColor.black,
                                          )))
                                  : BlocBuilder<WishListCubit, WishListState>(
                                      builder: (context, wishListState) {
                                        bool isInWishList = context
                                            .read<WishListCubit>()
                                            .isItemInWishList(
                                                itemId: state.item!.id!);
                                        return IconButton(
                                            onPressed: () {
                                              if (context
                                                      .read<AuthCubit>()
                                                      .state
                                                      .user !=
                                                  null) {
                                                if (isInWishList) {
                                                  context
                                                      .read<WishListCubit>()
                                                      .removeItemFromWishList(
                                                          userId: context
                                                              .read<AuthCubit>()
                                                              .state
                                                              .user!
                                                              .id,
                                                          itemId:
                                                              state.item!.id!);
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
                                                          itemId:
                                                              state.item!.id!,
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
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .hideCurrentSnackBar();
                                                              }));
                                                }
                                              } else {
                                                CommonHelper.showSignInDialog(
                                                    context: context,
                                                    item: state.item!);
                                              }
                                            },
                                            style: IconButton.styleFrom(
                                                backgroundColor:
                                                    AppColor.green),
                                            icon: Icon(
                                              isInWishList
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: AppColor.black,
                                            ));
                                      },
                                    ),
                              Expanded(
                                child: BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, authState) {
                                    return ElevatedButton(
                                        onPressed: _isShimmer
                                            ? () {}
                                            : () async {
                                                if (authState.authState ==
                                                    AuthenticationState
                                                        .authenticated) {
                                                  await CommonHelper
                                                      .addButtonClickAnimation(
                                                          context: context,
                                                          widgetKey: _widgetKey,
                                                          runAddToCartAnimation:
                                                              runAddToCartAnimation,
                                                          cartKey: _cartKey);
                                                  // ignore: use_build_context_synchronously
                                                  context
                                                      .read<CartCubit>()
                                                      .addProduct(
                                                          state.item,
                                                          int.parse(
                                                              _quantityController
                                                                  .text));

                                                  AnalyticsService()
                                                      .addItemToCartLog(
                                                          // ignore: use_build_context_synchronously
                                                          currency: context
                                                                      .locale
                                                                      .toString() ==
                                                                  "vi_VI"
                                                              ? "đ"
                                                              // ignore: use_build_context_synchronously
                                                              : context.locale
                                                                          .toString() ==
                                                                      "en_EN"
                                                                  ? "\$"
                                                                  : "đ",
                                                          itemValue: state
                                                                  .item!.price *
                                                              // ignore: use_build_context_synchronously
                                                              (context.locale
                                                                          .toString() ==
                                                                      "vi_VI"
                                                                  ? CurrencyRate
                                                                      .vnd
                                                                  // ignore: use_build_context_synchronously
                                                                  : context.locale
                                                                              .toString() ==
                                                                          "en_EN"
                                                                      ? 1
                                                                      : CurrencyRate
                                                                          .vnd),
                                                          item: state.item);
                                                  // ignore: use_build_context_synchronously
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          notifySnackBar(
                                                              message:
                                                                  "add_item_to_cart_successfully"
                                                                      .tr(),
                                                              onHideSnackBarButtonClick:
                                                                  () {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .hideCurrentSnackBar();
                                                              }));
                                                } else {
                                                  CommonHelper.showSignInDialog(
                                                      context: context,
                                                      item: state.item!);
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                            iconColor: AppColor.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: AppColor.green),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: 1),
                                            Text(
                                              'add_to_cart',
                                              style: TextStyle(
                                                  color: AppColor.black),
                                            ).tr(),
                                            Icon(Icons
                                                .add_shopping_cart_outlined)
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
            listener: (context, state) {
              if (state.item != null && state.brandName != null) {
                setState(() {
                  _isShimmer = false;
                });
                _cartKey.currentState!.updateBadge(
                    context.read<CartCubit>().state.getQuantity() >
                            AppConfig.maxBadgeQuantity
                        ? "${AppConfig.maxBadgeQuantity}+"
                        : "${context.read<CartCubit>().state.getQuantity()}");
              }
            },
          )),
    );
  }

  handleClick(int item, String merchandiseId) {
    switch (item) {
      case 0:
        Share.share("let_check_this_product".tr(args: [
          "${AppConfig.customUri}${RouteName.merchandiseDetail}?id=$merchandiseId"
        ]));
    }
  }
}
