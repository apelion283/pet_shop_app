import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/horizontal_merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';

class FoodsSection extends StatefulWidget {
  final List<MerchandiseItem>? foodList;
  const FoodsSection({super.key, required this.foodList});

  @override
  State<FoodsSection> createState() => _FoodsSectionState();
}

class _FoodsSectionState extends State<FoodsSection> {
  final CarouselSliderController _buttonCarouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: AppColor.gray.withOpacity(0.5))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              child: CardHeader(
                iconPath: "assets/icons/ic_pet_foods.svg",
                cardName: 'pet_food',
                onExploreButtonClick: () {
                  Navigator.of(context).pushNamed(RouteName.explore);
                },
              ),
            ),
            (widget.foodList?.isNotEmpty ?? false)
                ? SizedBox(
                    height: 250,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () =>
                                _buttonCarouselController.previousPage(
                                    curve: Curves.linear,
                                    duration: Duration(milliseconds: 300)),
                            icon: Icon(Icons.arrow_back_ios_new_outlined)),
                        Expanded(
                            flex: 2,
                            child: CarouselSlider.builder(
                              itemCount: (widget.foodList!.length / 2).ceil(),
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                final firstItemIndex = itemIndex * 2;
                                return BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, authState) {
                                  return Column(children: [
                                    horizontalMerchandiseItem(
                                        item: widget.foodList![firstItemIndex],
                                        onItemClick: () {
                                          AnalyticsService().viewProductLog(
                                              currency: context.locale
                                                          .toString() ==
                                                      "vi_VI"
                                                  ? "đ"
                                                  : context.locale.toString() ==
                                                          "en_EN"
                                                      ? "\$"
                                                      : "đ",
                                              itemValue: widget
                                                      .foodList![firstItemIndex]
                                                      .price *
                                                  (context.locale.toString() ==
                                                          "vi_VI"
                                                      ? CurrencyRate.vnd
                                                      : context.locale
                                                                  .toString() ==
                                                              "en_EN"
                                                          ? 1
                                                          : CurrencyRate.vnd),
                                              item: widget
                                                  .foodList![firstItemIndex]);
                                          Navigator.pushNamed(context,
                                              RouteName.merchandiseDetail,
                                              arguments:
                                                  MerchandiseItemPageArguments(
                                                      itemId: widget
                                                              .foodList![
                                                                  firstItemIndex]
                                                              .id ??
                                                          ""));
                                        },
                                        onCartButtonClick: () {
                                          if (authState.authState ==
                                              AuthenticationState
                                                  .authenticated) {
                                            AnalyticsService().addItemToCartLog(
                                                currency: context.locale
                                                            .toString() ==
                                                        "vi_VI"
                                                    ? "đ"
                                                    : context.locale
                                                                .toString() ==
                                                            "en_EN"
                                                        ? "\$"
                                                        : "đ",
                                                itemValue: widget
                                                        .foodList![
                                                            firstItemIndex]
                                                        .price *
                                                    (context.locale
                                                                .toString() ==
                                                            "vi_VI"
                                                        ? CurrencyRate.vnd
                                                        : context.locale
                                                                    .toString() ==
                                                                "en_EN"
                                                            ? 1
                                                            : CurrencyRate.vnd),
                                                item: widget
                                                    .foodList![firstItemIndex]);
                                            addProduct(
                                              widget.foodList![firstItemIndex],
                                            );
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
                                                            RouteName.signIn,
                                                            arguments:
                                                                SignInPageArguments(
                                                                    itemToAdd: (
                                                                  1,
                                                                  widget.foodList![
                                                                      firstItemIndex]
                                                                )));
                                                      },
                                                      onNegativeButtonClick:
                                                          () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                });
                                          }
                                        }),
                                    if (firstItemIndex + 1 <
                                        widget.foodList!.length)
                                      horizontalMerchandiseItem(
                                          item: widget
                                              .foodList![firstItemIndex + 1],
                                          onItemClick: () {
                                            AnalyticsService().viewProductLog(
                                                currency: context.locale
                                                            .toString() ==
                                                        "vi_VI"
                                                    ? "đ"
                                                    : context.locale
                                                                .toString() ==
                                                            "en_EN"
                                                        ? "\$"
                                                        : "đ",
                                                itemValue: widget
                                                        .foodList![
                                                            firstItemIndex]
                                                        .price *
                                                    (context.locale
                                                                .toString() ==
                                                            "vi_VI"
                                                        ? CurrencyRate.vnd
                                                        : context.locale
                                                                    .toString() ==
                                                                "en_EN"
                                                            ? 1
                                                            : CurrencyRate.vnd),
                                                item: widget
                                                    .foodList![firstItemIndex]);
                                            Navigator.pushNamed(context,
                                                RouteName.merchandiseDetail,
                                                arguments:
                                                    MerchandiseItemPageArguments(
                                                        itemId: widget
                                                                .foodList![
                                                                    firstItemIndex +
                                                                        1]
                                                                .id ??
                                                            ""));
                                          },
                                          onCartButtonClick: () {
                                            if (authState.authState ==
                                                AuthenticationState
                                                    .authenticated) {
                                              AnalyticsService()
                                                  .addItemToCartLog(
                                                      currency: context.locale
                                                                  .toString() ==
                                                              "vi_VI"
                                                          ? "đ"
                                                          : context.locale
                                                                      .toString() ==
                                                                  "en_EN"
                                                              ? "\$"
                                                              : "đ",
                                                      itemValue: widget
                                                              .foodList![
                                                                  firstItemIndex]
                                                              .price *
                                                          (context.locale
                                                                      .toString() ==
                                                                  "vi_VI"
                                                              ? CurrencyRate.vnd
                                                              : context.locale
                                                                          .toString() ==
                                                                      "en_EN"
                                                                  ? 1
                                                                  : CurrencyRate
                                                                      .vnd),
                                                      item: widget.foodList![
                                                          firstItemIndex]);
                                              addProduct(
                                                widget.foodList![
                                                    firstItemIndex + 1],
                                              );
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
                                                              RouteName.signIn,
                                                              arguments:
                                                                  SignInPageArguments(
                                                                      itemToAdd: (
                                                                    1,
                                                                    widget.foodList![
                                                                        firstItemIndex +
                                                                            1]
                                                                  )));
                                                        },
                                                        onNegativeButtonClick:
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                  });
                                            }
                                          })
                                    else
                                      Container(),
                                  ]);
                                });
                              },
                              carouselController: _buttonCarouselController,
                              options: CarouselOptions(
                                height: 250,
                                viewportFraction: 1,
                              ),
                            )),
                        IconButton(
                            onPressed: () => _buttonCarouselController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear),
                            icon: Icon(Icons.arrow_forward_ios_rounded))
                      ],
                    ),
                  )
                : SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('there_is_no_data').tr(),
                    ),
                  ),
            SizedBox(
              height: 8,
            )
          ],
        ));
  }

  void addProduct(MerchandiseItem item) {
    ProgressHUD.show();
    context.read<CartCubit>().addProduct(item, 1);
    ProgressHUD.showSuccess(context.tr('add_item_to_cart_successfully'));
  }
}
