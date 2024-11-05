import 'package:easy_localization/easy_localization.dart';

class MoneyFormatHelper {
  static final NumberFormat _numberFormat =
      NumberFormat.currency(locale: "VI", symbol: "đ");

  static String formatVNCurrency(num value) {
    return _numberFormat.format(value).replaceAll(".", ",").replaceAll(" ", "");
  }
}
