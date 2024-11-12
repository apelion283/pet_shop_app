import 'package:flutter_pet_shop_app/domain/entities/animal_type.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet_species.dart';

class PetState {
  final Pet? pet;
  final AnimalType? type;
  final PetSpecies? species;
  const PetState({this.pet, this.type, this.species});

  PetState copyWith({Pet? pet, AnimalType? type, PetSpecies? species}) {
    return PetState(
        pet: pet ?? this.pet,
        type: type ?? this.type,
        species: species ?? this.species);
  }
}
