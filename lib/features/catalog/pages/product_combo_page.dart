import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/repositories/catalog_repository.dart';

/// Combo / bundle product editor.
///
/// Lets the user wire several existing products together into a
/// combo, optionally setting a fixed combo price. Items can be
/// flagged optional (e.g. "drink choice") and per-item quantity
/// supports decimals for weighable components.
class ProductComboPage extends ConsumerStatefulWidget {
  const ProductComboPage({required this.productId, super.key});

  final String productId;

  @override
  ConsumerState<ProductComboPage> createState() => _ProductComboPageState();
}

class _ProductComboPageState extends ConsumerState<ProductComboPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final List<_ItemDraft> _items = <_ItemDraft>[];

  bool _loading = true;
  bool _saving = false;
  String? _error;
  Product? _parent;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final repo = ref.read(catalogRepositoryProvider);
    try {
      final parent = await repo.getProduct(widget.productId);
      final combo = await repo.getCombo(widget.productId);
      if (!mounted) return;
      setState(() {
        _parent = parent;
        _nameController.text = combo.name ?? parent.name;
        if (combo.comboPrice != null) {
          _priceController.text = combo.comboPrice!.toStringAsFixed(2);
        }
        _items
          ..clear()
          ..addAll(combo.items.map(_ItemDraft.fromExisting));
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _addItem() async {
    final repo = ref.read(catalogRepositoryProvider);
    final picked = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceLight,
      builder: (_) => _ProductPicker(
        repository: repo,
        excludeProductId: widget.productId,
      ),
    );
    if (picked == null || !mounted) return;
    if (_items.any((d) => d.productId == picked.id)) {
      _showSnack(AppLocalizations.of(context)!.catalogComboItemAlreadyAdded);
      return;
    }
    setState(() {
      _items.add(_ItemDraft(
        productId: picked.id,
        productName: picked.name,
        productNameAr: picked.nameAr,
        quantity: 1,
        isOptional: false,
      ));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_items.isEmpty) {
      _showSnack(l10n.catalogComboNeedsAtLeastOneItem);
      return;
    }
    final payload = <ComboItemPayload>[];
    for (final item in _items) {
      final qty = double.tryParse(item.qtyController.text);
      if (qty == null || qty <= 0) {
        _showSnack(l10n.catalogComboInvalidQuantity);
        return;
      }
      payload.add(ComboItemPayload(
        productId: item.productId,
        quantity: qty,
        isOptional: item.isOptional,
      ));
    }
    double? comboPrice;
    if (_priceController.text.trim().isNotEmpty) {
      comboPrice = double.tryParse(_priceController.text.trim());
      if (comboPrice == null || comboPrice < 0) {
        _showSnack(l10n.catalogComboInvalidPrice);
        return;
      }
    }

    setState(() => _saving = true);
    try {
      await ref.read(catalogRepositoryProvider).syncCombo(
            widget.productId,
            name: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            comboPrice: comboPrice,
            items: payload,
          );
      if (!mounted) return;
      _showSnack(l10n.catalogComboSaved);
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      _showSnack('${l10n.catalogComboSaveFailed}: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _clear() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.catalogComboClearConfirmTitle),
        content: Text(l10n.catalogComboClearConfirmBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.commonDelete)),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref.read(catalogRepositoryProvider).clearCombo(widget.productId);
      if (!mounted) return;
      _showSnack(l10n.catalogComboCleared);
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      _showSnack('$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.catalogComboTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.catalogComboTitle)),
        body: Center(child: Text(_error!)),
      );
    }
    return PosFormPage(
      title: l10n.catalogComboTitle,
      subtitle: _parent?.name ?? '',
      onBack: () => context.pop(),
      bottomBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: PosButton(
                label: l10n.catalogComboClear,
                onPressed: _saving ? null : _clear,
                variant: PosButtonVariant.outline,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: PosButton(
                label: l10n.commonSave,
                onPressed: _saving ? null : _save,
                isLoading: _saving,
              ),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.catalogComboHeading, style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.md),
                    PosTextField(
                      controller: _nameController,
                      label: l10n.catalogComboName,
                      hint: l10n.catalogComboNameHint,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PosTextField(
                      controller: _priceController,
                      label: l10n.catalogComboPrice,
                      hint: l10n.catalogComboPriceHint,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(l10n.catalogComboItemsHeading,
                      style: AppTypography.titleMedium),
                ),
                PosButton(
                  label: l10n.catalogComboAddItem,
                  onPressed: _saving ? null : _addItem,
                  icon: Icons.add,
                  variant: PosButtonVariant.outlinePrimary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (_items.isEmpty)
              PosCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text(
                      l10n.catalogComboNoItems,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (_, i) => _buildItemRow(i),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(int index) {
    final l10n = AppLocalizations.of(context)!;
    final item = _items[index];
    return PosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName ?? item.productId,
                      style: AppTypography.bodyMedium),
                  if (item.productNameAr != null)
                    Text(item.productNameAr!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        )),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 100,
              child: PosTextField(
                controller: item.qtyController,
                label: l10n.catalogComboQty,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,3}')),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              children: [
                Text(l10n.catalogComboOptional,
                    style: AppTypography.bodySmall),
                Switch(
                  value: item.isOptional,
                  onChanged: (v) => setState(() => item.isOptional = v),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _removeItem(index),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemDraft {
  _ItemDraft({
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required double quantity,
    required this.isOptional,
  }) : qtyController = TextEditingController(text: quantity.toString());

  factory _ItemDraft.fromExisting(ComboItem item) => _ItemDraft(
        productId: item.productId,
        productName: item.productName,
        productNameAr: item.productNameAr,
        quantity: item.quantity,
        isOptional: item.isOptional,
      );

  final String productId;
  final String? productName;
  final String? productNameAr;
  bool isOptional;
  final TextEditingController qtyController;

  void dispose() => qtyController.dispose();
}

class _ProductPicker extends StatefulWidget {
  const _ProductPicker({required this.repository, required this.excludeProductId});

  final CatalogRepository repository;
  final String excludeProductId;

  @override
  State<_ProductPicker> createState() => _ProductPickerState();
}

class _ProductPickerState extends State<_ProductPicker> {
  final _searchController = TextEditingController();
  bool _loading = false;
  List<Product> _results = const [];

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
    setState(() => _loading = true);
    try {
      final result = await widget.repository.listProducts(
        page: 1,
        perPage: 50,
        search: query.trim().isEmpty ? null : query.trim(),
      );
      if (!mounted) return;
      setState(() {
        _results = result.items
            .where((p) => p.id != widget.excludeProductId)
            .toList();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.catalogComboPickItem,
                      style: AppTypography.titleMedium),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            PosTextField(
              controller: _searchController,
              label: l10n.commonSearch,
              hint: l10n.catalogComboSearchHint,
              onChanged: _runSearch,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: _results.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final p = _results[i];
                        return ListTile(
                          title: Text(p.name),
                          subtitle: Text(
                            '${p.sku ?? ''}  •  ${p.sellPrice.toStringAsFixed(2)}',
                            style: AppTypography.bodySmall,
                          ),
                          onTap: () => Navigator.of(ctx).pop(p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
