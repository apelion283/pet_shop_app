import 'package:bloc/bloc.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/merchandise_repository.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/domain/usecases/merchandise_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:hive/hive.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  final MerchandiseUsecase _usecase =
      MerchandiseUsecase(MerchandiseRepositoryImpl(FirebaseDataSourceImpl()));

  void loadDataFromLocal() {
    var cartBox = Hive.box('cartBox');
    List<(int, Object)> cartList = [];
    if (cartBox.isOpen && cartBox.isNotEmpty) {
      for (var item in cartBox.values) {
        cartList.add((
          item["quantity"] as int,
          item["isMerchandise"]
              ? MerchandiseItem.fromJson(item["item"])
              : Pet.fromJson(item["item"])
        ));
      }
      emit(state.copyWith(cartList));
    }
  }

  void clearCart() {
    emit(state.copyWith([]));
  }

  void addProduct(Object? item, int quantity) {
    if (item != null) {
      var updateCartList = [...state.cartList];
      int indexOfItem = getIndexOfItem(
          itemId: item is MerchandiseItem ? item.id : (item as Pet).id);
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
    }
  }

  void increaseQuantityOfItem(String? itemId) {
    var updateCartList = [...state.cartList];
    if (itemId != null) {
      int indexOfItem = getIndexOfItem(itemId: itemId);
      if (indexOfItem > -1) {
        updateCartList[indexOfItem] = (
          updateCartList[indexOfItem].$1 + 1,
          updateCartList[indexOfItem].$2
        );
        emit(state.copyWith(updateCartList));
      }
    }
  }

  void decreaseQuantityOfItem(
    String? itemId,
  ) {
    var updateCartList = [...state.cartList];
    if (itemId != null) {
      int indexOfItem = getIndexOfItem(itemId: itemId);
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

  void updateCart((int, Object) cartItem) {
    bool isMerchandiseItem;
    if (cartItem.$2 is MerchandiseItem) {
      isMerchandiseItem = true;
    } else {
      isMerchandiseItem = false;
    }
    var updateCartList = [...state.cartList];
    int indexOfItem = getIndexOfItem(
        itemId: isMerchandiseItem
            ? (cartItem.$2 as MerchandiseItem).id
            : (cartItem.$2 as Pet).id);
    if (indexOfItem > -1) {
      updateCartList[indexOfItem] = (cartItem.$1, cartItem.$2);
      emit(state.copyWith(updateCartList));
    } else {
      addProduct(cartItem.$2, cartItem.$1);
    }
  }

  void deleteItemFromCart(String itemId) {
    var updateCartList = [...state.cartList];
    int indexOfItem = getIndexOfItem(itemId: itemId);
    if (indexOfItem > -1) {
      updateCartList.removeAt(indexOfItem);
      emit(state.copyWith(updateCartList));
    }
  }

  Future<Failure?> checkOut(
      List<(int, Object)> checkOutList, String? orderMessage) async {
    final result = await _usecase.checkOut(
        checkOutList: checkOutList, orderMessage: orderMessage);
    if (result == null) {
      clearCart();
      return null;
    } else {
      return result;
    }
  }

  bool isPetExistInCart(Pet pet) {
    return state.cartList
            .indexWhere((element) => (element.$2 as Pet).id == pet.id) !=
        -1;
  }

  int getIndexOfItem({required itemId}) {
    return state.cartList.indexWhere((element) =>
        (element.$2 is MerchandiseItem)
            ? (element.$2 as MerchandiseItem).id == itemId
            : (element.$2 as Pet).id == itemId);
  }
}
