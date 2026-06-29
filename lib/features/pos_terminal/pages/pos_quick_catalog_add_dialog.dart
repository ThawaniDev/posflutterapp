import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/repositories/catalog_repository.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';

/// Shows a lightweight "add product to catalog + cart" dialog from the POS
/// cashier page.
///
/// • Called from the top-bar "Add Product" button → [barcode] is null.
/// • Called from the barcode-not-found path       → [barcode] is pre-filled.
///
/// On confirm the product is created in the backend catalogue, then added to
/// the active cart immediately so the cashier doesn't have to scan again.
Future<bool> showPosQuickCatalogAddDialog(BuildContext context, WidgetRef ref, {String? barcode}) async {
  final barcodeCtrl = TextEditingController(text: barcode ?? '');
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final added = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _QuickCatalogAddDialog(
      formKey: formKey,
      barcodeCtrl: barcodeCtrl,
      nameCtrl: nameCtrl,
      priceCtrl: priceCtrl,
      hasPrefilledBarcode: barcode != null && barcode.isNotEmpty,
    ),
  );

  if (added != true) return false;

  final name = nameCtrl.text.trim();
  final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
  final bc = barcodeCtrl.text.trim();

  try {
    final data = <String, dynamic>{
      'name': name,
      'name_ar': name, // default to same; owner can edit later
      'sell_price': price,
      if (bc.isNotEmpty) 'barcode': bc,
      'is_active': true,
    };
    final created = await ref.read(catalogRepositoryProvider).createProduct(data);
    ref.read(cartProvider.notifier).addProduct(created);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.posProductAdded(created.name)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
      );
    }
    return false;
  } finally {
    barcodeCtrl.dispose();
    nameCtrl.dispose();
    priceCtrl.dispose();
  }
}

class _QuickCatalogAddDialog extends StatefulWidget {
  const _QuickCatalogAddDialog({
    required this.formKey,
    required this.barcodeCtrl,
    required this.nameCtrl,
    required this.priceCtrl,
    required this.hasPrefilledBarcode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController barcodeCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController priceCtrl;
  final bool hasPrefilledBarcode;

  @override
  State<_QuickCatalogAddDialog> createState() => _QuickCatalogAddDialogState();
}

class _QuickCatalogAddDialogState extends State<_QuickCatalogAddDialog> {
  bool _isLoading = false; // used when async save is triggered from the dialog itself

  void _submit() {
    if (!widget.formKey.currentState!.validate()) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                      child: const Icon(Icons.add_box_rounded, color: AppColors.primary, size: 22),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.posQuickAddProduct, style: AppTypography.titleMedium),
                          Text(
                            'Create product and add to cart',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context, false),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),

                AppSpacing.gapH20,

                // ── Barcode ──────────────────────────────────────────────────
                PosTextField(
                  controller: widget.barcodeCtrl,
                  label: 'Barcode',
                  hint: 'Scan or type barcode',
                  prefixIcon: Icons.qr_code_rounded,
                  // Show a "scanned" chip when pre-filled from a scan
                  suffix: widget.hasPrefilledBarcode
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Scanned',
                            style: AppTypography.micro.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                          ),
                        )
                      : null,
                ),

                AppSpacing.gapH12,

                // ── Product Name ─────────────────────────────────────────────
                PosTextField(
                  controller: widget.nameCtrl,
                  label: l10n.posOpenPriceName,
                  hint: 'Enter product name',
                  autofocus: true,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),

                AppSpacing.gapH12,

                // ── Price ────────────────────────────────────────────────────
                PosTextField(
                  controller: widget.priceCtrl,
                  label: l10n.posOpenPricePrice,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}'))],
                  prefixIcon: Icons.attach_money_rounded,
                  validator: (v) {
                    final parsed = double.tryParse(v ?? '');
                    if (parsed == null || parsed <= 0) return 'Enter a valid price';
                    return null;
                  },
                ),

                AppSpacing.gapH8,

                // Hint — owner can enrich the product later
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.info),
                    AppSpacing.gapW4,
                    Expanded(
                      child: Text(
                        'Product will be saved to your catalog. You can add more details later.',
                        style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
                      ),
                    ),
                  ],
                ),

                AppSpacing.gapH20,

                // ── Actions ──────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: PosButton(
                        label: l10n.commonCancel,
                        variant: PosButtonVariant.outline,
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosButton(
                        label: 'Add to Cart',
                        icon: Icons.add_shopping_cart_rounded,
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
