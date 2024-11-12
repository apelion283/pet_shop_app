import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String? id;
  final String name;
  final DateTime birthday;
  final bool gender;
  final String weight;
  final String height;
  final String color;
  final String description;
  final double price;
  final String imageUrl;
  final String animalTypeId;
  final String speciesId;

  const Pet(
      {required this.id,
      required this.name,
      required this.birthday,
      required this.gender,
      required this.weight,
      required this.height,
      required this.color,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.animalTypeId,
      required this.speciesId});

  @override
  List<Object?> get props => [
        id,
        name,
        birthday,
        gender,
        weight,
        height,
        color,
        description,
        price,
        imageUrl,
        animalTypeId,
        speciesId
      ];

  factory Pet.fromJson(Map<dynamic, dynamic> json) {
    return Pet(
        id: json['id'],
        name: json['name'],
        birthday: DateTime.parse(json['birthday']),
        gender: json['gender'],
        weight: json['weight'],
        height: json['height'],
        color: json['color'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'],
        animalTypeId: json['animalTypeId'],
        speciesId: json['speciesId']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "birthday": birthday.toIso8601String(),
      "gender": gender,
      "weight": weight,
      "height": height,
      "color": color,
      "price": price,
      "imageUrl": imageUrl,
      "animalTypeId": animalTypeId,
      "speciesId": speciesId
    };
  }
}
