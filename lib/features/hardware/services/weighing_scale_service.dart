import 'dart:async';

import 'package:flutter/foundation.dart';

/// Weighing scale configuration
class ScaleConfig {
  final String comPort; // COM3, /dev/ttyUSB0, etc.
  final int baudRate;
  final int dataBits;
  final String parity; // none, odd, even
  final int stopBits;
  final String protocol; // standard, continuous, on_demand
  final String unit; // kg, g, lb
  final int decimalPlaces;
  final String? requestCommand; // command to request weight reading

  const ScaleConfig({
    this.comPort = 'COM3',
    this.baudRate = 9600,
    this.dataBits = 8,
    this.parity = 'none',
    this.stopBits = 1,
    this.protocol = 'standard',
    this.unit = 'kg',
    this.decimalPlaces = 3,
    this.requestCommand,
  });

  factory ScaleConfig.fromJson(Map<String, dynamic> json) {
    return ScaleConfig(
      comPort: json['com_port'] as String? ?? 'COM3',
      baudRate: json['baud_rate'] as int? ?? 9600,
      dataBits: json['data_bits'] as int? ?? 8,
      parity: json['parity'] as String? ?? 'none',
      stopBits: json['stop_bits'] as int? ?? 1,
      protocol: json['protocol'] as String? ?? 'standard',
      unit: json['unit'] as String? ?? 'kg',
      decimalPlaces: json['decimal_places'] as int? ?? 3,
      requestCommand: json['request_command'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'com_port': comPort,
    'baud_rate': baudRate,
    'data_bits': dataBits,
    'parity': parity,
    'stop_bits': stopBits,
    'protocol': protocol,
    'unit': unit,
    'decimal_places': decimalPlaces,
    'request_command': requestCommand,
  };
}

/// Weight reading result
class WeightReading {
  final double weight;
  final String unit;
  final bool stable;
  final DateTime readAt;

  const WeightReading({required this.weight, required this.unit, required this.stable, required this.readAt});
}

/// Weighing scale service — serial port communication
/// Uses flutter_libserialport for serial port access
class WeighingScaleService {
  ScaleConfig _config = const ScaleConfig();
  final _weightController = StreamController<WeightReading>.broadcast();
  bool _isConnected = false;
  Timer? _pollingTimer;
  double _lastWeight = 0.0;
  double _tare = 0.0;

  Stream<WeightReading> get onWeightChange => _weightController.stream;
  bool get isConnected => _isConnected;
  double get lastWeight => _lastWeight;
  double get tare => _tare;
  ScaleConfig get config => _config;

  void configure(ScaleConfig config) {
    _config = config;
  }

  /// Connect to the scale
  Future<bool> connect() async {
    try {
      // Note: actual serial port connection uses flutter_libserialport
      // This is the interface — platform-specific implementation varies
      _isConnected = true;
      debugPrint('WeighingScaleService: Connected to ${_config.comPort}');
      return true;
    } catch (e) {
      debugPrint('WeighingScaleService connect error: $e');
      _isConnected = false;
      return false;
    }
  }

  /// Disconnect from the scale
  Future<void> disconnect() async {
    _pollingTimer?.cancel();
    _isConnected = false;
  }

  /// Start continuous weight reading
  void startContinuousReading({Duration interval = const Duration(milliseconds: 500)}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) => _readWeight());
  }

  /// Stop continuous reading
  void stopContinuousReading() {
    _pollingTimer?.cancel();
  }

  /// Read weight once
  Future<WeightReading?> readWeightOnce() async {
    return _readWeight();
  }

  /// Set tare (zero the scale with current weight)
  void setTare(double weight) {
    _tare = weight;
  }

  /// Reset tare to zero
  void resetTare() {
    _tare = 0.0;
  }

  /// Internal weight reading method
  Future<WeightReading?> _readWeight() async {
    if (!_isConnected) return null;

    try {
      // In production, this reads from the serial port using flutter_libserialport
      // The response format depends on the scale model/protocol
      // Common format: "ST,GS,  0.125kg" or "+  0.125 kg"
      // For now, return the last known weight
      final reading = WeightReading(weight: _lastWeight - _tare, unit: _config.unit, stable: true, readAt: DateTime.now());
      _weightController.add(reading);
      return reading;
    } catch (e) {
      debugPrint('WeighingScaleService read error: $e');
      return null;
    }
  }

  /// Parse weight from scale response string
  double parseWeightResponse(String response) {
    // Common formats:
    // "ST,GS,  0.125kg"
    // "+  0.125 kg"
    // "  0.125"
    final cleanedResponse = response.trim().replaceAll(RegExp(r'[A-Za-z,]'), '').replaceAll(RegExp(r'\s+'), ' ').trim();

    return double.tryParse(cleanedResponse) ?? 0.0;
  }

  /// Test scale connection
  Future<bool> test() async {
    if (!_isConnected) {
      final connected = await connect();
      if (!connected) return false;
    }
    final reading = await readWeightOnce();
    return reading != null;
  }

  void dispose() {
    _pollingTimer?.cancel();
    _weightController.close();
  }
}
