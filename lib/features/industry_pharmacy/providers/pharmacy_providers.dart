import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_pharmacy/providers/pharmacy_state.dart';
import 'package:thawani_pos/features/industry_pharmacy/repositories/pharmacy_repository.dart';

final pharmacyProvider = StateNotifierProvider<PharmacyNotifier, PharmacyState>((ref) {
  return PharmacyNotifier(ref.watch(pharmacyRepositoryProvider));
});

class PharmacyNotifier extends StateNotifier<PharmacyState> {
  final PharmacyRepository _repo;
  PharmacyNotifier(this._repo) : super(const PharmacyInitial());

  Future<void> load() async {
    state = const PharmacyLoading();
    try {
      final prescriptions = await _repo.listPrescriptions();
      final schedules = await _repo.listDrugSchedules();
      state = PharmacyLoaded(prescriptions: prescriptions, drugSchedules: schedules);
    } on DioException catch (e) {
      state = PharmacyError(message: _extractError(e));
    } catch (e) {
      state = PharmacyError(message: e.toString());
    }
  }

  Future<void> createPrescription(Map<String, dynamic> data) async {
    try {
      await _repo.createPrescription(data);
      await load();
    } on DioException catch (e) {
      state = PharmacyError(message: _extractError(e));
    }
  }

  Future<void> updatePrescription(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updatePrescription(id, data);
      await load();
    } on DioException catch (e) {
      state = PharmacyError(message: _extractError(e));
    }
  }

  Future<void> createDrugSchedule(Map<String, dynamic> data) async {
    try {
      await _repo.createDrugSchedule(data);
      await load();
    } on DioException catch (e) {
      state = PharmacyError(message: _extractError(e));
    }
  }

  Future<void> updateDrugSchedule(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateDrugSchedule(id, data);
      await load();
    } on DioException catch (e) {
      state = PharmacyError(message: _extractError(e));
    }
  }
}

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
