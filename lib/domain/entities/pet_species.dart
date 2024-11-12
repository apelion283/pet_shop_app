import 'package:equatable/equatable.dart';

class PetSpecies extends Equatable {
  final String id;
  final String name;
  final String animalTypeId;
  const PetSpecies(
      {required this.id, required this.name, required this.animalTypeId});
  @override
  List<Object?> get props => [id, name, animalTypeId];
}
