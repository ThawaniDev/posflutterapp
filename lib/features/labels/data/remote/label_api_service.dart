import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/models/label_print_stats.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';

final labelApiServiceProvider = Provider<LabelApiService>((ref) {
  return LabelApiService(ref.watch(dioClientProvider));
});

class LabelApiService {
  LabelApiService(this._dio);
  final Dio _dio;

  Future<List<LabelTemplate>> listTemplates({
    String? search,
    String? type,
  }) async {
    final params = <String, dynamic>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (type != null && type.isNotEmpty) params['type'] = type;
    final response = await _dio.get(
      ApiEndpoints.labelTemplates,
      queryParameters: params.isEmpty ? null : params,
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => LabelTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<LabelTemplate>> getPresets() async {
    final response = await _dio.get(ApiEndpoints.labelPresets);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
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

  Future<List<LabelPrintHistory>> getPrintHistory({
    DateTime? from,
    DateTime? to,
    String? templateId,
    int? perPage,
  }) async {
    final params = <String, dynamic>{};
    if (from != null) params['from'] = '${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}';
    if (to != null) params['to'] = '${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}';
    if (templateId != null) params['template_id'] = templateId;
    if (perPage != null) params['per_page'] = perPage;
    final response = await _dio.get(
      ApiEndpoints.labelPrintHistory,
      queryParameters: params.isEmpty ? null : params,
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => LabelPrintHistory.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> recordPrint(Map<String, dynamic> data) async {
    await _dio.post(ApiEndpoints.labelPrintHistory, data: data);
  }

  Future<LabelPrintStats> getPrintHistoryStats() async {
    final response = await _dio.get(ApiEndpoints.labelPrintHistoryStats);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LabelPrintStats.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<LabelTemplate> duplicateTemplate(String id) async {
    final response = await _dio.post('${ApiEndpoints.labelTemplates}/$id/duplicate');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LabelTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<LabelTemplate> setDefaultTemplate(String id) async {
    final response = await _dio.post('${ApiEndpoints.labelTemplates}/$id/set-default');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LabelTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
