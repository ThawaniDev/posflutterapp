import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/hardware/enums/connection_type.dart';
import 'package:thawani_pos/features/hardware/enums/hardware_device_type.dart';
import 'package:thawani_pos/features/hardware/models/hardware_configuration.dart';
import 'package:thawani_pos/features/hardware/models/hardware_event_log.dart';
import 'package:thawani_pos/features/hardware/providers/hardware_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // HardwareDeviceType Enum
  // ═══════════════════════════════════════════════════════════

  group('HardwareDeviceType enum', () {
    test('fromValue returns correct enum', () {
      expect(HardwareDeviceType.fromValue('receipt_printer'), HardwareDeviceType.receiptPrinter);
      expect(HardwareDeviceType.fromValue('barcode_scanner'), HardwareDeviceType.barcodeScanner);
      expect(HardwareDeviceType.fromValue('cash_drawer'), HardwareDeviceType.cashDrawer);
      expect(HardwareDeviceType.fromValue('customer_display'), HardwareDeviceType.customerDisplay);
      expect(HardwareDeviceType.fromValue('weighing_scale'), HardwareDeviceType.weighingScale);
      expect(HardwareDeviceType.fromValue('label_printer'), HardwareDeviceType.labelPrinter);
      expect(HardwareDeviceType.fromValue('card_terminal'), HardwareDeviceType.cardTerminal);
      expect(HardwareDeviceType.fromValue('nfc_reader'), HardwareDeviceType.nfcReader);
    });

    test('tryFromValue returns null for invalid', () {
      expect(HardwareDeviceType.tryFromValue('invalid'), isNull);
      expect(HardwareDeviceType.tryFromValue(null), isNull);
    });

    test('all 8 device types exist', () {
      expect(HardwareDeviceType.values, hasLength(8));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // ConnectionType Enum
  // ═══════════════════════════════════════════════════════════

  group('ConnectionType enum', () {
    test('fromValue returns correct enum', () {
      expect(ConnectionType.fromValue('usb'), ConnectionType.usb);
      expect(ConnectionType.fromValue('network'), ConnectionType.network);
      expect(ConnectionType.fromValue('bluetooth'), ConnectionType.bluetooth);
      expect(ConnectionType.fromValue('serial'), ConnectionType.serial);
    });

    test('tryFromValue returns null for invalid', () {
      expect(ConnectionType.tryFromValue('zigbee'), isNull);
    });

    test('all 4 connection types exist', () {
      expect(ConnectionType.values, hasLength(4));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // HardwareConfiguration Model
  // ═══════════════════════════════════════════════════════════

  group('HardwareConfiguration model', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'hw-001',
        'store_id': 'store-001',
        'terminal_id': 'term-001',
        'device_type': 'receipt_printer',
        'connection_type': 'usb',
        'device_name': 'Epson TM-T88V',
        'config_json': {'paper_width': 80, 'dpi': 203},
        'is_active': true,
        'created_at': '2024-06-01T10:00:00.000Z',
        'updated_at': '2024-06-01T10:00:00.000Z',
      };

      final config = HardwareConfiguration.fromJson(json);
      expect(config.id, 'hw-001');
      expect(config.storeId, 'store-001');
      expect(config.terminalId, 'term-001');
      expect(config.deviceType, HardwareDeviceType.receiptPrinter);
      expect(config.connectionType, ConnectionType.usb);
      expect(config.deviceName, 'Epson TM-T88V');
      expect(config.configJson['paper_width'], 80);
      expect(config.isActive, isTrue);
    });

    test('toJson round-trip preserves data', () {
      final config = HardwareConfiguration(
        id: 'hw-002',
        storeId: 'store-002',
        terminalId: 'term-002',
        deviceType: HardwareDeviceType.barcodeScanner,
        connectionType: ConnectionType.bluetooth,
        deviceName: 'Zebra DS2208',
        configJson: {'mode': 'hid'},
        isActive: true,
      );

      final json = config.toJson();
      final restored = HardwareConfiguration.fromJson(json);
      expect(restored.id, config.id);
      expect(restored.deviceType, config.deviceType);
      expect(restored.connectionType, config.connectionType);
      expect(restored.deviceName, config.deviceName);
    });

    test('copyWith creates modified copy', () {
      final config = HardwareConfiguration(
        id: 'hw-003',
        storeId: 'store-003',
        terminalId: 'term-003',
        deviceType: HardwareDeviceType.cashDrawer,
        connectionType: ConnectionType.usb,
        configJson: {},
        isActive: true,
      );

      final modified = config.copyWith(isActive: false, deviceName: 'Cash Drawer X');
      expect(modified.id, config.id);
      expect(modified.isActive, isFalse);
      expect(modified.deviceName, 'Cash Drawer X');
    });

    test('equality by id', () {
      final a = HardwareConfiguration(
        id: 'hw-same',
        storeId: 's',
        terminalId: 't',
        deviceType: HardwareDeviceType.receiptPrinter,
        connectionType: ConnectionType.usb,
        configJson: {},
      );
      final b = HardwareConfiguration(
        id: 'hw-same',
        storeId: 's2',
        terminalId: 't2',
        deviceType: HardwareDeviceType.barcodeScanner,
        connectionType: ConnectionType.network,
        configJson: {},
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // HardwareEventLog Model
  // ═══════════════════════════════════════════════════════════

  group('HardwareEventLog model', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'evt-001',
        'store_id': 'store-001',
        'terminal_id': 'term-001',
        'device_type': 'receipt_printer',
        'event': 'connected',
        'details': 'USB port 3',
        'created_at': '2024-06-01T10:00:00.000Z',
      };

      final log = HardwareEventLog.fromJson(json);
      expect(log.id, 'evt-001');
      expect(log.deviceType, HardwareDeviceType.receiptPrinter);
      expect(log.event, 'connected');
      expect(log.details, 'USB port 3');
    });

    test('toJson round-trip preserves data', () {
      final log = HardwareEventLog(
        id: 'evt-002',
        storeId: 'store-002',
        terminalId: 'term-002',
        deviceType: HardwareDeviceType.cashDrawer,
        event: 'opened',
      );

      final json = log.toJson();
      final restored = HardwareEventLog.fromJson(json);
      expect(restored.id, log.id);
      expect(restored.event, log.event);
      expect(restored.deviceType, log.deviceType);
    });

    test('copyWith works', () {
      final log = HardwareEventLog(
        id: 'evt-003',
        storeId: 's',
        terminalId: 't',
        deviceType: HardwareDeviceType.nfcReader,
        event: 'scan',
      );
      final modified = log.copyWith(event: 'auth_success');
      expect(modified.event, 'auth_success');
      expect(modified.id, 'evt-003');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // HardwareConfigListState
  // ═══════════════════════════════════════════════════════════

  group('HardwareConfigListState', () {
    test('initial state', () {
      const state = HardwareConfigListInitial();
      expect(state, isA<HardwareConfigListState>());
    });

    test('loading state', () {
      const state = HardwareConfigListLoading();
      expect(state, isA<HardwareConfigListState>());
    });

    test('loaded state with configs', () {
      final configs = [
        HardwareConfiguration(
          id: 'c1',
          storeId: 's1',
          terminalId: 't1',
          deviceType: HardwareDeviceType.receiptPrinter,
          connectionType: ConnectionType.usb,
          configJson: {},
        ),
      ];
      final state = HardwareConfigListLoaded(configs: configs);
      expect(state.configs, hasLength(1));
    });

    test('error state', () {
      const state = HardwareConfigListError('Failed');
      expect(state.message, 'Failed');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SupportedModelsState
  // ═══════════════════════════════════════════════════════════

  group('SupportedModelsState', () {
    test('initial state', () {
      const state = SupportedModelsInitial();
      expect(state, isA<SupportedModelsState>());
    });

    test('loaded with models', () {
      final state = SupportedModelsLoaded(
        models: [
          {'brand': 'Epson', 'model': 'TM-T88V', 'device_type': 'receipt_printer'},
        ],
      );
      expect(state.models, hasLength(1));
    });

    test('error state', () {
      const state = SupportedModelsError('Network error');
      expect(state.message, 'Network error');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // DeviceTestState
  // ═══════════════════════════════════════════════════════════

  group('DeviceTestState', () {
    test('idle state', () {
      const state = DeviceTestIdle();
      expect(state, isA<DeviceTestState>());
    });

    test('running state', () {
      const state = DeviceTestRunning();
      expect(state, isA<DeviceTestState>());
    });

    test('success state', () {
      const state = DeviceTestSuccess(success: true, message: 'Test passed', testedAt: '2024-06-01T10:00:00Z');
      expect(state.success, isTrue);
      expect(state.message, 'Test passed');
      expect(state.testedAt, '2024-06-01T10:00:00Z');
    });

    test('error state', () {
      const state = DeviceTestError('Connection refused');
      expect(state.message, 'Connection refused');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // EventLogListState
  // ═══════════════════════════════════════════════════════════

  group('EventLogListState', () {
    test('initial state', () {
      const state = EventLogListInitial();
      expect(state, isA<EventLogListState>());
    });

    test('loaded with pagination', () {
      final logs = [
        HardwareEventLog(
          id: 'l1',
          storeId: 's1',
          terminalId: 't1',
          deviceType: HardwareDeviceType.receiptPrinter,
          event: 'connected',
        ),
      ];
      final state = EventLogListLoaded(logs: logs, currentPage: 1, lastPage: 5, total: 50);
      expect(state.logs, hasLength(1));
      expect(state.total, 50);
      expect(state.lastPage, 5);
    });

    test('error state', () {
      const state = EventLogListError('Timeout');
      expect(state.message, 'Timeout');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Cross-cutting
  // ═══════════════════════════════════════════════════════════

  group('Cross-cutting hardware tests', () {
    test('all device types have valid values', () {
      for (final type in HardwareDeviceType.values) {
        expect(type.value, isNotEmpty);
        expect(HardwareDeviceType.fromValue(type.value), type);
      }
    });

    test('all connection types have valid values', () {
      for (final type in ConnectionType.values) {
        expect(type.value, isNotEmpty);
        expect(ConnectionType.fromValue(type.value), type);
      }
    });

    test('HardwareConfiguration with each device type round-trips', () {
      for (final dt in HardwareDeviceType.values) {
        for (final ct in ConnectionType.values) {
          final config = HardwareConfiguration(
            id: '${dt.value}-${ct.value}',
            storeId: 's',
            terminalId: 't',
            deviceType: dt,
            connectionType: ct,
            configJson: {},
          );
          final json = config.toJson();
          final restored = HardwareConfiguration.fromJson(json);
          expect(restored.deviceType, dt);
          expect(restored.connectionType, ct);
        }
      }
    });
  });
}
