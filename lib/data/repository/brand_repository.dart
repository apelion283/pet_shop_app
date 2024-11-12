import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';

abstract class BrandRepository {
  Future<Either<Failure, String>> getBrandNameById(String brandId);
}

class BrandRepositoryImpl implements BrandRepository {
  final FirebaseDataSourceImpl dataSourceImpl;
  BrandRepositoryImpl(this.dataSourceImpl);
  @override
  Future<Either<Failure, String>> getBrandNameById(String brandId) async {
    try {
      final result = await dataSourceImpl.getBrandNameByBrandId(brandId);
      return result.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
