import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/repository/pet_repository.dart';
import 'package:flutter_pet_shop_app/domain/entities/animal_type.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet_species.dart';

class PetUsecase {
  final PetRepositoryImpl petRepositoryImpl;
  const PetUsecase({required this.petRepositoryImpl});

  Future<Either<Failure, (AnimalType, PetSpecies, Pet)>> getPetDataById(
      String petId) async {
    final result = await petRepositoryImpl.getPetDataById(petId);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Failure, List<Pet>>> getAllPet() async {
    final result = await petRepositoryImpl.getAllPet();
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
