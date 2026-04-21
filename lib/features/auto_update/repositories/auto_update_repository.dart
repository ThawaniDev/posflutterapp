import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/auto_update/data/remote/auto_update_api_service.dart';

final autoUpdateRepositoryProvider = Provider<AutoUpdateRepository>((ref) {
  return AutoUpdateRepository(ref.read(autoUpdateApiServiceProvider));
});

class AutoUpdateRepository {
  AutoUpdateRepository(this._api);
  final AutoUpdateApiService _api;

  Future<Map<String, dynamic>> checkForUpdate({required String currentVersion, required String platform, String? channel}) =>
      _api.checkForUpdate(currentVersion: currentVersion, platform: platform, channel: channel);

  Future<Map<String, dynamic>> reportStatus({required String releaseId, required String status, String? errorMessage}) =>
      _api.reportStatus(releaseId: releaseId, status: status, errorMessage: errorMessage);

  Future<Map<String, dynamic>> getChangelog({String? platform, String? channel}) =>
      _api.getChangelog(platform: platform, channel: channel);

  Future<Map<String, dynamic>> getUpdateHistory() => _api.getUpdateHistory();

  Future<Map<String, dynamic>> getCurrentVersion({required String platform}) => _api.getCurrentVersion(platform: platform);

  Future<Map<String, dynamic>> getManifest({required String version, String? platform, String? channel}) =>
      _api.getManifest(version: version, platform: platform, channel: channel);

  Future<Map<String, dynamic>> getDownloadInfo({required String version, String? platform, String? channel}) =>
      _api.getDownloadInfo(version: version, platform: platform, channel: channel);

  Future<Map<String, dynamic>> getRolloutStatus({String? platform, String? channel}) =>
      _api.getRolloutStatus(platform: platform, channel: channel);
}
