import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

class SyncApiService {
  SyncApiService(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> push({
    required String terminalId,
    required List<Map<String, dynamic>> changes,
    String? syncToken,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.syncPush,
      data: {'terminal_id': terminalId, 'changes': changes, 'sync_token': ?syncToken},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> pull({required String terminalId, List<String>? tables, String? syncToken}) async {
    final response = await _dio.get(
      ApiEndpoints.syncPull,
      queryParameters: {
        'terminal_id': terminalId,
        'tables': ?tables,
        'sync_token': ?syncToken,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fullSync({required String terminalId}) async {
    final response = await _dio.get(ApiEndpoints.syncFull, queryParameters: {'terminal_id': terminalId});
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> status() async {
    final response = await _dio.get(ApiEndpoints.syncStatus);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resolveConflict({
    required String conflictId,
    required String resolution,
    Map<String, dynamic>? mergedData,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.syncResolveConflict(conflictId),
      data: {'resolution': resolution, 'merged_data': ?mergedData},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listConflicts({String? status, String? tableName, int? perPage}) async {
    final response = await _dio.get(
      ApiEndpoints.syncConflicts,
      queryParameters: {
        'status': ?status,
        'table_name': ?tableName,
        'per_page': ?perPage,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> heartbeat({String? terminalId, List<Map<String, dynamic>>? changes}) async {
    final response = await _dio.post(
      ApiEndpoints.syncHeartbeat,
      data: {'terminal_id': ?terminalId, 'changes': ?changes},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}

final syncApiServiceProvider = Provider<SyncApiService>((ref) {
  return SyncApiService(ref.watch(dioClientProvider));
});
