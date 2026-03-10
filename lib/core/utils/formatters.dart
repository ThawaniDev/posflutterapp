import 'package:intl/intl.dart';

/// Thawani POS Formatters — currency, dates, numbers, relative time.
///
/// Conventions:
///  - Currency: Omani Rial (OMR) with 3 decimal places.
///  - Dates: dd/MM/yyyy (display), yyyy-MM-dd (API/ISO).
///  - Arabic numerals are handled via Intl locale.
class Formatters {
  Formatters._();

  // ─── Currency ────────────────────────────────────────────

  /// Omani Rial: 1234.567 → "ر.ع. 1,234.567"
  static String currency(double amount, {String symbol = 'ر.ع.'}) {
    final formatter = NumberFormat.currency(decimalDigits: 3, symbol: '$symbol ');
    return formatter.format(amount);
  }

  /// Short currency (no decimals): 1234 → "ر.ع. 1,234"
  static String currencyShort(double amount, {String symbol = 'ر.ع.'}) {
    final formatter = NumberFormat.currency(decimalDigits: 0, symbol: '$symbol ');
    return formatter.format(amount);
  }

  /// Compact currency: 12500 → "ر.ع. 12.5K"
  static String currencyCompact(double amount, {String symbol = 'ر.ع.'}) {
    return '$symbol ${NumberFormat.compact().format(amount)}';
  }

  /// Raw price number (no symbol): "1,234.567"
  static String price(double amount, {int decimals = 3}) {
    return NumberFormat('#,##0.${List.filled(decimals, '0').join()}').format(amount);
  }

  // ─── Dates ───────────────────────────────────────────────

  /// Display format: 25/06/2025
  static String date(DateTime dt, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(dt);
  }

  /// ISO format for API: 2025-06-25
  static String dateIso(DateTime dt) {
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  /// Full date: Wednesday, 25 June 2025
  static String dateFull(DateTime dt) {
    return DateFormat('EEEE, d MMMM yyyy').format(dt);
  }

  /// Medium date: 25 Jun 2025
  static String dateMedium(DateTime dt) {
    return DateFormat('d MMM yyyy').format(dt);
  }

  /// Short date: Jun 25
  static String dateShort(DateTime dt) {
    return DateFormat('MMM d').format(dt);
  }

  /// Date and time: 25/06/2025 14:35
  static String dateTime(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  /// Date time with seconds: 25/06/2025 14:35:22
  static String dateTimeFull(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dt);
  }

  /// ISO 8601 full: 2025-06-25T14:35:22
  static String dateTimeIso(DateTime dt) => dt.toIso8601String();

  // ─── Time ────────────────────────────────────────────────

  /// 24h time: 14:35
  static String time(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  /// 12h time: 2:35 PM
  static String time12(DateTime dt) {
    return DateFormat('h:mm a').format(dt);
  }

  /// Time with seconds: 14:35:22
  static String timeFull(DateTime dt) {
    return DateFormat('HH:mm:ss').format(dt);
  }

  // ─── Relative Time ──────────────────────────────────────

  /// "Just now", "2m ago", "3h ago", "Yesterday", "5 days ago", etc.
  static String timeAgo(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  /// "In 2 hours", "In 3 days", etc.
  static String timeUntil(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);

    if (diff.isNegative) return timeAgo(dt);
    if (diff.inMinutes < 60) return 'In ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'In ${diff.inHours}h';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays < 7) return 'In ${diff.inDays} days';
    return dateMedium(dt);
  }

  // ─── Numbers ─────────────────────────────────────────────

  /// With commas: 12345 → "12,345"
  static String number(num value) {
    return NumberFormat('#,##0').format(value);
  }

  /// Decimal: 0.856 → "0.86"
  static String decimal(num value, {int places = 2}) {
    return value.toStringAsFixed(places);
  }

  /// Compact: 12500 → "12.5K"
  static String compact(num value) {
    return NumberFormat.compact().format(value);
  }

  /// Percentage: 0.856 → "85.6%"
  static String percent(double value, {int places = 1}) {
    return '${(value * 100).toStringAsFixed(places)}%';
  }

  /// Integer percentage: 0.856 → "86%"
  static String percentInt(double value) {
    return '${(value * 100).round()}%';
  }

  /// Ordinal: 1 → "1st", 2 → "2nd", 23 → "23rd"
  static String ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  // ─── File Sizes ──────────────────────────────────────────

  /// Bytes → human-readable: 1536 → "1.5 KB"
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }

  // ─── Phone ───────────────────────────────────────────────

  /// Oman phone: "96812345" → "+968 1234 5678" (8-digit)
  static String omanPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 8) {
      return '+968 ${digits.substring(0, 4)} ${digits.substring(4)}';
    }
    if (digits.length > 8 && digits.startsWith('968')) {
      final local = digits.substring(3);
      return '+968 ${local.substring(0, 4)} ${local.substring(4)}';
    }
    return raw;
  }

  // ─── Duration ────────────────────────────────────────────

  /// Duration → "1h 23m" or "45m" or "30s"
  static String duration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    }
    if (d.inMinutes > 0) {
      return '${d.inMinutes}m';
    }
    return '${d.inSeconds}s';
  }
}
