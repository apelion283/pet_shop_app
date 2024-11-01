import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/brand_repository.dart';
import 'package:flutter_pet_shop_app/data/repository/merchandise_repository.dart';
import 'package:flutter_pet_shop_app/domain/usecases/brand_usecase.dart';
import 'package:flutter_pet_shop_app/domain/usecases/merchandise_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/cubit/merchandise_detail_state.dart';

class MerchandiseDetailCubit extends Cubit<MerchandiseDetailState> {
  MerchandiseDetailCubit() : super(MerchandiseDetailState());

  final MerchandiseUsecase _merchandiseUsecase =
      MerchandiseUsecase(MerchandiseRepositoryImpl(FirebaseDataSourceImpl()));
  final BrandUsecase _brandUsecase =
      BrandUsecase(BrandRepositoryImpl(FirebaseDataSourceImpl()));

  void getMerchandiseDataById(String itemId) async {
    try {
      final result =
          await _merchandiseUsecase.getMerchandiseItemDatById(itemId);
      result.fold((l) => {}, (r) => emit(state.copyWith(result.right, null)));
      if (result.isRight) {
        final brandResult =
            await _brandUsecase.getBrandNameById(state.item!.brandId);
        brandResult.fold((l) => {}, (r) => emit(state.copyWith(state.item, r)));
      }
    } catch (e) {
      e.toString();
    }
  }
}
