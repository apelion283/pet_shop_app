import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/bill_detail_bottom_modal_sheet.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/cart_item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double total = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                      return Column(
                          children: state.cartList == null ||
                                  state.cartList!.isEmpty
                              ? [
                                  Center(
                                      child: Text(
                                          "There is nothing here. Let's add an item!"))
                                ]
                              : List.generate(state.cartList?.length ?? 0,
                                  (index) {
                                  return Column(
                                    children: [
                                      Slidable(
                                        endActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            extentRatio: 0.3,
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  context
                                                      .read<CartCubit>()
                                                      .deleteItemFromCart(state
                                                          .cartList![index]
                                                          .$2
                                                          .id as String);
                                                },
                                                icon: Icons
                                                    .delete_forever_outlined,
                                                label: "Delete",
                                                backgroundColor: AppColor.red,
                                                foregroundColor: AppColor.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              )
                                            ]),
                                        child: Column(children: [
                                          CartItem(
                                              cartItem: state.cartList![index]),
                                        ]),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  );
                                }));
                    }),
                  )))
        ],
      ),
      bottomNavigationBar:
          BlocConsumer<CartCubit, CartState>(builder: (context, state) {
        if (state.cartList != null) {
          for (var item in state.cartList!) {
            total += item.$1 * item.$2.price;
          }
        }
        return state.cartList != null || state.cartList!.isNotEmpty
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
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                                    onCheckoutButtonClick: () {},
                                  );
                                });
                          },
                          child: Text(
                            "View Detail",
                            style: TextStyle(color: AppColor.green),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                            child: Text(
                              "Check Out ${total == 0 ? "" : "\$${total + 100}"}",
                              style: TextStyle(color: AppColor.white),
                            ),
                          ),
                        )
                      ],
                    )))
            : SizedBox(
                height: 0,
              );
      }, listener: (context, state) {
        if (state.cartList != null && state.cartList!.isNotEmpty) {
          double newTotal = 0;
          for (var item in state.cartList!) {
            newTotal += (item.$1 * item.$2.price);
          }
          setState(() {
            total = newTotal;
          });
        }
      }),
    ));
  }
}
