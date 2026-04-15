import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/industry_pharmacy/enums/drug_schedule_type.dart';
import 'package:wameedpos/features/industry_pharmacy/models/prescription.dart';
import 'package:wameedpos/features/industry_pharmacy/models/drug_schedule.dart';
import 'package:wameedpos/features/industry_pharmacy/providers/pharmacy_state.dart';

void main() {
  // ═══════════════ DrugScheduleType Enum ═══════════════
  group('DrugScheduleType', () {
    test('all values exist', () {
      expect(DrugScheduleType.values, hasLength(3));
      expect(DrugScheduleType.values, contains(DrugScheduleType.otc));
      expect(DrugScheduleType.values, contains(DrugScheduleType.prescriptionOnly));
      expect(DrugScheduleType.values, contains(DrugScheduleType.controlled));
    });

    test('value property', () {
      expect(DrugScheduleType.otc.value, 'otc');
      expect(DrugScheduleType.prescriptionOnly.value, 'prescription_only');
      expect(DrugScheduleType.controlled.value, 'controlled');
    });

    test('fromValue round-trip', () {
      for (final e in DrugScheduleType.values) {
        expect(DrugScheduleType.fromValue(e.value), e);
      }
    });
  });

  // ═══════════════ Prescription Model ═══════════════
  group('Prescription', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'order_id': 'o1',
      'prescription_number': 'RX-001',
      'patient_name': 'Ahmed',
      'patient_id': 'P100',
      'doctor_name': 'Dr. Ali',
      'doctor_license': 'LIC-99',
      'insurance_provider': 'Dhofar Insurance',
      'insurance_claim_amount': 25.5,
      'notes': 'Take after meals',
      'created_at': '2025-01-15T10:00:00.000Z',
    };

    test('fromJson creates instance', () {
      final p = Prescription.fromJson(json);
      expect(p.id, '1');
      expect(p.prescriptionNumber, 'RX-001');
      expect(p.patientName, 'Ahmed');
      expect(p.doctorName, 'Dr. Ali');
      expect(p.insuranceClaimAmount, 25.5);
    });

    test('toJson round-trip', () {
      final p = Prescription.fromJson(json);
      final out = p.toJson();
      expect(out['prescription_number'], 'RX-001');
      expect(out['patient_name'], 'Ahmed');
    });

    test('nullable fields', () {
      final p = Prescription.fromJson({'id': '2', 'store_id': 's1', 'prescription_number': 'RX-002', 'patient_name': 'Sara'});
      expect(p.doctorName, isNull);
      expect(p.insuranceClaimAmount, isNull);
      expect(p.orderId, isNull);
    });
  });

  // ═══════════════ DrugSchedule Model ═══════════════
  group('DrugSchedule', () {
    final json = {
      'id': '10',
      'product_id': 'prod1',
      'schedule_type': 'otc',
      'active_ingredient': 'Paracetamol',
      'dosage_form': 'Tablet',
      'strength': '500mg',
      'manufacturer': 'PharmaCo',
      'requires_prescription': false,
    };

    test('fromJson creates instance', () {
      final d = DrugSchedule.fromJson(json);
      expect(d.id, '10');
      expect(d.scheduleType, DrugScheduleType.otc);
      expect(d.activeIngredient, 'Paracetamol');
      expect(d.requiresPrescription, false);
    });

    test('toJson round-trip', () {
      final d = DrugSchedule.fromJson(json);
      final out = d.toJson();
      expect(out['schedule_type'], 'otc');
      expect(out['active_ingredient'], 'Paracetamol');
    });
  });

  // ═══════════════ PharmacyState ═══════════════
  group('PharmacyState', () {
    test('initial', () {
      const s = PharmacyInitial();
      expect(s, isA<PharmacyState>());
    });

    test('loading', () {
      const s = PharmacyLoading();
      expect(s, isA<PharmacyState>());
    });

    test('loaded', () {
      const s = PharmacyLoaded(prescriptions: [], drugSchedules: []);
      expect(s.prescriptions, isEmpty);
      expect(s.drugSchedules, isEmpty);
    });

    test('error', () {
      const s = PharmacyError(message: 'fail');
      expect(s.message, 'fail');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('Pharmacy endpoints', () {
    test('prescriptions', () {
      expect(ApiEndpoints.pharmacyPrescriptions, '/industry/pharmacy/prescriptions');
    });

    test('drug schedules', () {
      expect(ApiEndpoints.pharmacyDrugSchedules, '/industry/pharmacy/drug-schedules');
    });
  });

  // ═══════════════ Route ═══════════════
  group('Pharmacy route', () {
    test('route constant', () {
      expect(Routes.industryPharmacy, '/industry/pharmacy');
    });
  });
}
