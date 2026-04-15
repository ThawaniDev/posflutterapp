import 'package:wameedpos/features/industry_pharmacy/models/prescription.dart';
import 'package:wameedpos/features/industry_pharmacy/models/drug_schedule.dart';

sealed class PharmacyState {
  const PharmacyState();
}

class PharmacyInitial extends PharmacyState {
  const PharmacyInitial();
}

class PharmacyLoading extends PharmacyState {
  const PharmacyLoading();
}

class PharmacyLoaded extends PharmacyState {
  final List<Prescription> prescriptions;
  final List<DrugSchedule> drugSchedules;

  const PharmacyLoaded({required this.prescriptions, required this.drugSchedules});

  PharmacyLoaded copyWith({List<Prescription>? prescriptions, List<DrugSchedule>? drugSchedules}) =>
      PharmacyLoaded(prescriptions: prescriptions ?? this.prescriptions, drugSchedules: drugSchedules ?? this.drugSchedules);
}

class PharmacyError extends PharmacyState {
  final String message;
  const PharmacyError({required this.message});
}
