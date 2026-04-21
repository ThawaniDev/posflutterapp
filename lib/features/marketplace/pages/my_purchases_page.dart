import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/marketplace/models/marketplace_invoice.dart';
import 'package:wameedpos/features/marketplace/models/template_purchase.dart';
import 'package:wameedpos/features/marketplace/providers/marketplace_providers.dart';
import 'package:wameedpos/features/marketplace/providers/marketplace_state.dart';

class MyPurchasesPage extends ConsumerStatefulWidget {
  const MyPurchasesPage({super.key});

  @override
  ConsumerState<MyPurchasesPage> createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends ConsumerState<MyPurchasesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myPurchasesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPurchasesProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
  title: l10n.marketplaceMyPurchases,
  showSearch: false,
    child: switch (state) {
        MyPurchasesInitial() || MyPurchasesLoading() => PosLoadingSkeleton.list(),
        MyPurchasesError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(myPurchasesProvider.notifier).load(),
        ),
        MyPurchasesLoaded(:final purchases, :final invoices) => DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceFor(context),
                  border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
                ),
                child: TabBar(
                  tabs: [
                    Tab(text: '${l10n.marketplacePurchases} (${purchases.length})'),
                    Tab(text: '${l10n.marketplaceInvoices} (${invoices.length})'),
                  ],
                  labelStyle: AppTypography.labelSmall,
                  indicatorColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [_buildPurchasesTab(purchases, l10n, isDark), _buildInvoicesTab(invoices, l10n, isDark)],
                ),
              ),
            ],
          ),
        ),
      },
);
  }

  Widget _buildPurchasesTab(List<TemplatePurchase> purchases, AppLocalizations l10n, bool isDark) {
    if (purchases.isEmpty) {
      return PosEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: l10n.marketplaceNoPurchases,
        subtitle: l10n.marketplaceNoPurchasesSubtitle,
      );
    }

    return PosDataTable<TemplatePurchase>(
      columns: [
        PosTableColumn(title: l10n.marketplaceTemplateName, key: 'name'),
        PosTableColumn(title: l10n.marketplacePurchaseType, key: 'type'),
        PosTableColumn(title: l10n.marketplaceAmount, key: 'amount'),
        PosTableColumn(title: l10n.marketplaceStatus, key: 'status'),
        PosTableColumn(title: l10n.marketplaceExpires, key: 'expires'),
      ],
      items: purchases,
      itemId: (p) => p.id,
      cellBuilder: (purchase, colIndex, column) => switch (colIndex) {
        0 => Text(purchase.listingName ?? '-', style: AppTypography.bodySmall),
        1 => PosBadge(label: purchase.purchaseType, variant: PosBadgeVariant.info),
        2 => Text(purchase.amountPaid.toStringAsFixed(2), style: AppTypography.bodySmall),
        3 =>
          purchase.isActive
              ? PosBadge(label: l10n.marketplaceActive, variant: PosBadgeVariant.success)
              : purchase.isExpired
              ? PosBadge(label: l10n.marketplaceExpired, variant: PosBadgeVariant.error)
              : PosBadge(label: l10n.marketplaceCancelled, variant: PosBadgeVariant.neutral),
        4 => Text(
          purchase.expiresAt != null ? _formatDate(purchase.expiresAt!) : '-',
          style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
        ),
        _ => const SizedBox.shrink(),
      },
      actions: [
        PosTableRowAction<TemplatePurchase>(
          icon: Icons.cancel_outlined,
          label: l10n.marketplaceCancel,
          onTap: (purchase) {
            if (!purchase.isActive) return;
            _showCancelDialog(purchase, l10n);
          },
        ),
      ],
    );
  }

  Widget _buildInvoicesTab(List<MarketplaceInvoice> invoices, AppLocalizations l10n, bool isDark) {
    if (invoices.isEmpty) {
      return PosEmptyState(
        icon: Icons.receipt_long_outlined,
        title: l10n.marketplaceNoInvoices,
        subtitle: l10n.marketplaceNoInvoicesSubtitle,
      );
    }

    return PosDataTable<MarketplaceInvoice>(
      columns: [
        PosTableColumn(title: l10n.marketplacePurchaseId, key: 'purchase'),
        PosTableColumn(title: l10n.marketplaceAmount, key: 'amount'),
        PosTableColumn(title: l10n.marketplaceCurrencyCol, key: 'currency'),
        PosTableColumn(title: l10n.marketplaceStatus, key: 'status'),
        PosTableColumn(title: l10n.marketplacePaymentMethod, key: 'method'),
        PosTableColumn(title: l10n.marketplacePaidAt, key: 'paid'),
      ],
      items: invoices,
      itemId: (inv) => inv.id,
      cellBuilder: (invoice, colIndex, column) => switch (colIndex) {
        0 => Text(invoice.purchaseId, style: AppTypography.bodySmall),
        1 => Text(invoice.amount.toStringAsFixed(2), style: AppTypography.bodySmall),
        2 => Text(invoice.currency, style: AppTypography.bodySmall),
        3 =>
          invoice.status == 'paid'
              ? PosBadge(label: l10n.marketplacePaid, variant: PosBadgeVariant.success)
              : PosBadge(label: invoice.status, variant: PosBadgeVariant.warning),
        4 => Text(invoice.paymentMethod ?? '-', style: AppTypography.bodySmall),
        5 => Text(invoice.paidAt != null ? _formatDate(invoice.paidAt!) : '-', style: AppTypography.bodySmall),
        _ => const SizedBox.shrink(),
      },
    );
  }

  void _showCancelDialog(TemplatePurchase purchase, AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.marketplaceCancelPurchase,
      message: l10n.marketplaceCancelConfirm,
      confirmLabel: l10n.marketplaceConfirm,
      cancelLabel: l10n.layoutCancel,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(myPurchasesProvider.notifier).cancelPurchase(purchase.id);
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
