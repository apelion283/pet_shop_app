import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
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
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

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
                'hide_detail',
                style: TextStyle(color: AppColor.green),
              ).tr()),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: TextField(
                controller: _messageController,
                onChanged: (value) {
                  _messageController.text = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            width: 1, color: Colors.black.withOpacity(0.1))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    hintText: context.tr('leave_us_message'),
                    hintStyle: TextStyle(color: AppColor.gray)),
                cursorColor: AppColor.gray,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          BlocBuilder<CartCubit, CartState>(builder: (context, state) {
            return Column(
              children: [
                ExpenseRow(
                    rowName: 'sub_total',
                    rowValue: MoneyFormatHelper.formatVNCurrency(
                        state.getTotal() * CurrencyRate.vnd),
                    rowTextStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 8,
                ),
                ExpenseRow(
                    rowName: 'shipping_charges',
                    rowValue: MoneyFormatHelper.formatVNCurrency(
                        100 * CurrencyRate.vnd),
                    rowTextStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 16,
                ),
                ExpenseRow(
                    rowName: 'total',
                    rowValue: MoneyFormatHelper.formatVNCurrency(
                        (state.getTotal() + 100) * CurrencyRate.vnd),
                    rowTextStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onCheckoutButtonClick(_messageController.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.green,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    child: Text(
                      'check_out',
                      style: TextStyle(color: AppColor.white),
                    ).tr(args: ['']),
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
