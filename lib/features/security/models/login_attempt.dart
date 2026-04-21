import 'package:wameedpos/features/security/enums/login_attempt_type.dart';

class LoginAttempt {

  const LoginAttempt({
    required this.id,
    required this.storeId,
    required this.userIdentifier,
    required this.attemptType,
    required this.isSuccessful,
    this.ipAddress,
    this.deviceId,
    this.attemptedAt,
    this.userAgent,
    this.failureReason,
    this.geoLocation,
    this.deviceName,
  });

  factory LoginAttempt.fromJson(Map<String, dynamic> json) {
    return LoginAttempt(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userIdentifier: json['user_identifier'] as String,
      attemptType: LoginAttemptType.fromValue(json['attempt_type'] as String),
      isSuccessful: json['is_successful'] as bool,
      ipAddress: json['ip_address'] as String?,
      deviceId: json['device_id'] as String?,
      attemptedAt: json['attempted_at'] != null ? DateTime.parse(json['attempted_at'] as String) : null,
      userAgent: json['user_agent'] as String?,
      failureReason: json['failure_reason'] as String?,
      geoLocation: json['geo_location'] != null ? Map<String, dynamic>.from(json['geo_location'] as Map) : null,
      deviceName: json['device_name'] as String?,
    );
  }
  final String id;
  final String storeId;
  final String userIdentifier;
  final LoginAttemptType attemptType;
  final bool isSuccessful;
  final String? ipAddress;
  final String? deviceId;
  final DateTime? attemptedAt;
  final String? userAgent;
  final String? failureReason;
  final Map<String, dynamic>? geoLocation;
  final String? deviceName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_identifier': userIdentifier,
      'attempt_type': attemptType.value,
      'is_successful': isSuccessful,
      'ip_address': ipAddress,
      'device_id': deviceId,
      'attempted_at': attemptedAt?.toIso8601String(),
      'user_agent': userAgent,
      'failure_reason': failureReason,
      'geo_location': geoLocation,
      'device_name': deviceName,
    };
  }

  LoginAttempt copyWith({
    String? id,
    String? storeId,
    String? userIdentifier,
    LoginAttemptType? attemptType,
    bool? isSuccessful,
    String? ipAddress,
    String? deviceId,
    DateTime? attemptedAt,
    String? userAgent,
    String? failureReason,
    Map<String, dynamic>? geoLocation,
    String? deviceName,
  }) {
    return LoginAttempt(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      attemptType: attemptType ?? this.attemptType,
      isSuccessful: isSuccessful ?? this.isSuccessful,
      ipAddress: ipAddress ?? this.ipAddress,
      deviceId: deviceId ?? this.deviceId,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      userAgent: userAgent ?? this.userAgent,
      failureReason: failureReason ?? this.failureReason,
      geoLocation: geoLocation ?? this.geoLocation,
      deviceName: deviceName ?? this.deviceName,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is LoginAttempt && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LoginAttempt(id: $id, userIdentifier: $userIdentifier, attemptType: $attemptType, isSuccessful: $isSuccessful)';
}
