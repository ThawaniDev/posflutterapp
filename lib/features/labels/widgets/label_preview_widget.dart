import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';

/// Renders a real visual preview of a label template at a chosen pixel scale.
///
/// Reads `template.layoutJson['elements']` and lays each element out at its
/// configured (x, y, width, height) in millimetres. Recognised element types:
/// barcode, qr_code, product_name, price, sku, custom_text, expiry_date,
/// weight, separator, logo.
///
/// Pass [data] to fill in dynamic fields (product name, price, barcode value).
/// When [data] is null, demo placeholder values are shown.
class LabelPreviewWidget extends StatelessWidget {
  const LabelPreviewWidget({
    super.key,
    required this.template,
    this.data,
    this.scale = 4.0,
    this.background = Colors.white,
    this.showBorder = true,
  });

  final LabelTemplate template;
  final LabelPreviewData? data;
  final double scale;
  final Color background;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final widthPx = template.labelWidthMm * scale;
    final heightPx = template.labelHeightMm * scale;
    final elements = (template.layoutJson['elements'] as List?)?.cast<dynamic>() ?? const [];
    final preview = data ?? const LabelPreviewData.demo();

    return Container(
      width: widthPx,
      height: heightPx,
      decoration: BoxDecoration(
        color: background,
        border: showBorder ? Border.all(color: Colors.grey.shade400) : null,
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          for (final raw in elements) _LabelElementView(element: raw as Map<String, dynamic>, data: preview, scale: scale),
        ],
      ),
    );
  }
}

/// Dynamic data substituted into label elements during preview & print.
class LabelPreviewData {
  const LabelPreviewData({
    required this.productName,
    required this.productNameAr,
    required this.barcode,
    required this.price,
    required this.currency,
    this.sku,
    this.expiryDate,
    this.weight,
  });

  const LabelPreviewData.demo()
    : productName = 'Product Name',
      productNameAr = 'اسم المنتج',
      barcode = '1234567890128',
      price = 9.999,
      currency = '\u0081',
      sku = 'SKU-001',
      expiryDate = null,
      weight = null;

  final String productName;
  final String productNameAr;
  final String barcode;
  final double price;
  final String currency;
  final String? sku;
  final String? expiryDate;
  final String? weight;
}

class _LabelElementView extends StatelessWidget {
  const _LabelElementView({required this.element, required this.data, required this.scale});

  final Map<String, dynamic> element;
  final LabelPreviewData data;
  final double scale;

  double _toDouble(Object? v, double fallback) {
    if (v == null) return fallback;
    return double.tryParse(v.toString()) ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    final type = (element['type'] as String?) ?? 'custom_text';
    final x = _toDouble(element['x'], 0);
    final y = _toDouble(element['y'], 0);
    final width = _toDouble(element['width'], 20);
    final height = _toDouble(element['height'], 6);
    final config = (element['config'] as Map?)?.cast<String, dynamic>() ?? const {};

    return Positioned(
      left: x * scale,
      top: y * scale,
      width: width * scale,
      height: height * scale,
      child: _buildElement(type, config),
    );
  }

  Widget _buildElement(String type, Map<String, dynamic> config) {
    switch (type) {
      case 'barcode':
        return _BarcodeRenderer(
          value: data.barcode,
          format: (config['format'] as String?) ?? 'code128',
          showText: (config['show_text'] as bool?) ?? true,
        );
      case 'qr_code':
        return _BarcodeRenderer(value: data.barcode, format: 'qr');
      case 'product_name':
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            (config['use_arabic'] as bool? ?? false) ? data.productNameAr : data.productName,
            style: TextStyle(fontSize: _toDouble(config['font_size'], 10), fontWeight: FontWeight.w600, color: Colors.black),
          ),
        );
      case 'price':
        final showCurrency = config['show_currency'] as bool? ?? true;
        final priceText = data.price.toStringAsFixed(3);
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            showCurrency ? '$priceText ${data.currency}' : priceText,
            style: TextStyle(fontSize: _toDouble(config['font_size'], 12), fontWeight: FontWeight.bold, color: Colors.black),
          ),
        );
      case 'sku':
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('SKU: ${data.sku ?? '-'}', style: const TextStyle(fontSize: 8, color: Colors.black87)),
        );
      case 'custom_text':
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            (config['text'] as String?) ?? '',
            style: TextStyle(fontSize: _toDouble(config['font_size'], 9), color: Colors.black87),
          ),
        );
      case 'expiry_date':
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('EXP: ${data.expiryDate ?? '--/--/--'}', style: const TextStyle(fontSize: 8, color: Colors.black87)),
        );
      case 'weight':
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(data.weight ?? '0.000 kg', style: const TextStyle(fontSize: 8, color: Colors.black87)),
        );
      case 'separator':
        return const Divider(color: Colors.black54, thickness: 0.5, height: 0.5);
      case 'logo':
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_outlined, size: 14, color: Colors.black45),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _BarcodeRenderer extends StatelessWidget {
  const _BarcodeRenderer({required this.value, required this.format, this.showText = true});

  final String value;
  final String format;
  final bool showText;

  Barcode _resolveBarcode() {
    switch (format) {
      case 'ean13':
        return Barcode.ean13();
      case 'ean8':
        return Barcode.ean8();
      case 'upc_a':
        return Barcode.upcA();
      case 'code39':
        return Barcode.code39();
      case 'itf':
        return Barcode.itf();
      case 'qr':
        return Barcode.qrCode();
      case 'code128':
      default:
        return Barcode.code128();
    }
  }

  @override
  Widget build(BuildContext context) {
    final barcode = _resolveBarcode();
    return CustomPaint(
      painter: _BarcodePainter(barcode: barcode, value: value, showText: showText),
      child: const SizedBox.expand(),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  _BarcodePainter({required this.barcode, required this.value, required this.showText});

  final Barcode barcode;
  final String value;
  final bool showText;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    try {
      final ops = barcode.make(value, width: size.width, height: showText ? size.height * 0.8 : size.height, drawText: false);
      for (final op in ops) {
        if (op is BarcodeBar && op.black) {
          canvas.drawRect(Rect.fromLTWH(op.left, op.top, op.width, op.height), paint);
        }
      }
      if (showText && size.height > 12) {
        final tp = TextPainter(
          text: TextSpan(
            text: value,
            style: const TextStyle(fontSize: 8, color: Colors.black),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        tp.layout(maxWidth: size.width);
        tp.paint(canvas, Offset((size.width - tp.width) / 2, size.height - tp.height));
      }
    } catch (_) {
      // Invalid value for this symbology — render placeholder bars
      final placeholder = Paint()..color = Colors.grey.shade400;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), placeholder);
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.barcode.name != barcode.name;
}
