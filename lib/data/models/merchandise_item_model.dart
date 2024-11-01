import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_shop_app/core/enum/merchandise_type.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

class MerchandiseItemModel extends MerchandiseItem {
  MerchandiseItemModel(
      {required String id,
      required super.name,
      required super.description,
      required super.weight,
      required super.price,
      required super.imageUrl,
      required super.type,
      required super.manufactorId,
      required super.brandId})
      : super(id: id);

  factory MerchandiseItemModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return MerchandiseItemModel(
        id: snapshot.id,
        name: data?["name"],
        description: data?["description"],
        weight: data?["weight"],
        price: (data?["price"] as num).toDouble(),
        imageUrl: data?["imageUrl"],
        type: MerchandiseType.fromJson(data?["type"]),
        manufactorId: data?["manufactorId"],
        brandId: data?["brandId"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      "name": name,
      "description": description,
      "weight": weight,
      "price": price,
      "imageUrl": imageUrl,
      "type": type?.toJson(),
      "manufactorId": manufactorId,
      "brandId": brandId
    };
  }
}
