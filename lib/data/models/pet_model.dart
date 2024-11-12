import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

class PetModel extends Pet {
  const PetModel(
      {required String id,
      required super.name,
      required super.birthday,
      required super.gender,
      required super.weight,
      required super.height,
      required super.color,
      required super.description,
      required super.price,
      required super.imageUrl,
      required super.animalTypeId,
      required super.speciesId})
      : super(id: id);

  factory PetModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return PetModel(
        id: snapshot.id,
        name: data?['name'],
        birthday: (data?['birthday'] as Timestamp).toDate(),
        gender: data?['gender'] as bool,
        weight: data?['weight'],
        height: data?['height'],
        color: data?['color'],
        description: data?['description'],
        price: (data?['price'] as num).toDouble(),
        imageUrl: data?['imageUrl'],
        animalTypeId: data?['animalTypeId'],
        speciesId: data?['speciesId']);
  }
}
