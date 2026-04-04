import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/catalog/models/supplier.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';
import 'package:thawani_pos/features/inventory/enums/purchase_order_status.dart';
import 'package:thawani_pos/features/inventory/models/purchase_order.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';

class PurchaseOrdersPage extends ConsumerStatefulWidget {
  const PurchaseOrdersPage({super.key});

  @override
  ConsumerState<PurchaseOrdersPage> createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends ConsumerState<PurchaseOrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(purchaseOrdersProvider.notifier).load());
  }

  PosBadgeVariant _statusVariant(PurchaseOrderStatus? status) {
    switch (status) {
      case PurchaseOrderStatus.draft:
        return PosBadgeVariant.neutral;
      case PurchaseOrderStatus.sent:
        return PosBadgeVariant.info;
      case PurchaseOrderStatus.partiallyReceived:
        return PosBadgeVariant.warning;
      case PurchaseOrderStatus.fullyReceived:
        return PosBadgeVariant.success;
      case PurchaseOrderStatus.cancelled:
        return PosBadgeVariant.error;
      case null:
        return PosBadgeVariant.neutral;
    }
  }

  Future<void> _handleSend(PurchaseOrder order) async {
    try {
      await ref.read(purchaseOrdersProvider.notifier).sendOrder(order.id);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.inventoryPOSent)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _handleCancel(PurchaseOrder order) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.inventoryCancelPOTitle),
        content: Text(l10n.purchaseOrderCancelConfirm(order.referenceNumber ?? order.id)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonNo)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.inventoryCancelOrder),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(purchaseOrdersProvider.notifier).cancelOrder(order.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.inventoryPOCancelled)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(purchaseOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryPurchaseOrders),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.inventoryFilterByStatus,
            onSelected: (value) {
              ref.read(purchaseOrdersProvider.notifier).filterByStatus(value);
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: null, child: Text(l10n.inventoryAll)),
              PopupMenuItem(value: 'draft', child: Text(l10n.inventoryDraft)),
              PopupMenuItem(value: 'sent', child: Text(l10n.inventorySent)),
              PopupMenuItem(value: 'partially_received', child: Text(l10n.inventoryPartiallyReceived)),
              PopupMenuItem(value: 'fully_received', child: Text(l10n.inventoryFullyReceived)),
              PopupMenuItem(value: 'cancelled', child: Text(l10n.inventoryCancelled)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(purchaseOrdersProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: l10n.inventoryNewPO, icon: Icons.add, onPressed: () => _showCreateDialog()),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PurchaseOrdersState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is PurchaseOrdersLoading || state is PurchaseOrdersInitial;
    final error = state is PurchaseOrdersError ? state.message : null;
    final orders = state is PurchaseOrdersLoaded ? state.orders : <PurchaseOrder>[];

    return PosDataTable<PurchaseOrder>(
      columns: [
        PosTableColumn(title: l10n.inventoryRef),
        PosTableColumn(title: l10n.inventorySupplier),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.inventoryTotal, numeric: true),
        PosTableColumn(title: l10n.inventoryExpected),
      ],
      items: orders,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(purchaseOrdersProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(icon: Icons.shopping_cart_outlined, title: l10n.inventoryNoPOs),
      actions: [
        PosTableRowAction<PurchaseOrder>(
          label: l10n.inventorySendAction,
          icon: Icons.send_outlined,
          color: AppColors.info,
          isVisible: (po) => po.status == PurchaseOrderStatus.draft,
          onTap: (po) => _handleSend(po),
        ),
        PosTableRowAction<PurchaseOrder>(
          label: l10n.inventoryReceiveAction,
          icon: Icons.archive_outlined,
          color: AppColors.success,
          isVisible: (po) => po.status == PurchaseOrderStatus.sent,
          onTap: (po) {
            // TODO: Show receive dialog with item quantities
          },
        ),
        PosTableRowAction<PurchaseOrder>(
          label: l10n.commonCancel,
          icon: Icons.cancel_outlined,
          isDestructive: true,
          isVisible: (po) => po.status == PurchaseOrderStatus.draft || po.status == PurchaseOrderStatus.sent,
          onTap: (po) => _handleCancel(po),
        ),
      ],
      cellBuilder: (po, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(po.referenceNumber ?? po.id.substring(0, 8));
          case 1:
            return Text(po.supplierName ?? po.supplierId.substring(0, 8));
          case 2:
            return PosBadge(label: po.status?.value ?? 'draft', variant: _statusVariant(po.status));
          case 3:
            return Text(po.totalCost?.toStringAsFixed(2) ?? '-');
          case 4:
            return Text(
              po.expectedDate != null ? '${po.expectedDate!.day}/${po.expectedDate!.month}/${po.expectedDate!.year}' : '-',
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _showCreateDialog() async {
    final l10n = AppLocalizations.of(context)!;
    // Ensure suppliers and products are loaded
    if (ref.read(suppliersProvider) is! SuppliersLoaded) {
      await ref.read(suppliersProvider.notifier).load();
    }
    if (ref.read(productsProvider) is! ProductsLoaded) {
      await ref.read(productsProvider.notifier).load();
    }

    final formKey = GlobalKey<FormState>();
    final refController = TextEditingController();
    final quantityController = TextEditingController();
    final unitCostController = TextEditingController();
    String? selectedSupplierId;
    String? selectedProductId;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final suppState = ref.read(suppliersProvider);
          final supplierList = suppState is SuppliersLoaded ? suppState.suppliers : <Supplier>[];
          final prodState = ref.read(productsProvider);
          final productList = prodState is ProductsLoaded ? prodState.products : <Product>[];

          return AlertDialog(
            title: Text(l10n.inventoryNewPO),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedSupplierId,
                        decoration: InputDecoration(labelText: l10n.inventorySupplier),
                        isExpanded: true,
                        items: supplierList.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedSupplierId = v),
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: refController,
                        decoration: InputDecoration(labelText: l10n.inventoryReferenceOptional),
                      ),
                      const Divider(height: 24),
                      Text(l10n.inventoryProduct, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<String>(
                        value: selectedProductId,
                        decoration: InputDecoration(labelText: l10n.inventoryProduct),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: quantityController,
                        decoration: InputDecoration(labelText: l10n.inventoryQuantity),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.commonRequired;
                          if (double.tryParse(v) == null) return l10n.commonInvalid;
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: unitCostController,
                        decoration: InputDecoration(labelText: l10n.inventoryUnitCostLabel),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.commonRequired;
                          if (double.tryParse(v) == null) return l10n.commonInvalid;
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(ctx, {
                      'supplier_id': selectedSupplierId,
                      if (refController.text.isNotEmpty) 'reference_number': refController.text,
                      'items': [
                        {
                          'product_id': selectedProductId,
                          'quantity_ordered': double.parse(quantityController.text),
                          'unit_cost': double.parse(unitCostController.text),
                        },
                      ],
                    });
                  }
                },
                child: Text(l10n.commonCreate),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      try {
        await ref.read(purchaseOrdersProvider.notifier).createOrder(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.inventoryPOCreatedMsg)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }

    refController.dispose();
    quantityController.dispose();
    unitCostController.dispose();
  }
}
