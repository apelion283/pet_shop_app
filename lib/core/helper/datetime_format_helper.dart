import 'package:easy_localization/easy_localization.dart';

class DateTimeFormatHelper {
  static final DateFormat _dateFormat = DateFormat.yMd("vi");

  static String formatVNDate(DateTime value) {
    return _dateFormat.format(value);
  }
}
