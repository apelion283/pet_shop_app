import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/repository/merchandise_repository.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

class MerchandiseUsecase {
  MerchandiseRepositoryImpl merchandiseRepositoryImpl;
  MerchandiseUsecase(this.merchandiseRepositoryImpl);

  Future<Either<Failure, List<MerchandiseItem>>> getAllFoodItems() async {
    final result = await merchandiseRepositoryImpl.getAllFoodItems();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Failure, List<MerchandiseItem>>> getAllAccessoryItems() async {
    final result = await merchandiseRepositoryImpl.getAllAccessoryItems();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Failure, MerchandiseItem>> getMerchandiseItemDatById(
      String itemId) async {
    final result =
        await merchandiseRepositoryImpl.getMerchandiseItemDataById(itemId);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
