enum TranslationCategory {
  common('common'),
  ui('ui'),
  pos('pos'),
  receipt('receipt'),
  notification('notification'),
  report('report');

  const TranslationCategory(this.value);
  final String value;

  static TranslationCategory fromValue(String value) {
    return TranslationCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TranslationCategory: $value'),
    );
  }

  static TranslationCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
