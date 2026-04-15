import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';

class InvoiceOcrPage extends ConsumerStatefulWidget {
  const InvoiceOcrPage({super.key});

  @override
  ConsumerState<InvoiceOcrPage> createState() => _InvoiceOcrPageState();
}

class _InvoiceOcrPageState extends ConsumerState<InvoiceOcrPage> {
  XFile? _selectedImage;
  bool _isProcessing = false;
  String? _imageSizeLabel;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, maxWidth: 2048, maxHeight: 2048, imageQuality: 85);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    final sizeKB = bytes.length / 1024;
    final sizeLabel = sizeKB > 1024 ? '${(sizeKB / 1024).toStringAsFixed(1)} MB' : '${sizeKB.toStringAsFixed(0)} KB';

    setState(() {
      _selectedImage = image;
      _imageSizeLabel = sizeLabel;
    });
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;
    setState(() => _isProcessing = true);
    try {
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      ref.read(aiFeatureResultProvider.notifier).invoke('invoice_ocr', params: {'image': base64Image});
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _imageSizeLabel = null;
    });
    ref.read(aiFeatureResultProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiFeatureResultProvider);
    final isMobile = context.isPhone;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.document_scanner_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.wameedAIInvoiceOCR),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Image Upload Zone ───────────────────────────────
            if (_selectedImage == null) _buildUploadZone(l10n, isDark) else _buildImagePreview(l10n, isMobile, isDark),

            const SizedBox(height: 20),

            // ─── Process Button ──────────────────────────────────
            if (_selectedImage != null && state is! AIFeatureResultLoading)
              SizedBox(
                width: double.infinity,
                child: PosButton(
                  label: state is AIFeatureResultLoaded ? l10n.wameedAIRescanInvoice : l10n.wameedAIExtractData,
                  icon: state is AIFeatureResultLoaded ? Icons.refresh : Icons.auto_awesome,
                  onPressed: _isProcessing ? null : _processImage,
                ),
              ),

            const SizedBox(height: 24),

            // ─── Results ─────────────────────────────────────────
            switch (state) {
              AIFeatureResultInitial() =>
                _selectedImage == null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 56,
                                color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.wameedAIUploadInvoicePrompt,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              AIFeatureResultLoading() => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      SizedBox(width: 56, height: 56, child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary)),
                      const SizedBox(height: 20),
                      Text(
                        l10n.wameedAIProcessingInvoice,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.wameedAIOCRProcessingHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              AIFeatureResultError(:final message) => Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(message, style: const TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: PosButton(label: l10n.commonRetry, icon: Icons.refresh, onPressed: _processImage),
                  ),
                ],
              ),
              AIFeatureResultLoaded(:final result) => _buildOcrResults(result.data, isMobile, l10n),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildUploadZone(AppLocalizations l10n, bool isDark) {
    return GestureDetector(
      onTap: () => _showImageSourceSheet(l10n),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.add_a_photo_outlined, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.wameedAISelectInvoiceImage,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.wameedAIUploadInvoicePrompt,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSourceChip(Icons.camera_alt, l10n.wameedAICamera, () => _pickImage(ImageSource.camera)),
                const SizedBox(width: 16),
                _buildSourceChip(Icons.photo_library, l10n.wameedAIGallery, () => _pickImage(ImageSource.gallery)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceChip(IconData icon, String label, VoidCallback onTap) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(AppLocalizations l10n, bool isMobile, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Image preview with constrained height
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: isMobile ? 250 : 350),
              child: Image.file(File(_selectedImage!.path), width: double.infinity, fit: BoxFit.contain),
            ),
          ),
          // Image info bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.wameedAIImageSelected,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${_selectedImage!.name}${_imageSizeLabel != null ? ' · $_imageSizeLabel' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Change image button
                IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 20),
                  tooltip: l10n.wameedAIChangeImage,
                  onPressed: () => _showImageSourceSheet(l10n),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: 8),
                // Remove image button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: l10n.wameedAIRemoveImage,
                  onPressed: _clearImage,
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.error,
                    backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceSheet(AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(ctx).hintColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.wameedAISelectInvoiceImage,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.primary),
                ),
                title: Text(l10n.wameedAICamera),
                subtitle: Text(l10n.wameedAICameraTakePhoto),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, color: AppColors.info),
                ),
                title: Text(l10n.wameedAIGallery),
                subtitle: Text(l10n.wameedAIGallerySelectPhoto),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOcrResults(Map<String, dynamic>? data, bool isMobile, AppLocalizations l10n) {
    if (data == null) return const SizedBox.shrink();

    final vendor = data['vendor'] ?? data['supplier'] ?? {};
    // Backend returns 'items' from AI, fallback to 'line_items'
    final lineItems =
        (data['items'] as List?)?.cast<Map<String, dynamic>>() ??
        (data['line_items'] as List?)?.cast<Map<String, dynamic>>() ??
        [];
    // Backend returns totals as flat keys at root, or nested in 'totals'
    final totals = data['totals'] as Map<String, dynamic>? ?? <String, dynamic>{};
    // If totals is empty, construct from flat root keys
    final effectiveTotals = totals.isNotEmpty
        ? totals
        : <String, dynamic>{
            if (data['subtotal'] != null) 'subtotal': data['subtotal'],
            if (data['tax'] != null) 'tax': data['tax'],
            if (data['discount'] != null) 'discount': data['discount'],
            if (data['total'] != null) 'total': data['total'],
          };
    final invoiceNumber = data['invoice_number'] ?? data['number'] ?? '';
    final invoiceDate = data['invoice_date'] ?? data['date'] ?? '';
    final currency = data['currency']?.toString() ?? '\$';
    final notes = data['notes']?.toString() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Invoice header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.wameedAIInvoiceExtracted,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
                  ),
                ],
              ),
              const Divider(height: 20),
              if (invoiceNumber.toString().isNotEmpty) _kvRow(l10n.wameedAIInvoiceNumber, invoiceNumber.toString()),
              if (invoiceDate.toString().isNotEmpty) _kvRow(l10n.wameedAIInvoiceDate, invoiceDate.toString()),
              if (vendor is Map) ...[
                if (vendor['name'] != null) _kvRow(l10n.wameedAIVendor, vendor['name'].toString()),
                if (vendor['phone'] != null) _kvRow(l10n.wameedAIPhone, vendor['phone'].toString()),
              ],
            ],
          ),
        ),

        // Line items
        if (lineItems.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.wameedAILineItems, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              children: [
                // Header row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          l10n.wameedAIProduct,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.wameedAIQty,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.wameedAIPrice,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.wameedAITotal,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                ...lineItems.asMap().entries.map((entry) {
                  final item = entry.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item['name']?.toString() ?? item['description']?.toString() ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${item['quantity'] ?? item['qty'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '\$${item['unit_price'] ?? item['price'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '\$${item['total'] ?? item['line_total'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],

        // Totals
        if (effectiveTotals.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              children: [
                if (effectiveTotals['subtotal'] != null) _kvRow(l10n.wameedAISubtotal, '$currency${effectiveTotals['subtotal']}'),
                if (effectiveTotals['tax'] != null) _kvRow(l10n.wameedAITax, '$currency${effectiveTotals['tax']}'),
                if (effectiveTotals['discount'] != null)
                  _kvRow(l10n.wameedAIDiscount, '-$currency${effectiveTotals['discount']}'),
                const Divider(height: 16),
                _kvRow(
                  l10n.wameedAIGrandTotal,
                  '$currency${effectiveTotals['total'] ?? effectiveTotals['grand_total'] ?? 'N/A'}',
                  isBold: true,
                ),
              ],
            ),
          ),
        ],

        // Notes
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.note_outlined, size: 16, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(child: Text(notes, style: Theme.of(context).textTheme.bodySmall)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _kvRow(String key, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isBold ? null : Theme.of(context).hintColor,
              fontWeight: isBold ? FontWeight.w700 : null,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: isBold ? FontWeight.w800 : FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
