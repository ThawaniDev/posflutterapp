import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Format currency with Omani Rial (3 decimal places)
  static String currency(double amount, {String symbol = 'ر.ع.'}) {
    final formatter = NumberFormat.currency(
      decimalDigits: 3,
      symbol: symbol,
    );
    return formatter.format(amount);
  }

  /// Format date
  static String date(DateTime dt, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(dt);
  }

  /// Format date and time
  static String dateTime(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  /// Format time only
  static String time(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  /// Format number with commas
  static String number(num value) {
    return NumberFormat('#,##0').format(value);
  }
}
