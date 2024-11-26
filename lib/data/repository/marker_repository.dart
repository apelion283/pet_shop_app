import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/domain/entities/marker.dart';

abstract class MarkerRepository {
  Future<Either<Failure, Marker>> getMarkerById(String markerId);
  Future<Either<Failure, List<Marker>>> getAllMarker();
}

class MarkerRepositoryImpl implements MarkerRepository {
  final FirebaseDataSourceImpl firebaseDataSourceImpl;
  const MarkerRepositoryImpl({required this.firebaseDataSourceImpl});

  @override
  Future<Either<Failure, List<Marker>>> getAllMarker() async {
    return await firebaseDataSourceImpl.getAllMarker();
  }

  @override
  Future<Either<Failure, Marker>> getMarkerById(String markerId) async {
    return await firebaseDataSourceImpl.getMarkerById(markerId);
  }
}
