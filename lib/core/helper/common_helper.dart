import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/currency_rate.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/helper/money_format_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';

class CommonHelper {
  static final CommonHelper _commonHelper = CommonHelper._internal();
  factory CommonHelper() {
    return _commonHelper;
  }

  CommonHelper._internal();

  /// Helper for add to cart animation
  static Future<void> addButtonClickAnimation(
      {required BuildContext context,
      required GlobalKey widgetKey,
      required Function(GlobalKey) runAddToCartAnimation,
      required GlobalKey<CartIconKey> cartKey}) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!
        // ignore: use_build_context_synchronously
        .runCartAnimation(context.read<CartCubit>().state.getQuantity() >
                AppConfig.maxBadgeQuantity
            ? "${AppConfig.maxBadgeQuantity}+"
            // ignore: use_build_context_synchronously
            : "${context.read<CartCubit>().state.getQuantity()}");
  }

  ///Helper for locale
  static String getCurrencySymbolBaseOnLocale({required BuildContext context}) {
    return context.locale.toString() == "vi_VI"
        ? "đ"
        : context.locale.toString() == "en_EN"
            ? "\$"
            : "đ";
  }

  static String getPriceStringBaseOnLocale(
      {required BuildContext context, required double price}) {
    return context.locale.toString() == "vi_VI"
        ? MoneyFormatHelper.formatVNCurrency(price * CurrencyRate.vnd)
        : context.locale.toString() == "en_EN"
            ? "\$${price * 1}"
            : MoneyFormatHelper.formatVNCurrency(price * CurrencyRate.vnd);
  }

  static double getPriceBaseOnLocale(
      {required BuildContext context, required Object item}) {
    return item is! MerchandiseItem && item is! Pet
        ? throw Exception(
            "Must pass and Merchandise or Pet object to CommonHelper.getPriceBaseOnLocale()")
        : (item is MerchandiseItem ? item.price : (item as Pet).price) *
            (context.locale.toString() == "vi_VI"
                ? CurrencyRate.vnd
                : context.locale.toString() == "en_EN"
                    ? 1
                    : CurrencyRate.vnd);
  }

  ///Helper for dialog
  static void showSignInDialog(
      {required BuildContext context, required Object item}) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
              icon: Icons.question_mark_outlined,
              title: 'sign_in_to_shopping',
              message: 'need_to_sign_in_description',
              positiveButtonText: 'sign_in',
              negativeButtonText: 'cancel',
              onPositiveButtonClick: () {
                Navigator.pushNamed(context, RouteName.signIn,
                    arguments: SignInPageArguments(itemToAdd: (1, item)));
              },
              onNegativeButtonClick: () {
                Navigator.of(context).pop();
              });
        });
  }
}
