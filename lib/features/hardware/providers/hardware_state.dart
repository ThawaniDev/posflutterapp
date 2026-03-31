import 'package:thawani_pos/features/hardware/models/hardware_configuration.dart';
import 'package:thawani_pos/features/hardware/models/hardware_event_log.dart';
import 'package:thawani_pos/features/hardware/services/hardware_auto_detector.dart';

// ─── Hardware Config List State ────────────────────────────
sealed class HardwareConfigListState {
  const HardwareConfigListState();
}

final class HardwareConfigListInitial extends HardwareConfigListState {
  const HardwareConfigListInitial();
}

final class HardwareConfigListLoading extends HardwareConfigListState {
  const HardwareConfigListLoading();
}

final class HardwareConfigListLoaded extends HardwareConfigListState {
  const HardwareConfigListLoaded({required this.configs});
  final List<HardwareConfiguration> configs;
}

final class HardwareConfigListError extends HardwareConfigListState {
  const HardwareConfigListError(this.message);
  final String message;
}

// ─── Supported Models State ────────────────────────────────
sealed class SupportedModelsState {
  const SupportedModelsState();
}

final class SupportedModelsInitial extends SupportedModelsState {
  const SupportedModelsInitial();
}

final class SupportedModelsLoading extends SupportedModelsState {
  const SupportedModelsLoading();
}

final class SupportedModelsLoaded extends SupportedModelsState {
  const SupportedModelsLoaded({required this.models});
  final List<Map<String, dynamic>> models;
}

final class SupportedModelsError extends SupportedModelsState {
  const SupportedModelsError(this.message);
  final String message;
}

// ─── Device Test State ─────────────────────────────────────
sealed class DeviceTestState {
  const DeviceTestState();
}

final class DeviceTestIdle extends DeviceTestState {
  const DeviceTestIdle();
}

final class DeviceTestRunning extends DeviceTestState {
  const DeviceTestRunning();
}

final class DeviceTestSuccess extends DeviceTestState {
  const DeviceTestSuccess({required this.success, required this.message, required this.testedAt});
  final bool success;
  final String message;
  final String testedAt;
}

final class DeviceTestError extends DeviceTestState {
  const DeviceTestError(this.message);
  final String message;
}

// ─── Event Log List State ──────────────────────────────────
sealed class EventLogListState {
  const EventLogListState();
}

final class EventLogListInitial extends EventLogListState {
  const EventLogListInitial();
}

final class EventLogListLoading extends EventLogListState {
  const EventLogListLoading();
}

final class EventLogListLoaded extends EventLogListState {
  const EventLogListLoaded({required this.logs, required this.currentPage, required this.lastPage, required this.total});
  final List<HardwareEventLog> logs;
  final int currentPage;
  final int lastPage;
  final int total;
}

final class EventLogListError extends EventLogListState {
  const EventLogListError(this.message);
  final String message;
}

// ─── Network Scan State ────────────────────────────────────
sealed class NetworkScanState {
  const NetworkScanState();
}

final class NetworkScanIdle extends NetworkScanState {
  const NetworkScanIdle();
}

final class NetworkScanRunning extends NetworkScanState {
  const NetworkScanRunning({required this.scanned, required this.total});
  final int scanned;
  final int total;
  double get progress => total > 0 ? scanned / total : 0;
}

final class NetworkScanComplete extends NetworkScanState {
  const NetworkScanComplete({required this.devices});
  final List<DetectedDevice> devices;
}

final class NetworkScanError extends NetworkScanState {
  const NetworkScanError(this.message);
  final String message;
}
