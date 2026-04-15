import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/hardware/data/remote/hardware_api_service.dart';

class HardwareRepository {
  HardwareRepository(this._api);

  final HardwareApiService _api;

  Future<List<dynamic>> listConfigs({String? terminalId, String? deviceType, bool? isActive}) =>
      _api.listConfigs(terminalId: terminalId, deviceType: deviceType, isActive: isActive);

  Future<Map<String, dynamic>> saveConfig({
    required String terminalId,
    required String deviceType,
    required String connectionType,
    String? deviceName,
    Map<String, dynamic>? configJson,
    bool? isActive,
  }) => _api.saveConfig(
    terminalId: terminalId,
    deviceType: deviceType,
    connectionType: connectionType,
    deviceName: deviceName,
    configJson: configJson,
    isActive: isActive,
  );

  Future<void> removeConfig(String id) => _api.removeConfig(id);

  Future<List<dynamic>> supportedModels({String? deviceType, bool? isCertified}) =>
      _api.supportedModels(deviceType: deviceType, isCertified: isCertified);

  Future<Map<String, dynamic>> testDevice({
    required String terminalId,
    required String deviceType,
    required String connectionType,
    String? testType,
  }) => _api.testDevice(terminalId: terminalId, deviceType: deviceType, connectionType: connectionType, testType: testType);

  Future<Map<String, dynamic>> recordEvent({
    required String terminalId,
    required String deviceType,
    required String event,
    Map<String, dynamic>? details,
  }) => _api.recordEvent(terminalId: terminalId, deviceType: deviceType, event: event, details: details);

  Future<Map<String, dynamic>> eventLogs({String? terminalId, String? deviceType, String? event, int? perPage}) =>
      _api.eventLogs(terminalId: terminalId, deviceType: deviceType, event: event, perPage: perPage);
}

final hardwareRepositoryProvider = Provider<HardwareRepository>((ref) {
  return HardwareRepository(ref.watch(hardwareApiServiceProvider));
});
