import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/accounting/data/remote/accounting_api_service.dart';

final accountingRepositoryProvider = Provider<AccountingRepository>((ref) {
  return AccountingRepository(ref.watch(accountingApiServiceProvider));
});

class AccountingRepository {
  final AccountingApiService _apiService;

  AccountingRepository(this._apiService);

  Future<Map<String, dynamic>> getStatus() => _apiService.getStatus();

  Future<Map<String, dynamic>> connect({
    required String provider,
    required String accessToken,
    required String refreshToken,
    required String tokenExpiresAt,
    String? realmId,
    String? tenantId,
    String? companyName,
  }) => _apiService.connect(
    provider: provider,
    accessToken: accessToken,
    refreshToken: refreshToken,
    tokenExpiresAt: tokenExpiresAt,
    realmId: realmId,
    tenantId: tenantId,
    companyName: companyName,
  );

  Future<Map<String, dynamic>> disconnect() => _apiService.disconnect();

  Future<Map<String, dynamic>> refreshToken({
    required String accessToken,
    String? refreshTokenValue,
    required String tokenExpiresAt,
  }) => _apiService.refreshToken(accessToken: accessToken, refreshTokenValue: refreshTokenValue, tokenExpiresAt: tokenExpiresAt);

  Future<Map<String, dynamic>> getMappings() => _apiService.getMappings();

  Future<Map<String, dynamic>> saveMappings(List<Map<String, dynamic>> mappings) => _apiService.saveMappings(mappings);

  Future<Map<String, dynamic>> deleteMapping(String id) => _apiService.deleteMapping(id);

  Future<Map<String, dynamic>> getPosAccountKeys() => _apiService.getPosAccountKeys();

  Future<Map<String, dynamic>> triggerExport({required String startDate, required String endDate, List<String>? exportTypes}) =>
      _apiService.triggerExport(startDate: startDate, endDate: endDate, exportTypes: exportTypes);

  Future<Map<String, dynamic>> listExports({String? status, int? limit}) => _apiService.listExports(status: status, limit: limit);

  Future<Map<String, dynamic>> getExport(String id) => _apiService.getExport(id);

  Future<Map<String, dynamic>> retryExport(String id) => _apiService.retryExport(id);

  Future<Map<String, dynamic>> getAutoExportConfig() => _apiService.getAutoExportConfig();

  Future<Map<String, dynamic>> updateAutoExportConfig(Map<String, dynamic> data) => _apiService.updateAutoExportConfig(data);
}
