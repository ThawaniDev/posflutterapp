import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/inventory/models/goods_receipt.dart';
import 'package:wameedpos/features/inventory/enums/goods_receipt_status.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

class GoodsReceiptsPage extends ConsumerStatefulWidget {
  const GoodsReceiptsPage({super.key});

  @override
  ConsumerState<GoodsReceiptsPage> createState() => _GoodsReceiptsPageState();
}

class _GoodsReceiptsPageState extends ConsumerState<GoodsReceiptsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(goodsReceiptsProvider.notifier).load());
  }

  Future<void> _handleConfirm(GoodsReceipt receipt) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.inventoryConfirmReceiptTitle,
      message: l10n.goodsReceiptConfirm(receipt.referenceNumber ?? receipt.id),
      confirmLabel: l10n.inventoryConfirmReceiptTitle,
      cancelLabel: l10n.commonCancel,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(goodsReceiptsProvider.notifier).confirmReceipt(receipt.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.inventoryReceiptConfirmedMsg);
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
    final state = ref.watch(goodsReceiptsProvider);

    return PosListPage(
      title: l10n.inventoryGoodsReceipts,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showGoodsReceiptsInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(goodsReceiptsProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.inventoryNewReceipt, icon: Icons.add, onPressed: () => context.push(Routes.goodsReceiptsAdd)),
      ],
      child: _buildBody(state),
    );
  }

  Widget _buildBody(GoodsReceiptsState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is GoodsReceiptsLoading || state is GoodsReceiptsInitial;
    final error = state is GoodsReceiptsError ? state.message : null;
    final receipts = state is GoodsReceiptsLoaded ? state.receipts : <GoodsReceipt>[];
    final loaded = state is GoodsReceiptsLoaded ? state : null;

    return PosDataTable<GoodsReceipt>(
      columns: [
        PosTableColumn(title: l10n.inventoryReference),
        PosTableColumn(title: l10n.inventorySupplier),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.inventoryTotalCost, numeric: true),
        PosTableColumn(title: l10n.inventoryReceived),
      ],
      items: receipts,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(goodsReceiptsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: l10n.inventoryNoGoodsReceipts,
        subtitle: l10n.inventoryNoGoodsReceiptsHint,
      ),
      actions: [
        PosTableRowAction<GoodsReceipt>(
          label: l10n.inventoryConfirmReceiptTitle,
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          isVisible: (r) => r.status == GoodsReceiptStatus.draft,
          onTap: (r) => _handleConfirm(r),
        ),
      ],
      cellBuilder: (receipt, colIndex, col) {
        final isDraft = receipt.status == GoodsReceiptStatus.draft;
        switch (colIndex) {
          case 0:
            return Text(receipt.referenceNumber ?? receipt.id.substring(0, 8));
          case 1:
            return Text(receipt.supplierName ?? receipt.supplierId ?? '-');
          case 2:
            return PosBadge(
              label: receipt.status?.value ?? 'draft',
              variant: isDraft ? PosBadgeVariant.warning : PosBadgeVariant.success,
            );
          case 3:
            return Text(receipt.totalCost?.toStringAsFixed(2) ?? '-');
          case 4:
            return Text(
              receipt.receivedAt != null
                  ? '${receipt.receivedAt!.day}/${receipt.receivedAt!.month}/${receipt.receivedAt!.year}'
                  : '-',
            );
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: 25,
    );
  }
}
