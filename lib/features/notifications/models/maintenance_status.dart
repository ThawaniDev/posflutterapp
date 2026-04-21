/// System maintenance banner status exposed to apps.
class MaintenanceStatus {
  const MaintenanceStatus({required this.isEnabled, required this.isIpAllowed, this.bannerEn, this.bannerAr, this.expectedEndAt});

  factory MaintenanceStatus.fromJson(Map<String, dynamic> json) {
    return MaintenanceStatus(
      isEnabled: (json['is_enabled'] as bool?) ?? false,
      isIpAllowed: (json['is_ip_allowed'] as bool?) ?? false,
      bannerEn: json['banner_en'] as String?,
      bannerAr: json['banner_ar'] as String?,
      expectedEndAt: json['expected_end_at'] != null ? DateTime.tryParse(json['expected_end_at'] as String) : null,
    );
  }

  static const MaintenanceStatus empty = MaintenanceStatus(isEnabled: false, isIpAllowed: false);

  final bool isEnabled;
  final bool isIpAllowed;
  final String? bannerEn;
  final String? bannerAr;
  final DateTime? expectedEndAt;

  /// True when a banner should actually be shown to the user.
  bool get shouldShow => isEnabled && !isIpAllowed;
}
