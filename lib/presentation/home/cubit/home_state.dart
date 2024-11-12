import 'package:equatable/equatable.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

class HomeState extends Equatable {
  final List<MerchandiseItem> foodList;
  final String? foodListError;
  final List<MerchandiseItem> accessoryList;
  final String? accessoryListError;
  final List<Pet> petList;
  final String? petListError;

  const HomeState(
      {this.foodList = const [],
      this.foodListError,
      this.accessoryList = const [],
      this.accessoryListError,
      this.petList = const [],
      this.petListError});

  HomeState copyWith(
      {List<MerchandiseItem>? foodList,
      String? foodListError,
      List<MerchandiseItem>? accessoryList,
      String? accessoryListError,
      List<Pet>? petList,
      String? petListError}) {
    return HomeState(
        foodList: foodList ?? this.foodList,
        foodListError: foodListError ?? this.foodListError,
        accessoryList: accessoryList ?? this.accessoryList,
        accessoryListError: accessoryListError ?? this.accessoryListError,
        petList: petList ?? this.petList,
        petListError: petListError ?? this.petListError);
  }

  @override
  List<Object?> get props => [
        foodList,
        foodListError,
        accessoryList,
        accessoryListError,
        petList,
        petListError
      ];
}
