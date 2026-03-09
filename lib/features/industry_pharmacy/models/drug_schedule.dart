import 'package:thawani_pos/features/industry_pharmacy/enums/drug_schedule_type.dart';

class DrugSchedule {
  final String id;
  final String productId;
  final DrugScheduleType scheduleType;
  final String? activeIngredient;
  final String? dosageForm;
  final String? strength;
  final String? manufacturer;
  final bool? requiresPrescription;

  const DrugSchedule({
    required this.id,
    required this.productId,
    required this.scheduleType,
    this.activeIngredient,
    this.dosageForm,
    this.strength,
    this.manufacturer,
    this.requiresPrescription,
  });

  factory DrugSchedule.fromJson(Map<String, dynamic> json) {
    return DrugSchedule(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      scheduleType: DrugScheduleType.fromValue(json['schedule_type'] as String),
      activeIngredient: json['active_ingredient'] as String?,
      dosageForm: json['dosage_form'] as String?,
      strength: json['strength'] as String?,
      manufacturer: json['manufacturer'] as String?,
      requiresPrescription: json['requires_prescription'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'schedule_type': scheduleType.value,
      'active_ingredient': activeIngredient,
      'dosage_form': dosageForm,
      'strength': strength,
      'manufacturer': manufacturer,
      'requires_prescription': requiresPrescription,
    };
  }

  DrugSchedule copyWith({
    String? id,
    String? productId,
    DrugScheduleType? scheduleType,
    String? activeIngredient,
    String? dosageForm,
    String? strength,
    String? manufacturer,
    bool? requiresPrescription,
  }) {
    return DrugSchedule(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      scheduleType: scheduleType ?? this.scheduleType,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      dosageForm: dosageForm ?? this.dosageForm,
      strength: strength ?? this.strength,
      manufacturer: manufacturer ?? this.manufacturer,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrugSchedule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DrugSchedule(id: $id, productId: $productId, scheduleType: $scheduleType, activeIngredient: $activeIngredient, dosageForm: $dosageForm, strength: $strength, ...)';
}
