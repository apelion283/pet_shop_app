import 'package:flutter_pet_shop_app/domain/entities/marker.dart';

class MarkersState {
  final List<Marker> markerList;
  const MarkersState({this.markerList = const []});

  MarkersState copyWith(List<Marker>? markers) {
    return MarkersState(markerList: markers ?? markerList);
  }
}
