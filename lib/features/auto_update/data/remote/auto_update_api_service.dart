import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

final autoUpdateApiServiceProvider = Provider<AutoUpdateApiService>((ref) {
  return AutoUpdateApiService(ref);
});

class AutoUpdateApiService {
  final Ref _ref;
  AutoUpdateApiService(this._ref);

  /// POST /auto-update/check
  Future<Map<String, dynamic>> checkForUpdate({required String currentVersion, required String platform, String? channel}) async {
    final body = <String, dynamic>{'current_version': currentVersion, 'platform': platform};
    if (channel != null) body['channel'] = channel;

    final res = await _ref.read(dioClientProvider).post(ApiEndpoints.autoUpdateCheck, data: body);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// POST /auto-update/report-status
  Future<Map<String, dynamic>> reportStatus({required String releaseId, required String status, String? errorMessage}) async {
    final body = <String, dynamic>{'release_id': releaseId, 'status': status};
    if (errorMessage != null) body['error_message'] = errorMessage;

    final res = await _ref.read(dioClientProvider).post(ApiEndpoints.autoUpdateReportStatus, data: body);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// GET /auto-update/changelog
  Future<Map<String, dynamic>> getChangelog({String? platform, String? channel}) async {
    final params = <String, dynamic>{};
    if (platform != null) params['platform'] = platform;
    if (channel != null) params['channel'] = channel;

    final res = await _ref.read(dioClientProvider).get(ApiEndpoints.autoUpdateChangelog, queryParameters: params);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// GET /auto-update/history
  Future<Map<String, dynamic>> getUpdateHistory() async {
    final res = await _ref.read(dioClientProvider).get(ApiEndpoints.autoUpdateHistory);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// GET /auto-update/current-version
  Future<Map<String, dynamic>> getCurrentVersion({required String platform}) async {
    final res = await _ref
        .read(dioClientProvider)
        .get(ApiEndpoints.autoUpdateCurrentVersion, queryParameters: {'platform': platform});
    return Map<String, dynamic>.from(res.data as Map);
  }
}
