import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/cart_item.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/expense_row.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/slide_to_right_animation.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/dash_line.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      return SafeArea(
          bottom: true,
          child: RefreshIndicator(
              onRefresh: () async {
                context.read<CartCubit>();
              },
              child: Scaffold(
                  backgroundColor: AppColor.white,
                  appBar: AppBar(
                    backgroundColor: AppColor.white,
                    title: const Text(
                      'your_cart',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ).tr(),
                    centerTitle: true,
                  ),
                  body: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: state.cartList.isEmpty
                                  ? Center(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('there_is_nothing_here').tr(),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColor.green,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed(RouteName.explore);
                                            },
                                            child: Text(
                                              'explore_now',
                                              style: TextStyle(
                                                  color: AppColor.black),
                                            ).tr())
                                      ],
                                    ))
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              children: List.generate(
                                                  state.cartList.length,
                                                  (index) {
                                                return Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 8),
                                                    child: Slidable(
                                                      endActionPane: ActionPane(
                                                          motion:
                                                              ScrollMotion(),
                                                          extentRatio: 0.3,
                                                          children: [
                                                            SlidableAction(
                                                              onPressed:
                                                                  (context) {
                                                                String
                                                                    itemToDeleteId =
                                                                    "";
                                                                if (state
                                                                        .cartList[
                                                                            index]
                                                                        .$2
                                                                    is MerchandiseItem) {
                                                                  itemToDeleteId = (state
                                                                          .cartList[
                                                                              index]
                                                                          .$2 as MerchandiseItem)
                                                                      .id as String;
                                                                } else if (state
                                                                    .cartList[
                                                                        index]
                                                                    .$2 is Pet) {
                                                                  itemToDeleteId = (state
                                                                          .cartList[
                                                                              index]
                                                                          .$2 as Pet)
                                                                      .id as String;
                                                                }
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return CustomAlertDialog(
                                                                          icon: Icons
                                                                              .question_mark_outlined,
                                                                          title:
                                                                              'about_to_delete',
                                                                          message:
                                                                              'are_you_sure_to_delete',
                                                                          positiveButtonText:
                                                                              'delete',
                                                                          negativeButtonText:
                                                                              'cancel',
                                                                          onPositiveButtonClick:
                                                                              () {
                                                                            context.read<CartCubit>().deleteItemFromCart(
                                                                                  itemToDeleteId,
                                                                                );
                                                                          },
                                                                          onNegativeButtonClick:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                    });
                                                              },
                                                              icon: Icons
                                                                  .delete_forever_outlined,
                                                              label: context
                                                                  .tr('delete'),
                                                              backgroundColor:
                                                                  AppColor.red,
                                                              foregroundColor:
                                                                  AppColor
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                            )
                                                          ]),
                                                      child: CartItem(
                                                          cartItem: state
                                                              .cartList[index]),
                                                    ));
                                              }),
                                            ),
                                            DashLine(
                                              margin: EdgeInsets.only(
                                                  top: 8, bottom: 16),
                                              color: AppColor.gray,
                                            ),
                                            TextField(
                                                controller: _messageController,
                                                cursorColor: AppColor.gray,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText:
                                                      "leave_us_message".tr(),
                                                  hintStyle: TextStyle(
                                                      color: AppColor.gray
                                                          .withOpacity(0.4)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          borderSide: BorderSide(
                                                              color: AppColor
                                                                  .gray
                                                                  .withOpacity(
                                                                      0.8))),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          borderSide: BorderSide(
                                                              color: AppColor
                                                                  .gray
                                                                  .withOpacity(
                                                                      0.5))),
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 16, bottom: 8),
                                              child: ExpenseRow(
                                                  rowName: "sub_total",
                                                  rowTextStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  rowValue:
                                                      getPriceBaseOnLocale(
                                                          state.getTotal())),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: ExpenseRow(
                                                  rowName: "shipping_charges",
                                                  rowTextStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  rowValue:
                                                      getPriceBaseOnLocale(5)),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: ExpenseRow(
                                                  rowName: "total",
                                                  rowTextStyle: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500),
                                                  rowValue:
                                                      getPriceBaseOnLocale(
                                                          state.getTotal() +
                                                              5)),
                                            ),
                                          ]))))
                    ],
                  ),
                  bottomNavigationBar: state.cartList.isNotEmpty
                      ? Container(
                          height: AppConfig.mainBottomNavigationBarHeight,
                          margin:
                              EdgeInsets.only(right: 12, left: 12, bottom: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColor.black,
                              borderRadius: BorderRadius.circular(32)),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            SlideAction(
                              height: AppConfig.mainBottomNavigationBarHeight,
                              onSubmit: () {
                                return checkOut(
                                    checkOutList: state.cartList,
                                    orderMessage: _messageController.text);
                              },
                              innerColor: AppColor.green,
                              outerColor: AppColor.black,
                              sliderButtonIconPadding: 0,
                              sliderButtonIcon: Container(
                                height:
                                    AppConfig.mainBottomNavigationBarHeight - 8,
                                width:
                                    AppConfig.mainBottomNavigationBarHeight - 8,
                                padding: EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  "assets/icons/ic_right_arrow.svg",
                                ),
                              ),
                              textStyle: TextStyle(
                                  fontSize: 18, color: AppColor.green),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 16, bottom: 16),
                                    child: SlideToRightAnimation(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      "Place an order",
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]))
                      : SizedBox(
                          height: 0,
                        ))));
    });
  }

  Future<void> checkOut(
      {required List<(int, Object)> checkOutList, String? orderMessage}) async {
    final result =
        await context.read<CartCubit>().checkOut(checkOutList, orderMessage);
    AnalyticsService().checkOutLog(
        currency: getCurrencySymbolBaseOnLocale(),
        // ignore: use_build_context_synchronously
        total: double.parse(
            // ignore: use_build_context_synchronously
            getPriceBaseOnLocale(context.read<CartCubit>().state.getTotal())),
        items: checkOutList,
        message: orderMessage);
    if (result != null) {
      ProgressHUD.showError("something_went_wrong".tr());
    }
  }

  String getCurrencySymbolBaseOnLocale() {
    return context.locale.toString() == "vi_VI"
        ? "đ"
        : context.locale.toString() == "en_EN"
            ? "\$"
            : "đ";
  }

  String getPriceBaseOnLocale(double price) {
    return context.locale.toString() == "vi_VI"
        ? MoneyFormatHelper.formatVNCurrency(price * CurrencyRate.vnd)
        : context.locale.toString() == "en_EN"
            ? "\$${price * 1}"
            : MoneyFormatHelper.formatVNCurrency(price * CurrencyRate.vnd);
  }
}
