import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/enum/merchandise_type.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_auth_service.dart';
import 'package:flutter_pet_shop_app/data/models/animal_type_model.dart';
import 'package:flutter_pet_shop_app/data/models/bill_detail_model.dart';
import 'package:flutter_pet_shop_app/data/models/bill_model.dart';
import 'package:flutter_pet_shop_app/data/models/marker_model.dart';
import 'package:flutter_pet_shop_app/data/models/merchandise_item_model.dart';
import 'package:flutter_pet_shop_app/data/models/pet_model.dart';
import 'package:flutter_pet_shop_app/data/models/pet_species_model.dart';

abstract class FirebaseDataSource {
  FirebaseFirestore get database;
  Future<Either<Failure, List<MerchandiseItemModel>>> getAllFoodItems();
  Future<Either<Failure, List<MerchandiseItemModel>>> getAllAccessoryItems();
  Future<Either<Failure, MerchandiseItemModel>> getMerchandiseItemDataById(
      String itemId);

  Future<Either<Failure, String>> getBrandNameByBrandId(String brandId);
  Future<Failure?> checkOut(
      {required List<BillDetailModel> checkOutList, String? orderMessage});
  Future<Either<Failure, (AnimalTypeModel, PetSpeciesModel, PetModel)>>
      getPetDataById(String petId);
  Future<Either<Failure, List<PetModel>>> getAllPets();
  Future<void> putDeviceToken(String deviceId, String token);
  Future<Either<Failure, List<MarkerModel>>> getAllMarker();
  Future<Either<Failure, MarkerModel>> getMarkerById(String markerId);
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
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
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
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, MerchandiseItemModel>> getMerchandiseItemDataById(
      String itemId) async {
    try {
      final merchandiseCollection = database.collection("merchandises");
      final result = await merchandiseCollection.doc(itemId).get();
      return Right(MerchandiseItemModel.fromFirestore(result, null));
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, String>> getBrandNameByBrandId(String brandId) async {
    try {
      final brandCollection = database.collection("brands");
      final result = await brandCollection.doc(brandId).get();
      return Right(result["name"]);
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Failure?> checkOut(
      {required List<BillDetailModel> checkOutList,
      String? orderMessage}) async {
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
    } on FirebaseException catch (e) {
      return Failure(message: e.message, code: e.code);
    }
  }

  @override
  Future<Either<Failure, List<PetModel>>> getAllPets() async {
    try {
      final petsCollection = database.collection('pets');
      final result = await petsCollection.get();
      final pets =
          result.docs.map((doc) => PetModel.fromFirestore(doc, null)).toList();
      return Right(pets);
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, (AnimalTypeModel, PetSpeciesModel, PetModel)>>
      getPetDataById(String petId) async {
    try {
      final petsCollection = database.collection('pets');
      final petResult = await petsCollection.doc(petId).get();
      final petFromFirebase = PetModel.fromFirestore(petResult, null);
      final animalTypeCollection = database.collection('animalTypes');
      final animalTypeResult =
          await animalTypeCollection.doc(petFromFirebase.animalTypeId).get();
      final petSpeciesCollection = database.collection('species');
      final petSpeciesResult =
          await petSpeciesCollection.doc(petFromFirebase.speciesId).get();
      return Right((
        AnimalTypeModel.fromFirestore(
            snapshot: animalTypeResult, options: null),
        PetSpeciesModel.fromFirestore(
            snapshot: petSpeciesResult, options: null),
        petFromFirebase
      ));
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<void> putDeviceToken(String deviceId, String token) async {
    try {
      final devicesTokenCollection = database.collection('deviceTokens');
      final result = await devicesTokenCollection.doc(deviceId).get();
      if (result.data()?["token"] == token) {
        return;
      } else {
        await devicesTokenCollection.doc(deviceId).set({"token": token});
      }
    } on FirebaseException catch (e) {
      e.toString();
    }
  }

  @override
  Future<Either<Failure, List<MarkerModel>>> getAllMarker() async {
    try {
      final markersCollection = database.collection("markers");
      final result = await markersCollection.get();
      return Right(result.docs
          .map((doc) => MarkerModel.fromFirestore(snapshot: doc, options: null))
          .toList());
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, MarkerModel>> getMarkerById(String markerId) async {
    try {
      final markersCollection = database.collection("markers");
      final result = await markersCollection.doc(markerId).get();
      return Right(MarkerModel.fromFirestore(snapshot: result, options: null));
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }
}
