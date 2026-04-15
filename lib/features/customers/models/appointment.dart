import 'package:wameedpos/features/customers/enums/appointment_status.dart';

class Appointment {
  final String id;
  final String storeId;
  final String? customerId;
  final String? staffId;
  final String serviceProductId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final AppointmentStatus? status;
  final String? notes;
  final bool? reminderSent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Appointment({
    required this.id,
    required this.storeId,
    this.customerId,
    this.staffId,
    required this.serviceProductId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    this.status,
    this.notes,
    this.reminderSent,
    this.createdAt,
    this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String?,
      staffId: json['staff_id'] as String?,
      serviceProductId: json['service_product_id'] as String,
      appointmentDate: DateTime.parse(json['appointment_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: AppointmentStatus.tryFromValue(json['status'] as String?),
      notes: json['notes'] as String?,
      reminderSent: json['reminder_sent'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'staff_id': staffId,
      'service_product_id': serviceProductId,
      'appointment_date': appointmentDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'status': status?.value,
      'notes': notes,
      'reminder_sent': reminderSent,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Appointment copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? staffId,
    String? serviceProductId,
    DateTime? appointmentDate,
    String? startTime,
    String? endTime,
    AppointmentStatus? status,
    String? notes,
    bool? reminderSent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      staffId: staffId ?? this.staffId,
      serviceProductId: serviceProductId ?? this.serviceProductId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      reminderSent: reminderSent ?? this.reminderSent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Appointment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Appointment(id: $id, storeId: $storeId, customerId: $customerId, staffId: $staffId, serviceProductId: $serviceProductId, appointmentDate: $appointmentDate, ...)';
}
