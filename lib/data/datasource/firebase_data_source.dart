import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/enum/merchandise_type.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_auth_service.dart';
import 'package:flutter_pet_shop_app/data/models/bill_detail_model.dart';
import 'package:flutter_pet_shop_app/data/models/bill_model.dart';
import 'package:flutter_pet_shop_app/data/models/merchandise_item_model.dart';

abstract class FirebaseDataSource {
  FirebaseFirestore get database;

  Future<Either<Failure, List<MerchandiseItemModel>>> getAllMerchandise();
  Future<Either<Failure, List<MerchandiseItemModel>>> getAllFoodItems();
  Future<Either<Failure, List<MerchandiseItemModel>>> getAllAccessoryItems();
  Future<Either<Failure, MerchandiseItemModel>> getMerchandiseItemDataById(
      String itemId);

  Future<Either<Failure, String>> getBrandNameByBrandId(String brandId);
  Future<Failure?> checkOut(
      List<BillDetailModel> checkOutList, String? orderMessage);
}

class FirebaseDataSourceImpl implements FirebaseDataSource {
  @override
  FirebaseFirestore get database => FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<MerchandiseItemModel>>>
      getAllAccessoryItems() async {
    try {
      final merchandisesCollection = database.collection("merchandises");
      final result = await merchandisesCollection
          .where("type", isEqualTo: MerchandiseType.accessory.toJson())
          .get();
      return Right(result.docs
          .map((doc) =>
              MerchandiseItemModel.fromFirestore(doc, SnapshotOptions()))
          .toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MerchandiseItemModel>>> getAllFoodItems() async {
    try {
      final merchandisesCollection = database.collection("merchandises");
      final result = await merchandisesCollection
          .where("type", isEqualTo: MerchandiseType.food.toJson())
          .get();
      return Right(result.docs
          .map((doc) => MerchandiseItemModel.fromFirestore(doc, null))
          .toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MerchandiseItemModel>>> getAllMerchandise() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MerchandiseItemModel>> getMerchandiseItemDataById(
      String itemId) async {
    try {
      final merchandiseCollection = database.collection("merchandises");
      final result = await merchandiseCollection.doc(itemId).get();
      return Right(MerchandiseItemModel.fromFirestore(result, null));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getBrandNameByBrandId(String brandId) async {
    try {
      final brandCollection = database.collection("brands");
      final result = await brandCollection.doc(brandId).get();
      return Right(result["name"]);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Failure?> checkOut(
      List<BillDetailModel> checkOutList, String? orderMessage) async {
    try {
      final billsCollection = database.collection("bills");
      String billId = billsCollection.doc().id;
      await billsCollection.doc(billId).set(BillModel(
              id: billId,
              createdDate: DateTime.now(),
              totalAmount: checkOutList.fold<double>(
                  100, (total, item) => total += item.subTotal),
              accountId: FirebaseAuthServiceImpl().auth!.currentUser!.uid,
              orderMessage: orderMessage ?? "")
          .toJson());

      final billDetailsCollection = database.collection("billDetails");
      for (var item in checkOutList) {
        await billDetailsCollection.doc().set(BillDetailModel(
                id: "",
                merchandiseItemId: item.merchandiseItemId,
                billId: billId,
                createdDate: item.createdDate,
                quantity: item.quantity,
                subTotal: item.subTotal)
            .toJson());
      }
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
