import 'package:equatable/equatable.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';

class HomeState extends Equatable {
  final List<MerchandiseItem>? foodList;
  final String? foodListError;
  final List<MerchandiseItem>? accessoryList;
  final String? accessoryListError;

  const HomeState(
      {this.foodList,
      this.foodListError,
      this.accessoryList,
      this.accessoryListError});

  HomeState copyWith(
      {List<MerchandiseItem>? foodList,
      String? foodListError,
      List<MerchandiseItem>? accessoryList,
      String? accessoryListError}) {
    return HomeState(
        foodList: foodList ?? this.foodList,
        foodListError: foodListError ?? this.foodListError,
        accessoryList: accessoryList ?? this.accessoryList,
        accessoryListError: accessoryListError ?? this.accessoryListError);
  }

  @override
  List<Object?> get props =>
      [foodList, foodListError, accessoryList, accessoryListError];
}
