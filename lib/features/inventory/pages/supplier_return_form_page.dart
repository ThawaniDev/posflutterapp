import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';

class SupplierReturnFormPage extends ConsumerStatefulWidget {
  const SupplierReturnFormPage({super.key});

  @override
  ConsumerState<SupplierReturnFormPage> createState() => _SupplierReturnFormPageState();
}

class _SupplierReturnFormPageState extends ConsumerState<SupplierReturnFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _refController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  String? _supplierId;
  bool _isSaving = false;

  final List<_ReturnLineItem> _items = [_ReturnLineItem()];

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
    _reasonController.dispose();
    _notesController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addItem() => setState(() => _items.add(_ReturnLineItem()));

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
    if (_supplierId == null) {
      showPosErrorSnackbar(context, AppLocalizations.of(context)!.supplierReturnSelectSupplier);
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);

    final data = <String, dynamic>{
      'supplier_id': _supplierId,
      'reference_number': _refController.text.isNotEmpty ? _refController.text : null,
      'reason': _reasonController.text.isNotEmpty ? _reasonController.text : null,
      'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
      'items': _items.map((item) => item.toJson()).toList(),
    };

    try {
      await ref.read(supplierReturnsProvider.notifier).createReturn(data);
      if (mounted) {
        showPosSuccessSnackbar(context, l10n.supplierReturnCreated);
        Navigator.pop(context, true);
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
      appBar: AppBar(title: Text(l10n.supplierReturnNew)),
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
              clearable: false,
              validator: (v) => v == null ? l10n.supplierReturnSelectSupplier : null,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _refController, label: l10n.inventoryReferenceNumber, hint: l10n.supplierReturnRefHint),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _reasonController,
              label: l10n.supplierReturnReason,
              hint: l10n.supplierReturnReasonHint,
              maxLines: 2,
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
                        clearable: false,
                        validator: (v) => v == null ? l10n.supplierReturnSelectProduct : null,
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
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: PosTextField(
                              controller: item.reasonController,
                              label: l10n.supplierReturnItemReason,
                              hint: l10n.supplierReturnItemReasonHint,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: PosTextField(
                              controller: item.batchController,
                              label: l10n.supplierReturnBatchNumber,
                              hint: l10n.supplierReturnBatchHint,
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
              label: _isSaving ? l10n.inventorySaving : l10n.supplierReturnCreateBtn,
              onPressed: _isSaving ? null : _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReturnLineItem {
  String? productId;
  final quantityController = TextEditingController();
  final unitCostController = TextEditingController();
  final reasonController = TextEditingController();
  final batchController = TextEditingController();

  void dispose() {
    quantityController.dispose();
    unitCostController.dispose();
    reasonController.dispose();
    batchController.dispose();
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId ?? '',
    'quantity': double.tryParse(quantityController.text) ?? 0,
    'unit_cost': double.tryParse(unitCostController.text) ?? 0,
    if (reasonController.text.isNotEmpty) 'reason': reasonController.text,
    if (batchController.text.isNotEmpty) 'batch_number': batchController.text,
  };
}
