import 'package:wameedpos/features/industry_electronics/enums/repair_job_status.dart';

class RepairJob {

  const RepairJob({
    required this.id,
    required this.storeId,
    this.customerId,
    required this.deviceDescription,
    this.imei,
    required this.issueDescription,
    this.status,
    this.diagnosisNotes,
    this.repairNotes,
    this.estimatedCost,
    this.finalCost,
    this.partsUsed,
    required this.staffUserId,
    this.receivedAt,
    this.estimatedReadyAt,
    this.completedAt,
    this.collectedAt,
  });

  factory RepairJob.fromJson(Map<String, dynamic> json) {
    return RepairJob(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String?,
      deviceDescription: json['device_description'] as String,
      imei: json['imei'] as String?,
      issueDescription: json['issue_description'] as String,
      status: RepairJobStatus.tryFromValue(json['status'] as String?),
      diagnosisNotes: json['diagnosis_notes'] as String?,
      repairNotes: json['repair_notes'] as String?,
      estimatedCost: (json['estimated_cost'] != null ? double.tryParse(json['estimated_cost'].toString()) : null),
      finalCost: (json['final_cost'] != null ? double.tryParse(json['final_cost'].toString()) : null),
      partsUsed: json['parts_used'] != null ? Map<String, dynamic>.from(json['parts_used'] as Map) : null,
      staffUserId: json['staff_user_id'] as String,
      receivedAt: json['received_at'] != null ? DateTime.parse(json['received_at'] as String) : null,
      estimatedReadyAt: json['estimated_ready_at'] != null ? DateTime.parse(json['estimated_ready_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      collectedAt: json['collected_at'] != null ? DateTime.parse(json['collected_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String? customerId;
  final String deviceDescription;
  final String? imei;
  final String issueDescription;
  final RepairJobStatus? status;
  final String? diagnosisNotes;
  final String? repairNotes;
  final double? estimatedCost;
  final double? finalCost;
  final Map<String, dynamic>? partsUsed;
  final String staffUserId;
  final DateTime? receivedAt;
  final DateTime? estimatedReadyAt;
  final DateTime? completedAt;
  final DateTime? collectedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'device_description': deviceDescription,
      'imei': imei,
      'issue_description': issueDescription,
      'status': status?.value,
      'diagnosis_notes': diagnosisNotes,
      'repair_notes': repairNotes,
      'estimated_cost': estimatedCost,
      'final_cost': finalCost,
      'parts_used': partsUsed,
      'staff_user_id': staffUserId,
      'received_at': receivedAt?.toIso8601String(),
      'estimated_ready_at': estimatedReadyAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'collected_at': collectedAt?.toIso8601String(),
    };
  }

  RepairJob copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? deviceDescription,
    String? imei,
    String? issueDescription,
    RepairJobStatus? status,
    String? diagnosisNotes,
    String? repairNotes,
    double? estimatedCost,
    double? finalCost,
    Map<String, dynamic>? partsUsed,
    String? staffUserId,
    DateTime? receivedAt,
    DateTime? estimatedReadyAt,
    DateTime? completedAt,
    DateTime? collectedAt,
  }) {
    return RepairJob(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      deviceDescription: deviceDescription ?? this.deviceDescription,
      imei: imei ?? this.imei,
      issueDescription: issueDescription ?? this.issueDescription,
      status: status ?? this.status,
      diagnosisNotes: diagnosisNotes ?? this.diagnosisNotes,
      repairNotes: repairNotes ?? this.repairNotes,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      finalCost: finalCost ?? this.finalCost,
      partsUsed: partsUsed ?? this.partsUsed,
      staffUserId: staffUserId ?? this.staffUserId,
      receivedAt: receivedAt ?? this.receivedAt,
      estimatedReadyAt: estimatedReadyAt ?? this.estimatedReadyAt,
      completedAt: completedAt ?? this.completedAt,
      collectedAt: collectedAt ?? this.collectedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is RepairJob && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'RepairJob(id: $id, storeId: $storeId, customerId: $customerId, deviceDescription: $deviceDescription, imei: $imei, issueDescription: $issueDescription, ...)';
}
