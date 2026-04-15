import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';
import 'package:wameedpos/features/hardware/models/hardware_configuration.dart';
import 'package:wameedpos/features/hardware/services/barcode_scanner_service.dart';
import 'package:wameedpos/features/hardware/services/card_terminal_service.dart';
import 'package:wameedpos/features/hardware/services/cash_drawer_service.dart';
import 'package:wameedpos/features/hardware/services/customer_display_service.dart';
import 'package:wameedpos/features/hardware/services/label_printer_service.dart';
import 'package:wameedpos/features/hardware/services/nfc_reader_service.dart';
import 'package:wameedpos/features/hardware/services/receipt_printer_service.dart';
import 'package:wameedpos/features/hardware/services/weighing_scale_service.dart';

/// Peripheral connection status
class PeripheralStatus {
  final HardwareDeviceType type;
  final bool isConfigured;
  final bool isConnected;
  final String? deviceName;
  final String? errorMessage;
  final DateTime? lastActivity;

  const PeripheralStatus({
    required this.type,
    this.isConfigured = false,
    this.isConnected = false,
    this.deviceName,
    this.errorMessage,
    this.lastActivity,
  });

  PeripheralStatus copyWith({
    bool? isConfigured,
    bool? isConnected,
    String? deviceName,
    String? errorMessage,
    DateTime? lastActivity,
  }) => PeripheralStatus(
    type: type,
    isConfigured: isConfigured ?? this.isConfigured,
    isConnected: isConnected ?? this.isConnected,
    deviceName: deviceName ?? this.deviceName,
    errorMessage: errorMessage ?? this.errorMessage,
    lastActivity: lastActivity ?? this.lastActivity,
  );
}

/// Central hardware manager — orchestrates all peripheral device services.
///
/// Provides:
/// - Single initialization point for all hardware
/// - Status tracking for each device type
/// - Configuration from stored hardware_configurations
/// - Graceful shutdown of all peripherals
class HardwareManager {
  final ReceiptPrinterService receiptPrinter = ReceiptPrinterService();
  final BarcodeScannerService barcodeScanner = BarcodeScannerService();
  final CashDrawerService cashDrawer = CashDrawerService();
  final CustomerDisplayService customerDisplay = CustomerDisplayService();
  final WeighingScaleService weighingScale = WeighingScaleService();
  final LabelPrinterService labelPrinter = LabelPrinterService();
  final CardTerminalService cardTerminal = CardTerminalService();
  final NfcReaderService nfcReader = NfcReaderService();

  final Map<HardwareDeviceType, PeripheralStatus> _statuses = {};
  final _statusController = StreamController<Map<HardwareDeviceType, PeripheralStatus>>.broadcast();

  /// Stream of status updates for all peripherals
  Stream<Map<HardwareDeviceType, PeripheralStatus>> get statusStream => _statusController.stream;

  /// Current status of all peripherals
  Map<HardwareDeviceType, PeripheralStatus> get statuses => Map.unmodifiable(_statuses);

  /// Get status for a specific device type
  PeripheralStatus? getStatus(HardwareDeviceType type) => _statuses[type];

  /// Check if a specific device type is connected and ready
  bool isReady(HardwareDeviceType type) => _statuses[type]?.isConnected ?? false;

  /// Initialize all peripherals from a list of stored configurations
  Future<void> initializeAll(List<HardwareConfiguration> configs) async {
    // Initialize status map for all device types
    for (final type in HardwareDeviceType.values) {
      _statuses[type] = PeripheralStatus(type: type);
    }

    for (final config in configs) {
      if (config.isActive != true) continue;
      await _initializeDevice(config);
    }

    _notifyStatusChange();
  }

