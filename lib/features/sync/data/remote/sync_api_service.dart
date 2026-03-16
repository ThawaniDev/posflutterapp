import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class SyncApiService {
  final Dio _dio;
  SyncApiService(this._dio);

  Future<Map<String, dynamic>> push({
    required String terminalId,
    required List<Map<String, dynamic>> changes,
    String? syncToken,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.syncPush,
      data: {'terminal_id': terminalId, 'changes': changes, if (syncToken != null) 'sync_token': syncToken},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> pull({required String terminalId, List<String>? tables, String? syncToken}) async {
    final response = await _dio.get(
      ApiEndpoints.syncPull,
      queryParameters: {
        'terminal_id': terminalId,
        if (tables != null) 'tables': tables,
        if (syncToken != null) 'sync_token': syncToken,
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

  Future<Map<String, dynamic>> resolveConflict({required String conflictId, required String resolution}) async {
    final response = await _dio.post(ApiEndpoints.syncResolveConflict(conflictId), data: {'resolution': resolution});
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listConflicts({String? status, String? tableName, int? perPage}) async {
    final response = await _dio.get(
      ApiEndpoints.syncConflicts,
      queryParameters: {
        if (status != null) 'status': status,
        if (tableName != null) 'table_name': tableName,
        if (perPage != null) 'per_page': perPage,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> heartbeat({String? terminalId, List<Map<String, dynamic>>? changes}) async {
    final response = await _dio.post(
      ApiEndpoints.syncHeartbeat,
      data: {if (terminalId != null) 'terminal_id': terminalId, if (changes != null) 'changes': changes},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}

final syncApiServiceProvider = Provider<SyncApiService>((ref) {
  return SyncApiService(ref.watch(dioClientProvider));
});
