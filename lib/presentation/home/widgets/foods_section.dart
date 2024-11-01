import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/horizontal_merchandise_item.dart';

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
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: AppColor.gray.withOpacity(0.5))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: cardHeader("assets/icons/ic_pet_foods.svg", "Pet Food"),
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
                                return Column(children: [
                                  horizontalMerchandiseItem(
                                      item: widget.foodList![firstItemIndex],
                                      onItemClick: () {
                                        Navigator.pushNamed(context,
                                            RouteName.merchandiseDetail,
                                            arguments:
                                                MerchandiseItemPageArguments(
                                                    widget
                                                            .foodList![
                                                                firstItemIndex]
                                                            .id ??
                                                        ""));
                                      },
                                      onCartButtonClick: () {
                                        context.read<CartCubit>().addProduct(
                                            widget.foodList![firstItemIndex],
                                            1);
                                      }),
                                  if (firstItemIndex + 1 <
                                      widget.foodList!.length)
                                    horizontalMerchandiseItem(
                                        item: widget
                                            .foodList![firstItemIndex + 1],
                                        onItemClick: () {
                                          Navigator.pushNamed(context,
                                              RouteName.merchandiseDetail,
                                              arguments:
                                                  MerchandiseItemPageArguments(
                                                      widget
                                                              .foodList![
                                                                  firstItemIndex +
                                                                      1]
                                                              .id ??
                                                          ""));
                                        },
                                        onCartButtonClick: () {
                                          context.read<CartCubit>().addProduct(
                                              widget.foodList![
                                                  firstItemIndex + 1],
                                              1);
                                        })
                                  else
                                    Container()
                                ]);
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
                      child: Text("There is no data here"),
                    ),
                  )
          ],
        ));
  }
}
