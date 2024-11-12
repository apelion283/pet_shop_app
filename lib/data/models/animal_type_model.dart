import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_shop_app/domain/entities/animal_type.dart';

class AnimalTypeModel extends AnimalType {
  const AnimalTypeModel({required super.id, required super.name});

  factory AnimalTypeModel.fromFirestore(
      {required DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options}) {
    final data = snapshot.data();
    return AnimalTypeModel(id: snapshot.id, name: data?['name']);
  }
}
