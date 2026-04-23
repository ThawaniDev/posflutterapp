import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/services/label_printer_service.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';

/// Outcome of a quick-print attempt, surfaced to the UI for snackbars.
enum QuickPrintResult {
  /// Sent to the printer successfully and recorded.
  success,

  /// Server-side history was recorded but no physical printer is configured.
  noPrinter,

  /// No template is selected and no default exists.
  noTemplate,

  /// Printer command failed.
  printerError,
}

/// Generate a 13-digit weighable EAN-13 with a leading prefix.
///
/// Format: PP NNNNN WWWWW C
///   PP    = 2-digit prefix (e.g. 21 = weight in grams, 23 = price in fils)
///   NNNNN = product PLU (5 digits)
///   WWWWW = weight in grams or price in fractional units (5 digits)
///   C     = EAN-13 checksum
///
/// Returns the full 13-digit barcode.
String buildWeighableEan13({
  required int prefix,
  required int plu,
  required int payload,
}) {
  assert(prefix >= 0 && prefix <= 99, 'prefix must be a 1- or 2-digit number');
  final p = prefix.toString().padLeft(2, '0');
  final n = plu.toString().padLeft(5, '0');
  final w = payload.toString().padLeft(5, '0');
  if (p.length != 2) throw ArgumentError('prefix overflow: $prefix');
  if (n.length > 5) throw ArgumentError('plu overflow: $plu');
  if (w.length > 5) throw ArgumentError('payload overflow: $payload');
  final body = '$p${n.substring(n.length - 5)}${w.substring(w.length - 5)}';
  return '$body${_ean13Checksum(body)}';
}

String _ean13Checksum(String first12) {
  if (first12.length != 12) {
    throw ArgumentError('EAN-13 body must be exactly 12 digits, got "${first12.length}"');
  }
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    final d = int.parse(first12[i]);
    sum += i.isEven ? d : d * 3;
  }
  final mod = sum % 10;
  return (mod == 0 ? 0 : 10 - mod).toString();
}

/// Resolve the best label template for quick-printing.
/// Priority: explicit `templateId` → org's default template → first preset.
LabelTemplate? resolveQuickPrintTemplate(List<LabelTemplate> templates, {String? templateId}) {
  if (templates.isEmpty) return null;
  if (templateId != null) {
    for (final t in templates) {
      if (t.id == templateId) return t;
    }
  }
  for (final t in templates) {
    if (t.isDefault == true) return t;
  }
  for (final t in templates) {
    if (t.isPreset == true) return t;
  }
  return templates.first;
}

/// Quick-print labels for a single product using the default template and
/// the currently configured label printer. Always records server-side
/// history for audit, even when no physical printer is available.
Future<QuickPrintResult> quickPrintProductLabel(
  WidgetRef ref, {
  required Product product,
  required List<LabelTemplate> templates,
  int quantity = 1,
  String? templateId,
}) async {
  final template = resolveQuickPrintTemplate(templates, templateId: templateId);
  if (template == null) return QuickPrintResult.noTemplate;

  final printer = ref.read(hardwareManagerProvider).labelPrinter;
  final cfg = printer.config;
  final connected = (cfg.connectionType == 'network' && (cfg.ipAddress?.isNotEmpty ?? false)) ||
      (cfg.connectionType == 'usb' && (cfg.usbDevicePath?.isNotEmpty ?? false));

  bool printedOk = true;
  if (connected) {
    final data = ProductLabelData(
      nameAr: product.nameAr ?? product.name,
      nameEn: product.name,
      barcode: product.barcode ?? product.sku ?? product.id,
      price: product.sellPrice,
      sku: product.sku,
    );
    printedOk = await printer.printProductLabels(
      List<ProductLabelData>.filled(quantity, data),
    );
  }

  // Always record print history server-side.
  try {
    await ref.read(labelRepositoryProvider).recordPrint({
      'template_id': template.id,
      'printer_name': cfg.ipAddress ?? cfg.usbDevicePath ?? '',
      'product_count': 1,
      'total_labels': quantity,
    });
  } catch (_) {
    // Recording failure should not block the user — UI still surfaces print result.
  }

  if (!connected) return QuickPrintResult.noPrinter;
  return printedOk ? QuickPrintResult.success : QuickPrintResult.printerError;
}
