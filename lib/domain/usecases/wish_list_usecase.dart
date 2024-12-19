import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/repository/wish_list_repository.dart';

class WishListUsecase {
  final WishListRepositoryImpl wishListRepositoryImpl;
  const WishListUsecase({required this.wishListRepositoryImpl});

  Future<Either<Failure, List<Object>>> getWishListOfUser(
      {required String userId}) async {
    return await wishListRepositoryImpl.getWishListOfUser(userId: userId);
  }

  Future<Failure?> addItemToWishList(
      {required String userId,
      required String itemId,
      required bool isMerchandiseItem}) async {
    return await wishListRepositoryImpl.addItemToWishList(
        userId: userId, itemId: itemId, isMerchandiseItem: isMerchandiseItem);
  }

  Future<Failure?> removeItemFromWishList(
      {required String userId, required String itemId}) async {
    return await wishListRepositoryImpl.removeItemFromWishList(
        itemId: itemId, userId: userId);
  }
}
