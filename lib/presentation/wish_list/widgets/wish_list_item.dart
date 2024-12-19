import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

class WishListItem extends StatefulWidget {
  final Object item;
  final GlobalKey widgetKey;
  final Function onItemClick;
  final Function onAddToCartButtonClick;
  final Function onFavoriteButtonClick;

  const WishListItem({
    super.key,
    required this.item,
    required this.onItemClick,
    required this.onAddToCartButtonClick,
    required this.onFavoriteButtonClick,
    required this.widgetKey,
  });

  @override
  State<WishListItem> createState() => _WishListItemState();
}

class _WishListItemState extends State<WishListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => widget.onItemClick(),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              fit: BoxFit.contain,
                              widget.item is MerchandiseItem
                                  ? (widget.item as MerchandiseItem).imageUrl
                                  : (widget.item as Pet).imageUrl,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.green,
                                    ),
                                  );
                                }
                              },
                            )),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: () => widget.onFavoriteButtonClick(),
                            style: IconButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                backgroundColor:
                                    AppColor.gray.withOpacity(0.4)),
                            icon: Icon(
                              Icons.favorite,
                              color: AppColor.green,
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item is MerchandiseItem
                              ? (widget.item as MerchandiseItem).name
                              : (widget.item as Pet).name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Text(
                            widget.item is MerchandiseItem
                                ? (widget.item as MerchandiseItem).weight
                                : (widget.item as Pet).weight,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColor.gray),
                          ),
                        ),
                        SizedBox(),
                        Text(
                          CommonHelper.getPriceStringBaseOnLocale(
                              context: context,
                              price: widget.item is MerchandiseItem
                                  ? (widget.item as MerchandiseItem).price
                                  : (widget.item as Pet).price),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColor.blue,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Offstage(
                          child: Container(
                            key: widget.widgetKey,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(
                                widget.item is MerchandiseItem
                                    ? (widget.item as MerchandiseItem).imageUrl
                                    : (widget.item as Pet).imageUrl,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => widget.onAddToCartButtonClick(),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              backgroundColor: AppColor.green,
                              shape: CircleBorder()),
                          child: Icon(
                            Icons.add_shopping_cart_outlined,
                            color: AppColor.black,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 8,
          ),
          child: Divider(
            thickness: 1,
          ),
        )
      ],
    );
  }
}
