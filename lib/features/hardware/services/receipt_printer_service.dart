import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

/// ESC/POS command constants
class EscPos {
  static const List<int> init = [0x1B, 0x40]; // ESC @
  static const List<int> cut = [0x1D, 0x56, 0x00]; // GS V 0 (full cut)
  static const List<int> partialCut = [0x1D, 0x56, 0x01]; // GS V 1
  static const List<int> feedAndCut = [0x1D, 0x56, 0x42, 0x00]; // GS V B 0
  static const List<int> lineFeed = [0x0A]; // LF
  static const List<int> alignLeft = [0x1B, 0x61, 0x00]; // ESC a 0
  static const List<int> alignCenter = [0x1B, 0x61, 0x01]; // ESC a 1
  static const List<int> alignRight = [0x1B, 0x61, 0x02]; // ESC a 2
  static const List<int> boldOn = [0x1B, 0x45, 0x01]; // ESC E 1
  static const List<int> boldOff = [0x1B, 0x45, 0x00]; // ESC E 0
  static const List<int> underlineOn = [0x1B, 0x2D, 0x01]; // ESC - 1
  static const List<int> underlineOff = [0x1B, 0x2D, 0x00]; // ESC - 0
  static const List<int> doubleSizeOn = [0x1D, 0x21, 0x11]; // GS ! 0x11
  static const List<int> doubleSizeOff = [0x1D, 0x21, 0x00]; // GS ! 0x00
  static const List<int> doubleWidthOn = [0x1D, 0x21, 0x10]; // GS ! 0x10
  static const List<int> doubleHeightOn = [0x1D, 0x21, 0x01]; // GS ! 0x01

  // Cash drawer kick
  static const List<int> drawerKickPin2 = [0x1B, 0x70, 0x00, 0x19, 0xFA];
  static const List<int> drawerKickPin5 = [0x1B, 0x70, 0x01, 0x19, 0xFA];

  // Barcode commands
  static List<int> barcodeCode128(String data) {
    return [
      0x1D, 0x6B, 0x49, // GS k 73 (Code128)
      data.length + 2,
      0x7B, 0x42, // {B (Code set B)
      ...data.codeUnits,
    ];
  }

  // QR Code commands
  static List<int> qrCode(String data, {int moduleSize = 4, int errorCorrection = 48}) {
    final dataBytes = data.codeUnits;
    final storeLen = dataBytes.length + 3;
    final pL = storeLen % 256;
    final pH = storeLen ~/ 256;
    return [
      // Set QR model
      0x1D, 0x28, 0x6B, 0x04, 0x00, 0x31, 0x41, 0x32, 0x00,
      // Set module size
      0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x43, moduleSize,
      // Set error correction
      0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, errorCorrection,
      // Store data
      0x1D, 0x28, 0x6B, pL, pH, 0x31, 0x50, 0x30, ...dataBytes,
      // Print QR code
      0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30,
    ];
  }
}

/// Print density levels
enum PrintDensity {
  light,
  normal,
  dark;

  List<int> get escPosCommand {
    return switch (this) {
      PrintDensity.light => [0x1D, 0x7C, 0x02],
      PrintDensity.normal => [0x1D, 0x7C, 0x04],
      PrintDensity.dark => [0x1D, 0x7C, 0x07],
    };
  }
}

/// Paper widths
enum PaperWidth {
  mm58(32),
  mm80(48);

  const PaperWidth(this.charsPerLine);
  final int charsPerLine;
}

/// Alignment for text
enum PrintAlignment {
  left,
  center,
  right;

  List<int> get escPosCommand {
    return switch (this) {
      PrintAlignment.left => EscPos.alignLeft,
      PrintAlignment.center => EscPos.alignCenter,
      PrintAlignment.right => EscPos.alignRight,
    };
  }
}

/// Represents a single line or command in a receipt
class ReceiptLine {
  final String? text;
  final PrintAlignment alignment;
  final bool bold;
  final bool underline;
  final bool doubleSize;
  final bool doubleWidth;
  final bool doubleHeight;
  final String? barcode;
  final String? qrCode;
  final int feedLines;
  final bool separator;
  final String? leftText;
  final String? rightText;

  const ReceiptLine({
    this.text,
    this.alignment = PrintAlignment.left,
    this.bold = false,
    this.underline = false,
    this.doubleSize = false,
    this.doubleWidth = false,
    this.doubleHeight = false,
    this.barcode,
    this.qrCode,
    this.feedLines = 0,
    this.separator = false,
    this.leftText,
    this.rightText,
  });

