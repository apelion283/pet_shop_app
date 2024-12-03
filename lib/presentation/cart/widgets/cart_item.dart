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
    bool isMerchandise = widget.cartItem.$2 is MerchandiseItem;
    return Container(
      color: AppColor.white,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                fit: BoxFit.fill,
                isMerchandise
                    ? (widget.cartItem.$2 as MerchandiseItem).imageUrl
                    : (widget.cartItem.$2 as Pet).imageUrl,
              ),
            ),
          ),
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMerchandise
                        ? (widget.cartItem.$2 as MerchandiseItem).name
                        : (widget.cartItem.$2 as Pet).name,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  isMerchandise
                      ? Text(
                          (widget.cartItem.$2 as MerchandiseItem).weight,
                          style: TextStyle(color: AppColor.gray, fontSize: 12),
                        )
                      : ColorBoxFromColorHex(
                          colorName: (widget.cartItem.$2 as Pet).color,
                          width: 30,
                          height: 30),
                  SizedBox(
                    height: 32,
                  ),
                  BlocBuilder<CartCubit, CartState>(builder: (context, state) {
                    int indexOfItem = context.read<CartCubit>().getIndexOfItem(
                        itemId: isMerchandise
                            ? (widget.cartItem.$2 as MerchandiseItem).id
                            : (widget.cartItem.$2 as Pet).id);

                    return Text(
                      "${MoneyFormatHelper.formatVNCurrency(isMerchandise ? (widget.cartItem.$2 as MerchandiseItem).price * CurrencyRate.vnd : (widget.cartItem.$2 as Pet).price * CurrencyRate.vnd)} x ${indexOfItem != -1 ? state.cartList[indexOfItem].$1 : _quantityController.text}",
                      style: TextStyle(
                          color: AppColor.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    );
                  }),
                ],
              )),
          isMerchandise
              ? Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AddButton(onButtonClick: () {
                        setState(() {
                          _quantityController.text =
                              _quantityController.text.isNotEmpty
                                  ? (int.parse(_quantityController.text) + 1)
                                      .toString()
                                  : "1";
                        });
                        context.read<CartCubit>().increaseQuantityOfItem(
                              isMerchandise
                                  ? (widget.cartItem.$2 as MerchandiseItem).id
                                  : (widget.cartItem.$2 as Pet).id,
                            );
                      }),
                      Stack(
                        children: [
                          Positioned(
                              top: 0,
                              bottom: 0,
                              left: 10,
                              right: 10,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: AppColor.gray.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8)),
                              )),
                          TextField(
                            controller: _quantityController,
                            style:
                                TextStyle(color: AppColor.black, fontSize: 15),
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[1-9][0-9]*'))
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
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
                        ],
                      ),
                      RemoveButton(onButtonClick: () {
                        setState(() {
                          _quantityController.text =
                              _quantityController.text.isNotEmpty &&
                                      int.parse(_quantityController.text) > 1
                                  ? (int.parse(_quantityController.text) - 1)
                                      .toString()
                                  : "1";
                        });
                        context.read<CartCubit>().decreaseQuantityOfItem(
                              isMerchandise
                                  ? (widget.cartItem.$2 as MerchandiseItem).id
                                  : (widget.cartItem.$2 as Pet).id,
                            );
                      })
                    ],
                  ))
              : Expanded(flex: 2, child: SizedBox())
        ],
      ),
    );
  }
}
