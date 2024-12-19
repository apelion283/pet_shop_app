import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/helper/datetime_format_helper.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/pet/cubit/pet_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/pet/cubit/pet_state.dart';
import 'package:flutter_pet_shop_app/presentation/pet/widgets/auto_scroll_after_fill_max_height.dart';
import 'package:flutter_pet_shop_app/presentation/pet/widgets/pet_status_row.dart';
import 'package:flutter_pet_shop_app/presentation/pet/widgets/section_header.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/color_box_from_color_hex.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class PetProfilePage extends StatefulWidget {
  const PetProfilePage({super.key});

  @override
  State<PetProfilePage> createState() => _PetProfilePage();
}

class _PetProfilePage extends State<PetProfilePage> {
  bool _isShimmer = true;
  final GlobalKey<CartIconKey> _cartKey = GlobalKey<CartIconKey>();
  final GlobalKey _widgetKey = GlobalKey();
  late Function(GlobalKey) runAddToCartAnimation;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PetProfilePageArguments;
    return BlocProvider(
      create: (context) => PetCubit()..getPetDataById(args.petId),
      child: BlocConsumer<PetCubit, PetState>(builder: (context, state) {
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
            child: RefreshIndicator(
                color: AppColor.black,
                backgroundColor: AppColor.green,
                onRefresh: () async {
                  context.read<PetCubit>().getPetDataById(args.petId);
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
                              _isShimmer
                                  ? CustomShimmer(
                                      child: Container(
                                          color: AppColor.gray,
                                          child: Text(context.tr("loading"),
                                              style: TextStyle(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18))),
                                    )
                                  : Text(
                                      context.tr("pet_profile",
                                          args: [state.pet!.name]),
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
                                                        AppConfig
                                                            .maxBadgeQuantity
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
                            onSelected: (item) => _isShimmer
                                ? {}
                                : (handleClick(item, state.pet!.id!)),
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
                      body: Column(
                        children: [
                          Expanded(
                              child: SingleChildScrollView(
                                  child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                    ),
                                    CircleAvatar(
                                      backgroundColor:
                                          AppColor.gray.withOpacity(0.5),
                                      radius: 60,
                                      child: Container(
                                        key: _widgetKey,
                                        child: _isShimmer
                                            ? CustomShimmer(
                                                child: CircleAvatar(radius: 60))
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    state.pet?.imageUrl ?? ""),
                                                radius: 50,
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 32,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _isShimmer
                                              ? CustomShimmer(
                                                  child: Container(
                                                      color: AppColor.gray,
                                                      child: Text(
                                                        'loading',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20),
                                                      ).tr()))
                                              : Text(
                                                  state.pet!.name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20),
                                                ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            children: [
                                              _isShimmer
                                                  ? CustomShimmer(
                                                      child: Container(
                                                          color: AppColor.gray,
                                                          child: Text(
                                                            'loading',
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ).tr()),
                                                    )
                                                  : Text(state.type!.name,
                                                      style: TextStyle(
                                                          color: AppColor.gray,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 15)),
                                              SizedBox(
                                                height: 15,
                                                child: VerticalDivider(
                                                  thickness: 2,
                                                  color: AppColor.gray,
                                                ),
                                              ),
                                              _isShimmer
                                                  ? Flexible(
                                                      child: CustomShimmer(
                                                        child: Container(
                                                            color:
                                                                AppColor.gray,
                                                            child: Text(
                                                              'loading',
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ).tr()),
                                                      ),
                                                    )
                                                  : Flexible(
                                                      child: Text(
                                                          state.species!.name,
                                                          style: TextStyle(
                                                              color:
                                                                  AppColor.gray,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _isShimmer
                                              ? CustomShimmer(
                                                  child: Container(
                                                    color: AppColor.gray,
                                                    child: Text("loading".tr()),
                                                  ),
                                                )
                                              : SectionHeader(
                                                  svgIconPath:
                                                      "assets/icons/ic_pets.svg",
                                                  sectionName: context.tr(
                                                      'about_pet',
                                                      args: [state.pet!.name])),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          _isShimmer
                                              ? CustomShimmer(
                                                  child: Container(
                                                  color: AppColor.gray,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                ))
                                              : AutoScrollAfterFillMaxHeight(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3,
                                                  textToShow:
                                                      state.pet!.description,
                                                  textStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _isShimmer
                                          ? CustomShimmer(
                                              child: Container(
                                                margin: EdgeInsets.only(top: 8),
                                                color: AppColor.gray,
                                                child: Text("loading".tr()),
                                              ),
                                            )
                                          : SectionHeader(
                                              svgIconPath:
                                                  "assets/icons/ic_pet_status.svg",
                                              sectionName: context.tr(
                                                  'pet_status',
                                                  args: [state.pet!.name])),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      PetStatusRow(
                                          isShimmer: _isShimmer,
                                          trailing: SvgPicture.asset(
                                              'assets/icons/ic_gender.svg'),
                                          name: context.tr('gender'),
                                          value: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(state
                                                              .pet?.gender ??
                                                          false
                                                      ? "assets/icons/ic_gender_male.svg"
                                                      : "assets/icons/ic_gender_female.svg"),
                                                  SizedBox(
                                                    width: 8,
                                                  )
                                                ],
                                              ),
                                              Text(context.tr(
                                                  state.pet?.gender ?? false
                                                      ? 'male'
                                                      : 'female'))
                                            ],
                                          )),
                                      PetStatusRow(
                                        isShimmer: _isShimmer,
                                        trailing: SvgPicture.asset(
                                            'assets/icons/ic_height.svg'),
                                        name: context.tr('height'),
                                        value: Text(state.pet?.height ?? ""),
                                      ),
                                      PetStatusRow(
                                        isShimmer: _isShimmer,
                                        trailing: SvgPicture.asset(
                                            'assets/icons/ic_weight.svg'),
                                        name: context.tr('weight'),
                                        value: Text(state.pet?.weight ?? ""),
                                      ),
                                      PetStatusRow(
                                        isShimmer: _isShimmer,
                                        trailing: SvgPicture.asset(
                                            'assets/icons/ic_color.svg'),
                                        name: context.tr('color'),
                                        value: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ColorBoxFromColorHex(
                                                colorName:
                                                    state.pet?.color ?? "",
                                                width: 50,
                                                height: 50)
                                          ],
                                        ),
                                      ),
                                      PetStatusRow(
                                        isShimmer: _isShimmer,
                                        trailing: SvgPicture.asset(
                                            'assets/icons/ic_birthday.svg'),
                                        name: context.tr('birthday'),
                                        value: Text(
                                            DateTimeFormatHelper.formatVNDate(
                                                state.pet?.birthday ??
                                                    DateTime.now())),
                                        isShowDivider: false,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )))
                        ],
                      ),
                      bottomNavigationBar: Padding(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, bottom: 16, top: 8),
                          child: Row(
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
                                                itemId: state.pet!.id!);
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
                                                              state.pet!.id!);
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
                                                              state.pet!.id!,
                                                          isMerchandiseItem:
                                                              false);
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
                                                    item: state.pet!);
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
                                        onPressed: () async {
                                          _isShimmer
                                              ? {}
                                              : {
                                                  if (authState.authState ==
                                                      AuthenticationState
                                                          .authenticated)
                                                    {
                                                      if (!context
                                                          .read<CartCubit>()
                                                          .isPetExistInCart(
                                                              state.pet!))
                                                        {
                                                          await CommonHelper
                                                              .addButtonClickAnimation(
                                                                  context:
                                                                      context,
                                                                  widgetKey:
                                                                      _widgetKey,
                                                                  runAddToCartAnimation:
                                                                      runAddToCartAnimation,
                                                                  cartKey:
                                                                      _cartKey),
                                                          // ignore: use_build_context_synchronously
                                                          context
                                                              .read<CartCubit>()
                                                              .addProduct(
                                                                  state.pet, 1),

                                                          AnalyticsService().viewProductLog(
                                                              currency: CommonHelper.getCurrencySymbolBaseOnLocale(
                                                                  // ignore: use_build_context_synchronously
                                                                  context: context),
                                                              itemValue: CommonHelper.getPriceBaseOnLocale(
                                                                  // ignore: use_build_context_synchronously
                                                                  context: context,
                                                                  item: state.pet!),
                                                              item: state.pet),
                                                          ScaffoldMessenger.of(
                                                                  // ignore: use_build_context_synchronously
                                                                  context)
                                                              .showSnackBar(
                                                                  notifySnackBar(
                                                                      message:
                                                                          "add_item_to_cart_successfully"
                                                                              .tr(),
                                                                      onHideSnackBarButtonClick:
                                                                          () {
                                                                        ScaffoldMessenger.of(context)
                                                                            .hideCurrentSnackBar();
                                                                      }))
                                                        }
                                                      else
                                                        {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  notifySnackBar(
                                                                      message:
                                                                          "you_can_only_add_one"
                                                                              .tr(),
                                                                      onHideSnackBarButtonClick:
                                                                          () {
                                                                        ScaffoldMessenger.of(context)
                                                                            .hideCurrentSnackBar();
                                                                      }))
                                                        }
                                                    }
                                                  else
                                                    {
                                                      CommonHelper
                                                          .showSignInDialog(
                                                              context: context,
                                                              item: state.pet!)
                                                    }
                                                };
                                        },
                                        style: ElevatedButton.styleFrom(
                                            iconColor: AppColor.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: AppColor.green),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: 1),
                                            _isShimmer
                                                ? CustomShimmer(
                                                    child: Container(
                                                      color: AppColor.gray,
                                                      child:
                                                          Text("loading".tr()),
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: Text(
                                                    'get_with',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: AppColor.black),
                                                  ).tr(args: [
                                                    state.pet!.name,
                                                    MoneyFormatHelper
                                                        .formatVNCurrency(state
                                                                .pet!.price *
                                                            CurrencyRate.vnd)
                                                  ])),
                                            Icon(
                                                Icons
                                                    .add_shopping_cart_outlined,
                                                color: AppColor.black)
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ))),
                )));
      }, listener: (context, state) {
        if (state.pet != null && state.species != null && state.type != null) {
          setState(() {
            _isShimmer = false;
          });
          _cartKey.currentState!.updateBadge(
              context.read<CartCubit>().state.getQuantity() >
                      AppConfig.maxBadgeQuantity
                  ? "${AppConfig.maxBadgeQuantity}+"
                  : "${context.read<CartCubit>().state.getQuantity()}");
        }
      }),
    );
  }

  handleClick(int item, String petId) {
    switch (item) {
      case 0:
        Share.share("let_check_this_cute_pet".tr(
            args: ["${AppConfig.customUri}${RouteName.petProfile}?id=$petId"]));
        break;
    }
  }
}
