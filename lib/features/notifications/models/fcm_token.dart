import 'package:wameedpos/features/notifications/enums/fcm_device_type.dart';

class FcmToken {

  const FcmToken({
    required this.id,
    required this.userId,
    required this.token,
    required this.deviceType,
    this.createdAt,
    this.updatedAt,
  });

  factory FcmToken.fromJson(Map<String, dynamic> json) {
    return FcmToken(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      token: json['token'] as String,
      deviceType: FcmDeviceType.fromValue(json['device_type'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String userId;
  final String token;
  final FcmDeviceType deviceType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'token': token,
      'device_type': deviceType.value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  FcmToken copyWith({
    String? id,
    String? userId,
    String? token,
    FcmDeviceType? deviceType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FcmToken(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      deviceType: deviceType ?? this.deviceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is FcmToken && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FcmToken(id: $id, userId: $userId, token: $token, deviceType: $deviceType, createdAt: $createdAt, updatedAt: $updatedAt)';
}
