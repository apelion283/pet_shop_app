import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/pet_repository.dart';
import 'package:flutter_pet_shop_app/domain/usecases/pet_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/pet/cubit/pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetUsecase _petUsecase = PetUsecase(
      petRepositoryImpl:
          PetRepositoryImpl(firebaseDataSourceImpl: FirebaseDataSourceImpl()));
  PetCubit() : super(PetState());

  void getPetDataById(String petId) async {
    final result = await _petUsecase.getPetDataById(petId);
    if (result.isRight) {
      emit(state.copyWith(
          type: result.right.$1,
          species: result.right.$2,
          pet: result.right.$3));
    } else {
      result.left.message;
    }
  }
}
