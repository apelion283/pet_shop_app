import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/constants/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/cubit/merchandise_detail_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/cubit/merchandise_detail_state.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/widgets/clip_path.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/add_button.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/remove_button.dart';
import 'package:shimmer/shimmer.dart';

class MerchandiseItemDetailPage extends StatefulWidget {
  const MerchandiseItemDetailPage({super.key});

  @override
  State<MerchandiseItemDetailPage> createState() =>
      _MerchandiseItemDetailPageState();
}

class _MerchandiseItemDetailPageState extends State<MerchandiseItemDetailPage> {
  final TextEditingController _quantityController = TextEditingController();
  bool _isShimmer = true;

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

    return BlocProvider(
        create: (context) =>
            MerchandiseDetailCubit()..getMerchandiseDataById(arg.itemId),
        child: BlocConsumer<MerchandiseDetailCubit, MerchandiseDetailState>(
          builder: (context, state) => Scaffold(
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
                              color: AppColor.white,
                            )),
                        _isShimmer
                            ? Shimmer.fromColors(
                                baseColor: AppColor.green.withOpacity(0.4),
                                highlightColor: AppColor.gray,
                                child: Text(
                                  state.item?.name ?? context.tr('loading'),
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ))
                            : Text(state.item?.name ?? context.tr('loading'),
                                style: TextStyle(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)),
                        IconButton(onPressed: () {
                          CommonPageController.controller.jumpToPage(
                              ScreenInBottomBarOfMainScreen.cart.index);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }, icon: BlocBuilder<CartCubit, CartState>(
                            builder: (context, state) {
                          return state.cartList.isNotEmpty
                              ? Badge(
                                  label: Text(state.cartList.length.toString()),
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: AppColor.white,
                                  ),
                                )
                              : Icon(
                                  Icons.shopping_cart_outlined,
                                  color: AppColor.white,
                                );
                        }))
                      ])),
              body: _isShimmer
                  ? Shimmer.fromColors(
                      baseColor: AppColor.green.withOpacity(0.4),
                      highlightColor: AppColor.gray,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight: size.height * 0.3,
                            flexibleSpace: FlexibleSpaceBar(
                              background: ClipPath(
                                clipper: ClipPathOnBoard(),
                                child: Image.network(
                                  state.item?.imageUrl ??
                                      "https://firebasestorage.googleapis.com/v0/b/pet-shop-4739c.appspot.com/o/merchandise_images%2Fjosera.png?alt=media&token=5ca61ce3-c3d0-46fe-807b-5947335775ab",
                                  height: size.height * 0.3,
                                  width: size.width,
                                  fit: BoxFit.contain,
                                ),
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
                                              Text(
                                                "${state.item?.name} - ${state.item?.weight}",
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
                                                  Text(
                                                    'brand',
                                                    style: TextStyle(
                                                        color: AppColor.blue,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ).tr(args: [
                                                    state.brandName != null
                                                        ? state.brandName!
                                                        : context.tr('loading')
                                                  ]),
                                                  Text(
                                                    MoneyFormatHelper
                                                        .formatVNCurrency((state
                                                                        .item
                                                                        ?.price ==
                                                                    null
                                                                ? 0
                                                                : state.item!
                                                                    .price) *
                                                            CurrencyRate.vnd),
                                                    style: TextStyle(
                                                        color: AppColor.green,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                                      Text(
                                        state.item?.description ??
                                            context.tr('loading'),
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
                    )
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: size.height * 0.3,
                          flexibleSpace: FlexibleSpaceBar(
                            background: ClipPath(
                              clipper: ClipPathOnBoard(),
                              child: Image.network(
                                state.item?.imageUrl ??
                                    "https://firebasestorage.googleapis.com/v0/b/pet-shop-4739c.appspot.com/o/merchandise_images%2Fjosera.png?alt=media&token=5ca61ce3-c3d0-46fe-807b-5947335775ab",
                                height: size.height * 0.3,
                                width: size.width,
                                fit: BoxFit.contain,
                              ),
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
                                            Text(
                                              "${state.item?.name} - ${state.item?.weight}",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'brand',
                                                  style: TextStyle(
                                                      color: AppColor.blue,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ).tr(args: [
                                                  state.brandName != null
                                                      ? state.brandName!
                                                      : context.tr('loading')
                                                ]),
                                                Text(
                                                  MoneyFormatHelper
                                                      .formatVNCurrency(
                                                          (state.item?.price ==
                                                                      null
                                                                  ? 0
                                                                  : state.item!
                                                                      .price) *
                                                              CurrencyRate.vnd),
                                                  style: TextStyle(
                                                      color: AppColor.green,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                    Text(
                                      state.item?.description ??
                                          context.tr('loading'),
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
              bottomNavigationBar: Padding(
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
                            RemoveButton(onButtonClick: () {
                              setState(() {
                                _quantityController.text = _quantityController
                                            .text.isNotEmpty &&
                                        int.parse(_quantityController.text) > 1
                                    ? (int.parse(_quantityController.text) - 1)
                                        .toString()
                                    : "1";
                              });
                            }),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            width: 1, color: AppColor.gray),
                                        right: BorderSide(
                                            width: 1, color: AppColor.gray))),
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
                                          color: Colors.transparent, width: 0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                  ),
                                )),
                            AddButton(onButtonClick: () {
                              setState(() {
                                _quantityController.text = _quantityController
                                        .text.isNotEmpty
                                    ? (int.parse(_quantityController.text) + 1)
                                        .toString()
                                    : "1";
                              });
                            }),
                          ],
                        )
                      ],
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        return ElevatedButton(
                            onPressed: _isShimmer
                                ? () {}
                                : () {
                                    if (authState.authState ==
                                        AuthenticationState.authenticated) {
                                      ProgressHUD.show();
                                      context.read<CartCubit>().addProduct(
                                          state.item,
                                          int.parse(_quantityController.text));
                                      ProgressHUD.showSuccess(context
                                          .tr('add_item_to_cart_successfully'));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                                icon: Icons
                                                    .question_mark_outlined,
                                                title: 'sign_in_to_shopping',
                                                message:
                                                    'need_to_sign_in_description',
                                                positiveButtonText: 'sign_in',
                                                negativeButtonText: 'cancel',
                                                onPositiveButtonClick: () {
                                                  Navigator.pushNamed(
                                                      context, RouteName.signIn,
                                                      arguments:
                                                          SignInPageArguments(
                                                              itemToAdd: (
                                                            1,
                                                            state.item!
                                                          )));
                                                },
                                                onNegativeButtonClick: () {
                                                  Navigator.of(context).pop();
                                                });
                                          });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                                iconColor: AppColor.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColor.green),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 1),
                                Text(
                                  'add_to_cart',
                                  style: TextStyle(color: AppColor.white),
                                ).tr(),
                                Icon(Icons.add_shopping_cart_outlined)
                              ],
                            ));
                      },
                    )
                  ],
                ),
              )),
          listener: (context, state) {
            if (state.item != null && state.brandName != null) {
              setState(() {
                _isShimmer = false;
              });
            }
          },
        ));
  }
}