  /// Initialize a single device from configuration
  Future<bool> _initializeDevice(HardwareConfiguration config) async {
    final type = config.deviceType;

    final configJson = config.configJson;

    try {
      _updateStatus(type, isConfigured: true, deviceName: config.deviceName);

      switch (type) {
        case HardwareDeviceType.receiptPrinter:
          receiptPrinter.configure(PrinterConfig.fromJson(configJson));
          final connected = await receiptPrinter.connect();
          _updateStatus(type, isConnected: connected);
          // Also configure cash drawer if it uses printer kick
          cashDrawer.configure(CashDrawerConfig.fromJson(configJson));
          return connected;

        case HardwareDeviceType.barcodeScanner:
          barcodeScanner.configure(ScannerConfig.fromJson(configJson));
          barcodeScanner.startListening();
          _updateStatus(type, isConnected: true);
          return true;

        case HardwareDeviceType.cashDrawer:
          cashDrawer.configure(CashDrawerConfig.fromJson(configJson));
          _updateStatus(type, isConnected: true);
          return true;

        case HardwareDeviceType.customerDisplay:
          customerDisplay.configure(CustomerDisplayConfig.fromJson(configJson));
          final connected = await customerDisplay.connect();
          _updateStatus(type, isConnected: connected);
          return connected;

        case HardwareDeviceType.weighingScale:
          weighingScale.configure(ScaleConfig.fromJson(configJson));
          final connected = await weighingScale.connect();
          _updateStatus(type, isConnected: connected);
          return connected;

        case HardwareDeviceType.labelPrinter:
          labelPrinter.configure(LabelPrinterConfig.fromJson(configJson));
          _updateStatus(type, isConnected: true);
          return true;

        case HardwareDeviceType.cardTerminal:
          cardTerminal.configure(CardTerminalConfig.fromJson(configJson));
          final connected = await cardTerminal.initialize();
          _updateStatus(type, isConnected: connected);
          return connected;

        case HardwareDeviceType.nfcReader:
          nfcReader.configure(NfcReaderConfig.fromJson(configJson));
          final connected = await nfcReader.connect();
          _updateStatus(type, isConnected: connected);
          return connected;
      }
    } catch (e) {
      debugPrint('HardwareManager: Failed to initialize ${type.value}: $e');
      _updateStatus(type, isConnected: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Reconfigure and reconnect a specific device
  Future<bool> reconfigure(HardwareConfiguration config) async {
    // Disconnect existing
    await disconnectDevice(config.deviceType);
    // Re-initialize
    return _initializeDevice(config);
  }

  /// Disconnect a specific device type
  Future<void> disconnectDevice(HardwareDeviceType? type) async {
    if (type == null) return;
    try {
      switch (type) {
        case HardwareDeviceType.receiptPrinter:
          await receiptPrinter.disconnect();
        case HardwareDeviceType.barcodeScanner:
          barcodeScanner.stopListening();
        case HardwareDeviceType.cashDrawer:
          break; // No persistent connection
        case HardwareDeviceType.customerDisplay:
          await customerDisplay.disconnect();
        case HardwareDeviceType.weighingScale:
          await weighingScale.disconnect();
        case HardwareDeviceType.labelPrinter:
          break; // No persistent connection
        case HardwareDeviceType.cardTerminal:
          await cardTerminal.disconnect();
        case HardwareDeviceType.nfcReader:
          await nfcReader.disconnect();
      }
      _updateStatus(type, isConnected: false);
    } catch (e) {
      debugPrint('HardwareManager: Error disconnecting ${type.value}: $e');
    }
  }

  /// Test a specific device
  Future<bool> testDevice(HardwareDeviceType type) async {
    try {
      switch (type) {
        case HardwareDeviceType.receiptPrinter:
          return await receiptPrinter.printTestPage();
        case HardwareDeviceType.barcodeScanner:
          return barcodeScanner.isListening;
        case HardwareDeviceType.cashDrawer:
          return await cashDrawer.open();
        case HardwareDeviceType.customerDisplay:
          return await customerDisplay.test();
        case HardwareDeviceType.weighingScale:
          final reading = await weighingScale.readWeightOnce();
          return reading != null;
        case HardwareDeviceType.labelPrinter:
          return await labelPrinter.printTestLabel();
        case HardwareDeviceType.cardTerminal:
          return cardTerminal.isConnected;
        case HardwareDeviceType.nfcReader:
          return nfcReader.isConnected;
      }
    } catch (e) {
      debugPrint('HardwareManager: Test failed for ${type.value}: $e');
      return false;
    }
  }

  /// Gracefully shut down all peripherals
  Future<void> shutdownAll() async {
    for (final type in HardwareDeviceType.values) {
      await disconnectDevice(type);
    }
    barcodeScanner.dispose();
    nfcReader.dispose();
    _notifyStatusChange();
  }

  void _updateStatus(HardwareDeviceType type, {bool? isConfigured, bool? isConnected, String? deviceName, String? errorMessage}) {
    final current = _statuses[type] ?? PeripheralStatus(type: type);
    _statuses[type] = current.copyWith(
      isConfigured: isConfigured,
      isConnected: isConnected,
      deviceName: deviceName,
      errorMessage: errorMessage,
      lastActivity: DateTime.now(),
    );
    _notifyStatusChange();
  }

  void _notifyStatusChange() {
    if (!_statusController.isClosed) {
      _statusController.add(Map.unmodifiable(_statuses));
    }
  }

  void dispose() {
    _statusController.close();
  }
}
