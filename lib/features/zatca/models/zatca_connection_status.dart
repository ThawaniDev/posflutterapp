class ZatcaConnectionStatus {
  const ZatcaConnectionStatus({
    required this.environment,
    required this.isProduction,
    required this.isHealthy,
    required this.connected,
    required this.devices,
    required this.queueDepth,
    this.certificate,
    this.lastSuccess,
    this.lastError,
  });

  factory ZatcaConnectionStatus.fromJson(Map<String, dynamic> json) {
    return ZatcaConnectionStatus(
      environment: json['environment'] as String? ?? 'sandbox',
      isProduction: json['is_production'] as bool? ?? false,
      isHealthy: json['is_healthy'] as bool? ?? false,
      connected: json['connected'] as bool? ?? false,
      certificate: json['certificate'] != null
          ? ZatcaConnectionCertificate.fromJson(Map<String, dynamic>.from(json['certificate'] as Map))
          : null,
      devices: ZatcaConnectionDevices.fromJson(Map<String, dynamic>.from(json['devices'] as Map)),
      queueDepth: json['queue_depth'] as int? ?? 0,
      lastSuccess: json['last_success'] != null
          ? ZatcaConnectionEvent.fromJson(Map<String, dynamic>.from(json['last_success'] as Map))
          : null,
      lastError: json['last_error'] != null
          ? ZatcaConnectionEvent.fromJson(Map<String, dynamic>.from(json['last_error'] as Map))
          : null,
    );
  }
  final String environment;
  final bool isProduction;
  final bool isHealthy;
  final bool connected;
  final ZatcaConnectionCertificate? certificate;
  final ZatcaConnectionDevices devices;
  final int queueDepth;
  final ZatcaConnectionEvent? lastSuccess;
  final ZatcaConnectionEvent? lastError;
}

class ZatcaConnectionCertificate {
  const ZatcaConnectionCertificate({
    required this.id,
    required this.type,
    required this.issuedAt,
    required this.expiresAt,
    required this.expiringSoon,
    required this.expired,
    this.ccsid,
    this.pcsid,
    this.daysUntilExpiry,
  });

  factory ZatcaConnectionCertificate.fromJson(Map<String, dynamic> json) {
    return ZatcaConnectionCertificate(
      id: json['id'] as String,
      type: json['type'] as String,
      ccsid: json['ccsid'] as String?,
      pcsid: json['pcsid'] as String?,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      daysUntilExpiry: json['days_until_expiry'] as int?,
      expiringSoon: json['expiring_soon'] as bool? ?? false,
      expired: json['expired'] as bool? ?? false,
    );
  }

  final String id;
  final String type;
  final String? ccsid;
  final String? pcsid;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final int? daysUntilExpiry;
  final bool expiringSoon;
  final bool expired;
}

class ZatcaConnectionDevices {
  const ZatcaConnectionDevices({required this.total, required this.active, required this.tampered});

  factory ZatcaConnectionDevices.fromJson(Map<String, dynamic> json) {
    return ZatcaConnectionDevices(
      total: json['total'] as int? ?? 0,
      active: json['active'] as int? ?? 0,
      tampered: json['tampered'] as int? ?? 0,
    );
  }

  final int total;
  final int active;
  final int tampered;
}

class ZatcaConnectionEvent {
  const ZatcaConnectionEvent({
    required this.id,
    this.invoiceNumber,
    this.submittedAt,
    this.lastAttemptAt,
    this.flow,
    this.responseCode,
    this.message,
    this.errors,
  });

  factory ZatcaConnectionEvent.fromJson(Map<String, dynamic> json) {
    return ZatcaConnectionEvent(
      id: json['id'] as String,
      invoiceNumber: json['invoice_number'] as String?,
      submittedAt: json['submitted_at'] != null ? DateTime.tryParse(json['submitted_at'] as String) : null,
      lastAttemptAt: json['last_attempt_at'] != null ? DateTime.tryParse(json['last_attempt_at'] as String) : null,
      flow: json['flow'] as String?,
      responseCode: json['response_code'] as String?,
      message: json['message'] as String?,
      errors: json['errors'] is List ? List<dynamic>.from(json['errors'] as List) : null,
    );
  }

  final String id;
  final String? invoiceNumber;
  final DateTime? submittedAt;
  final DateTime? lastAttemptAt;
  final String? flow;
  final String? responseCode;
  final String? message;
  final List<dynamic>? errors;
}
