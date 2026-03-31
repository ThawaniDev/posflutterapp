import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/hardware/enums/hardware_device_type.dart';
import 'package:thawani_pos/features/hardware/models/hardware_configuration.dart';
import 'package:thawani_pos/features/hardware/models/hardware_event_log.dart';
import 'package:thawani_pos/features/hardware/providers/hardware_state.dart';
import 'package:thawani_pos/features/hardware/repositories/hardware_repository.dart';
import 'package:thawani_pos/features/hardware/services/hardware_auto_detector.dart';
import 'package:thawani_pos/features/hardware/services/hardware_manager.dart';

// ─── Config List Provider ──────────────────────────────────
class HardwareConfigListNotifier extends StateNotifier<HardwareConfigListState> {
  HardwareConfigListNotifier(this._repo) : super(const HardwareConfigListInitial());

  final HardwareRepository _repo;

  Future<void> load({String? terminalId, String? deviceType}) async {
    state = const HardwareConfigListLoading();
    try {
      final data = await _repo.listConfigs(terminalId: terminalId, deviceType: deviceType);
      final configs = data.map((e) => HardwareConfiguration.fromJson(e as Map<String, dynamic>)).toList();
      state = HardwareConfigListLoaded(configs: configs);
    } catch (e) {
      state = HardwareConfigListError(e.toString());
    }
  }

  Future<void> save({
    required String terminalId,
    required String deviceType,
    required String connectionType,
    String? deviceName,
    Map<String, dynamic>? configJson,
  }) async {
    try {
      await _repo.saveConfig(
        terminalId: terminalId,
        deviceType: deviceType,
        connectionType: connectionType,
        deviceName: deviceName,
        configJson: configJson,
      );
      await load(terminalId: terminalId);
    } catch (e) {
      state = HardwareConfigListError(e.toString());
    }
  }

  Future<void> remove(String id, {String? terminalId}) async {
    try {
      await _repo.removeConfig(id);
      await load(terminalId: terminalId);
    } catch (e) {
      state = HardwareConfigListError(e.toString());
    }
  }
}

final hardwareConfigListProvider = StateNotifierProvider<HardwareConfigListNotifier, HardwareConfigListState>((ref) {
  return HardwareConfigListNotifier(ref.watch(hardwareRepositoryProvider));
});

// ─── Supported Models Provider ─────────────────────────────
class SupportedModelsNotifier extends StateNotifier<SupportedModelsState> {
  SupportedModelsNotifier(this._repo) : super(const SupportedModelsInitial());

  final HardwareRepository _repo;

  Future<void> load({String? deviceType}) async {
    state = const SupportedModelsLoading();
    try {
      final data = await _repo.supportedModels(deviceType: deviceType);
      final models = data.map((e) => e as Map<String, dynamic>).toList();
      state = SupportedModelsLoaded(models: models);
    } catch (e) {
      state = SupportedModelsError(e.toString());
    }
  }
}

final supportedModelsProvider = StateNotifierProvider<SupportedModelsNotifier, SupportedModelsState>((ref) {
  return SupportedModelsNotifier(ref.watch(hardwareRepositoryProvider));
});

// ─── Device Test Provider ──────────────────────────────────
class DeviceTestNotifier extends StateNotifier<DeviceTestState> {
  DeviceTestNotifier(this._repo) : super(const DeviceTestIdle());

  final HardwareRepository _repo;

  Future<void> test({
    required String terminalId,
    required String deviceType,
    required String connectionType,
    String? testType,
  }) async {
    state = const DeviceTestRunning();
    try {
      final result = await _repo.testDevice(
        terminalId: terminalId,
        deviceType: deviceType,
        connectionType: connectionType,
        testType: testType,
      );
      state = DeviceTestSuccess(
        success: result['success'] as bool,
        message: result['message'] as String,
        testedAt: result['tested_at'] as String,
      );
    } catch (e) {
      state = DeviceTestError(e.toString());
    }
  }

  void reset() => state = const DeviceTestIdle();
}

final deviceTestProvider = StateNotifierProvider<DeviceTestNotifier, DeviceTestState>((ref) {
  return DeviceTestNotifier(ref.watch(hardwareRepositoryProvider));
});

// ─── Event Log List Provider ───────────────────────────────
class EventLogListNotifier extends StateNotifier<EventLogListState> {
  EventLogListNotifier(this._repo) : super(const EventLogListInitial());

  final HardwareRepository _repo;

  Future<void> load({String? terminalId, String? deviceType, String? event, int? perPage}) async {
    state = const EventLogListLoading();
    try {
      final data = await _repo.eventLogs(terminalId: terminalId, deviceType: deviceType, event: event, perPage: perPage);
      final logs = (data['data'] as List).map((e) => HardwareEventLog.fromJson(e as Map<String, dynamic>)).toList();
      state = EventLogListLoaded(
        logs: logs,
        currentPage: data['current_page'] as int,
        lastPage: data['last_page'] as int,
        total: data['total'] as int,
      );
    } catch (e) {
      state = EventLogListError(e.toString());
    }
  }
}

final eventLogListProvider = StateNotifierProvider<EventLogListNotifier, EventLogListState>((ref) {
  return EventLogListNotifier(ref.watch(hardwareRepositoryProvider));
});

// ─── Hardware Manager Provider (singleton) ─────────────────
final hardwareManagerProvider = Provider<HardwareManager>((ref) {
  final manager = HardwareManager();
  ref.onDispose(manager.dispose);
  return manager;
});

// ─── Peripheral Status Provider ────────────────────────────
final peripheralStatusProvider = StreamProvider<Map<HardwareDeviceType, PeripheralStatus>>((ref) {
  return ref.watch(hardwareManagerProvider).statusStream;
});

// ─── Auto Detector Provider ────────────────────────────────
final hardwareAutoDetectorProvider = Provider<HardwareAutoDetector>((ref) {
  return HardwareAutoDetector();
});

// ─── Network Scan State ────────────────────────────────────
class NetworkScanNotifier extends StateNotifier<NetworkScanState> {
  NetworkScanNotifier(this._detector) : super(const NetworkScanIdle());

  final HardwareAutoDetector _detector;

  Future<void> scan({String? subnet}) async {
    state = const NetworkScanRunning(scanned: 0, total: 254);
    try {
      final detectedSubnet = subnet ?? await _detector.detectSubnet() ?? '192.168.1';
      final devices = await _detector.scanAll(
        subnet: detectedSubnet,
        onProgress: (scanned, total) {
          if (mounted) {
            state = NetworkScanRunning(scanned: scanned, total: total);
          }
        },
      );
      state = NetworkScanComplete(devices: devices);
    } catch (e) {
      state = NetworkScanError(e.toString());
    }
  }

  void reset() => state = const NetworkScanIdle();
}

final networkScanProvider = StateNotifierProvider<NetworkScanNotifier, NetworkScanState>((ref) {
  return NetworkScanNotifier(ref.watch(hardwareAutoDetectorProvider));
});
