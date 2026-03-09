class AppConstants {
  AppConstants._();

  static const String appName = 'Thawani POS';
  static const String appVersion = '1.0.0';

  // Supabase
  static const String supabaseUrl = 'https://xyunpamaxzomfpwtggvl.supabase.co';
  static const String supabaseAnonKey = ''; // Set from env

  // API
  static const String apiBaseUrl = 'http://localhost:8000/api/v2';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // Sync
  static const Duration syncInterval = Duration(seconds: 30);
  static const Duration maxOfflineDuration = Duration(hours: 72);

  // POS
  static const String defaultCurrency = 'OMR';
  static const String currencySymbol = 'ر.ع.';
  static const int decimalPlaces = 3;

  // Pagination
  static const int defaultPageSize = 25;
  static const int maxPageSize = 100;
}
