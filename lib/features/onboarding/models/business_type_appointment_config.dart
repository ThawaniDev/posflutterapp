import 'package:wameedpos/features/orders/enums/cancellation_fee_type.dart';

class BusinessTypeAppointmentConfig {
  final String id;
  final String businessTypeId;
  final int? defaultSlotDurationMinutes;
  final int? minAdvanceBookingHours;
  final int? maxAdvanceBookingDays;
  final int? cancellationWindowHours;
  final CancellationFeeType? cancellationFeeType;
  final double? cancellationFeeValue;
  final bool? allowWalkins;
  final double? overbookingBufferPercentage;
  final bool? requireDeposit;
  final double? depositPercentage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessTypeAppointmentConfig({
    required this.id,
    required this.businessTypeId,
    this.defaultSlotDurationMinutes,
    this.minAdvanceBookingHours,
    this.maxAdvanceBookingDays,
    this.cancellationWindowHours,
    this.cancellationFeeType,
    this.cancellationFeeValue,
    this.allowWalkins,
    this.overbookingBufferPercentage,
    this.requireDeposit,
    this.depositPercentage,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessTypeAppointmentConfig.fromJson(Map<String, dynamic> json) {
    return BusinessTypeAppointmentConfig(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      defaultSlotDurationMinutes: (json['default_slot_duration_minutes'] as num?)?.toInt(),
      minAdvanceBookingHours: (json['min_advance_booking_hours'] as num?)?.toInt(),
      maxAdvanceBookingDays: (json['max_advance_booking_days'] as num?)?.toInt(),
      cancellationWindowHours: (json['cancellation_window_hours'] as num?)?.toInt(),
      cancellationFeeType: CancellationFeeType.tryFromValue(json['cancellation_fee_type'] as String?),
      cancellationFeeValue: (json['cancellation_fee_value'] != null
          ? double.tryParse(json['cancellation_fee_value'].toString())
          : null),
      allowWalkins: json['allow_walkins'] as bool?,
      overbookingBufferPercentage: (json['overbooking_buffer_percentage'] != null
          ? double.tryParse(json['overbooking_buffer_percentage'].toString())
          : null),
      requireDeposit: json['require_deposit'] as bool?,
      depositPercentage: (json['deposit_percentage'] != null ? double.tryParse(json['deposit_percentage'].toString()) : null),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'default_slot_duration_minutes': defaultSlotDurationMinutes,
      'min_advance_booking_hours': minAdvanceBookingHours,
      'max_advance_booking_days': maxAdvanceBookingDays,
      'cancellation_window_hours': cancellationWindowHours,
      'cancellation_fee_type': cancellationFeeType?.value,
      'cancellation_fee_value': cancellationFeeValue,
      'allow_walkins': allowWalkins,
      'overbooking_buffer_percentage': overbookingBufferPercentage,
      'require_deposit': requireDeposit,
      'deposit_percentage': depositPercentage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BusinessTypeAppointmentConfig copyWith({
    String? id,
    String? businessTypeId,
    int? defaultSlotDurationMinutes,
    int? minAdvanceBookingHours,
    int? maxAdvanceBookingDays,
    int? cancellationWindowHours,
    CancellationFeeType? cancellationFeeType,
    double? cancellationFeeValue,
    bool? allowWalkins,
    double? overbookingBufferPercentage,
    bool? requireDeposit,
    double? depositPercentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessTypeAppointmentConfig(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      defaultSlotDurationMinutes: defaultSlotDurationMinutes ?? this.defaultSlotDurationMinutes,
      minAdvanceBookingHours: minAdvanceBookingHours ?? this.minAdvanceBookingHours,
      maxAdvanceBookingDays: maxAdvanceBookingDays ?? this.maxAdvanceBookingDays,
      cancellationWindowHours: cancellationWindowHours ?? this.cancellationWindowHours,
      cancellationFeeType: cancellationFeeType ?? this.cancellationFeeType,
      cancellationFeeValue: cancellationFeeValue ?? this.cancellationFeeValue,
      allowWalkins: allowWalkins ?? this.allowWalkins,
      overbookingBufferPercentage: overbookingBufferPercentage ?? this.overbookingBufferPercentage,
      requireDeposit: requireDeposit ?? this.requireDeposit,
      depositPercentage: depositPercentage ?? this.depositPercentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessTypeAppointmentConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BusinessTypeAppointmentConfig(id: $id, businessTypeId: $businessTypeId, defaultSlotDurationMinutes: $defaultSlotDurationMinutes, minAdvanceBookingHours: $minAdvanceBookingHours, maxAdvanceBookingDays: $maxAdvanceBookingDays, cancellationWindowHours: $cancellationWindowHours, ...)';
}