  factory ReceiptLine.text(
    String text, {
    PrintAlignment alignment = PrintAlignment.left,
    bool bold = false,
    bool underline = false,
    bool doubleSize = false,
  }) {
    return ReceiptLine(text: text, alignment: alignment, bold: bold, underline: underline, doubleSize: doubleSize);
  }

  factory ReceiptLine.twoColumn(String left, String right, {bool bold = false}) {
    return ReceiptLine(leftText: left, rightText: right, bold: bold);
  }

  factory ReceiptLine.separator({String char = '-'}) {
    return ReceiptLine(separator: true, text: char);
  }

  factory ReceiptLine.feed([int lines = 1]) {
    return ReceiptLine(feedLines: lines);
  }

  factory ReceiptLine.barcodeLine(String data) {
    return ReceiptLine(barcode: data);
  }

  factory ReceiptLine.qr(String data) {
    return ReceiptLine(qrCode: data);
  }
}

/// Printer configuration data
class PrinterConfig {
  final String connectionType; // usb, network, bluetooth
  final String? ipAddress;
  final int port;
  final String? usbDevicePath;
  final PaperWidth paperWidth;
  final bool autoCut;
  final PrintDensity density;
  final String? model;

  const PrinterConfig({
    required this.connectionType,
    this.ipAddress,
    this.port = 9100,
    this.usbDevicePath,
    this.paperWidth = PaperWidth.mm80,
    this.autoCut = true,
    this.density = PrintDensity.normal,
    this.model,
  });

