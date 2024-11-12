import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

class ExploreState {
  final List<Pet> petList;
  final List<MerchandiseItem> accessoryList;
  final List<MerchandiseItem> foodList;
  const ExploreState(
      {this.petList = const [],
      this.accessoryList = const [],
      this.foodList = const []});

  ExploreState copyWith(
      {List<Pet>? petList,
      List<MerchandiseItem>? accessoryList,
      List<MerchandiseItem>? foodList}) {
    return ExploreState(
        petList: petList ?? this.petList,
        accessoryList: accessoryList ?? this.accessoryList,
        foodList: foodList ?? this.foodList);
  }
}
