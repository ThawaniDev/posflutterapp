import 'package:thawani_pos/features/payments/enums/installment_provider.dart';

/// Platform-level installment provider configuration.
class InstallmentProviderConfig {
  final String id;
  final InstallmentProvider provider;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? logoUrl;
  final bool isEnabled;
  final bool isUnderMaintenance;
  final String? maintenanceMessage;
  final String? maintenanceMessageAr;
  final List<String> supportedCurrencies;
  final double? minAmount;
  final double? maxAmount;
  final List<int> supportedInstallmentCounts;
  final int sortOrder;
  final String? createdAt;
  final String? updatedAt;

  const InstallmentProviderConfig({
    required this.id,
    required this.provider,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.logoUrl,
    this.isEnabled = true,
    this.isUnderMaintenance = false,
    this.maintenanceMessage,
    this.maintenanceMessageAr,
    this.supportedCurrencies = const ['SAR'],
    this.minAmount,
    this.maxAmount,
    this.supportedInstallmentCounts = const [3, 4],
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  bool get isAvailable => isEnabled && !isUnderMaintenance;

  factory InstallmentProviderConfig.fromJson(Map<String, dynamic> json) {
    return InstallmentProviderConfig(
      id: json['id'] as String,
      provider: InstallmentProvider.fromValue(json['provider'] as String),
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      logoUrl: json['logo_url'] as String?,
      isEnabled: json['is_enabled'] as bool? ?? true,
      isUnderMaintenance: json['is_under_maintenance'] as bool? ?? false,
      maintenanceMessage: json['maintenance_message'] as String?,
      maintenanceMessageAr: json['maintenance_message_ar'] as String?,
      supportedCurrencies: (json['supported_currencies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['SAR'],
      minAmount: double.tryParse(json['min_amount']?.toString() ?? ''),
      maxAmount: double.tryParse(json['max_amount']?.toString() ?? ''),
      supportedInstallmentCounts:
          (json['supported_installment_counts'] as List<dynamic>?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList() ??
          [3, 4],
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'provider': provider.value,
    'name': name,
    'name_ar': nameAr,
    'description': description,
    'description_ar': descriptionAr,
    'logo_url': logoUrl,
    'is_enabled': isEnabled,
    'is_under_maintenance': isUnderMaintenance,
    'maintenance_message': maintenanceMessage,
    'maintenance_message_ar': maintenanceMessageAr,
    'supported_currencies': supportedCurrencies,
    'min_amount': minAmount,
    'max_amount': maxAmount,
    'supported_installment_counts': supportedInstallmentCounts,
    'sort_order': sortOrder,
  };

  InstallmentProviderConfig copyWith({
    String? id,
    InstallmentProvider? provider,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? logoUrl,
    bool? isEnabled,
    bool? isUnderMaintenance,
    String? maintenanceMessage,
    String? maintenanceMessageAr,
    List<String>? supportedCurrencies,
    double? minAmount,
    double? maxAmount,
    List<int>? supportedInstallmentCounts,
    int? sortOrder,
  }) {
    return InstallmentProviderConfig(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      logoUrl: logoUrl ?? this.logoUrl,
      isEnabled: isEnabled ?? this.isEnabled,
      isUnderMaintenance: isUnderMaintenance ?? this.isUnderMaintenance,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      maintenanceMessageAr: maintenanceMessageAr ?? this.maintenanceMessageAr,
      supportedCurrencies: supportedCurrencies ?? this.supportedCurrencies,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      supportedInstallmentCounts: supportedInstallmentCounts ?? this.supportedInstallmentCounts,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is InstallmentProviderConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
