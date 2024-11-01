import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/repository/brand_repository.dart';

class BrandUsecase {
  final BrandRepositoryImpl repositoryImpl;
  BrandUsecase(this.repositoryImpl);

  Future<Either<Failure, String>> getBrandNameById(String brandId) async {
    try {
      final result = await repositoryImpl.getBrandNameById(brandId);
      return result.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
