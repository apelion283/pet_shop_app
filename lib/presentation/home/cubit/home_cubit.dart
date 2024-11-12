import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/merchandise_repository.dart';
import 'package:flutter_pet_shop_app/data/repository/pet_repository.dart';
import 'package:flutter_pet_shop_app/domain/usecases/merchandise_usecase.dart';
import 'package:flutter_pet_shop_app/domain/usecases/pet_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final _merchandiseUsecase =
      MerchandiseUsecase(MerchandiseRepositoryImpl(FirebaseDataSourceImpl()));

  final _petUsecase = PetUsecase(
      petRepositoryImpl:
          PetRepositoryImpl(firebaseDataSourceImpl: FirebaseDataSourceImpl()));

  void getInitData() async {
    getAllPet();
    getAllFoodItems();
    getAllAccessoryItems();
  }

  void getAllPet() async {
    final result = await _petUsecase.getAllPet();
    result.fold((l) => emit(state.copyWith(petListError: l.message)),
        (r) => emit(state.copyWith(petList: r)));
  }

  void getAllFoodItems() async {
    final result = await _merchandiseUsecase.getAllFoodItems();
    result.fold(
        (l) => emit(state.copyWith(foodListError: l.message)),
        (r) => emit(state.copyWith(
            foodList: r..sort((a, b) => a.name.compareTo(b.name)))));
  }

  void getAllAccessoryItems() async {
    final result = await _merchandiseUsecase.getAllAccessoryItems();
    result.fold((l) => emit(state.copyWith(accessoryListError: l.message)),
        (r) => emit(state.copyWith(accessoryList: r)));
  }
}
