import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/repository/marker_repository.dart';
import 'package:flutter_pet_shop_app/domain/entities/marker.dart';

class MarkerUsecase {
  final MarkerRepositoryImpl markerRepositoryImpl;
  const MarkerUsecase({required this.markerRepositoryImpl});

  Future<Either<Failure, Marker>> getMarkerById(String markerId) async {
    return await markerRepositoryImpl.getMarkerById(markerId);
  }

  Future<Either<Failure, List<Marker>>> getAllMarker() async {
    return await markerRepositoryImpl.getAllMarker();
  }
}
