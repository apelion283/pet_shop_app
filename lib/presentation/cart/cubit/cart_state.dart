import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

class CartState {
  final List<(int, MerchandiseItem)> cartList;
  const CartState({this.cartList = const []});

  CartState copyWith(List<(int, MerchandiseItem)>? list) {
    return CartState(cartList: list ?? cartList);
  }

  double getTotal() =>
      cartList.fold(0, (sum, item) => sum += item.$1 * item.$2.price);
}
