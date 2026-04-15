import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:wameedpos/features/hardware/services/receipt_printer_service.dart';

/// Cash drawer configuration
class CashDrawerConfig {
  final String triggerMethod; // 'printer_kick', 'direct_usb'
  final int pin; // 0 = pin 2, 1 = pin 5
  final int pulseOnMs;
  final int pulseOffMs;
  final String? printerIp; // if trigger_method is printer_kick
  final int printerPort;

  const CashDrawerConfig({
    this.triggerMethod = 'printer_kick',
    this.pin = 0,
    this.pulseOnMs = 100,
    this.pulseOffMs = 100,
    this.printerIp,
    this.printerPort = 9100,
  });

  factory CashDrawerConfig.fromJson(Map<String, dynamic> json) {
    return CashDrawerConfig(
      triggerMethod: json['trigger_method'] as String? ?? 'printer_kick',
      pin: json['pin'] as int? ?? 0,
      pulseOnMs: json['pulse_on'] as int? ?? 100,
      pulseOffMs: json['pulse_off'] as int? ?? 100,
      printerIp: json['printer_ip'] as String? ?? json['ip'] as String?,
      printerPort: json['printer_port'] as int? ?? json['port'] as int? ?? 9100,
    );
  }

  Map<String, dynamic> toJson() => {
    'trigger_method': triggerMethod,
    'pin': pin,
    'pulse_on': pulseOnMs,
    'pulse_off': pulseOffMs,
    'printer_ip': printerIp,
    'printer_port': printerPort,
  };
}

/// Cash drawer service — controls electronic cash drawer
/// Commonly triggered via the receipt printer's RJ-12 kick connector
class CashDrawerService {
  CashDrawerConfig _config = const CashDrawerConfig();
  ReceiptPrinterService? _printerService;
  DateTime? _lastOpenTime;

  CashDrawerConfig get config => _config;
  DateTime? get lastOpenTime => _lastOpenTime;

  void configure(CashDrawerConfig config, {ReceiptPrinterService? printerService}) {
    _config = config;
    _printerService = printerService;
  }

  /// Open the cash drawer
  Future<bool> open() async {
    try {
      bool success = false;

      if (_config.triggerMethod == 'printer_kick' && _printerService != null) {
        success = await _printerService!.openCashDrawer(pin: _config.pin);
      } else if (_config.triggerMethod == 'printer_kick') {
        // Direct network kick without printer service
        success = await _sendKickPulse();
      }

      if (success) {
        _lastOpenTime = DateTime.now();
      }

      return success;
    } catch (e) {
      debugPrint('CashDrawerService open error: $e');
      return false;
    }
  }

  /// Send kick pulse directly to printer IP
  Future<bool> _sendKickPulse() async {
    if (_config.printerIp == null || _config.printerIp!.isEmpty) return false;

    try {
      final kickCommand = _config.pin == 0 ? EscPos.drawerKickPin2 : EscPos.drawerKickPin5;

      final socket = await Socket.connect(_config.printerIp!, _config.printerPort, timeout: const Duration(seconds: 3));
      socket.add(Uint8List.fromList(kickCommand));
      await socket.flush();
      await socket.close();
      return true;
    } catch (e) {
      debugPrint('CashDrawerService _sendKickPulse error: $e');
      return false;
    }
  }

  /// Test the cash drawer
  Future<bool> test() async {
    return open();
  }
}
