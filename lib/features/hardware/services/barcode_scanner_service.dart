import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';

/// Barcode scan result
class BarcodeScanResult {
  final String barcode;
  final DateTime scannedAt;
  final String source; // 'keyboard_wedge', 'serial', 'bluetooth'

  const BarcodeScanResult({required this.barcode, required this.scannedAt, this.source = 'keyboard_wedge'});
}

/// Scanner configuration
class ScannerConfig {
  final String connectionType; // usb, serial, bluetooth
  final int scannerTimeout; // ms to wait for complete barcode
  final int minBarcodeLength;
  final int maxBarcodeLength;
  final String? prefix; // character(s) prepended by scanner
  final String? suffix; // character(s) appended by scanner (typically \n)
  final String? comPort; // for serial connection

  const ScannerConfig({
    this.connectionType = 'usb',
    this.scannerTimeout = 100,
    this.minBarcodeLength = 4,
    this.maxBarcodeLength = 50,
    this.prefix,
    this.suffix,
    this.comPort,
  });

  factory ScannerConfig.fromJson(Map<String, dynamic> json) {
    return ScannerConfig(
      connectionType: json['connection_type'] as String? ?? 'usb',
      scannerTimeout: json['scanner_timeout'] as int? ?? 100,
      minBarcodeLength: json['min_barcode_length'] as int? ?? 4,
      maxBarcodeLength: json['max_barcode_length'] as int? ?? 50,
      prefix: json['prefix'] as String?,
      suffix: json['suffix'] as String?,
      comPort: json['com_port'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'connection_type': connectionType,
    'scanner_timeout': scannerTimeout,
    'min_barcode_length': minBarcodeLength,
    'max_barcode_length': maxBarcodeLength,
    'prefix': prefix,
    'suffix': suffix,
    'com_port': comPort,
  };
}

/// Barcode scanner service — listens for USB HID keyboard-wedge input
/// Scanners in keyboard-wedge mode send characters very fast (< 50ms between keystrokes)
/// followed by Enter. Human typing is slower (> 100ms between keystrokes).
class BarcodeScannerService {
  ScannerConfig _config = const ScannerConfig();
  final _scanController = StreamController<BarcodeScanResult>.broadcast();
  String _buffer = '';
  DateTime _lastKeyTime = DateTime.now();
  Timer? _scanTimer;
  bool _isListening = false;

  // DataWedge (PDA) support
  FlutterDataWedge? _dataWedge;
  StreamSubscription<ScanResult>? _dataWedgeSub;
  bool _dataWedgeInitialized = false;

  Stream<BarcodeScanResult> get onScan => _scanController.stream;
  bool get isListening => _isListening;
  bool get isDataWedgeAvailable => _dataWedgeInitialized;
  ScannerConfig get config => _config;

  void configure(ScannerConfig config) {
    _config = config;
  }

  /// Start listening for barcode scans via keyboard-wedge (HID) and DataWedge (PDA)
  void startListening() {
    _isListening = true;
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);

    // Initialize DataWedge for PDA devices (Android only)
    if (!kIsWeb && Platform.isAndroid) {
      _initDataWedge();
    }
  }

  /// Initialize Zebra/Honeywell DataWedge for PDA barcode scanning
  Future<void> _initDataWedge() async {
    if (_dataWedgeInitialized) return;
    try {
      _dataWedge = FlutterDataWedge();
      await _dataWedge!.initialize();
      await _dataWedge!.createDefaultProfile(profileName: 'ThawaniPOS');
      _dataWedgeSub = _dataWedge!.onScanResult.listen(_handleDataWedgeScan);
      _dataWedgeInitialized = true;
      debugPrint('BarcodeScannerService: DataWedge initialized successfully');
    } catch (e) {
      debugPrint('BarcodeScannerService: DataWedge not available ($e) — using keyboard-wedge only');
      _dataWedgeInitialized = false;
    }
  }

  /// Handle scan result from DataWedge PDA
  void _handleDataWedgeScan(ScanResult result) {
    final barcode = result.data.trim();
    if (barcode.isEmpty) return;
    if (barcode.length < _config.minBarcodeLength || barcode.length > _config.maxBarcodeLength) return;

    debugPrint('BarcodeScannerService: DataWedge scan: $barcode');
    _scanController.add(BarcodeScanResult(barcode: barcode, scannedAt: DateTime.now(), source: 'datawedge'));
  }

  /// Stop listening
  void stopListening() {
    _isListening = false;
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _scanTimer?.cancel();
    _buffer = '';
    _dataWedgeSub?.cancel();
    _dataWedgeSub = null;
  }

  /// Handle a keyboard event — distinguish scanner input from human typing
  bool _handleKeyEvent(KeyEvent event) {
    if (!_isListening) return false;
    if (event is! KeyDownEvent) return false;

    final now = DateTime.now();
    final timeSinceLast = now.difference(_lastKeyTime).inMilliseconds;
    _lastKeyTime = now;

    // If too much time has passed, reset the buffer (human typing)
    if (timeSinceLast > _config.scannerTimeout) {
      _buffer = '';
    }

    final character = event.character;

    // Enter key — finalize the barcode
    if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _processBuffer();
      return _buffer.isNotEmpty; // consume the event only if we had a buffer
    }

    // Accumulate characters
    if (character != null && character.isNotEmpty) {
      _buffer += character;

      // Reset timeout timer
      _scanTimer?.cancel();
      _scanTimer = Timer(Duration(milliseconds: _config.scannerTimeout * 2), () {
        // If no Enter received within timeout, try processing anyway
        _processBuffer();
      });

      // Return false to not consume the event (allow normal typing)
      return false;
    }

    return false;
  }

  /// Process the accumulated buffer as a barcode
  void _processBuffer() {
    _scanTimer?.cancel();
    var barcode = _buffer.trim();
    _buffer = '';

    if (barcode.isEmpty) return;

    // Strip prefix/suffix if configured
    if (_config.prefix != null && barcode.startsWith(_config.prefix!)) {
      barcode = barcode.substring(_config.prefix!.length);
    }
    if (_config.suffix != null && barcode.endsWith(_config.suffix!)) {
      barcode = barcode.substring(0, barcode.length - _config.suffix!.length);
    }

    // Validate length
    if (barcode.length < _config.minBarcodeLength || barcode.length > _config.maxBarcodeLength) {
      return;
    }

    debugPrint('BarcodeScannerService: Scanned barcode: $barcode');
    _scanController.add(BarcodeScanResult(barcode: barcode, scannedAt: DateTime.now(), source: 'keyboard_wedge'));
  }

  /// Manually submit a barcode (e.g., from manual entry field)
  void manualEntry(String barcode) {
    if (barcode.trim().isEmpty) return;
    _scanController.add(BarcodeScanResult(barcode: barcode.trim(), scannedAt: DateTime.now(), source: 'manual'));
  }

  void dispose() {
    stopListening();
    _dataWedge = null;
    _dataWedgeInitialized = false;
    _scanController.close();
  }
}
