import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

class CartState {
  final List<(int, MerchandiseItem)>? cartList;
  const CartState({this.cartList});

  CartState copyWith(List<(int, MerchandiseItem)>? list) {
    return CartState(cartList: list ?? cartList);
  }
}
