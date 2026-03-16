import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/industry_electronics/models/device_imei_record.dart';
import 'package:thawani_pos/features/industry_electronics/models/repair_job.dart';
import 'package:thawani_pos/features/industry_electronics/models/trade_in_record.dart';

final electronicsApiServiceProvider = Provider<ElectronicsApiService>((ref) {
  return ElectronicsApiService(ref.watch(dioClientProvider));
});

class ElectronicsApiService {
  final Dio _dio;
  ElectronicsApiService(this._dio);

  Future<List<DeviceImeiRecord>> listImeiRecords({String? status, String? search, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.electronicsImeiRecords,
      queryParameters: {
        'per_page': perPage,
        if (status != null) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => DeviceImeiRecord.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<DeviceImeiRecord> createImeiRecord(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.electronicsImeiRecords, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return DeviceImeiRecord.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<DeviceImeiRecord> updateImeiRecord(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.electronicsImeiRecord(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return DeviceImeiRecord.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<RepairJob>> listRepairJobs({String? status, String? search, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.electronicsRepairJobs,
      queryParameters: {
        'per_page': perPage,
        if (status != null) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => RepairJob.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<RepairJob> createRepairJob(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.electronicsRepairJobs, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return RepairJob.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<RepairJob> updateRepairJob(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.electronicsRepairJob(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return RepairJob.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<RepairJob> updateRepairJobStatus(String id, String status) async {
    final response = await _dio.patch(ApiEndpoints.electronicsRepairJobStatus(id), data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return RepairJob.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<TradeInRecord>> listTradeIns({String? customerId, String? search, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.electronicsTradeIns,
      queryParameters: {
        'per_page': perPage,
        if (customerId != null) 'customer_id': customerId,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => TradeInRecord.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<TradeInRecord> createTradeIn(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.electronicsTradeIns, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TradeInRecord.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
