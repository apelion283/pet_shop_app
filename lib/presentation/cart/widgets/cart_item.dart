import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/add_button.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/color_box_from_color_hex.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/remove_button.dart';

class CartItem extends StatefulWidget {
  final (int, Object) cartItem;
  const CartItem({super.key, required this.cartItem});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _quantityController.text = widget.cartItem.$1.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isMerchandise = widget.cartItem.$2 is MerchandiseItem;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 5,
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Image.network(
                    fit: BoxFit.fill,
                    _isMerchandise
                        ? (widget.cartItem.$2 as MerchandiseItem).imageUrl
                        : (widget.cartItem.$2 as Pet).imageUrl,
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<CartCubit, CartState>(
                            builder: (context, state) {
                          int indexOfItem = context
                              .read<CartCubit>()
                              .getIndexOfItem(
                                  itemId: _isMerchandise
                                      ? (widget.cartItem.$2 as MerchandiseItem)
                                          .id
                                      : (widget.cartItem.$2 as Pet).id);

                          return Text(
                            "${MoneyFormatHelper.formatVNCurrency(_isMerchandise ? (widget.cartItem.$2 as MerchandiseItem).price * CurrencyRate.vnd : (widget.cartItem.$2 as Pet).price * CurrencyRate.vnd)} x ${indexOfItem != -1 ? state.cartList[indexOfItem].$1 : _quantityController.text}",
                            style: TextStyle(
                                color: AppColor.green,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          );
                        }),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          _isMerchandise
                              ? (widget.cartItem.$2 as MerchandiseItem).name
                              : (widget.cartItem.$2 as Pet).name,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        _isMerchandise
                            ? Text(
                                (widget.cartItem.$2 as MerchandiseItem).weight,
                                style: TextStyle(
                                    color: AppColor.gray, fontSize: 12),
                              )
                            : ColorBoxFromColorHex(
                                colorName: (widget.cartItem.$2 as Pet).color,
                                width: 30,
                                height: 30)
                      ],
                    )),
                _isMerchandise
                    ? Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AddButton(onButtonClick: () {
                              setState(() {
                                _quantityController.text = _quantityController
                                        .text.isNotEmpty
                                    ? (int.parse(_quantityController.text) + 1)
                                        .toString()
                                    : "1";
                              });
                              context.read<CartCubit>().increaseQuantityOfItem(
                                    _isMerchandise
                                        ? (widget.cartItem.$2
                                                as MerchandiseItem)
                                            .id
                                        : (widget.cartItem.$2 as Pet).id,
                                  );
                            }),
                            SizedBox(
                              height: 10,
                              child: TextField(
                                controller: _quantityController,
                                style: TextStyle(
                                    color: AppColor.gray, fontSize: 15),
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.done,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[1-9][0-9]*'))
                                ],
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0))),
                                cursorColor: AppColor.gray,
                                onChanged: (value) {
                                  setState(() {
                                    _quantityController.text = value;
                                  });
                                  if (value.toString().isNotEmpty) {
                                    context.read<CartCubit>().updateCart(
                                        (int.parse(value), widget.cartItem.$2));
                                  }
                                },
                              ),
                            ),
                            RemoveButton(onButtonClick: () {
                              setState(() {
                                _quantityController.text = _quantityController
                                            .text.isNotEmpty &&
                                        int.parse(_quantityController.text) > 1
                                    ? (int.parse(_quantityController.text) - 1)
                                        .toString()
                                    : "1";
                              });
                              context.read<CartCubit>().decreaseQuantityOfItem(
                                    _isMerchandise
                                        ? (widget.cartItem.$2
                                                as MerchandiseItem)
                                            .id
                                        : (widget.cartItem.$2 as Pet).id,
                                  );
                            })
                          ],
                        ))
                    : Expanded(flex: 2, child: SizedBox())
              ],
            ),
          )),
    );
  }
}
