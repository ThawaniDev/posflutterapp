import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Label size in millimeters and dots
class LabelSize {

  const LabelSize({required this.widthMm, required this.heightMm, this.dpi = 203});
  final double widthMm;
  final double heightMm;
  final int dpi;

  int get widthDots => (widthMm * dpi / 25.4).round();
  int get heightDots => (heightMm * dpi / 25.4).round();

  static const LabelSize standard50x30 = LabelSize(widthMm: 50, heightMm: 30);
  static const LabelSize standard60x40 = LabelSize(widthMm: 60, heightMm: 40);
  static const LabelSize standard100x50 = LabelSize(widthMm: 100, heightMm: 50);
  static const LabelSize shelf50x25 = LabelSize(widthMm: 50, heightMm: 25);
  static const LabelSize jewelry40x20 = LabelSize(widthMm: 40, heightMm: 20);
}

/// Label printer configuration
class LabelPrinterConfig { // print speed 1-14

  const LabelPrinterConfig({
    this.connectionType = 'network',
    this.ipAddress,
    this.port = 9100,
    this.usbDevicePath,
    this.language = 'zpl',
    this.dpi = 203,
    this.labelWidthMm = 50,
    this.labelHeightMm = 30,
    this.gapMm = 3,
    this.darkness = 10,
    this.speed = 4,
  });

  factory LabelPrinterConfig.fromJson(Map<String, dynamic> json) {
    return LabelPrinterConfig(
      connectionType: json['connection_type'] as String? ?? 'network',
      ipAddress: json['ip'] as String? ?? json['ip_address'] as String?,
      port: json['port'] as int? ?? 9100,
      usbDevicePath: json['usb_device_path'] as String?,
      language: json['language'] as String? ?? 'zpl',
      dpi: json['dpi'] as int? ?? 203,
      labelWidthMm: (json['label_width_mm'] != null ? double.tryParse(json['label_width_mm'].toString()) : null) ?? 50,
      labelHeightMm: (json['label_height_mm'] != null ? double.tryParse(json['label_height_mm'].toString()) : null) ?? 30,
      gapMm: (json['gap_mm'] != null ? double.tryParse(json['gap_mm'].toString()) : null) ?? 3,
      darkness: json['darkness'] as int? ?? 10,
      speed: json['speed'] as int? ?? 4,
    );
  }
  final String connectionType; // usb, network
  final String? ipAddress;
  final int port;
  final String? usbDevicePath;
  final String language; // zpl, tspl, escpos
  final int dpi;
  final double labelWidthMm;
  final double labelHeightMm;
  final double gapMm;
  final int darkness; // 1-15 for ZPL, 1-15 for TSPL
  final int speed;

  Map<String, dynamic> toJson() => {
    'connection_type': connectionType,
    'ip': ipAddress,
    'port': port,
    'usb_device_path': usbDevicePath,
    'language': language,
    'dpi': dpi,
    'label_width_mm': labelWidthMm,
    'label_height_mm': labelHeightMm,
    'gap_mm': gapMm,
    'darkness': darkness,
    'speed': speed,
  };

  LabelSize get labelSize => LabelSize(widthMm: labelWidthMm, heightMm: labelHeightMm, dpi: dpi);
}

/// Label data for a product label
class ProductLabelData {

  const ProductLabelData({
    required this.nameAr,
    required this.nameEn,
    required this.barcode,
    required this.price,
    this.currency = '\u0081',
    this.originalPrice,
    this.sku,
    this.expiryDate,
    this.weight,
  });
  final String nameAr;
  final String nameEn;
  final String barcode;
  final double price;
  final String currency;
  final double? originalPrice;
  final String? sku;
  final String? expiryDate;
  final String? weight;
}

/// Label printer service — generates ZPL/TSPL/ESC/POS label commands and prints
class LabelPrinterService {
  LabelPrinterConfig _config = const LabelPrinterConfig();

  LabelPrinterConfig get config => _config;

  void configure(LabelPrinterConfig config) {
    _config = config;
  }

  /// Generate ZPL code for a product label
  String generateZPL(ProductLabelData data) {
    final size = _config.labelSize;
    final buf = StringBuffer();

    buf.writeln('^XA');
    buf.writeln('^PW${size.widthDots}');
    buf.writeln('^LL${size.heightDots}');
    buf.writeln('^MD${_config.darkness}');

    // Arabic name (top, right-aligned for Arabic)
    buf.writeln('^CF0,25');
    buf.writeln('^FO20,10^FD${data.nameAr}^FS');

    // English name
    buf.writeln('^CF0,18');
    buf.writeln('^FO20,40^FD${data.nameEn}^FS');

    // SKU if available
    if (data.sku != null) {
      buf.writeln('^CF0,14');
      buf.writeln('^FO20,62^FDSKU: ${data.sku}^FS');
    }

    // Barcode (Code128)
    buf.writeln('^BY2,2.5,45');
    buf.writeln('^FO20,${data.sku != null ? 80 : 65}^BC^FD${data.barcode}^FS');

    // Price
    final priceY = data.sku != null ? 140 : 125;
    if (data.originalPrice != null && data.originalPrice != data.price) {
      // Strikethrough original price
      buf.writeln('^CF0,18');
      buf.writeln('^FO20,$priceY^FD${data.currency} ${data.originalPrice!.toStringAsFixed(2)}^FS');
      buf.writeln('^CF0,24');
      buf.writeln('^FO${size.widthDots ~/ 2},$priceY^FD${data.currency} ${data.price.toStringAsFixed(2)}^FS');
    } else {
      buf.writeln('^CF0,24');
      buf.writeln('^FO20,$priceY^FD${data.currency} ${data.price.toStringAsFixed(2)}^FS');
    }

    // Expiry date if present
    if (data.expiryDate != null) {
      buf.writeln('^CF0,14');
      buf.writeln('^FO20,${priceY + 30}^FDEXP: ${data.expiryDate}^FS');
    }

    // Weight if present
    if (data.weight != null) {
      buf.writeln('^CF0,14');
      buf.writeln('^FO${size.widthDots ~/ 2},${priceY + 30}^FD${data.weight}^FS');
    }

    buf.writeln('^XZ');
    return buf.toString();
  }

