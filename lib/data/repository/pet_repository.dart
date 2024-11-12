import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/domain/entities/animal_type.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet_species.dart';

abstract class PetRepository {
  Future<Either<Failure, (AnimalType, PetSpecies, Pet)>> getPetDataById(
      String petId);
  Future<Either<Failure, List<Pet>>> getAllPet();
}

class PetRepositoryImpl extends PetRepository {
  final FirebaseDataSourceImpl firebaseDataSourceImpl;
  PetRepositoryImpl({required this.firebaseDataSourceImpl});
  @override
  Future<Either<Failure, List<Pet>>> getAllPet() async {
    final result = await firebaseDataSourceImpl.getAllPets();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, (AnimalType, PetSpecies, Pet)>> getPetDataById(
      String petId) async {
    final result = await firebaseDataSourceImpl.getPetDataById(petId);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
