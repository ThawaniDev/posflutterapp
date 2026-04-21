import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';

/// Detected device info
class DetectedDevice {

  const DetectedDevice({
    required this.type,
    required this.name,
    required this.connectionType,
    this.address,
    this.port,
    this.metadata = const {},
  });
  final HardwareDeviceType type;
  final String name;
  final String connectionType; // usb, network
  final String? address; // IP address for network, device path for USB
  final int? port;
  final Map<String, dynamic> metadata;
}

/// Auto-detector for POS peripherals
///
/// Discovers:
/// - Network printers via port scanning (9100)
/// - Network customer displays via known ports
/// - USB devices via Windows device enumeration (future)
class HardwareAutoDetector {
  /// Scan the local network for receipt printers (port 9100)
  Future<List<DetectedDevice>> scanNetworkPrinters({
    String subnet = '192.168.1',
    int startIp = 1,
    int endIp = 254,
    int port = 9100,
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    final devices = <DetectedDevice>[];

    // Scan range in parallel batches to avoid overwhelming the network
    const batchSize = 20;
    for (int start = startIp; start <= endIp; start += batchSize) {
      final end = (start + batchSize - 1).clamp(startIp, endIp);
      final futures = <Future<DetectedDevice?>>[];

      for (int i = start; i <= end; i++) {
        final ip = '$subnet.$i';
        futures.add(_probePort(ip, port, timeout, HardwareDeviceType.receiptPrinter));
      }

      final results = await Future.wait(futures);
      devices.addAll(results.whereType<DetectedDevice>());
    }

    return devices;
  }

  /// Scan for label printers (typically also on port 9100)
  Future<List<DetectedDevice>> scanNetworkLabelPrinters({
    String subnet = '192.168.1',
    int startIp = 1,
    int endIp = 254,
    int port = 9100,
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    // Label printers use the same port as receipt printers
    // Differentiation happens during device identification
    final devices = <DetectedDevice>[];

    const batchSize = 20;
    for (int start = startIp; start <= endIp; start += batchSize) {
      final end = (start + batchSize - 1).clamp(startIp, endIp);
      final futures = <Future<DetectedDevice?>>[];

      for (int i = start; i <= end; i++) {
        final ip = '$subnet.$i';
        futures.add(_probePort(ip, port, timeout, HardwareDeviceType.labelPrinter));
      }

      final results = await Future.wait(futures);
      devices.addAll(results.whereType<DetectedDevice>());
    }

    return devices;
  }

  /// Scan for all device types on the network
  Future<List<DetectedDevice>> scanAll({
    String subnet = '192.168.1',
    Duration timeout = const Duration(milliseconds: 500),
    void Function(int scanned, int total)? onProgress,
  }) async {
    final devices = <DetectedDevice>[];
    const total = 254;
    int scanned = 0;

    const batchSize = 20;
    for (int start = 1; start <= 254; start += batchSize) {
      final end = (start + batchSize - 1).clamp(1, 254);
      final futures = <Future<DetectedDevice?>>[];

      for (int i = start; i <= end; i++) {
        final ip = '$subnet.$i';
        // Probe common POS peripheral ports
        futures.add(_probePort(ip, 9100, timeout, HardwareDeviceType.receiptPrinter));
      }

      final results = await Future.wait(futures);
      devices.addAll(results.whereType<DetectedDevice>());

      scanned += (end - start + 1);
      onProgress?.call(scanned, total);
    }

    return devices;
  }

  /// List available serial/COM ports (for scales, serial scanners)
  List<String> listSerialPorts() {
    // On Windows, available COM ports can be detected
    // via Win32 API or by checking registry
    if (Platform.isWindows) {
      // In production, use flutter_libserialport to enumerate
      // SerialPort.availablePorts
      debugPrint('HardwareAutoDetector: Enumerating serial ports...');
      return []; // Will be populated by flutter_libserialport
    }
    return [];
  }

  /// Detect the local subnet from the device's network interfaces
  Future<String?> detectSubnet() async {
    try {
      final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          final parts = addr.address.split('.');
          if (parts.length == 4 && parts[0] != '127') {
            return '${parts[0]}.${parts[1]}.${parts[2]}';
          }
        }
      }
    } catch (e) {
      debugPrint('HardwareAutoDetector: Error detecting subnet: $e');
    }
    return null;
  }

  /// Probe a single IP:port to check if a device is listening
  Future<DetectedDevice?> _probePort(String ip, int port, Duration timeout, HardwareDeviceType type) async {
    try {
      final socket = await Socket.connect(ip, port, timeout: timeout);
      await socket.close();
      return DetectedDevice(type: type, name: '${_nameForType(type)} @ $ip', connectionType: 'network', address: ip, port: port);
    } catch (_) {
      return null;
    }
  }

  String _nameForType(HardwareDeviceType type) {
    switch (type) {
      case HardwareDeviceType.receiptPrinter:
        return 'Network Printer';
      case HardwareDeviceType.labelPrinter:
        return 'Label Printer';
      case HardwareDeviceType.customerDisplay:
        return 'Customer Display';
      case HardwareDeviceType.cardTerminal:
        return 'Card Terminal';
      default:
        return 'Device';
    }
  }
}