  /// Generate TSPL code for a product label
  String generateTSPL(ProductLabelData data) {
    final buf = StringBuffer();

    buf.writeln('SIZE ${_config.labelWidthMm} mm, ${_config.labelHeightMm} mm');
    buf.writeln('GAP ${_config.gapMm} mm, 0 mm');
    buf.writeln('DIRECTION 1');
    buf.writeln('CLS');
    buf.writeln('DENSITY ${_config.darkness}');
    buf.writeln('SPEED ${_config.speed}');

    // Arabic name
    buf.writeln('TEXT 20,10,"4",0,1,1,"${data.nameAr}"');

    // English name
    buf.writeln('TEXT 20,40,"3",0,1,1,"${data.nameEn}"');

    // Barcode
    buf.writeln('BARCODE 20,70,"128",50,1,0,2,2,"${data.barcode}"');

    // Price
    buf.writeln('TEXT 20,135,"4",0,1,1,"${data.currency} ${data.price.toStringAsFixed(2)}"');

    buf.writeln('PRINT 1');
    return buf.toString();
  }

  /// Send label code to the printer
  Future<bool> printLabel(String labelCode, {int copies = 1}) async {
    try {
      if (_config.connectionType == 'network') {
        if (_config.ipAddress == null || _config.ipAddress!.isEmpty) return false;

        final socket = await Socket.connect(_config.ipAddress!, _config.port, timeout: const Duration(seconds: 5));

        for (int i = 0; i < copies; i++) {
          socket.write(labelCode);
        }

        await socket.flush();
        await socket.close();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('LabelPrinterService print error: $e');
      return false;
    }
  }

  /// Print product labels.
  ///
  /// When `connectionType == 'pdf'` (or `language == 'pdf'`), or when no
  /// USB / network endpoint is configured, the labels are rendered as a PDF
  /// and handed off to the system print dialog via the `printing` package
  /// (spec rule #7 — image-based fallback for non-ZPL/TSPL printers).
  Future<bool> printProductLabels(List<ProductLabelData> products, {int copies = 1}) async {
    final useFallback = _config.connectionType == 'pdf' ||
        _config.language == 'pdf' ||
        (_config.connectionType == 'network' && (_config.ipAddress == null || _config.ipAddress!.isEmpty)) ||
        (_config.connectionType == 'usb' && (_config.usbDevicePath == null || _config.usbDevicePath!.isEmpty));

    if (useFallback) {
      return printProductLabelsPdf(products, copies: copies);
    }
    final labelCodes = StringBuffer();
    for (final product in products) {
      final code = _config.language == 'tspl' ? generateTSPL(product) : generateZPL(product);
      labelCodes.writeln(code);
    }
    return printLabel(labelCodes.toString(), copies: copies);
  }

  /// PDF / raster fallback. Generates a multi-page PDF — one page per label
  /// — sized to the configured label dimensions, and shows the system print
  /// dialog. Useful for office printers that do not understand ZPL/TSPL.
  Future<bool> printProductLabelsPdf(List<ProductLabelData> products, {int copies = 1}) async {
    try {
      final bytes = await buildLabelsPdf(products, copies: copies);
      return Printing.layoutPdf(onLayout: (_) async => bytes);
    } catch (e) {
      debugPrint('LabelPrinterService PDF fallback error: $e');
      return false;
    }
  }

  /// Build a PDF document of all the labels (one per page) at the configured
  /// physical label size. Exposed for testing.
  Future<Uint8List> buildLabelsPdf(List<ProductLabelData> products, {int copies = 1}) async {
    final pageFormat = PdfPageFormat(
      _config.labelWidthMm * PdfPageFormat.mm,
      _config.labelHeightMm * PdfPageFormat.mm,
      marginAll: 0,
    );
    final doc = pw.Document();
    final code128 = Barcode.code128();

    for (final product in products) {
      for (var i = 0; i < copies; i++) {
        doc.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (ctx) => pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text(
                    product.nameAr,
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                    maxLines: 1,
                    overflow: pw.TextOverflow.clip,
                  ),
                  pw.Text(
                    product.nameEn,
                    style: const pw.TextStyle(fontSize: 8),
                    maxLines: 1,
                    overflow: pw.TextOverflow.clip,
                  ),
                  pw.SizedBox(height: 2),
                  pw.Expanded(
                    child: pw.BarcodeWidget(
                      data: product.barcode,
                      barcode: code128,
                      drawText: true,
                      textStyle: const pw.TextStyle(fontSize: 7),
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      if (product.sku != null)
                        pw.Text(product.sku!, style: const pw.TextStyle(fontSize: 6)),
                      pw.Text(
                        '${product.currency} ${product.price.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return doc.save();
  }

  /// Print a test label
  Future<bool> printTestLabel() async {
    const testData = ProductLabelData(
      nameAr: 'اختبار ملصق',
      nameEn: 'Test Label',
      barcode: '1234567890128',
      price: 9.99,
      currency: '\u0081',
      sku: 'TEST-001',
    );

    final code = _config.language == 'tspl' ? generateTSPL(testData) : generateZPL(testData);

    return printLabel(code);
  }
}
