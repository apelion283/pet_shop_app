import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';

class HorizontalMerchandiseItem extends StatelessWidget {
  final bool isShimmer;
  final MerchandiseItem item;
  final Function onItemClick;
  final Function onCartButtonClick;
  const HorizontalMerchandiseItem(
      {super.key,
      required this.isShimmer,
      required this.item,
      required this.onItemClick,
      required this.onCartButtonClick});

  @override
  Widget build(BuildContext context) {
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
                isShimmer
                    ? CustomShimmer(
                        child: Container(
                            color: AppColor.gray, width: 75, height: 100))
                    : Image.network(
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
                      isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              item.name,
                              style: TextStyle(
                                  color: AppColor.blue,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(
                        height: isShimmer ? 4 : 0,
                      ),
                      isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              item.description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(
                        height: isShimmer ? 4 : 0,
                      ),
                      isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              item.weight,
                              style: TextStyle(
                                  color: AppColor.gray,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(
                        height: isShimmer ? 4 : 0,
                      ),
                      isShimmer
                          ? CustomShimmer(
                              child: Container(
                                  color: AppColor.gray, child: Text('loading')),
                            )
                          : Text(
                              MoneyFormatHelper.formatVNCurrency(
                                  item.price * CurrencyRate.vnd),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
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
                        onPressed: () =>
                            isShimmer ? () {} : onCartButtonClick(),
                        icon: Icon(
                          Icons.add_shopping_cart_rounded,
                          color: AppColor.black,
                        ))),
              ])),
        ));
  }
}
