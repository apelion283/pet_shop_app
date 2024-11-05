import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

Widget verticalMerchandiseItem(
    {required MerchandiseItem item, required Function onItemClick}) {
  return GestureDetector(
      onTap: () {
        onItemClick();
      },
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColor.gray.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Image.network(
                  item.imageUrl,
                  width: 150,
                  height: 200,
                ),
                Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColor.green, fontWeight: FontWeight.w500),
                ),
                Text(
                  MoneyFormatHelper.formatVNCurrency(
                      item.price * CurrencyRate.vnd),
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
                )
              ],
            ),
          )));
}
