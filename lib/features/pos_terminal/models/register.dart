class Register {
  final String id;
  final String storeId;
  final Map<String, dynamic>? store;
  final String name;
  final String? deviceId;
  final String? appVersion;
  final String? platform;
  final DateTime? lastSyncAt;
  final bool isOnline;
  final bool isActive;

  // SoftPOS
  final bool softposEnabled;
  final String? nearpayTid;
  final String? nearpayMid;

  // Acquirer
  final String? acquirerSource;
  final String? acquirerName;
  final String? acquirerReference;

  // Device hardware
  final String? deviceModel;
  final String? osVersion;
  final bool nfcCapable;
  final String? serialNumber;

  // Fee config
  final String? feeProfile;
  final double feeMadaPercentage;
  final double feeVisaMcPercentage;
  final double feeFlatPerTxn;
  final double wameedMarginPercentage;
  final String? feeDescription;

  // Settlement
  final String? settlementCycle;
  final String? settlementBankName;
  final String? settlementIban;

  // Status
  final String? softposStatus;
  final DateTime? softposActivatedAt;
  final DateTime? lastTransactionAt;
  final bool? isSoftposReady;
  final String? adminNotes;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Register({
    required this.id,
    required this.storeId,
    this.store,
    required this.name,
    this.deviceId,
    this.appVersion,
    this.platform,
    this.lastSyncAt,
    required this.isOnline,
    required this.isActive,
    this.softposEnabled = false,
    this.nearpayTid,
    this.nearpayMid,
    this.acquirerSource,
    this.acquirerName,
    this.acquirerReference,
    this.deviceModel,
    this.osVersion,
    this.nfcCapable = false,
    this.serialNumber,
    this.feeProfile,
    this.feeMadaPercentage = 0.0150,
    this.feeVisaMcPercentage = 0.0200,
    this.feeFlatPerTxn = 0.00,
    this.wameedMarginPercentage = 0.0040,
    this.feeDescription,
    this.settlementCycle,
    this.settlementBankName,
    this.settlementIban,
    this.softposStatus,
    this.softposActivatedAt,
    this.lastTransactionAt,
    this.isSoftposReady,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      store: json['store'] as Map<String, dynamic>?,
      name: json['name'] as String,
      deviceId: json['device_id'] as String?,
      appVersion: json['app_version'] as String?,
      platform: json['platform'] as String?,
      lastSyncAt: json['last_sync_at'] != null ? DateTime.parse(json['last_sync_at'] as String) : null,
      isOnline: (json['is_online'] as bool?) ?? false,
      isActive: (json['is_active'] as bool?) ?? true,
      // SoftPOS
      softposEnabled: (json['softpos_enabled'] as bool?) ?? false,
      nearpayTid: json['nearpay_tid'] as String?,
      nearpayMid: json['nearpay_mid'] as String?,
      // Acquirer
      acquirerSource: json['acquirer_source'] as String?,
      acquirerName: json['acquirer_name'] as String?,
      acquirerReference: json['acquirer_reference'] as String?,
      // Device
      deviceModel: json['device_model'] as String?,
      osVersion: json['os_version'] as String?,
      nfcCapable: (json['nfc_capable'] as bool?) ?? false,
      serialNumber: json['serial_number'] as String?,
      // Fees
      feeProfile: json['fee_profile'] as String?,
      feeMadaPercentage: (json['fee_mada_percentage'] != null ? double.tryParse(json['fee_mada_percentage'].toString()) : null) ?? 0.0150,
      feeVisaMcPercentage: (json['fee_visa_mc_percentage'] != null ? double.tryParse(json['fee_visa_mc_percentage'].toString()) : null) ?? 0.0200,
      feeFlatPerTxn: (json['fee_flat_per_txn'] != null ? double.tryParse(json['fee_flat_per_txn'].toString()) : null) ?? 0.00,
      wameedMarginPercentage: (json['wameed_margin_percentage'] != null ? double.tryParse(json['wameed_margin_percentage'].toString()) : null) ?? 0.0040,
      feeDescription: json['fee_description'] as String?,
      // Settlement
      settlementCycle: json['settlement_cycle'] as String?,
      settlementBankName: json['settlement_bank_name'] as String?,
      settlementIban: json['settlement_iban'] as String?,
      // Status
      softposStatus: json['softpos_status'] as String?,
      softposActivatedAt: json['softpos_activated_at'] != null ? DateTime.parse(json['softpos_activated_at'] as String) : null,
      lastTransactionAt: json['last_transaction_at'] != null ? DateTime.parse(json['last_transaction_at'] as String) : null,
      isSoftposReady: json['is_softpos_ready'] as bool?,
      adminNotes: json['admin_notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      if (deviceId != null) 'device_id': deviceId,
      if (appVersion != null) 'app_version': appVersion,
      if (platform != null) 'platform': platform,
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'is_online': isOnline,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Register copyWith({
    String? id,
    String? storeId,
    Map<String, dynamic>? store,
    String? name,
    String? deviceId,
    String? appVersion,
    String? platform,
    DateTime? lastSyncAt,
    bool? isOnline,
    bool? isActive,
    bool? softposEnabled,
    String? nearpayTid,
    String? nearpayMid,
    String? acquirerSource,
    String? acquirerName,
    String? acquirerReference,
    String? deviceModel,
    String? osVersion,
    bool? nfcCapable,
    String? serialNumber,
    String? feeProfile,
    double? feeMadaPercentage,
    double? feeVisaMcPercentage,
    double? feeFlatPerTxn,
    double? wameedMarginPercentage,
    String? feeDescription,
    String? settlementCycle,
    String? settlementBankName,
    String? settlementIban,
    String? softposStatus,
    DateTime? softposActivatedAt,
    DateTime? lastTransactionAt,
    bool? isSoftposReady,
    String? adminNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Register(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      store: store ?? this.store,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      appVersion: appVersion ?? this.appVersion,
      platform: platform ?? this.platform,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isOnline: isOnline ?? this.isOnline,
      isActive: isActive ?? this.isActive,
      softposEnabled: softposEnabled ?? this.softposEnabled,
      nearpayTid: nearpayTid ?? this.nearpayTid,
      nearpayMid: nearpayMid ?? this.nearpayMid,
      acquirerSource: acquirerSource ?? this.acquirerSource,
      acquirerName: acquirerName ?? this.acquirerName,
      acquirerReference: acquirerReference ?? this.acquirerReference,
      deviceModel: deviceModel ?? this.deviceModel,
      osVersion: osVersion ?? this.osVersion,
      nfcCapable: nfcCapable ?? this.nfcCapable,
      serialNumber: serialNumber ?? this.serialNumber,
      feeProfile: feeProfile ?? this.feeProfile,
      feeMadaPercentage: feeMadaPercentage ?? this.feeMadaPercentage,
      feeVisaMcPercentage: feeVisaMcPercentage ?? this.feeVisaMcPercentage,
      feeFlatPerTxn: feeFlatPerTxn ?? this.feeFlatPerTxn,
      wameedMarginPercentage: wameedMarginPercentage ?? this.wameedMarginPercentage,
      feeDescription: feeDescription ?? this.feeDescription,
      settlementCycle: settlementCycle ?? this.settlementCycle,
      settlementBankName: settlementBankName ?? this.settlementBankName,
      settlementIban: settlementIban ?? this.settlementIban,
      softposStatus: softposStatus ?? this.softposStatus,
      softposActivatedAt: softposActivatedAt ?? this.softposActivatedAt,
      lastTransactionAt: lastTransactionAt ?? this.lastTransactionAt,
      isSoftposReady: isSoftposReady ?? this.isSoftposReady,
      adminNotes: adminNotes ?? this.adminNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Register && other.id == id;

  @override
  int get hashCode => id.hashCode;

  /// Human-readable platform name.
  String get platformLabel {
    switch (platform?.toLowerCase()) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'ios':
        return 'iOS';
      case 'android':
        return 'Android';
      default:
        return platform ?? 'Unknown';
    }
  }

  /// Human-readable store name (from eager-loaded relation).
  String get storeName => store?['name'] as String? ?? '—';

  /// Human-readable acquirer label.
  String get acquirerLabel {
    switch (acquirerSource) {
      case 'hala':
        return 'HALA';
      case 'bank_rajhi':
        return 'Al Rajhi Bank';
      case 'bank_snb':
        return 'SNB';
      case 'geidea':
        return 'Geidea';
      case 'other':
        return acquirerName ?? 'Other';
      default:
        return '—';
    }
  }

  /// Human-readable SoftPOS status label.
  String get softposStatusLabel {
    switch (softposStatus) {
      case 'active':
        return 'Active';
      case 'pending':
        return 'Pending';
      case 'suspended':
        return 'Suspended';
      case 'deactivated':
        return 'Deactivated';
      default:
        return softposStatus ?? '—';
    }
  }
}
