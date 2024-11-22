import 'package:either_dart/either.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> signInLog(
      {String? loginMethod, Map<String, Object>? parameters}) async {
    await _analytics.logLogin(loginMethod: loginMethod, parameters: parameters);
  }

  Future<void> viewProductLog(
      {String? currency, double? itemValue, Object? item}) async {
    await _analytics.logViewItem(
        currency: currency != null && itemValue != null ? currency : null,
        value: currency != null && itemValue != null ? itemValue : null,
        items: item == null
            ? []
            : [
                AnalyticsEventItem(
                    itemId: item is MerchandiseItem
                        ? item.id
                        : item is Pet
                            ? item.id
                            : "",
                    itemName: item is MerchandiseItem
                        ? item.name
                        : item is Pet
                            ? item.name
                            : "",
                    itemBrand: item is MerchandiseItem
                        ? item.brandId
                        : item is Pet
                            ? item.speciesId
                            : "",
                    itemCategory: item is MerchandiseItem
                        ? item.type!.toJson()
                        : item is Pet
                            ? item.animalTypeId
                            : ""),
              ]);
  }

  Future<void> addItemToCartLog(
      {String? currency, double? itemValue, Object? item}) async {
    _analytics.logAddToCart(
        currency: currency != null && itemValue != null ? currency : null,
        value: currency != null && itemValue != null ? itemValue : null,
        items: item == null
            ? []
            : [
                AnalyticsEventItem(
                    itemId: item is MerchandiseItem
                        ? item.id
                        : item is Pet
                            ? item.id
                            : "",
                    itemName: item is MerchandiseItem
                        ? item.name
                        : item is Pet
                            ? item.name
                            : "",
                    itemBrand: item is MerchandiseItem
                        ? item.brandId
                        : item is Pet
                            ? item.speciesId
                            : "",
                    itemCategory: item is MerchandiseItem
                        ? item.type!.toJson()
                        : item is Pet
                            ? item.animalTypeId
                            : "",
                    itemCategory2:
                        item is MerchandiseItem ? "Merchandise" : "Pet"),
              ]);
  }

  Future<void> checkOutLog(
      {String? currency,
      double? total,
      List<(int, Object)>? items,
      String? message}) async {
    List<(int, Either<MerchandiseItem, Pet>)> cartList = [];

    if (items != null) {
      for (var item in items) {
        if (item is MerchandiseItem) {
          cartList.add((item.$1, Left(item.$2 as MerchandiseItem)));
        } else if (item is Pet) {
          cartList.add((item.$1, Right(item.$2 as Pet)));
        }
      }
    } else {
      cartList = [];
    }
    await _analytics.logPurchase(
        currency: currency != null && total != null ? currency : null,
        value: currency != null && total != null ? total : null,
        items: List.generate(cartList.length, (index) {
          bool isMerchandise = cartList[index] is MerchandiseItem;
          return AnalyticsEventItem(
            itemId: isMerchandise
                ? cartList[index].$2.left.id
                : cartList[index].$2.right.id,
            itemName: isMerchandise
                ? cartList[index].$2.left.name
                : cartList[index].$2.right.name,
            itemBrand: isMerchandise
                ? cartList[index].$2.left.brandId
                : cartList[index].$2.right.animalTypeId,
            itemCategory: isMerchandise
                ? cartList[index].$2.left.type.toString()
                : cartList[index].$2.right.speciesId,
            itemCategory2: isMerchandise ? "Merchandise" : "Pet",
            quantity: cartList[index].$1,
            price: isMerchandise
                ? cartList[index].$2.left.price
                : cartList[index].$2.right.price,
          );
        }),
        parameters: {"message": message!});
  }
}
