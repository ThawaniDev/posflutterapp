import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/repositories/catalog_repository.dart';

/// Selection returned from the picker sheet for a single product.
class LabelProductSelection {
  LabelProductSelection({required this.product, this.quantity = 1});

  final Product product;
  int quantity;
}

/// Show a modal sheet to multi-select products for label printing.
/// Returns the list of selected products + quantities, or null if cancelled.
Future<List<LabelProductSelection>?> showLabelProductPickerSheet(BuildContext context, {Set<String>? excludeProductIds}) {
  return showModalBottomSheet<List<LabelProductSelection>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) => _LabelProductPickerSheet(excludeProductIds: excludeProductIds ?? const {}),
  );
}

class _LabelProductPickerSheet extends ConsumerStatefulWidget {
  const _LabelProductPickerSheet({required this.excludeProductIds});

  final Set<String> excludeProductIds;

  @override
  ConsumerState<_LabelProductPickerSheet> createState() => _LabelProductPickerSheetState();
}

class _LabelProductPickerSheetState extends ConsumerState<_LabelProductPickerSheet> {
  final _searchController = TextEditingController();
  bool _loading = false;
  String? _error;
  List<Product> _results = const [];
  final Map<String, LabelProductSelection> _selected = {};

  @override
  void initState() {
    super.initState();
    _runSearch('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final result = await repo.listProducts(page: 1, perPage: 100, search: query.trim().isEmpty ? null : query.trim());
      if (!mounted) return;
      setState(() {
        _results = result.items.where((p) => !widget.excludeProductIds.contains(p.id)).toList();
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggle(Product product, bool? checked) {
    setState(() {
      if (checked ?? false) {
        _selected[product.id] = LabelProductSelection(product: product);
      } else {
        _selected.remove(product.id);
      }
    });
  }

  void _adjustQty(String id, int delta) {
    final sel = _selected[id];
    if (sel == null) return;
    setState(() {
      sel.quantity = (sel.quantity + delta).clamp(1, 9999);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(l10n.labelsAddProductsToQueue, style: AppTypography.titleMedium)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            PosTextField(
              controller: _searchController,
              label: l10n.commonSearch,
              hint: l10n.labelsProductSearchHint,
              onChanged: _runSearch,
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    )
                  : _results.isEmpty
                  ? Center(child: Text(l10n.labelsQueueEmpty))
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: _results.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final p = _results[i];
                        final sel = _selected[p.id];
                        final isSelected = sel != null;
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (v) => _toggle(p, v),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(p.name),
                          subtitle: Text('${p.sku ?? '-'}  •  ${p.sellPrice.toStringAsFixed(3)}', style: AppTypography.bodySmall),
                          secondary: isSelected
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () => _adjustQty(p.id, -1),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      child: Text(
                                        '${sel.quantity}',
                                        textAlign: TextAlign.center,
                                        style: AppTypography.titleSmall,
                                      ),
                                    ),
                                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _adjustQty(p.id, 1)),
                                  ],
                                )
                              : null,
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(child: Text(l10n.labelsSelectedCount(_selected.length), style: AppTypography.bodyMedium)),
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.commonCancel)),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text(l10n.commonConfirm),
                    onPressed: _selected.isEmpty ? null : () => Navigator.of(ctx).pop(_selected.values.toList()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
