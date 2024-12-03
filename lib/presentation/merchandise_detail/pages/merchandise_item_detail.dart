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
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/cubit/merchandise_detail_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/cubit/merchandise_detail_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/clip_path.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/add_button.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/remove_button.dart';
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
                            SizedBox()
                          ]),
                      actions: [
                        AddToCartIcon(
                            key: _cartKey,
                            badgeOptions: const BadgeOptions(
                                active: true,
                                backgroundColor: AppColor.black,
                                foregroundColor: AppColor.green),
                            icon: IconButton(
                                onPressed: _isShimmer
                                    ? () {}
                                    : () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        Navigator.pushNamed(
                                            context, RouteName.cart);
                                      },
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: AppColor.black,
                                )))
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
                                                                AppColor.green,
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
                              IconButton(
                                  style: IconButton.styleFrom(
                                      backgroundColor: AppColor.green),
                                  onPressed: _isShimmer
                                      ? () {}
                                      : () {
                                          Share.share("let_check_this_product"
                                              .tr(args: [
                                            "${AppConfig.customUri}${RouteName.merchandiseDetail}?id=${state.item!.id}"
                                          ]));
                                        },
                                  icon: Icon(
                                    Icons.share_outlined,
                                    color: AppColor.black,
                                  )),
                              Expanded(
                                child: BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, authState) {
                                    return ElevatedButton(
                                        onPressed: _isShimmer
                                            ? () {}
                                            : () {
                                                if (authState.authState ==
                                                    AuthenticationState
                                                        .authenticated) {
                                                  ProgressHUD.show();
                                                  context
                                                      .read<CartCubit>()
                                                      .addProduct(
                                                          state.item,
                                                          int.parse(
                                                              _quantityController
                                                                  .text));
                                                  addButtonClick(_widgetKey);
                                                  AnalyticsService()
                                                      .addItemToCartLog(
                                                          currency: context
                                                                      .locale
                                                                      .toString() ==
                                                                  "vi_VI"
                                                              ? "đ"
                                                              : context.locale
                                                                          .toString() ==
                                                                      "en_EN"
                                                                  ? "\$"
                                                                  : "đ",
                                                          itemValue: state
                                                                  .item!.price *
                                                              (context.locale
                                                                          .toString() ==
                                                                      "vi_VI"
                                                                  ? CurrencyRate
                                                                      .vnd
                                                                  : context.locale
                                                                              .toString() ==
                                                                          "en_EN"
                                                                      ? 1
                                                                      : CurrencyRate
                                                                          .vnd),
                                                          item: state.item);
                                                  ProgressHUD.showSuccess(
                                                      context.tr(
                                                          'add_item_to_cart_successfully'));
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CustomAlertDialog(
                                                            icon: Icons
                                                                .question_mark_outlined,
                                                            title:
                                                                'sign_in_to_shopping',
                                                            message:
                                                                'need_to_sign_in_description',
                                                            positiveButtonText:
                                                                'sign_in',
                                                            negativeButtonText:
                                                                'cancel',
                                                            onPositiveButtonClick:
                                                                () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  RouteName
                                                                      .signIn,
                                                                  arguments:
                                                                      SignInPageArguments(
                                                                          itemToAdd: (
                                                                        1,
                                                                        state
                                                                            .item!
                                                                      )));
                                                            },
                                                            onNegativeButtonClick:
                                                                () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                      });
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
                    "${context.read<CartCubit>().state.cartList.length}");
              }
            },
          )),
    );
  }

  void addButtonClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await _cartKey.currentState!
        // ignore: use_build_context_synchronously
        .runCartAnimation("${context.read<CartCubit>().state.cartList.length}");
  }
}
