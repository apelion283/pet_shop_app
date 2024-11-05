import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/models/bill_detail_model.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

abstract class MerchandiseRepository {
  Future<Either<Failure, List<MerchandiseItem>>> getAllFoodItems();
  Future<Either<Failure, List<MerchandiseItem>>> getAllAccessoryItems();
  Future<Either<Failure, MerchandiseItem>> getMerchandiseItemDataById(
      String itemId);
  Future<Failure?> checkOut(
      List<(int, MerchandiseItem)> checkOutList, String? orderMessage);
}

class MerchandiseRepositoryImpl implements MerchandiseRepository {
  final FirebaseDataSourceImpl dataSourceImpl;
  MerchandiseRepositoryImpl(this.dataSourceImpl);
  @override
  Future<Either<Failure, List<MerchandiseItem>>> getAllAccessoryItems() async {
    final result = await dataSourceImpl.getAllAccessoryItems();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<MerchandiseItem>>> getAllFoodItems() async {
    final result = await dataSourceImpl.getAllFoodItems();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, MerchandiseItem>> getMerchandiseItemDataById(
      String itemId) async {
    final result = await dataSourceImpl.getMerchandiseItemDataById(itemId);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Failure?> checkOut(
      List<(int, MerchandiseItem)> checkOutList, String? orderMessage) async {
    try {
      List<BillDetailModel> billDetails = [];
      for (var item in checkOutList) {
        BillDetailModel billDetail = BillDetailModel(
            id: "",
            merchandiseItemId: item.$2.id!,
            billId: "",
            createdDate: DateTime.now(),
            quantity: item.$1,
            subTotal: item.$1 * item.$2.price);
        billDetails.add(billDetail);
      }
      return await dataSourceImpl.checkOut(billDetails, orderMessage);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
