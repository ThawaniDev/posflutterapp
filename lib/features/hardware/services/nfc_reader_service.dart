import 'dart:async';

import 'package:flutter/foundation.dart';

/// NFC tag data
class NfcTagData {
  final String uid;
  final String? type; // NTAG213, MIFARE Classic, etc.
  final DateTime scannedAt;
  final Map<String, dynamic>? payload; // NDEF records if available

  const NfcTagData({required this.uid, this.type, required this.scannedAt, this.payload});
}

/// NFC reader configuration
class NfcReaderConfig {
  final String connectionType; // usb, built_in
  final String purpose; // staff_badge, customer_card, generic
  final bool continuousRead; // auto-read on tap
  final int debounceMs; // prevent duplicate reads
  final String? usbDevicePath;

  const NfcReaderConfig({
    this.connectionType = 'usb',
    this.purpose = 'staff_badge',
    this.continuousRead = true,
    this.debounceMs = 2000,
    this.usbDevicePath,
  });

  factory NfcReaderConfig.fromJson(Map<String, dynamic> json) {
    return NfcReaderConfig(
      connectionType: json['connection_type'] as String? ?? 'usb',
      purpose: json['purpose'] as String? ?? 'staff_badge',
      continuousRead: json['continuous_read'] as bool? ?? true,
      debounceMs: json['debounce_ms'] as int? ?? 2000,
      usbDevicePath: json['usb_device_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'connection_type': connectionType,
    'purpose': purpose,
    'continuous_read': continuousRead,
    'debounce_ms': debounceMs,
    'usb_device_path': usbDevicePath,
  };
}

/// NFC reader service — reads NFC tags for staff badge authentication
///
/// On Windows desktop, NFC readers typically appear as USB HID devices
/// that output the tag UID as keyboard input (similar to barcode scanners).
/// This service differentiates NFC reader input from barcode scanner input
/// by checking the prefix/format of the scanned data.
class NfcReaderService {
  NfcReaderConfig _config = const NfcReaderConfig();
  bool _isConnected = false;
  String? _lastUid;
  DateTime? _lastScanTime;

  final _tagController = StreamController<NfcTagData>.broadcast();

  NfcReaderConfig get config => _config;
  bool get isConnected => _isConnected;

  /// Stream of NFC tag reads
  Stream<NfcTagData> get tagStream => _tagController.stream;

  void configure(NfcReaderConfig config) {
    _config = config;
  }

  /// Start listening for NFC tags
  Future<bool> connect() async {
    try {
      // USB HID NFC readers output tag UID as keyboard input
      // The actual keyboard event handling is done by the HardwareManager
      // which routes HID input to either barcode scanner or NFC reader
      // based on prefix detection
      _isConnected = true;
      debugPrint('NfcReaderService: Connected (${_config.connectionType})');
      return true;
    } catch (e) {
      debugPrint('NfcReaderService connect error: $e');
      _isConnected = false;
      return false;
    }
  }

  /// Process a tag UID received from the HID input layer
  void processTagUid(String uid) {
    if (uid.isEmpty) return;

    // Debounce: ignore if same UID within debounce period
    final now = DateTime.now();
    if (_lastUid == uid && _lastScanTime != null) {
      final elapsed = now.difference(_lastScanTime!).inMilliseconds;
      if (elapsed < _config.debounceMs) return;
    }

    _lastUid = uid;
    _lastScanTime = now;

    final tagData = NfcTagData(uid: uid.toUpperCase().replaceAll(RegExp(r'[^0-9A-F]'), ''), scannedAt: now);

    _tagController.add(tagData);
    debugPrint('NfcReaderService: Tag scanned: ${tagData.uid}');
  }

  /// Check if a string looks like an NFC UID (hex string, 8-14 chars)
  static bool isNfcUid(String input) {
    final cleaned = input.trim().toUpperCase();
    // NFC UIDs are hex strings: 4 bytes (8 hex) for MIFARE Classic,
    // 7 bytes (14 hex) for NTAG, 10 bytes (20 hex) for some tags
    if (cleaned.length < 8 || cleaned.length > 20) return false;
    return RegExp(r'^[0-9A-F]+$').hasMatch(cleaned);
  }

  /// Disconnect NFC reader
  Future<void> disconnect() async {
    _isConnected = false;
    debugPrint('NfcReaderService: Disconnected');
  }

  void dispose() {
    _tagController.close();
  }
}
