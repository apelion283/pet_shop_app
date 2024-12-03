import 'package:flutter/widgets.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';

class VerticalMerchandiseItem extends StatelessWidget {
  final bool isShimmer;
  final MerchandiseItem item;
  final Function onItemClick;
  const VerticalMerchandiseItem(
      {super.key,
      required this.isShimmer,
      required this.item,
      required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onItemClick();
        },
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: isShimmer
                      ? CustomShimmer(
                          child: Container(
                          color: AppColor.gray,
                          child: Image.asset('assets/images/app_icon.png'),
                        ))
                      : Image.network(
                          item.imageUrl,
                        ),
                ),
                SizedBox(
                  height: 8,
                ),
                isShimmer
                    ? CustomShimmer(
                        child: Container(
                            color: AppColor.gray, child: Text('loading')))
                    : Text(
                        "${item.name.split(' ').first} ${item.name.split(' ')[1]}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColor.black, fontWeight: FontWeight.w500),
                      ),
                SizedBox(
                  height: 4,
                ),
                isShimmer
                    ? CustomShimmer(
                        child: Container(
                            color: AppColor.gray, child: Text('loading')))
                    : Text(
                        MoneyFormatHelper.formatVNCurrency(
                            item.price * CurrencyRate.vnd),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColor.gray, fontWeight: FontWeight.w400),
                      )
              ],
            )));
  }
}
