import 'package:bloc/bloc.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/marker_repository.dart';
import 'package:flutter_pet_shop_app/domain/usecases/marker_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/marker_detail/cubit/marker_detail_state.dart';

class MarkerDetailCubit extends Cubit<MarkerDetailState> {
  final MarkerUsecase markerUsecase = MarkerUsecase(
      markerRepositoryImpl: MarkerRepositoryImpl(
          firebaseDataSourceImpl: FirebaseDataSourceImpl()));
  MarkerDetailCubit() : super(MarkerDetailState());

  Future<void> getMarkerDetailById(String markerId) async {
    final result = await markerUsecase.getMarkerById(markerId);
    if (result.isRight) {
      emit(state.copyWith(result.right));
    }
  }
}
