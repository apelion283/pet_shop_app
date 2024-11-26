import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_shop_app/domain/entities/marker.dart' as entity;
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class MarkerModel extends entity.Marker {
  const MarkerModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.location,
      required super.phoneNumber,
      required super.address,
      required super.openTime,
      required super.closeTime,
      required super.imageUrl});

  factory MarkerModel.fromFirestore(
      {required DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options}) {
    final data = snapshot.data();
    return MarkerModel(
        id: snapshot.id,
        name: data?["name"],
        description: data?["description"],
        location: LatLng((data?["location"] as GeoPoint).latitude,
            (data?["location"] as GeoPoint).longitude),
        phoneNumber: data?["phoneNumber"],
        address: data?["address"],
        openTime: (data?["openTime"] as Timestamp).toDate(),
        closeTime: (data?["closeTime"] as Timestamp).toDate(),
        imageUrl: data?["imageUrl"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "location": GeoPoint(location.latitude, location.longitude),
      "phoneNumber": phoneNumber,
      "address": address,
      "openTime": Timestamp.fromDate(openTime),
      "closeTime": Timestamp.fromDate(closeTime),
      "imageUrl": imageUrl
    };
  }
}
