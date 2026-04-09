import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/catalog/models/supplier.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';

/// Form page to create a new goods receipt.
class GoodsReceiptFormPage extends ConsumerStatefulWidget {
  const GoodsReceiptFormPage({super.key});

  @override
  ConsumerState<GoodsReceiptFormPage> createState() => _GoodsReceiptFormPageState();
}

class _GoodsReceiptFormPageState extends ConsumerState<GoodsReceiptFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _refController = TextEditingController();
  final _notesController = TextEditingController();
  String? _supplierId;
  bool _isSaving = false;

  // Dynamic line items
  final List<_LineItem> _items = [_LineItem()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (ref.read(suppliersProvider) is! SuppliersLoaded) {
        ref.read(suppliersProvider.notifier).load();
      }
      if (ref.read(productsProvider) is! ProductsLoaded) {
        ref.read(productsProvider.notifier).load();
      }
    });
  }

  @override
  void dispose() {
    _refController.dispose();
    _notesController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() => _items.add(_LineItem()));
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items[index].dispose();
        _items.removeAt(index);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isSaving = true);

    final data = <String, dynamic>{
      'reference_number': _refController.text.isNotEmpty ? _refController.text : null,
      if (_supplierId != null) 'supplier_id': _supplierId,
      'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
      'items': _items.map((item) => item.toJson()).toList(),
    };

    try {
      await ref.read(goodsReceiptsProvider.notifier).createReceipt(data);
      if (mounted) {
        showPosSuccessSnackbar(context, l10n.inventoryDraftReceiptCreated);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suppState = ref.watch(suppliersProvider);
    final supplierList = suppState is SuppliersLoaded ? suppState.suppliers : <Supplier>[];
    final prodState = ref.watch(productsProvider);
    final productList = prodState is ProductsLoaded ? prodState.products : <Product>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventoryNewGoodsReceipt)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PosSearchableDropdown<String>(
              items: supplierList.map((s) => PosDropdownItem(value: s.id, label: s.name)).toList(),
              selectedValue: _supplierId,
              onChanged: (v) => setState(() => _supplierId = v),
              label: l10n.inventorySupplier,
              hint: l10n.inventorySupplier,
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _refController,
              label: l10n.inventoryReferenceNumber,
              hint: l10n.inventoryReferenceNumberHint,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _notesController, label: l10n.commonNotes, hint: l10n.inventoryNotesHint, maxLines: 2),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.inventoryLineItems, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ..._items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(l10n.inventoryItemLabel(index + 1), style: Theme.of(context).textTheme.titleSmall),
                          const Spacer(),
                          if (_items.length > 1)
                            IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => _removeItem(index)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      PosSearchableDropdown<String>(
                        items: productList.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
                        selectedValue: item.productId,
                        onChanged: (v) => setState(() => item.productId = v),
                        label: l10n.inventoryProduct,
                        hint: l10n.inventoryProduct,
                        showSearch: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: PosTextField(
                              controller: item.quantityController,
                              label: l10n.inventoryQuantity,
                              hint: '0',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: PosTextField(
                              controller: item.unitCostController,
                              label: l10n.inventoryUnitCostLabel,
                              hint: '0.00',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            PosButton(label: l10n.inventoryAddItemLabel, icon: Icons.add, variant: PosButtonVariant.outline, onPressed: _addItem),
            const SizedBox(height: AppSpacing.xl),
            PosButton(
              label: _isSaving ? l10n.inventorySaving : l10n.inventoryCreateReceipt,
              onPressed: _isSaving ? null : _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}

class _LineItem {
  String? productId;
  final quantityController = TextEditingController();
  final unitCostController = TextEditingController();

  void dispose() {
    quantityController.dispose();
    unitCostController.dispose();
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId ?? '',
    'quantity': double.tryParse(quantityController.text) ?? 0,
    'unit_cost': double.tryParse(unitCostController.text) ?? 0,
  };
}
