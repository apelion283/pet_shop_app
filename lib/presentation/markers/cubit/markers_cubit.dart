import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/marker_repository.dart';
import 'package:flutter_pet_shop_app/domain/usecases/marker_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/markers/cubit/markers_state.dart';

class MarkersCubit extends Cubit<MarkersState> {
  final MarkerUsecase _markerUsecase = MarkerUsecase(
      markerRepositoryImpl: MarkerRepositoryImpl(
          firebaseDataSourceImpl: FirebaseDataSourceImpl()));
  MarkersCubit() : super(MarkersState());

  Future<void> getAllMarkers() async {
    final result = await _markerUsecase.getAllMarker();
    if (result.isRight) {
      emit(state.copyWith(result.right));
    } else {
      emit(state.copyWith(null));
    }
  }
}
