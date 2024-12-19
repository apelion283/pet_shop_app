import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

class WishListState {
  final List<Either<MerchandiseItem, Pet>> wishList;
  const WishListState({this.wishList = const []});

  WishListState copyWith({List<Either<MerchandiseItem, Pet>>? wishList}) {
    return WishListState(wishList: wishList ?? const []);
  }
}
