import 'package:flutter/material.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase order sent.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _handleCancel(PurchaseOrder order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Purchase Order'),
        content: Text('Cancel order "${order.referenceNumber ?? order.id}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(purchaseOrdersProvider.notifier).cancelOrder(order.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase order cancelled.')));
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
    final state = ref.watch(purchaseOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Orders'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by status',
            onSelected: (value) {
              ref.read(purchaseOrdersProvider.notifier).filterByStatus(value);
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: null, child: Text('All')),
              const PopupMenuItem(value: 'draft', child: Text('Draft')),
              const PopupMenuItem(value: 'sent', child: Text('Sent')),
              const PopupMenuItem(value: 'partially_received', child: Text('Partially Received')),
              const PopupMenuItem(value: 'fully_received', child: Text('Fully Received')),
              const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(purchaseOrdersProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'New PO', icon: Icons.add, onPressed: () => _showCreateDialog()),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PurchaseOrdersState state) {
    final isLoading = state is PurchaseOrdersLoading || state is PurchaseOrdersInitial;
    final error = state is PurchaseOrdersError ? state.message : null;
    final orders = state is PurchaseOrdersLoaded ? state.orders : <PurchaseOrder>[];

    return PosDataTable<PurchaseOrder>(
      columns: const [
        PosTableColumn(title: 'Ref'),
        PosTableColumn(title: 'Supplier'),
        PosTableColumn(title: 'Status'),
        PosTableColumn(title: 'Total', numeric: true),
        PosTableColumn(title: 'Expected'),
      ],
      items: orders,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(purchaseOrdersProvider.notifier).load(),
      emptyConfig: const PosTableEmptyConfig(icon: Icons.shopping_cart_outlined, title: 'No purchase orders yet'),
      actions: [
        PosTableRowAction<PurchaseOrder>(
          label: 'Send',
          icon: Icons.send_outlined,
          color: AppColors.info,
          isVisible: (po) => po.status == PurchaseOrderStatus.draft,
          onTap: (po) => _handleSend(po),
        ),
        PosTableRowAction<PurchaseOrder>(
          label: 'Receive',
          icon: Icons.archive_outlined,
          color: AppColors.success,
          isVisible: (po) => po.status == PurchaseOrderStatus.sent,
          onTap: (po) {
            // TODO: Show receive dialog with item quantities
          },
        ),
        PosTableRowAction<PurchaseOrder>(
          label: 'Cancel',
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
            title: const Text('New Purchase Order'),
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
                        decoration: const InputDecoration(labelText: 'Supplier'),
                        isExpanded: true,
                        items: supplierList.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedSupplierId = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: refController,
                        decoration: const InputDecoration(labelText: 'Reference (optional)'),
                      ),
                      const Divider(height: 24),
                      const Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<String>(
                        value: selectedProductId,
                        decoration: const InputDecoration(labelText: 'Product'),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: quantityController,
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (double.tryParse(v) == null) return 'Invalid';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: unitCostController,
                        decoration: const InputDecoration(labelText: 'Unit Cost'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (double.tryParse(v) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
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
                child: const Text('Create'),
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase order created.')));
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
