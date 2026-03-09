enum MenuSyncStatus {
  success('success'),
  partial('partial'),
  failed('failed');

  const MenuSyncStatus(this.value);
  final String value;

  static MenuSyncStatus fromValue(String value) {
    return MenuSyncStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid MenuSyncStatus: $value'),
    );
  }

  static MenuSyncStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
