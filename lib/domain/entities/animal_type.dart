import 'package:equatable/equatable.dart';

class AnimalType extends Equatable {
  final String id;
  final String name;
  const AnimalType({required this.id, required this.name});
  @override
  List<Object?> get props => [id, name];
}
