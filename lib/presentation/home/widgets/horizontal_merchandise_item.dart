import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

Widget horizontalMerchandiseItem(
    {required MerchandiseItem item,
    required Function onItemClick,
    required Function onCartButtonClick}) {
  return Card(
      elevation: 5,
      shadowColor: AppColor.gray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: AppColor.gray.withOpacity(0.5)),
      ),
      child: GestureDetector(
        onTap: () => onItemClick(),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Image.network(
                item.imageUrl,
                width: 75,
                height: 100,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                          color: AppColor.green, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.description,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.weight,
                      style: TextStyle(
                          color: AppColor.gray, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      MoneyFormatHelper.formatVNCurrency(
                          item.price * CurrencyRate.vnd),
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SizedBox(
                width: 1,
              )),
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColor.green, shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () => onCartButtonClick(),
                      icon: Icon(
                        Icons.add_shopping_cart_rounded,
                        color: AppColor.white,
                      ))),
            ])),
      ));
}
