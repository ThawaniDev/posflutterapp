import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';
import 'package:wameedpos/features/hardware/models/hardware_configuration.dart';
import 'package:wameedpos/features/hardware/models/hardware_event_log.dart';
import 'package:wameedpos/features/hardware/providers/hardware_state.dart';
import 'package:wameedpos/features/hardware/repositories/hardware_repository.dart';
import 'package:wameedpos/features/hardware/services/hardware_auto_detector.dart';
import 'package:wameedpos/features/hardware/services/hardware_manager.dart';
import 'package:wameedpos/features/hardware/services/receipt_printer_service.dart' show PrinterConfig, PrinterSelection;

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

// ─── Live Status Initializer ───────────────────────────────
/// Initializes the [HardwareManager] from the currently-loaded configurations
/// so the peripheral status stream reflects *real* connection attempts rather
/// than a dormant/empty status map. Recomputes whenever the configuration list
/// changes (e.g. after add/remove/test) so the dashboard stays accurate.
final hardwareLiveStatusInitProvider = FutureProvider.autoDispose<void>((ref) async {
  final configState = ref.watch(hardwareConfigListProvider);
  final configs = switch (configState) {
    HardwareConfigListLoaded(:final configs) => configs,
    _ => const <HardwareConfiguration>[],
  };
  if (configs.isEmpty) return;
  await ref.read(hardwareManagerProvider).initializeAll(configs);
});

// ─── Auto Detector Provider ────────────────────────────────
final hardwareAutoDetectorProvider = Provider<HardwareAutoDetector>((ref) {
  return HardwareAutoDetector();
});

// ─── Detected Subnet Provider ──────────────────────────────
/// Detects the local /24 subnet from the device's network interfaces so the UI
/// can show which range is being scanned. Purely local — no backend.
final detectedSubnetProvider = FutureProvider.autoDispose<String?>((ref) {
  return ref.watch(hardwareAutoDetectorProvider).detectSubnet();
});

// ─── Network Scan State ────────────────────────────────────
class NetworkScanNotifier extends StateNotifier<NetworkScanState> {
  NetworkScanNotifier(this._detector) : super(const NetworkScanIdle());

  final HardwareAutoDetector _detector;

  Future<void> scan({String? subnet}) async {
    state = const NetworkScanRunning(scanned: 0, total: 254);
    try {
      final detectedSubnet = subnet ?? await _detector.detectSubnet() ?? '192.168.1';

      // Run network probe + bonded-BT listing in parallel.
      // BT listing is instant (no actual scan); network probe takes ~5 s.
      final results = await Future.wait<List<DetectedDevice>>([
        _detector.scanAll(
          subnet: detectedSubnet,
          onProgress: (scanned, total) {
            if (mounted) {
              state = NetworkScanRunning(scanned: scanned, total: total);
            }
          },
        ),
        _detector.scanBondedBluetoothDevices(),
      ]);

      state = NetworkScanComplete(devices: [...results[0], ...results[1]]);
    } catch (e) {
      state = NetworkScanError(e.toString());
    }
  }

  void reset() => state = const NetworkScanIdle();
}

final networkScanProvider = StateNotifierProvider<NetworkScanNotifier, NetworkScanState>((ref) {
  return NetworkScanNotifier(ref.watch(hardwareAutoDetectorProvider));
});

// ─── Printer Selection ─────────────────────────────────────

/// Checks for the device's own built-in printer (USB/serial device file).
/// Purely local — no network, no backend.
final builtInPrinterProvider = FutureProvider.autoDispose<PrinterSelection?>((ref) {
  return ref.read(hardwareAutoDetectorProvider).detectBuiltInPrinter();
});

/// User-overridden printer. `null` = auto-select from detected devices.
final selectedPrinterProvider = StateProvider<PrinterSelection?>((ref) => null);

/// Resolves the printer to use for the next receipt, in priority order:
///   1. User has explicitly chosen a printer (via the picker in the receipt dialog).
///   2. Built-in USB/serial printer detected on this terminal.
///   3. First receipt printer found in the local network scan.
///   4. First Bluetooth-bonded receipt printer.
final activePrinterProvider = Provider<PrinterSelection?>((ref) {
  // 1 — User pick
  final userPick = ref.watch(selectedPrinterProvider);
  if (userPick != null) return userPick;

  // 2 — Built-in (Landi / Sunmi / PAX internal printer)
  final builtIn = ref.watch(builtInPrinterProvider).valueOrNull;
  if (builtIn != null) return builtIn;

  // 3 & 4 — From the local scan results
  final scan = ref.watch(networkScanProvider);
  if (scan is NetworkScanComplete) {
    final printers = scan.devices.where((d) => d.type == HardwareDeviceType.receiptPrinter).toList();
    // Prefer network over Bluetooth
    for (final d in printers) {
      if (d.connectionType == 'network' && (d.address?.isNotEmpty ?? false)) {
        return PrinterSelection(
          label: d.name,
          config: PrinterConfig(connectionType: 'network', ipAddress: d.address, port: d.port ?? 9100),
        );
      }
    }
    for (final d in printers) {
      if (d.connectionType == 'bluetooth' && (d.address?.isNotEmpty ?? false)) {
        return PrinterSelection(
          label: d.name,
          config: PrinterConfig(connectionType: 'bluetooth', bluetoothAddress: d.address),
        );
      }
    }
  }

  return null;
});
