class Prescription {
  final String id;
  final String storeId;
  final String? orderId;
  final String prescriptionNumber;
  final String patientName;
  final String? patientId;
  final String? doctorName;
  final String? doctorLicense;
  final String? insuranceProvider;
  final double? insuranceClaimAmount;
  final String? notes;
  final DateTime? createdAt;

  const Prescription({
    required this.id,
    required this.storeId,
    this.orderId,
    required this.prescriptionNumber,
    required this.patientName,
    this.patientId,
    this.doctorName,
    this.doctorLicense,
    this.insuranceProvider,
    this.insuranceClaimAmount,
    this.notes,
    this.createdAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderId: json['order_id'] as String?,
      prescriptionNumber: json['prescription_number'] as String,
      patientName: json['patient_name'] as String,
      patientId: json['patient_id'] as String?,
      doctorName: json['doctor_name'] as String?,
      doctorLicense: json['doctor_license'] as String?,
      insuranceProvider: json['insurance_provider'] as String?,
      insuranceClaimAmount: (json['insurance_claim_amount'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'order_id': orderId,
      'prescription_number': prescriptionNumber,
      'patient_name': patientName,
      'patient_id': patientId,
      'doctor_name': doctorName,
      'doctor_license': doctorLicense,
      'insurance_provider': insuranceProvider,
      'insurance_claim_amount': insuranceClaimAmount,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Prescription copyWith({
    String? id,
    String? storeId,
    String? orderId,
    String? prescriptionNumber,
    String? patientName,
    String? patientId,
    String? doctorName,
    String? doctorLicense,
    String? insuranceProvider,
    double? insuranceClaimAmount,
    String? notes,
    DateTime? createdAt,
  }) {
    return Prescription(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      orderId: orderId ?? this.orderId,
      prescriptionNumber: prescriptionNumber ?? this.prescriptionNumber,
      patientName: patientName ?? this.patientName,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      doctorLicense: doctorLicense ?? this.doctorLicense,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insuranceClaimAmount: insuranceClaimAmount ?? this.insuranceClaimAmount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prescription && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Prescription(id: $id, storeId: $storeId, orderId: $orderId, prescriptionNumber: $prescriptionNumber, patientName: $patientName, patientId: $patientId, ...)';
}
