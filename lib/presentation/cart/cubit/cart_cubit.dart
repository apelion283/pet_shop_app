import 'package:bloc/bloc.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  void loadDataFromLocal() {}

  void addProduct(MerchandiseItem? item, int quantity) {
    if (item != null) {
      if (state.cartList != null) {
        var updateCartList = state.cartList;
        int indexOfItem =
            updateCartList!.indexWhere((element) => element.$2.id == item.id);
        if (indexOfItem > -1) {
          updateCartList[indexOfItem] = (
            updateCartList[indexOfItem].$1 + quantity,
            updateCartList[indexOfItem].$2
          );
          emit(state.copyWith(updateCartList));
        } else {
          updateCartList.add((quantity, item));
          emit(state.copyWith(updateCartList));
        }
      } else {
        var newCartList = state.cartList;
        newCartList = [];
        newCartList.add((quantity, item));
        emit(state.copyWith(newCartList));
      }
    }
  }

  void checkoutCart() async {}

  void increaseQuantityOfItem(String? itemId) {
    var updateCartList = state.cartList;
    if (updateCartList != null && itemId != null) {
      int indexOfItem =
          updateCartList.indexWhere((element) => element.$2.id == itemId);
      if (indexOfItem > -1) {
        updateCartList[indexOfItem] = (
          updateCartList[indexOfItem].$1 + 1,
          updateCartList[indexOfItem].$2
        );
        emit(state.copyWith(updateCartList));
      }
    }
  }

  void decreaseQuantityOfItem(String? itemId) {
    var updateCartList = state.cartList;
    if (updateCartList != null && itemId != null) {
      int indexOfItem =
          updateCartList.indexWhere((element) => element.$2.id == itemId);
      if (indexOfItem > -1) {
        if (updateCartList[indexOfItem].$1 <= 1) {
          updateCartList[indexOfItem] = (1, updateCartList[indexOfItem].$2);
        } else {
          updateCartList[indexOfItem] = (
            updateCartList[indexOfItem].$1 - 1,
            updateCartList[indexOfItem].$2
          );
        }
        emit(state.copyWith(updateCartList));
      }
    }
  }

  void updateCart((int, MerchandiseItem) cartItem) {
    var updateCartList = state.cartList;
    if (updateCartList != null) {
      int indexOfItem = updateCartList
          .indexWhere((element) => element.$2.id == cartItem.$2.id);
      if (indexOfItem > -1) {
        updateCartList[indexOfItem] = (cartItem.$1, cartItem.$2);
        emit(state.copyWith(updateCartList));
      } else {
        addProduct(cartItem.$2, cartItem.$1);
      }
    } else {
      addProduct(cartItem.$2, cartItem.$1);
    }
  }

  void deleteItemFromCart(String itemId) {
    var updateCartList = state.cartList;
    if (updateCartList != null) {
      int indexOfItem =
          updateCartList.indexWhere((element) => element.$2.id == itemId);
      // for (var item in updateCartList) {
      //   print("before: quantity: ${item.$1} -- id: ${item.$2.id}");
      // }
      if (indexOfItem > -1) {
        updateCartList.removeAt(indexOfItem);
        // for (var item in updateCartList) {
        //   print("after: quantity: ${item.$1} -- id: ${item.$2.id}");
        // }
        emit(state.copyWith(updateCartList));
      }
    }
  }
}
