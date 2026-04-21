import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_pharmacy/data/remote/pharmacy_api_service.dart';
import 'package:wameedpos/features/industry_pharmacy/models/prescription.dart';
import 'package:wameedpos/features/industry_pharmacy/models/drug_schedule.dart';

final pharmacyRepositoryProvider = Provider<PharmacyRepository>((ref) {
  return PharmacyRepository(apiService: ref.watch(pharmacyApiServiceProvider));
});

class PharmacyRepository {
  PharmacyRepository({required PharmacyApiService apiService}) : _apiService = apiService;
  final PharmacyApiService _apiService;

  Future<List<Prescription>> listPrescriptions({String? search, int perPage = 20}) =>
      _apiService.listPrescriptions(search: search, perPage: perPage);
  Future<Prescription> createPrescription(Map<String, dynamic> data) => _apiService.createPrescription(data);
  Future<Prescription> updatePrescription(String id, Map<String, dynamic> data) => _apiService.updatePrescription(id, data);

  Future<List<DrugSchedule>> listDrugSchedules({String? scheduleType, String? productId, int perPage = 20}) =>
      _apiService.listDrugSchedules(scheduleType: scheduleType, productId: productId, perPage: perPage);
  Future<DrugSchedule> createDrugSchedule(Map<String, dynamic> data) => _apiService.createDrugSchedule(data);
  Future<DrugSchedule> updateDrugSchedule(String id, Map<String, dynamic> data) => _apiService.updateDrugSchedule(id, data);
}
