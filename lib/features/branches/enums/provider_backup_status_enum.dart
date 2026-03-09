enum ProviderBackupStatusEnum {
  healthy('healthy'),
  warning('warning'),
  critical('critical'),
  unknown('unknown');

  const ProviderBackupStatusEnum(this.value);
  final String value;

  static ProviderBackupStatusEnum fromValue(String value) {
    return ProviderBackupStatusEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ProviderBackupStatusEnum: $value'),
    );
  }

  static ProviderBackupStatusEnum? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
