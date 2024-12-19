import 'package:cloud_firestore/cloud_firestore.dart';

class WishListItemModel {
  final String id;
  final String itemId;
  final ItemType type;
  final String userId;
  const WishListItemModel(
      {required this.id,
      required this.itemId,
      required this.type,
      required this.userId});

  factory WishListItemModel.fromFirestore(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? option}) {
    final data = snapshot.data();
    return WishListItemModel(
        id: snapshot.id,
        itemId: data["itemId"],
        userId: data["userId"],
        type: ItemType.fromJson(name: data["type"]));
  }

  Map<String, dynamic> toFirestore() {
    return {
      "itemId": itemId,
      "userId": userId,
      "type": type.toJson()
    };
  }
}

enum ItemType {
  merchandiseItem,
  pet;

  String toJson() {
    return name;
  }

  static ItemType fromJson({required String name}) =>
      ItemType.values.byName(name);
}
