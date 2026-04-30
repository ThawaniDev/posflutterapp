enum KnowledgeBaseCategory {
  general('general'),
  gettingStarted('getting_started'),
  posUsage('pos_usage'),
  inventory('inventory'),
  delivery('delivery'),
  billing('billing'),
  troubleshooting('troubleshooting');

  const KnowledgeBaseCategory(this.value);
  final String value;

  static KnowledgeBaseCategory fromValue(String value) {
    return KnowledgeBaseCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid KnowledgeBaseCategory: $value'),
    );
  }

  static KnowledgeBaseCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
