import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/models/bill_detail_model.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

abstract class MerchandiseRepository {
  Future<Either<Failure, List<MerchandiseItem>>> getAllFoodItems();
  Future<Either<Failure, List<MerchandiseItem>>> getAllAccessoryItems();
  Future<Either<Failure, MerchandiseItem>> getMerchandiseItemDataById(
      String itemId);
  Future<Failure?> checkOut(
      {required List<(int, MerchandiseItem)> checkOutList,
      String? orderMessage});
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
      {required List<(int, Object)> checkOutList, String? orderMessage}) async {
    try {
      List<BillDetailModel> billDetails = [];
      for (var item in checkOutList) {
        bool isMerchandise = item.$2 is MerchandiseItem;
        BillDetailModel billDetail = BillDetailModel(
            id: "",
            merchandiseItemId: isMerchandise
                ? (item.$2 as MerchandiseItem).id!
                : (item.$2 as Pet).id!,
            billId: "",
            createdDate: DateTime.now(),
            quantity: item.$1,
            subTotal: item.$1 *
                (isMerchandise
                    ? (item.$2 as MerchandiseItem).price
                    : (item.$2 as Pet).price));
        billDetails.add(billDetail);
      }
      return await dataSourceImpl.checkOut(
          checkOutList: billDetails, orderMessage: orderMessage);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
