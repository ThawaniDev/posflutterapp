import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/sync/data/remote/sync_api_service.dart';

class SyncRepository {
  final SyncApiService _api;
  SyncRepository(this._api);

  Future<Map<String, dynamic>> push({
    required String terminalId,
    required List<Map<String, dynamic>> changes,
    String? syncToken,
  }) => _api.push(terminalId: terminalId, changes: changes, syncToken: syncToken);

  Future<Map<String, dynamic>> pull({required String terminalId, List<String>? tables, String? syncToken}) =>
      _api.pull(terminalId: terminalId, tables: tables, syncToken: syncToken);

  Future<Map<String, dynamic>> fullSync({required String terminalId}) => _api.fullSync(terminalId: terminalId);

  Future<Map<String, dynamic>> status() => _api.status();

  Future<Map<String, dynamic>> resolveConflict({required String conflictId, required String resolution}) =>
      _api.resolveConflict(conflictId: conflictId, resolution: resolution);

  Future<Map<String, dynamic>> listConflicts({String? status, String? tableName, int? perPage}) =>
      _api.listConflicts(status: status, tableName: tableName, perPage: perPage);

  Future<Map<String, dynamic>> heartbeat({String? terminalId, List<Map<String, dynamic>>? changes}) =>
      _api.heartbeat(terminalId: terminalId, changes: changes);
}

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(ref.watch(syncApiServiceProvider));
});
