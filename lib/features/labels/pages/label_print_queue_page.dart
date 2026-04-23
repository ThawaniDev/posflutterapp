import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/services/label_printer_service.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/providers/label_providers.dart';
import 'package:wameedpos/features/labels/providers/label_state.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';
import 'package:wameedpos/features/labels/widgets/label_preview_widget.dart';
import 'package:wameedpos/features/labels/widgets/label_product_picker_sheet.dart';

/// The Label Print Queue page allows users to:
/// - Select a label template
/// - Choose products to print labels for
/// - Set quantities per product
/// - Configure printer settings (printer name, copies, page size)
/// - Preview labels before printing
/// - Submit the print job
class LabelPrintQueuePage extends ConsumerStatefulWidget {

  const LabelPrintQueuePage({super.key, this.templateId});
  final String? templateId;

  @override
  ConsumerState<LabelPrintQueuePage> createState() => _LabelPrintQueuePageState();
}

class _LabelPrintQueuePageState extends ConsumerState<LabelPrintQueuePage> {
  String? _selectedTemplateId;
  String _printerName = '';
  int _copies = 1;
  final List<_PrintQueueItem> _queueItems = [];
  final _searchController = TextEditingController();
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    _selectedTemplateId = widget.templateId;
    Future.microtask(() => ref.read(labelTemplatesProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(labelTemplatesProvider);
    final templates = state is LabelTemplatesLoaded ? state.templates : <LabelTemplate>[];

    return PosListPage(
      title: l10n.labelPrintQueue,
      showSearch: false,
      onBack: () => context.pop(),
      actions: [
        PosButton(
          label: l10n.labelPrint,
          icon: Icons.print_rounded,
          variant: PosButtonVariant.primary,
          size: PosButtonSize.sm,
          isLoading: _isPrinting,
          onPressed: _queueItems.isNotEmpty ? _handlePrint : null,
        ),
      ],
      child: context.isPhone
          ? _buildMobileBody(context, l10n, isDark, templates)
          : _buildDesktopBody(context, l10n, isDark, templates),
    );
  }

  Widget _buildMobileBody(BuildContext context, AppLocalizations l10n, bool isDark, List<LabelTemplate> templates) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          // Settings — stacked
          PosCard(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.labelPrintSettings,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),
                PosSearchableDropdown<String>(
                  hint: l10n.selectTemplate,
                  label: l10n.labelTemplate,
                  items: templates.map((t) => PosDropdownItem(value: t.id, label: t.name)).toList(),
                  selectedValue: _selectedTemplateId,
                  onChanged: (v) => setState(() => _selectedTemplateId = v),
                  showSearch: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _printerName,
                        decoration: InputDecoration(
                          labelText: l10n.labelPrinterName,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          prefixIcon: const Icon(Icons.print_rounded, size: 20),
                        ),
                        onChanged: (v) => _printerName = v,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: _copies.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.labelCopies,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (v) => _copies = int.tryParse(v) ?? 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Add products button
          PosCard(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosButton(
              label: l10n.labelsAddProductsToQueue,
              icon: Icons.add_rounded,
              variant: PosButtonVariant.soft,
              onPressed: _openProductPicker,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Queue list
          Expanded(
            child: PosCard(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(l10n.labelQueue, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      PosBadge(
                        label: l10n.labelsItemsWithCount(_queueItems.length.toString(), l10n.labelItems),
                        variant: PosBadgeVariant.primary,
                      ),
                      if (_queueItems.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded, size: 20),
                          onPressed: () => setState(() => _queueItems.clear()),
                        ),
                    ],
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: _queueItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.queue_rounded,
                                  size: 40,
                                  color: AppColors.mutedFor(context),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  l10n.labelEmptyQueue,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.mutedFor(context),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: _queueItems.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _queueItems[index];
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                                leading: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: AppRadius.borderSm,
                                  ),
                                  child: const Icon(Icons.inventory_2_rounded, size: 16, color: AppColors.primary),
                                ),
                                title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                subtitle: Text('SKU: ${item.sku}', style: const TextStyle(fontSize: 11)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, size: 18),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity > 1) _queueItems[index] = item.copyWith(quantity: item.quantity - 1);
                                        });
                                      },
                                    ),
                                    Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, size: 18),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () {
                                        setState(() {
                                          _queueItems[index] = item.copyWith(quantity: item.quantity + 1);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () => setState(() => _queueItems.removeAt(index)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Summary bar + preview button
          PosCard(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${l10n.labelTotalProducts}: ${_queueItems.length}', style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      '${l10n.labelTotalLabels}: ${_queueItems.fold<int>(0, (sum, i) => sum + i.quantity)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: PosButton(
                        icon: Icons.preview_rounded,
                        label: l10n.labelPreview,
                        variant: PosButtonVariant.outline,
                        onPressed: () => _showMobilePreviewSheet(context, l10n, isDark),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PosButton(
                        icon: Icons.print_rounded,
                        label: l10n.labelPrint,
                        isLoading: _isPrinting,
                        onPressed: _queueItems.isNotEmpty && !_isPrinting ? _handlePrint : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMobilePreviewSheet(BuildContext context, AppLocalizations l10n, bool isDark) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.labelPreview, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.md),
            Center(child: _buildPreviewSurface(templates: ref.read(labelTemplatesProvider) is LabelTemplatesLoaded ? (ref.read(labelTemplatesProvider) as LabelTemplatesLoaded).templates : <LabelTemplate>[])),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.primary.withValues(alpha: 0.05),
                borderRadius: AppRadius.borderMd,
              ),
              child: Column(
                children: [
                  _summaryRow(l10n.labelTotalProducts, '${_queueItems.length}'),
                  const SizedBox(height: AppSpacing.xs),
                  _summaryRow(l10n.labelTotalLabels, '${_queueItems.fold<int>(0, (sum, i) => sum + i.quantity)}'),
                  const SizedBox(height: AppSpacing.xs),
                  _summaryRow(l10n.labelCopies, '$_copies'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopBody(BuildContext context, AppLocalizations l10n, bool isDark, List<LabelTemplate> templates) {
    return Row(
      children: [
        // ─── Left: Print Settings + Queue ──────────────
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Template & printer selection
                PosCard(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.labelPrintSettings,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: PosSearchableDropdown<String>(
                              hint: l10n.selectTemplate,
                              label: l10n.labelTemplate,
                              items: templates.map((t) => PosDropdownItem(value: t.id, label: t.name)).toList(),
                              selectedValue: _selectedTemplateId,
                              onChanged: (v) => setState(() => _selectedTemplateId = v),
                              showSearch: true,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              initialValue: _printerName,
                              decoration: InputDecoration(
                                labelText: l10n.labelPrinterName,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                prefixIcon: const Icon(Icons.print_rounded, size: 20),
                              ),
                              onChanged: (v) => _printerName = v,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              initialValue: _copies.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: l10n.labelCopies,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              onChanged: (v) => _copies = int.tryParse(v) ?? 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.base),

                // Search to add products
                PosCard(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.labelAddProducts,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: PosButton(
                              label: l10n.labelsAddProductsToQueue,
                              icon: Icons.add_rounded,
                              variant: PosButtonVariant.soft,
                              onPressed: _openProductPicker,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.base),

                // Queue list
                Expanded(
                  child: PosCard(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              l10n.labelQueue,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            PosBadge(label: '${_queueItems.length} ${l10n.labelItems}', variant: PosBadgeVariant.primary),
                            if (_queueItems.isNotEmpty) ...[
                              const SizedBox(width: AppSpacing.sm),
                              PosButton(
                                label: l10n.labelClearAll,
                                variant: PosButtonVariant.ghost,
                                size: PosButtonSize.sm,
                                onPressed: () => setState(() => _queueItems.clear()),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Expanded(
                          child: _queueItems.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.queue_rounded,
                                        size: 48,
                                        color: AppColors.mutedFor(context),
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      Text(
                                        l10n.labelEmptyQueue,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.mutedFor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _queueItems.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = _queueItems[index];
                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                                      leading: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: AppRadius.borderMd,
                                        ),
                                        child: const Icon(Icons.inventory_2_rounded, size: 18, color: AppColors.primary),
                                      ),
                                      title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      subtitle: Text(l10n.labelsSkuLine(item.sku)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                                            onPressed: () {
                                              setState(() {
                                                if (item.quantity > 1) {
                                                  _queueItems[index] = item.copyWith(quantity: item.quantity - 1);
                                                }
                                              });
                                            },
                                          ),
                                          Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline, size: 20),
                                            onPressed: () {
                                              setState(() {
                                                _queueItems[index] = item.copyWith(quantity: item.quantity + 1);
                                              });
                                            },
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          IconButton(
                                            icon: const Icon(Icons.close, size: 18, color: AppColors.error),
                                            onPressed: () => setState(() => _queueItems.removeAt(index)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─── Right: Preview ────────────────────────────
        const SizedBox(width: AppSpacing.base),
        SizedBox(
          width: 300,
          child: PosCard(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.labelPreview, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: Center(child: _buildPreviewSurface(templates: templates)),
                ),
                const SizedBox(height: AppSpacing.md),
                // Summary
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Column(
                    children: [
                      _summaryRow(l10n.labelTotalProducts, '${_queueItems.length}'),
                      const SizedBox(height: AppSpacing.xs),
                      _summaryRow(l10n.labelTotalLabels, '${_queueItems.fold<int>(0, (sum, i) => sum + i.quantity)}'),
                      const SizedBox(height: AppSpacing.xs),
                      _summaryRow(l10n.labelCopies, '$_copies'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  /// Render the live preview using the selected template and the first queued item.
  Widget _buildPreviewSurface({required List<LabelTemplate> templates}) {
    if (_selectedTemplateId == null || templates.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.labelSelectTemplate,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      );
    }
    LabelTemplate? template;
    for (final t in templates) {
      if (t.id == _selectedTemplateId) {
        template = t;
        break;
      }
    }
    if (template == null) return const SizedBox.shrink();

    final first = _queueItems.isEmpty ? null : _queueItems.first;
    final data = first == null
        ? const LabelPreviewData.demo()
        : LabelPreviewData(
            productName: first.productName,
            productNameAr: first.productNameAr,
            barcode: first.barcode,
            price: first.price,
            currency: '\u0081',
            sku: first.sku,
          );

    // Pick a scale that fits the side panel comfortably.
    const maxWidth = 240.0;
    final scale = (maxWidth / template.labelWidthMm).clamp(2.0, 8.0);
    return LabelPreviewWidget(template: template, data: data, scale: scale);
  }

  Future<void> _openProductPicker() async {
    final existing = _queueItems.map((i) => i.productId).toSet();
    final selections = await showLabelProductPickerSheet(context, excludeProductIds: existing);
    if (selections == null || selections.isEmpty) return;
    setState(() {
      for (final sel in selections) {
        _queueItems.add(
          _PrintQueueItem(
            productId: sel.product.id,
            productName: sel.product.name,
            productNameAr: sel.product.nameAr ?? sel.product.name,
            sku: sel.product.sku ?? '-',
            barcode: sel.product.barcode ?? sel.product.sku ?? sel.product.id,
            price: sel.product.sellPrice,
            quantity: sel.quantity,
          ),
        );
      }
      _searchController.clear();
    });
  }

  /// Resolve the configured label printer from hardware settings, or null when none.
  LabelPrinterConfig? _resolvePrinterConfig() {
    final printer = ref.read(hardwareManagerProvider).labelPrinter;
    final cfg = printer.config;
    final connected = (cfg.connectionType == 'network' && (cfg.ipAddress?.isNotEmpty ?? false)) ||
        (cfg.connectionType == 'usb' && (cfg.usbDevicePath?.isNotEmpty ?? false));
    return connected ? cfg : null;
  }

  Future<void> _handlePrint() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedTemplateId == null) {
      showPosWarningSnackbar(context, l10n.labelSelectTemplate);
      return;
    }
    if (_queueItems.isEmpty) return;

    setState(() => _isPrinting = true);

    try {
      // 1. Send the actual print job to the configured label printer.
      final printer = ref.read(hardwareManagerProvider).labelPrinter;
      final config = _resolvePrinterConfig();
      bool printOk = true;
      if (config != null) {
        printer.configure(config);
        final products = <ProductLabelData>[];
        for (final item in _queueItems) {
          for (var i = 0; i < item.quantity; i++) {
            products.add(
              ProductLabelData(
                nameAr: item.productNameAr,
                nameEn: item.productName,
                barcode: item.barcode,
                price: item.price,
                sku: item.sku,
              ),
            );
          }
        }
        printOk = await printer.printProductLabels(products, copies: _copies);
      } else {
        // No physical printer — surface a clear warning but still record history
        // so the operator can audit the request and dispatch via a manual flow.
        if (mounted) showPosWarningSnackbar(context, l10n.labelsNoPrinterConfigured);
        printOk = false;
      }

      // 2. Always record print history server-side for audit/reporting.
      final totalLabels = _queueItems.fold<int>(0, (sum, i) => sum + i.quantity) * _copies;
      await ref.read(labelRepositoryProvider).recordPrint({
        'template_id': _selectedTemplateId,
        'printer_name': _printerName.isEmpty ? (config?.ipAddress ?? '') : _printerName,
        'product_count': _queueItems.length,
        'total_labels': totalLabels,
      });

      if (!mounted) return;
      if (printOk) {
        showPosSuccessSnackbar(context, l10n.labelsPrintedSuccessfully);
        setState(() {
          _isPrinting = false;
          _queueItems.clear();
        });
      } else {
        setState(() => _isPrinting = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPrinting = false);
        showPosErrorSnackbar(context, l10n.labelsPrintFailed(e.toString()));
      }
    }
  }
}

class _PrintQueueItem {
  const _PrintQueueItem({
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required this.sku,
    required this.barcode,
    required this.price,
    required this.quantity,
  });
  final String productId;
  final String productName;
  final String productNameAr;
  final String sku;
  final String barcode;
  final double price;
  final int quantity;

  _PrintQueueItem copyWith({int? quantity}) {
    return _PrintQueueItem(
      productId: productId,
      productName: productName,
      productNameAr: productNameAr,
      sku: sku,
      barcode: barcode,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}
