import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/models/wish_list_item_type_model.dart';

abstract class WishListRepository {
  Future<Either<Failure, List<Object>>> getWishListOfUser(
      {required String userId});
  Future<Failure?> addItemToWishList(
      {required String userId,
      required String itemId,
      required bool isMerchandiseItem});
  Future<Failure?> removeItemFromWishList(
      {required String itemId, required String userId});
}

class WishListRepositoryImpl implements WishListRepository {
  final FirebaseDataSourceImpl dataSourceImpl;
  const WishListRepositoryImpl({required this.dataSourceImpl});
  @override
  Future<Either<Failure, List<Object>>> getWishListOfUser(
      {required String userId}) async {
    return await dataSourceImpl.getWishListItemOfUser(userId: userId);
  }

  @override
  Future<Failure?> addItemToWishList(
      {required String userId,
      required String itemId,
      required bool isMerchandiseItem}) async {
    return await dataSourceImpl.addItemToWishList(
        itemId: itemId,
        userId: userId,
        type: isMerchandiseItem ? ItemType.merchandiseItem : ItemType.pet);
  }

  @override
  Future<Failure?> removeItemFromWishList(
      {required String itemId, required String userId}) async {
    return await dataSourceImpl.removeItemFromWishList(
        itemId: itemId, userId: userId);
  }
}
