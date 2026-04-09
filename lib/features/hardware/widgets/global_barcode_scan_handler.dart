import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/widgets/pos_dialog.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/hardware/providers/hardware_providers.dart';
import 'package:thawani_pos/features/hardware/services/barcode_scanner_service.dart';
import 'package:thawani_pos/features/hardware/widgets/barcode_product_popup.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_providers.dart';

/// Global barcode scan handler that listens for barcode scans across the entire app.
///
/// When a barcode is scanned (via keyboard-wedge HID or DataWedge PDA):
/// - Looks up the product by barcode
/// - If on the POS cashier page: adds to cart directly + shows success snackbar
/// - Otherwise: shows a detailed product popup with actions
/// - If product not found: offers to create a new product with the barcode pre-filled
class GlobalBarcodeScanHandler extends ConsumerStatefulWidget {
  const GlobalBarcodeScanHandler({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<GlobalBarcodeScanHandler> createState() => _GlobalBarcodeScanHandlerState();
}

class _GlobalBarcodeScanHandlerState extends ConsumerState<GlobalBarcodeScanHandler> {
  StreamSubscription<BarcodeScanResult>? _scanSubscription;
  bool _isProcessing = false;
  final FocusNode _focusNode = FocusNode(debugLabel: 'GlobalBarcodeScanHandler');

  @override
  void initState() {
    super.initState();
    // Start the barcode scanner immediately — no need to wait for a frame
    _startListening();
  }

  void _startListening() {
    final hardwareManager = ref.read(hardwareManagerProvider);
    final scanner = hardwareManager.barcodeScanner;

    // Start the scanner if not already listening
    if (!scanner.isListening) {
      scanner.startListening();
    }

    // Subscribe to barcode scan stream
    _scanSubscription?.cancel();
    _scanSubscription = scanner.onScan.listen(_onBarcodeScanned);
    debugPrint('GlobalBarcodeScanHandler: Listening for barcode scans (web: $kIsWeb, isListening: ${scanner.isListening})');
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeScanned(BarcodeScanResult scanResult) async {
    // Prevent concurrent processing
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final barcode = scanResult.barcode;
      debugPrint('GlobalBarcodeScanHandler: Processing barcode "$barcode" from ${scanResult.source}');

      // Check if we're on the POS cashier page
      final currentRoute = GoRouterState.of(context).matchedLocation;
      final isOnPosCashier = currentRoute == Routes.pos || currentRoute == Routes.posCheckout;

      // Look up product by barcode
      final product = await ref.read(posProductsProvider.notifier).findByBarcode(barcode);

      if (!mounted) return;

      if (isOnPosCashier && product != null) {
        // On POS cashier: add to cart directly (the cashier page handles its own scan)
        // Don't show popup — let the cashier page's own handler deal with it
        return;
      }

      // Show the product popup
      final action = await showBarcodeProductPopup(context, barcode: barcode, product: product);

      if (!mounted || action == null) return;

      _handlePopupAction(action, barcode, product);
    } finally {
      _isProcessing = false;
    }
  }

  void _handlePopupAction(BarcodePopupAction action, String barcode, Product? product) {
    switch (action) {
      case BarcodePopupAction.addToCart:
        if (product != null) {
          ref.read(cartProvider.notifier).addProduct(product);
          showPosSuccessSnackbar(context, '${product.name} added to cart');
        }
      case BarcodePopupAction.viewDetails:
        if (product != null) {
          context.go('${Routes.productsEdit}/${product.id}');
        }
      case BarcodePopupAction.editProduct:
        if (product != null) {
          context.go('${Routes.productsEdit}/${product.id}');
        }
      case BarcodePopupAction.addNewProduct:
        // Navigate to product creation with barcode pre-filled
        context.go('${Routes.productsAdd}?barcode=$barcode');
    }
  }

  @override
  Widget build(BuildContext context) {
    // On web, wrap in Focus to help maintain keyboard focus on the Flutter canvas.
    // HardwareKeyboard.instance.addHandler receives events only when Flutter has focus.
    if (kIsWeb) {
      return Focus(focusNode: _focusNode, autofocus: true, child: widget.child);
    }
    return widget.child;
  }
}
