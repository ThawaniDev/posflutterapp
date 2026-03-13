import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
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
  String? _statusFilter;

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
              setState(() => _statusFilter = value);
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
    if (state is PurchaseOrdersLoading || state is PurchaseOrdersInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PurchaseOrdersError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: 'Retry',
              onPressed: () => ref.read(purchaseOrdersProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is PurchaseOrdersLoaded) {
      if (state.orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No purchase orders yet', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      }

      return SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.md), child: _buildTable(state.orders));
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<PurchaseOrder> orders) {
    return PosDataTable(
      columns: const [
        DataColumn(label: Text('REF')),
        DataColumn(label: Text('SUPPLIER')),
        DataColumn(label: Text('STATUS')),
        DataColumn(label: Text('TOTAL'), numeric: true),
        DataColumn(label: Text('EXPECTED')),
        DataColumn(label: Text('ACTIONS')),
      ],
      rows: orders.map((po) {
        return DataRow(
          cells: [
            DataCell(Text(po.referenceNumber ?? po.id.substring(0, 8))),
            DataCell(Text(po.supplierId.substring(0, 8))),
            DataCell(PosBadge(label: po.status?.value ?? 'draft', variant: _statusVariant(po.status))),
            DataCell(Text(po.totalCost?.toStringAsFixed(2) ?? '-')),
            DataCell(
              Text(po.expectedDate != null ? '${po.expectedDate!.day}/${po.expectedDate!.month}/${po.expectedDate!.year}' : '-'),
            ),
            DataCell(_buildActionButtons(po)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(PurchaseOrder order) {
    final actions = <Widget>[];

    if (order.status == PurchaseOrderStatus.draft) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.send_outlined, size: 20, color: Colors.blue),
          tooltip: 'Send',
          onPressed: () => _handleSend(order),
        ),
      );
      actions.add(
        IconButton(
          icon: const Icon(Icons.cancel_outlined, size: 20, color: Colors.red),
          tooltip: 'Cancel',
          onPressed: () => _handleCancel(order),
        ),
      );
    } else if (order.status == PurchaseOrderStatus.sent) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.archive_outlined, size: 20, color: Colors.green),
          tooltip: 'Receive',
          onPressed: () {
            // TODO: Show receive dialog with item quantities
          },
        ),
      );
      actions.add(
        IconButton(
          icon: const Icon(Icons.cancel_outlined, size: 20, color: Colors.red),
          tooltip: 'Cancel',
          onPressed: () => _handleCancel(order),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();
    return Row(mainAxisSize: MainAxisSize.min, children: actions);
  }

  Future<void> _showCreateDialog() async {
    final formKey = GlobalKey<FormState>();
    final supplierController = TextEditingController();
    final refController = TextEditingController();
    final productIdController = TextEditingController();
    final quantityController = TextEditingController();
    final unitCostController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Purchase Order'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: supplierController,
                  decoration: const InputDecoration(labelText: 'Supplier ID'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: refController,
                  decoration: const InputDecoration(labelText: 'Reference (optional)'),
                ),
                const Divider(),
                const Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: productIdController,
                  decoration: const InputDecoration(labelText: 'Product ID'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
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
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, {
                  'supplier_id': supplierController.text,
                  if (refController.text.isNotEmpty) 'reference_number': refController.text,
                  'items': [
                    {
                      'product_id': productIdController.text,
                      'quantity': double.parse(quantityController.text),
                      'unit_cost': double.parse(unitCostController.text),
                    },
                  ],
                });
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    supplierController.dispose();
    refController.dispose();
    productIdController.dispose();
    quantityController.dispose();
    unitCostController.dispose();

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
  }
}
