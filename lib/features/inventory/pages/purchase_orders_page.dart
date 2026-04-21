import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/inventory/enums/purchase_order_status.dart';
import 'package:wameedpos/features/inventory/models/purchase_order.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

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
        showPosSuccessSnackbar(context, l10n.inventoryPOSent);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    }
  }

  Future<void> _handleReceive(PurchaseOrder order) async {
    final l10n = AppLocalizations.of(context)!;

    // Fetch order detail to get items
    PurchaseOrder detail;
    try {
      detail = await ref.read(purchaseOrdersProvider.notifier).getOrder(order.id);
    } catch (e) {
      if (mounted) showPosErrorSnackbar(context, e.toString());
      return;
    }

    final items = detail.items;
    if (items == null || items.isEmpty) {
      if (mounted) showPosErrorSnackbar(context, l10n.commonError);
      return;
    }

    // Controllers for quantity_received per item, pre-filled with ordered qty
    final controllers = <String, TextEditingController>{
      for (final item in items) item.productId: TextEditingController(text: item.quantityOrdered.toStringAsFixed(0)),
    };

    final result = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.inventoryReceivePOTitle, style: AppTypography.headlineSmall),
                  AppSpacing.gapH16,
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => AppSpacing.gapH12,
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productName ?? item.productId.substring(0, 8), style: AppTypography.bodyMedium),
                                  Text(
                                    '${l10n.inventoryOrdered}: ${item.quantityOrdered.toStringAsFixed(0)}',
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.gapW12,
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: controllers[item.productId],
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(labelText: l10n.inventoryReceived, isDense: true),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  AppSpacing.gapH24,
                  Row(
                    children: [
                      Expanded(
                        child: PosButton(
                          label: l10n.commonCancel,
                          variant: PosButtonVariant.outline,
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ),
                      AppSpacing.gapW12,
                      Expanded(
                        child: PosButton(
                          label: l10n.inventoryReceive,
                          variant: PosButtonVariant.primary,
                          onPressed: () {
                            final receivedItems = <Map<String, dynamic>>[];
                            for (final item in items) {
                              final qty = double.tryParse(controllers[item.productId]?.text ?? '') ?? 0;
                              receivedItems.add({'product_id': item.productId, 'quantity_received': qty});
                            }
                            Navigator.pop(ctx, receivedItems);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Dispose controllers
    for (final c in controllers.values) {
      c.dispose();
    }

    if (result != null && mounted) {
      try {
        await ref.read(purchaseOrdersProvider.notifier).receiveOrder(order.id, result);
        if (mounted) showPosSuccessSnackbar(context, l10n.inventoryPOReceived);
      } catch (e) {
        if (mounted) showPosErrorSnackbar(context, e.toString());
      }
    }
  }

  Future<void> _handleCancel(PurchaseOrder order) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.inventoryCancelPOTitle,
      message: l10n.purchaseOrderCancelConfirm(order.referenceNumber ?? order.id),
      confirmLabel: l10n.inventoryCancelOrder,
      cancelLabel: l10n.commonNo,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(purchaseOrdersProvider.notifier).cancelOrder(order.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.inventoryPOCancelled);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(purchaseOrdersProvider);

    return PosListPage(
      title: l10n.inventoryPurchaseOrders,
      filters: [
        SizedBox(
          width: 180,
          child: PosSearchableDropdown<String?>(
            hint: l10n.allStatuses,
            items: [
              PosDropdownItem<String?>(value: null, label: l10n.inventoryAll),
              PosDropdownItem<String?>(value: 'draft', label: l10n.inventoryDraft),
              PosDropdownItem<String?>(value: 'sent', label: l10n.inventorySent),
              PosDropdownItem<String?>(value: 'partially_received', label: l10n.inventoryPartiallyReceived),
              PosDropdownItem<String?>(value: 'fully_received', label: l10n.inventoryFullyReceived),
              PosDropdownItem<String?>(value: 'cancelled', label: l10n.inventoryCancelled),
            ],
            selectedValue: null,
            onChanged: (value) => ref.read(purchaseOrdersProvider.notifier).filterByStatus(value),
            showSearch: false,
            clearable: true,
          ),
        ),
      ],
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showPurchaseOrdersInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(purchaseOrdersProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.inventoryNewPO, icon: Icons.add, onPressed: () => _showCreateDialog()),
      ],
      child: _buildBody(state),
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
          onTap: (po) => _handleReceive(po),
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
                      PosSearchableDropdown<String>(
                        items: supplierList.map((s) => PosDropdownItem(value: s.id, label: s.name)).toList(),
                        selectedValue: selectedSupplierId,
                        onChanged: (v) => setDialogState(() => selectedSupplierId = v),
                        label: l10n.inventorySupplier,
                        hint: l10n.inventorySupplier,
                        showSearch: true,
                        clearable: false,
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
                      PosSearchableDropdown<String>(
                        items: productList.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
                        selectedValue: selectedProductId,
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        label: l10n.inventoryProduct,
                        hint: l10n.inventoryProduct,
                        showSearch: true,
                        clearable: false,
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
              PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.commonCancel),
              PosButton(
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
                variant: PosButtonVariant.ghost,
                label: l10n.commonCreate,
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
          showPosSuccessSnackbar(context, l10n.inventoryPOCreatedMsg);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }

    refController.dispose();
    quantityController.dispose();
    unitCostController.dispose();
  }
}
