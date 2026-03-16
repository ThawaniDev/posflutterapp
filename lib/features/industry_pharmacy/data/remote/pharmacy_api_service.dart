import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/industry_pharmacy/models/prescription.dart';
import 'package:thawani_pos/features/industry_pharmacy/models/drug_schedule.dart';

final pharmacyApiServiceProvider = Provider<PharmacyApiService>((ref) {
  return PharmacyApiService(ref.watch(dioClientProvider));
});

class PharmacyApiService {
  final Dio _dio;
  PharmacyApiService(this._dio);

  Future<List<Prescription>> listPrescriptions({String? search, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.pharmacyPrescriptions,
      queryParameters: {'per_page': perPage, if (search != null && search.isNotEmpty) 'search': search},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => Prescription.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<Prescription> createPrescription(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.pharmacyPrescriptions, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Prescription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Prescription> updatePrescription(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.pharmacyPrescription(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Prescription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<DrugSchedule>> listDrugSchedules({String? scheduleType, String? productId, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.pharmacyDrugSchedules,
      queryParameters: {
        'per_page': perPage,
        if (scheduleType != null) 'schedule_type': scheduleType,
        if (productId != null) 'product_id': productId,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => DrugSchedule.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<DrugSchedule> createDrugSchedule(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.pharmacyDrugSchedules, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return DrugSchedule.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<DrugSchedule> updateDrugSchedule(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.pharmacyDrugSchedule(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return DrugSchedule.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