  factory PrinterConfig.fromJson(Map<String, dynamic> json) {
    return PrinterConfig(
      connectionType: json['connection_type'] as String? ?? 'network',
      ipAddress: json['ip'] as String? ?? json['ip_address'] as String?,
      port: json['port'] as int? ?? 9100,
      usbDevicePath: json['usb_device_path'] as String?,
      paperWidth: json['paper_width'] == 58 ? PaperWidth.mm58 : PaperWidth.mm80,
      autoCut: json['auto_cut'] as bool? ?? true,
      density: PrintDensity.values.firstWhere(
        (d) => d.name == (json['density'] as String? ?? 'normal'),
        orElse: () => PrintDensity.normal,
      ),
      model: json['model'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'connection_type': connectionType,
    'ip': ipAddress,
    'port': port,
    'usb_device_path': usbDevicePath,
    'paper_width': paperWidth == PaperWidth.mm58 ? 58 : 80,
    'auto_cut': autoCut,
    'density': density.name,
    'model': model,
  };
}

/// Receipt printer service — handles ESC/POS command generation and network/USB printing
class ReceiptPrinterService {
  PrinterConfig? _config;
  Socket? _socket;
  bool _isConnected = false;

  PrinterConfig? get config => _config;
  bool get isConnected => _isConnected;

  void configure(PrinterConfig config) {
    _config = config;
  }

  /// Connect to the printer
  Future<bool> connect() async {
    if (_config == null) return false;

    try {
      if (_config!.connectionType == 'network') {
        if (_config!.ipAddress == null || _config!.ipAddress!.isEmpty) return false;
        _socket = await Socket.connect(_config!.ipAddress!, _config!.port, timeout: const Duration(seconds: 5));
        _isConnected = true;
        return true;
      }
      // USB printing uses raw print spooler — handled separately
      return true;
    } catch (e) {
      debugPrint('ReceiptPrinterService connect error: $e');
      _isConnected = false;
      return false;
    }
  }

  /// Disconnect from the printer
  Future<void> disconnect() async {
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
    _isConnected = false;
  }

  /// Generate ESC/POS bytes from receipt lines
  Uint8List buildReceipt(List<ReceiptLine> lines) {
    final bytes = <int>[];
    final charsPerLine = _config?.paperWidth.charsPerLine ?? 48;

    // Initialize printer
    bytes.addAll(EscPos.init);

    // Set density
    if (_config != null) {
      bytes.addAll(_config!.density.escPosCommand);
    }

    for (final line in lines) {
      // Separator
      if (line.separator) {
        final char = line.text ?? '-';
        bytes.addAll(EscPos.alignLeft);
        bytes.addAll((char * charsPerLine).codeUnits);
        bytes.addAll(EscPos.lineFeed);
        continue;
      }

      // Feed lines
      if (line.feedLines > 0) {
        for (int i = 0; i < line.feedLines; i++) {
          bytes.addAll(EscPos.lineFeed);
        }
        continue;
      }

      // Two-column text
      if (line.leftText != null && line.rightText != null) {
        if (line.bold) bytes.addAll(EscPos.boldOn);
        bytes.addAll(EscPos.alignLeft);

        final left = line.leftText!;
        final right = line.rightText!;
        final spaces = charsPerLine - left.length - right.length;
        final padded = left + (' ' * (spaces > 0 ? spaces : 1)) + right;
        bytes.addAll(padded.codeUnits);
        bytes.addAll(EscPos.lineFeed);

        if (line.bold) bytes.addAll(EscPos.boldOff);
        continue;
      }

      // Barcode
      if (line.barcode != null) {
        bytes.addAll(EscPos.alignCenter);
        bytes.addAll(EscPos.barcodeCode128(line.barcode!));
        bytes.addAll(EscPos.lineFeed);
        continue;
      }

      // QR Code
      if (line.qrCode != null) {
        bytes.addAll(EscPos.alignCenter);
        bytes.addAll(EscPos.qrCode(line.qrCode!));
        bytes.addAll(EscPos.lineFeed);
        continue;
      }

      // Regular text
      if (line.text != null) {
        bytes.addAll(line.alignment.escPosCommand);
        if (line.bold) bytes.addAll(EscPos.boldOn);
        if (line.underline) bytes.addAll(EscPos.underlineOn);
        if (line.doubleSize) bytes.addAll(EscPos.doubleSizeOn);
        if (line.doubleWidth) bytes.addAll(EscPos.doubleWidthOn);
        if (line.doubleHeight) bytes.addAll(EscPos.doubleHeightOn);

        bytes.addAll(line.text!.codeUnits);
        bytes.addAll(EscPos.lineFeed);

        if (line.doubleSize || line.doubleWidth || line.doubleHeight) {
          bytes.addAll(EscPos.doubleSizeOff);
        }
        if (line.underline) bytes.addAll(EscPos.underlineOff);
        if (line.bold) bytes.addAll(EscPos.boldOff);
      }
    }

    // Feed and cut
    bytes.addAll(EscPos.lineFeed);
    bytes.addAll(EscPos.lineFeed);
    bytes.addAll(EscPos.lineFeed);
    if (_config?.autoCut ?? true) {
      bytes.addAll(EscPos.feedAndCut);
    }

    return Uint8List.fromList(bytes);
  }

  /// Send raw bytes to the printer
  Future<bool> sendBytes(Uint8List data) async {
    if (_config == null) return false;

    try {
      if (_config!.connectionType == 'network') {
        final socket = await Socket.connect(_config!.ipAddress!, _config!.port, timeout: const Duration(seconds: 5));
        socket.add(data);
        await socket.flush();
        await socket.close();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('ReceiptPrinterService sendBytes error: $e');
      return false;
    }
  }

  /// Print receipt from lines
  Future<bool> printReceipt(List<ReceiptLine> lines) async {
    final data = buildReceipt(lines);
    return sendBytes(data);
  }

  /// Print a test page
  Future<bool> printTestPage() async {
    final lines = <ReceiptLine>[
      ReceiptLine.text('PRINTER TEST', alignment: PrintAlignment.center, bold: true, doubleSize: true),
      ReceiptLine.feed(),
      ReceiptLine.separator(),
      ReceiptLine.text('Wameed POS System', alignment: PrintAlignment.center),
      ReceiptLine.text('Printer Test Page', alignment: PrintAlignment.center),
      ReceiptLine.separator(),
      ReceiptLine.twoColumn('Left aligned', 'Right aligned'),
      ReceiptLine.text('Bold text', bold: true),
      ReceiptLine.text('Underlined text', underline: true),
      ReceiptLine.text('Double size', doubleSize: true),
      ReceiptLine.separator(),
      ReceiptLine.text('Arabic: اختبار الطباعة', alignment: PrintAlignment.right),
      ReceiptLine.separator(),
      ReceiptLine.barcodeLine('1234567890128'),
      ReceiptLine.feed(),
      ReceiptLine.qr('https://wameed.sa'),
      ReceiptLine.feed(),
      ReceiptLine.separator(),
      ReceiptLine.text(DateTime.now().toString(), alignment: PrintAlignment.center),
      ReceiptLine.text('Test Complete', alignment: PrintAlignment.center, bold: true),
      ReceiptLine.feed(3),
    ];
    return printReceipt(lines);
  }

  /// Open cash drawer via printer kick pulse
  Future<bool> openCashDrawer({int pin = 0}) async {
    final kickCommand = pin == 0 ? EscPos.drawerKickPin2 : EscPos.drawerKickPin5;
    return sendBytes(Uint8List.fromList(kickCommand));
  }
}
