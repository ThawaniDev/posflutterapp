import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/labels/models/label_print_history.dart';
import 'package:thawani_pos/features/labels/models/label_template.dart';

final labelApiServiceProvider = Provider<LabelApiService>((ref) {
  return LabelApiService(ref.watch(dioClientProvider));
});

class LabelApiService {
  final Dio _dio;

  LabelApiService(this._dio);

  Future<List<LabelTemplate>> listTemplates() async {
    final response = await _dio.get(ApiEndpoints.labelTemplates);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List;
    return list.map((j) => LabelTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<LabelTemplate>> getPresets() async {
    final response = await _dio.get(ApiEndpoints.labelPresets);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List;
    return list.map((j) => LabelTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<LabelTemplate> getTemplate(String id) async {
    final response = await _dio.get('${ApiEndpoints.labelTemplates}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LabelTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<LabelTemplate> createTemplate(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.labelTemplates, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LabelTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<LabelTemplate> updateTemplate(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.labelTemplates}/$id', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LabelTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteTemplate(String id) async {
    await _dio.delete('${ApiEndpoints.labelTemplates}/$id');
  }

  Future<List<LabelPrintHistory>> getPrintHistory() async {
    final response = await _dio.get(ApiEndpoints.labelPrintHistory);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List;
    return list.map((j) => LabelPrintHistory.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> recordPrint(Map<String, dynamic> data) async {
    await _dio.post(ApiEndpoints.labelPrintHistory, data: data);
  }
}
