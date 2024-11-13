import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/bill_detail_bottom_modal_sheet.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/cart_item.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      return SafeArea(
          bottom: false,
          child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'your_cart',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                    BorderRadius.circular(8))),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed(RouteName.explore);
                                        },
                                        child: Text(
                                          'explore_now',
                                          style:
                                              TextStyle(color: AppColor.white),
                                        ).tr())
                                  ],
                                ))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: List.generate(
                                          state.cartList.length, (index) {
                                        return Column(
                                          children: [
                                            Slidable(
                                              endActionPane: ActionPane(
                                                  motion: ScrollMotion(),
                                                  extentRatio: 0.3,
                                                  children: [
                                                    SlidableAction(
                                                      onPressed: (context) {
                                                        String itemToDeleteId =
                                                            "";
                                                        if (state
                                                                .cartList[index]
                                                                .$2
                                                            is MerchandiseItem) {
                                                          itemToDeleteId = (state
                                                                      .cartList[
                                                                          index]
                                                                      .$2
                                                                  as MerchandiseItem)
                                                              .id as String;
                                                        } else if (state
                                                            .cartList[index]
                                                            .$2 is Pet) {
                                                          itemToDeleteId = (state
                                                                  .cartList[
                                                                      index]
                                                                  .$2 as Pet)
                                                              .id as String;
                                                        }
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
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
                                                                    context
                                                                        .read<
                                                                            CartCubit>()
                                                                        .deleteItemFromCart(
                                                                          itemToDeleteId,
                                                                        );
                                                                  },
                                                                  onNegativeButtonClick:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  });
                                                            });
                                                      },
                                                      icon: Icons
                                                          .delete_forever_outlined,
                                                      label:
                                                          context.tr('delete'),
                                                      backgroundColor:
                                                          AppColor.red,
                                                      foregroundColor:
                                                          AppColor.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    )
                                                  ]),
                                              child: Column(children: [
                                                CartItem(
                                                    cartItem:
                                                        state.cartList[index]),
                                              ]),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            )
                                          ],
                                        );
                                      })))))
                ],
              ),
              bottomNavigationBar: state.cartList.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Colors.black.withOpacity(0.4), width: 1),
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return BillDetailBottomModalSheet(
                                          onCheckoutButtonClick: (value) async {
                                            ProgressHUD.show();
                                            final result = await context
                                                .read<CartCubit>()
                                                .checkOut(
                                                    state.cartList, value);
                                            if (result == null) {
                                              // ignore: use_build_context_synchronously
                                              ProgressHUD.showSuccess(context
                                                  .tr('order_successfully'));
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              ProgressHUD.showError(context
                                                  .tr('something_went_wrong'));
                                            }
                                          },
                                        );
                                      });
                                },
                                child: Text(
                                  'view_detail',
                                  style: TextStyle(color: AppColor.green),
                                ).tr(),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    ProgressHUD.show();
                                    final result = await context
                                        .read<CartCubit>()
                                        .checkOut(state.cartList, null);
                                    if (result == null) {
                                      ProgressHUD.showSuccess(
                                          // ignore: use_build_context_synchronously
                                          context.tr('order_successfully'));
                                    } else {
                                      ProgressHUD.showError(
                                          // ignore: use_build_context_synchronously
                                          context.tr('something_went_wrong'));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)))),
                                  child: Text(
                                    'check_out',
                                    style: TextStyle(color: AppColor.white),
                                  ).tr(args: [
                                    MoneyFormatHelper.formatVNCurrency(
                                        (state.getTotal() + 100) *
                                            CurrencyRate.vnd)
                                  ]),
                                ),
                              )
                            ],
                          )))
                  : SizedBox(
                      height: 0,
                    )));
    });
  }
}
