import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/color_box_from_color_hex.dart';

class ExploreItem extends StatelessWidget {
  final Object item;
  final GlobalKey widgetKey;
  final Function onItemClick;
  final Function onAddToCartButtonClick;
  const ExploreItem(
      {super.key,
      required this.item,
      required this.onItemClick,
      required this.onAddToCartButtonClick,
      required this.widgetKey});

  @override
  Widget build(BuildContext context) {
    bool isMerchandise = item is MerchandiseItem;
    return GestureDetector(
        onTap: () => onItemClick(),
        child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColor.gray.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    key: widgetKey,
                    child: Hero(
                        tag: isMerchandise
                            ? (item as MerchandiseItem).id!
                            : (item as Pet).id!,
                        child: Image.network(
                          isMerchandise
                              ? (item as MerchandiseItem).imageUrl
                              : (item as Pet).imageUrl,
                          width: 90,
                          height: 95,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Text(
                    MoneyFormatHelper.formatVNCurrency((isMerchandise
                            ? (item as MerchandiseItem).price
                            : (item as Pet).price) *
                        CurrencyRate.vnd),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColor.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  isMerchandise
                      ? Text((item as MerchandiseItem).weight,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: AppColor.gray))
                      : ColorBoxFromColorHex(
                          colorName: (item as Pet).color,
                          width: 20,
                          height: 20),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    isMerchandise
                        ? (item as MerchandiseItem).name
                        : (item as Pet).name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 150,
                    child: Divider(),
                  ),
                  GestureDetector(
                    onTap: () => onAddToCartButtonClick(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_shopping_cart,
                          color: AppColor.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: Text(
                          'add_to_cart',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ).tr())
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
