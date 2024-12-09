import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

class CartState {
  final List<(int, Object)> cartList;
  const CartState({this.cartList = const []});

  CartState copyWith(List<(int, Object)>? list) {
    return CartState(cartList: list ?? cartList);
  }

  int getQuantity() {
    return cartList.fold(0, (sum, item) {
      sum += item.$1;
      return sum;
    });
  }

  double getTotal() {
    return cartList.fold(0, (sum, item) {
      if (item.$2 is MerchandiseItem) {
        sum += item.$1 * (item.$2 as MerchandiseItem).price;
      } else if (item.$2 is Pet) {
        sum += item.$1 * (item.$2 as Pet).price;
      }
      return sum;
    });
  }
}
