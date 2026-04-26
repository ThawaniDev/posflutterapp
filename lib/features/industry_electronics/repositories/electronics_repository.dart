import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_electronics/data/remote/electronics_api_service.dart';
import 'package:wameedpos/features/industry_electronics/models/device_imei_record.dart';
import 'package:wameedpos/features/industry_electronics/models/repair_job.dart';
import 'package:wameedpos/features/industry_electronics/models/trade_in_record.dart';

final electronicsRepositoryProvider = Provider<ElectronicsRepository>((ref) {
  return ElectronicsRepository(apiService: ref.watch(electronicsApiServiceProvider));
});

class ElectronicsRepository {
  ElectronicsRepository({required ElectronicsApiService apiService}) : _apiService = apiService;
  final ElectronicsApiService _apiService;

  Future<List<DeviceImeiRecord>> listImeiRecords({String? status, String? search, int perPage = 20}) =>
      _apiService.listImeiRecords(status: status, search: search, perPage: perPage);
  Future<DeviceImeiRecord> createImeiRecord(Map<String, dynamic> data) => _apiService.createImeiRecord(data);
  Future<DeviceImeiRecord> updateImeiRecord(String id, Map<String, dynamic> data) => _apiService.updateImeiRecord(id, data);

  Future<List<RepairJob>> listRepairJobs({String? status, String? search, int perPage = 20}) =>
      _apiService.listRepairJobs(status: status, search: search, perPage: perPage);
  Future<RepairJob> createRepairJob(Map<String, dynamic> data) => _apiService.createRepairJob(data);
  Future<RepairJob> updateRepairJob(String id, Map<String, dynamic> data) => _apiService.updateRepairJob(id, data);
  Future<RepairJob> updateRepairJobStatus(String id, String status) => _apiService.updateRepairJobStatus(id, status);

  Future<List<TradeInRecord>> listTradeIns({String? customerId, String? search, int perPage = 20}) =>
      _apiService.listTradeIns(customerId: customerId, search: search, perPage: perPage);
  Future<TradeInRecord> createTradeIn(Map<String, dynamic> data) => _apiService.createTradeIn(data);

  Future<({bool valid, bool exists})> validateImei(String imei) =>
      _apiService.validateImei(imei);
}
