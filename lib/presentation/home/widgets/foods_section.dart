import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/horizontal_merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';

class FoodsSection extends StatefulWidget {
  final List<MerchandiseItem>? foodList;
  final bool isShimmer;
  const FoodsSection(
      {super.key, required this.foodList, required this.isShimmer});

  @override
  State<FoodsSection> createState() => _FoodsSectionState();
}

class _FoodsSectionState extends State<FoodsSection> {
  final CarouselSliderController _buttonCarouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(
          iconPath: "assets/icons/ic_pet_foods.svg",
          cardName: 'pet_food',
          onExploreButtonClick: () {
            Navigator.of(context).pushNamed(RouteName.explore);
          },
        ),
        (widget.foodList?.isNotEmpty ?? false)
            ? SizedBox(
                height: 250,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => widget.isShimmer
                            ? () {}
                            : _buttonCarouselController.previousPage(
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
                                HorizontalMerchandiseItem(
                                    isShimmer: widget.isShimmer,
                                    item: widget.foodList![firstItemIndex],
                                    onItemClick: () {
                                      AnalyticsService().viewProductLog(
                                          currency: CommonHelper
                                              .getCurrencySymbolBaseOnLocale(
                                                  context: context),
                                          itemValue:
                                              CommonHelper.getPriceBaseOnLocale(
                                                  context: context,
                                                  item: widget.foodList![
                                                      firstItemIndex]),
                                          item:
                                              widget.foodList![firstItemIndex]);
                                      Navigator.pushNamed(
                                          context, RouteName.merchandiseDetail,
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
                                          AuthenticationState.authenticated) {
                                        AnalyticsService().addItemToCartLog(
                                            currency: CommonHelper
                                                .getCurrencySymbolBaseOnLocale(
                                                    context: context),
                                            itemValue: CommonHelper
                                                .getPriceBaseOnLocale(
                                                    context: context,
                                                    item: widget.foodList![
                                                        firstItemIndex]),
                                            item: widget
                                                .foodList![firstItemIndex]);
                                        addProduct(
                                          widget.foodList![firstItemIndex],
                                        );
                                      } else {
                                        CommonHelper.showSignInDialog(
                                            context: context,
                                            item: widget
                                                .foodList![firstItemIndex]);
                                      }
                                    }),
                                if (firstItemIndex + 1 <
                                    widget.foodList!.length)
                                  HorizontalMerchandiseItem(
                                      isShimmer: widget.isShimmer,
                                      item:
                                          widget.foodList![firstItemIndex + 1],
                                      onItemClick: () {
                                        AnalyticsService().viewProductLog(
                                            currency: CommonHelper
                                                .getCurrencySymbolBaseOnLocale(
                                                    context: context),
                                            itemValue: CommonHelper
                                                .getPriceBaseOnLocale(
                                                    context: context,
                                                    item: widget.foodList![
                                                        firstItemIndex + 1]),
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
                                            AuthenticationState.authenticated) {
                                          AnalyticsService().addItemToCartLog(
                                              currency: CommonHelper
                                                  .getCurrencySymbolBaseOnLocale(
                                                      context: context),
                                              itemValue: CommonHelper
                                                  .getPriceBaseOnLocale(
                                                      context: context,
                                                      item: widget.foodList![
                                                          firstItemIndex + 1]),
                                              item: widget
                                                  .foodList![firstItemIndex]);
                                          addProduct(
                                            widget
                                                .foodList![firstItemIndex + 1],
                                          );
                                        } else {
                                          CommonHelper.showSignInDialog(
                                              context: context,
                                              item: widget.foodList![
                                                  firstItemIndex + 1]);
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
                        onPressed: () => widget.isShimmer
                            ? () {}
                            : _buttonCarouselController.nextPage(
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
    );
  }

  void addProduct(MerchandiseItem item) {
    ProgressHUD.show();
    context.read<CartCubit>().addProduct(item, 1);
    ProgressHUD.showSuccess(context.tr('add_item_to_cart_successfully'));
  }
}
