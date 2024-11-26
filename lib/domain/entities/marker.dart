import 'package:equatable/equatable.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class Marker extends Equatable {
  final String id;
  final String name;
  final String description;
  final LatLng location;
  final String phoneNumber;
  final String address;
  final DateTime openTime;
  final DateTime closeTime;
  final String imageUrl;

  const Marker({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.phoneNumber,
    required this.address,
    required this.openTime,
    required this.closeTime,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        location,
        phoneNumber,
        address,
        openTime,
        closeTime,
        imageUrl
      ];
}
