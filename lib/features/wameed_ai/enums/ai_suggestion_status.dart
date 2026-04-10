enum AISuggestionStatus {
  pending('pending'),
  viewed('viewed'),
  accepted('accepted'),
  dismissed('dismissed'),
  expired('expired');

  const AISuggestionStatus(this.value);
  final String value;

  static AISuggestionStatus fromValue(String value) {
    return AISuggestionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AISuggestionStatus: $value'),
    );
  }

  static AISuggestionStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
