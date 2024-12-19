import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/wish_list_repository.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/domain/usecases/wish_list_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListState());

  final _wishListUsecase = WishListUsecase(
      wishListRepositoryImpl:
          WishListRepositoryImpl(dataSourceImpl: FirebaseDataSourceImpl()));

  void getWishListOfUser({String? userId}) async {
    if (userId == null) {
      emit(state.copyWith());
    } else {
      final result = await _wishListUsecase.getWishListOfUser(userId: userId);
      if (result.isLeft) {
        emit(state.copyWith());
      } else {
        List<Either<MerchandiseItem, Pet>> resultList = [];
        result.right
            .map((element) => element is MerchandiseItem
                ? resultList.add(Left(element))
                : resultList.add(Right(element as Pet)))
            .toList();
        emit(state.copyWith(wishList: resultList));
      }
    }
  }

  void addItemToWishList(
      {required String userId,
      required String itemId,
      required bool isMerchandiseItem}) async {
    final result = await _wishListUsecase.addItemToWishList(
        userId: userId, itemId: itemId, isMerchandiseItem: isMerchandiseItem);
    if (result == null) {
      getWishListOfUser(userId: userId);
    }
  }

  void removeItemFromWishList(
      {required String userId, required String itemId}) async {
    final result = await _wishListUsecase.removeItemFromWishList(
        userId: userId, itemId: itemId);
    if (result == null) {
      getWishListOfUser(userId: userId);
    }
  }

  bool isItemInWishList({required String itemId}) {
    return state.wishList.any((item) {
      if (item.isLeft) {
        if (item.left.id == itemId) {
          return true;
        }
      } else if (item.isRight) {
        if (item.right.id == itemId) {
          return true;
        }
      }
      return false;
    });
  }
}
