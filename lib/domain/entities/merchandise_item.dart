import 'package:equatable/equatable.dart';
import 'package:flutter_pet_shop_app/core/enum/merchandise_type.dart';

class MerchandiseItem extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String imageUrl;
  final String weight;
  final double price;
  final MerchandiseType? type;
  final String manufactorId;
  final String brandId;

  const MerchandiseItem(
      {required this.id,
      required this.name,
      required this.description,
      required this.weight,
      required this.price,
      required this.imageUrl,
      this.type,
      required this.manufactorId,
      required this.brandId});

  factory MerchandiseItem.fromJson(Map<dynamic, dynamic> json) {
    return MerchandiseItem(
        id: "",
        name: json['name'],
        description: json['description'],
        weight: json['weight'],
        price: json['price'] as double,
        imageUrl: json['imageUrl'],
        manufactorId: json['manufactorId'],
        brandId: json['brandId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'weight': weight,
      'price': price,
      'imageUrl': imageUrl,
      'manufactorId': manufactorId,
      'brandId': brandId
    };
  }

  @override
  List<Object?> get props =>
      [id, name, description, weight, price, imageUrl, manufactorId, brandId];
}
