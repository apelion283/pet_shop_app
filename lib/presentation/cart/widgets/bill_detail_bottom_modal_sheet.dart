import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/widgets/expense_row.dart';

class BillDetailBottomModalSheet extends StatefulWidget {
  final Function onCheckoutButtonClick;
  const BillDetailBottomModalSheet(
      {super.key, required this.onCheckoutButtonClick});

  @override
  State<BillDetailBottomModalSheet> createState() =>
      _BillDetailBottomModalSheetState();
}

class _BillDetailBottomModalSheetState
    extends State<BillDetailBottomModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Hide Detail",
                style: TextStyle(color: AppColor.green),
              )),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            width: 1, color: Colors.black.withOpacity(0.1))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    hintText: "Leave us your messge",
                    hintStyle: TextStyle(color: AppColor.gray)),
                cursorColor: AppColor.gray,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          BlocBuilder<CartCubit, CartState>(builder: (context, state) {
            double total = 0;
            if (state.cartList != null) {
              for (var item in state.cartList!) {
                total += item.$1 * item.$2.price;
              }
            }
            return Column(
              children: [
                ExpenseRow(
                    rowName: "SubTotal",
                    rowValue: "$total",
                    rowTextStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 8,
                ),
                ExpenseRow(
                    rowName: "Shipping charges",
                    rowValue: "100",
                    rowTextStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 16,
                ),
                ExpenseRow(
                    rowName: "Total",
                    rowValue: "${total + 100}",
                    rowTextStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onCheckoutButtonClick();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.green,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    child: Text(
                      "Check Out",
                      style: TextStyle(color: AppColor.white),
                    ),
                  ),
                )
              ],
            );
          })
        ],
      ),
    );
  }
}
