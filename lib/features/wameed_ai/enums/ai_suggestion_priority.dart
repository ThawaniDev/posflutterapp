enum AISuggestionPriority {
  high('high'),
  medium('medium'),
  low('low');

  const AISuggestionPriority(this.value);
  final String value;

  static AISuggestionPriority fromValue(String value) {
    return AISuggestionPriority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AISuggestionPriority: $value'),
    );
  }

  static AISuggestionPriority? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
