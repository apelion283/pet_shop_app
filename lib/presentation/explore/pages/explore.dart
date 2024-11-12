import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/constants/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/explore/cubit/explore_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/explore/cubit/explore_state.dart';
import 'package:flutter_pet_shop_app/presentation/explore/widgets/explore_item.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:shimmer/shimmer.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool _isShimmer = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                      Text(context.tr('explore'),
                          style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                      IconButton(
                          onPressed: () {
                            CommonPageController.controller.jumpToPage(
                                ScreenInBottomBarOfMainScreen.cart.index);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          icon: _isShimmer
                              ? Shimmer.fromColors(
                                  baseColor: AppColor.green.withOpacity(0.4),
                                  highlightColor: AppColor.gray,
                                  child: SizedBox())
                              : BlocBuilder<CartCubit, CartState>(
                                  builder: (context, state) {
                                  return state.cartList.isNotEmpty
                                      ? Badge(
                                          label: Text(
                                              state.cartList.length.toString()),
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
            body: BlocProvider(
              create: (context) => ExploreCubit()..initData(),
              child: BlocConsumer<ExploreCubit, ExploreState>(
                builder: (context, state) {
                  var data = {
                    context.tr('our_pet'): state.petList,
                    context.tr('pet_accessories'): state.accessoryList,
                    context.tr('pet_food'): state.foodList
                  };
                  return ScrollableListTabScroller(
                    itemCount: data.length,
                    tabBuilder: (BuildContext context, int index, bool active) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          data.keys.elementAt(index),
                          style: !active
                              ? null
                              : TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                        ),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Text(
                            data.keys.elementAt(index),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          _isShimmer
                              ? Shimmer.fromColors(
                                  baseColor: AppColor.green.withOpacity(0.4),
                                  highlightColor: AppColor.gray,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.gray,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        margin:
                                            EdgeInsets.only(top: 8, left: 16),
                                        height: 200,
                                      )),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                          child: Container(
                                        margin:
                                            EdgeInsets.only(top: 8, right: 16),
                                        decoration: BoxDecoration(
                                          color: AppColor.gray,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        height: 200,
                                      ))
                                    ],
                                  ))
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
                                                item: data.values
                                                    .elementAt(index)[i],
                                                onAddToCartButtonClick: () {
                                                  addProduct(data.values
                                                      .elementAt(index)[i]);
                                                },
                                                onItemClick: () {
                                                  checkAndNavigateToItemDetailPage(
                                                      data.values
                                                          .elementAt(index)[i]);
                                                },
                                              )),
                                          i + 1 <
                                                  data.values
                                                      .elementAt(index)
                                                      .length
                                              ? Expanded(
                                                  flex: 1,
                                                  child: ExploreItem(
                                                    item: data.values.elementAt(
                                                        index)[i + 1],
                                                    onAddToCartButtonClick: () {
                                                      addProduct(data.values
                                                          .elementAt(
                                                              index)[i + 1]);
                                                    },
                                                    onItemClick: () {
                                                      checkAndNavigateToItemDetailPage(
                                                          data.values.elementAt(
                                                              index)[i + 1]);
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
                  );
                },
                listener: (context, state) {
                  if (state.accessoryList.isNotEmpty &&
                      state.foodList.isNotEmpty &&
                      state.petList.isNotEmpty) {
                    setState(() {
                      _isShimmer = false;
                    });
                  }
                },
              ),
            )));
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

  void addProduct(Object item) {
    if (context.read<AuthCubit>().state.authState ==
        AuthenticationState.unAuthenticated) {
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
                icon: Icons.question_mark_outlined,
                title: 'sign_in_to_shopping',
                message: 'need_to_sign_in_description',
                positiveButtonText: 'sign_in',
                negativeButtonText: 'cancel',
                onPositiveButtonClick: () {
                  Navigator.pushNamed(context, RouteName.signIn,
                      arguments: SignInPageArguments(itemToAdd: (1, item)));
                },
                onNegativeButtonClick: () {
                  Navigator.of(context).pop();
                });
          });
    } else {
      if (item is MerchandiseItem) {
        ProgressHUD.show();
        context.read<CartCubit>().addProduct(item, 1);
        ProgressHUD.showSuccess(context.tr('add_item_to_cart_successfully'));
      } else if (item is Pet) {
        if (!context.read<CartCubit>().isPetExistInCart(item)) {
          ProgressHUD.show();
          context.read<CartCubit>().addProduct(item, 1);
          ProgressHUD.showSuccess(context.tr('add_item_to_cart_successfully'));
        } else {
          ProgressHUD.showError(context.tr('you_can_only_add_one'));
        }
      } else {}
    }
  }
}
