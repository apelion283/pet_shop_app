import 'package:flutter_pet_shop_app/domain/entities/marker.dart';

class MarkerDetailState {
  final Marker? marker;
  const MarkerDetailState({this.marker});

  MarkerDetailState copyWith(Marker? marker) {
    return MarkerDetailState(marker: marker ?? this.marker);
  }
}
