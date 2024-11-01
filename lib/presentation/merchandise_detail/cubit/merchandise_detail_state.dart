import 'package:equatable/equatable.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

class MerchandiseDetailState extends Equatable {
  final MerchandiseItem? item;
  final String? brandName;
  const MerchandiseDetailState({this.item, this.brandName});

  MerchandiseDetailState copyWith(MerchandiseItem? item, String? brandName) {
    return MerchandiseDetailState(
        item: item ?? this.item, brandName: brandName ?? this.brandName);
  }

  @override
  List<Object?> get props => [item, brandName];
}
