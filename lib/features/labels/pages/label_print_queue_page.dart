import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_app_bar.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/features/labels/models/label_template.dart';
import 'package:thawani_pos/features/labels/providers/label_providers.dart';
import 'package:thawani_pos/features/labels/providers/label_state.dart';
import 'package:thawani_pos/features/labels/repositories/label_repository.dart';

/// The Label Print Queue page allows users to:
/// - Select a label template
/// - Choose products to print labels for
/// - Set quantities per product
/// - Configure printer settings (printer name, copies, page size)
/// - Preview labels before printing
/// - Submit the print job
class LabelPrintQueuePage extends ConsumerStatefulWidget {
  final String? templateId;

  const LabelPrintQueuePage({super.key, this.templateId});

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

    return Scaffold(
      appBar: PosAppBar(
        title: l10n.labelPrintQueue,
        showBackButton: true,
        onBackPressed: () => context.pop(),
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
      ),
      body: Row(
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
                              child: DropdownButtonFormField<String>(
                                value: _selectedTemplateId,
                                decoration: InputDecoration(
                                  labelText: l10n.labelTemplate,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: templates.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
                                onChanged: (v) => setState(() => _selectedTemplateId = v),
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
                              child: PosSearchField(
                                controller: _searchController,
                                hint: l10n.labelSearchProducts,
                                onSubmitted: (_) => _addDemoItem(),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            PosButton(
                              label: l10n.labelAdd,
                              icon: Icons.add_rounded,
                              variant: PosButtonVariant.soft,
                              size: PosButtonSize.sm,
                              onPressed: _addDemoItem,
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
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        Text(
                                          l10n.labelEmptyQueue,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
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
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.inventory_2_rounded, size: 18, color: AppColors.primary),
                                        ),
                                        title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                        subtitle: Text('SKU: ${item.sku}'),
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
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_2_rounded, size: 36, color: Colors.grey.shade600),
                            const SizedBox(height: 4),
                            Text('Product Name', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                            Text(
                              '0.000 OMR',
                              style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              height: 18,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Text(
                                  '||||||||||||',
                                  style: TextStyle(fontSize: 8, letterSpacing: -1, color: Colors.grey.shade700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Summary
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
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
      ),
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

  void _addDemoItem() {
    final name = _searchController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _queueItems.add(_PrintQueueItem(productName: name, sku: 'SKU-${_queueItems.length + 1}', quantity: 1));
      _searchController.clear();
    });
  }

  Future<void> _handlePrint() async {
    if (_selectedTemplateId == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelSelectTemplate)));
      return;
    }

    setState(() => _isPrinting = true);

    final data = {
      'template_id': _selectedTemplateId,
      'printer_name': _printerName,
      'product_count': _queueItems.length,
      'total_labels': _queueItems.fold<int>(0, (sum, i) => sum + i.quantity) * _copies,
    };

    try {
      // Record print via label repository
      await ref.read(labelRepositoryProvider).recordPrint(data);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelPrintSuccess)));
        setState(() {
          _isPrinting = false;
          _queueItems.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPrinting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}

class _PrintQueueItem {
  final String productName;
  final String sku;
  final int quantity;

  const _PrintQueueItem({required this.productName, required this.sku, required this.quantity});

  _PrintQueueItem copyWith({String? productName, String? sku, int? quantity}) {
    return _PrintQueueItem(
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
    );
  }
}
