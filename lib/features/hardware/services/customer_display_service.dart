import 'dart:async';

import 'package:flutter/foundation.dart';

/// Customer display configuration
class CustomerDisplayConfig { // number of lines (pole displays are typically 2)

  const CustomerDisplayConfig({
    this.displayType = 'pole_display',
    this.comPort,
    this.baudRate = 9600,
    this.welcomeMessage,
    this.idleMessage,
    this.lineWidth = 20,
    this.lineCount = 2,
  });

  factory CustomerDisplayConfig.fromJson(Map<String, dynamic> json) {
    return CustomerDisplayConfig(
      displayType: json['display_type'] as String? ?? 'pole_display',
      comPort: json['com_port'] as String?,
      baudRate: json['baud_rate'] as int? ?? 9600,
      welcomeMessage: json['welcome_message'] as String?,
      idleMessage: json['idle_message'] as String?,
      lineWidth: json['line_width'] as int? ?? 20,
      lineCount: json['line_count'] as int? ?? 2,
    );
  }
  final String displayType; // 'pole_display', 'secondary_screen'
  final String? comPort; // for pole display
  final int baudRate;
  final String? welcomeMessage;
  final String? idleMessage;
  final int lineWidth; // characters per line (pole displays are typically 20)
  final int lineCount;

  Map<String, dynamic> toJson() => {
    'display_type': displayType,
    'com_port': comPort,
    'baud_rate': baudRate,
    'welcome_message': welcomeMessage,
    'idle_message': idleMessage,
    'line_width': lineWidth,
    'line_count': lineCount,
  };
}

/// Pole display command constants (VFD — Vacuum Fluorescent Display)
class VfdCommands {
  static const List<int> clearScreen = [0x0C]; // FF - form feed / clear
  static const List<int> cursorHome = [0x0B]; // VT - cursor to home
  static List<int> setCursor(int line, int col) => [0x1F, 0x24, col, line];
  static const List<int> brightnessMax = [0x1F, 0x58, 0x04];
  static const List<int> brightnessMin = [0x1F, 0x58, 0x01];
}

/// Customer display service — renders info on pole display or secondary screen
class CustomerDisplayService {
  CustomerDisplayConfig _config = const CustomerDisplayConfig();
  bool _isConnected = false;

  CustomerDisplayConfig get config => _config;
  bool get isConnected => _isConnected;

  void configure(CustomerDisplayConfig config) {
    _config = config;
  }

  /// Connect to the display
  Future<bool> connect() async {
    try {
      if (_config.displayType == 'pole_display') {
        // Serial port connection via flutter_libserialport
        _isConnected = true;
        await showWelcome();
        return true;
      } else if (_config.displayType == 'secondary_screen') {
        _isConnected = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('CustomerDisplayService connect error: $e');
      _isConnected = false;
      return false;
    }
  }

  /// Disconnect
  Future<void> disconnect() async {
    _isConnected = false;
  }

  /// Show welcome message
  Future<void> showWelcome() async {
    final message = _config.welcomeMessage ?? 'Welcome!';
    final idleMsg = _config.idleMessage ?? '';
    await displayLines(message, idleMsg);
  }

  /// Show idle message
  Future<void> showIdle() async {
    final message = _config.idleMessage ?? 'Welcome!';
    await displayLines(message, '');
  }

  /// Display item being scanned
  Future<void> showItem(String itemName, double price, String currency) async {
    final priceLine = '$currency ${price.toStringAsFixed(2)}';
    final truncatedName = itemName.length > _config.lineWidth ? itemName.substring(0, _config.lineWidth) : itemName;
    await displayLines(truncatedName, priceLine);
  }

  /// Display subtotal
  Future<void> showSubtotal(double subtotal, int itemCount, String currency) async {
    await displayLines('Items: $itemCount', 'Total: $currency ${subtotal.toStringAsFixed(2)}');
  }

  /// Display total with payment info
  Future<void> showTotal(double total, String currency) async {
    await displayLines('TOTAL', '$currency ${total.toStringAsFixed(2)}');
  }

  /// Display change due
  Future<void> showChange(double change, String currency) async {
    await displayLines('CHANGE', '$currency ${change.toStringAsFixed(2)}');
  }

  /// Display thank you message
  Future<void> showThankYou() async {
    await displayLines('Thank You!', 'Come Again!');
    // Return to idle after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      showIdle();
    });
  }

  /// Display two lines on the pole display
  Future<void> displayLines(String line1, String line2) async {
    if (!_isConnected) return;

    if (_config.displayType == 'pole_display') {
      await _sendToPoleDisplay(line1, line2);
    }
    // Secondary screen rendering is handled by the Flutter UI layer
  }

  /// Send text to pole display via serial port
  Future<void> _sendToPoleDisplay(String line1, String line2) async {
    try {
      final width = _config.lineWidth;
      final paddedLine1 = line1.padRight(width).substring(0, width);
      final paddedLine2 = line2.padRight(width).substring(0, width);

      // Bytes would be sent via serial port in production
      final _ = <int>[
        ...VfdCommands.clearScreen,
        ...VfdCommands.setCursor(0, 0),
        ...paddedLine1.codeUnits,
        ...VfdCommands.setCursor(1, 0),
        ...paddedLine2.codeUnits,
      ];

      // In production, send via flutter_libserialport
      debugPrint('CustomerDisplay: $paddedLine1 | $paddedLine2');
    } catch (e) {
      debugPrint('CustomerDisplayService error: $e');
    }
  }

  /// Test the display
  Future<bool> test() async {
    if (!_isConnected) {
      final connected = await connect();
      if (!connected) return false;
    }
    await displayLines('DISPLAY TEST', 'OK');
    await Future.delayed(const Duration(seconds: 2));
    await showIdle();
    return true;
  }

  void dispose() {
    disconnect();
  }
}
