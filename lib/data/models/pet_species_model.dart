import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet_species.dart';

class PetSpeciesModel extends PetSpecies {
  const PetSpeciesModel(
      {required super.id, required super.name, required super.animalTypeId});

  factory PetSpeciesModel.fromFirestore(
      {required DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options}) {
    final data = snapshot.data();
    return PetSpeciesModel(
        id: snapshot.id,
        name: data?['name'],
        animalTypeId: data?['animalTypeId']);
  }
}
