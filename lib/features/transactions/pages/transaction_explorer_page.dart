import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/core/widgets/pos_searchable_dropdown.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_terminal/enums/transaction_status.dart';
import 'package:wameedpos/features/pos_terminal/enums/transaction_type.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction.dart';
import 'package:wameedpos/features/transactions/providers/transaction_explorer_providers.dart';
import 'package:wameedpos/features/transactions/providers/transaction_explorer_state.dart';
import 'package:wameedpos/features/transactions/widgets/transaction_analytics_charts.dart';
import 'package:wameedpos/features/transactions/widgets/transaction_stats_cards.dart';

class TransactionExplorerPage extends ConsumerStatefulWidget {
  const TransactionExplorerPage({super.key});

  @override
  ConsumerState<TransactionExplorerPage> createState() => _TransactionExplorerPageState();
}

class _TransactionExplorerPageState extends ConsumerState<TransactionExplorerPage> {
  final _searchController = TextEditingController();
  bool _showAnalytics = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transactionExplorerProvider.notifier).load();
      ref.read(transactionStatsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  PosBadgeVariant _statusVariant(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return PosBadgeVariant.success;
      case TransactionStatus.voided:
        return PosBadgeVariant.error;
      case TransactionStatus.pending:
        return PosBadgeVariant.warning;
    }
  }

  String _statusLabel(TransactionStatus status, AppLocalizations l10n) {
    switch (status) {
      case TransactionStatus.completed:
        return l10n.txStatusCompleted;
      case TransactionStatus.voided:
        return l10n.txStatusVoided;
      case TransactionStatus.pending:
        return l10n.txStatusPending;
    }
  }

  PosBadgeVariant _typeVariant(TransactionType type) {
    switch (type) {
      case TransactionType.sale:
        return PosBadgeVariant.primary;
      case TransactionType.returnValue:
        return PosBadgeVariant.warning;
      case TransactionType.voidValue:
        return PosBadgeVariant.error;
      case TransactionType.exchange:
        return PosBadgeVariant.info;
    }
  }

  String _typeLabel(TransactionType type, AppLocalizations l10n) {
    switch (type) {
      case TransactionType.sale:
        return l10n.txTypeSale;
      case TransactionType.returnValue:
        return l10n.txTypeReturn;
      case TransactionType.voidValue:
        return l10n.txTypeVoid;
      case TransactionType.exchange:
        return l10n.txTypeExchange;
    }
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showPosDateRangePicker(
      context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) {
      ref.read(transactionExplorerProvider.notifier).setDateRange(picked.start, picked.end);
      ref.read(transactionStatsProvider.notifier).load(dateFrom: picked.start, dateTo: picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isPhone;
    final state = ref.watch(transactionExplorerProvider);
    final statsState = ref.watch(transactionStatsProvider);

    return PosListPage(
      title: l10n.txExplorerTitle,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showTransactionExplorerInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: _showAnalytics ? Icons.analytics_outlined : Icons.analytics,
          tooltip: l10n.txToggleAnalytics,
          onPressed: () => setState(() => _showAnalytics = !_showAnalytics),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () {
            ref.read(transactionExplorerProvider.notifier).load();
            ref.read(transactionStatsProvider.notifier).load();
          },
          variant: PosButtonVariant.ghost,
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(transactionExplorerProvider.notifier).load();
          await ref.read(transactionStatsProvider.notifier).load();
        },
        child: ListView(
          padding: context.responsivePagePadding,
          children: [
            // ─── Stats Cards ─────────────────────────────
            if (_showAnalytics) ...[
              if (statsState is TransactionStatsLoading)
                const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()))
              else if (statsState is TransactionStatsLoaded)
                TransactionStatsCards(stats: statsState),
              AppSpacing.gapH16,
            ],

            // ─── Filter Bar ──────────────────────────────
            _buildFilterBar(l10n, isMobile),
            AppSpacing.gapH12,

            // ─── Analytics Charts ────────────────────────
            if (_showAnalytics && statsState is TransactionStatsLoaded) ...[
              TransactionAnalyticsCharts(stats: statsState),
              AppSpacing.gapH12,
              if (statsState.dailyTrend.isNotEmpty) ...[
                TransactionDailyTrendChart(data: statsState.dailyTrend),
                AppSpacing.gapH16,
              ],
            ],

            // ─── Transaction List ────────────────────────
            isMobile ? _buildMobileList(state, l10n) : _buildDesktopTable(state, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(AppLocalizations l10n, bool isMobile) {
    return PosCard(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
            width: isMobile ? double.infinity : 220,
            child: PosTextField(
              controller: _searchController,
              hint: l10n.txSearchHint,
              prefixIcon: Icons.search,
              onSubmitted: (v) => ref.read(transactionExplorerProvider.notifier).setSearch(v),
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 160,
            child: PosSearchableDropdown<String?>(
              items: [
                PosDropdownItem(value: null, label: l10n.txAllTypes),
                PosDropdownItem(value: 'sale', label: l10n.txTypeSale),
                PosDropdownItem(value: 'return', label: l10n.txTypeReturn),
                PosDropdownItem(value: 'void', label: l10n.txTypeVoid),
                PosDropdownItem(value: 'exchange', label: l10n.txTypeExchange),
              ],
              hint: l10n.txFilterType,
              showSearch: false,
              onChanged: (v) => ref.read(transactionExplorerProvider.notifier).setTypeFilter(v),
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 160,
            child: PosSearchableDropdown<String?>(
              items: [
                PosDropdownItem(value: null, label: l10n.txAllStatuses),
                PosDropdownItem(value: 'completed', label: l10n.txStatusCompleted),
                PosDropdownItem(value: 'voided', label: l10n.txStatusVoided),
                PosDropdownItem(value: 'pending', label: l10n.txStatusPending),
              ],
              hint: l10n.txFilterStatus,
              showSearch: false,
              onChanged: (v) => ref.read(transactionExplorerProvider.notifier).setStatusFilter(v),
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 160,
            child: OutlinedButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(l10n.txDateRange, style: AppTypography.bodySmall),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              ref.read(transactionExplorerProvider.notifier).clearFilters();
              ref.read(transactionStatsProvider.notifier).load();
            },
            icon: const Icon(Icons.clear_all, size: 16),
            label: Text(l10n.txClearFilters),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(TransactionExplorerState state, AppLocalizations l10n) {
    final isLoading = state is TransactionExplorerLoading || state is TransactionExplorerInitial;
    final error = state is TransactionExplorerError ? state.message : null;
    final transactions = state is TransactionExplorerLoaded ? state.transactions : <Transaction>[];
    final loaded = state is TransactionExplorerLoaded ? state : null;

    return PosDataTable<Transaction>(
      columns: [
        PosTableColumn(title: l10n.txColNumber),
        PosTableColumn(title: l10n.txColType),
        PosTableColumn(title: l10n.txColStatus),
        PosTableColumn(title: l10n.txColSubtotal, numeric: true),
        PosTableColumn(title: l10n.txColTax, numeric: true),
        PosTableColumn(title: l10n.txColTotal, numeric: true),
        PosTableColumn(title: l10n.txColDate),
      ],
      items: transactions,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(transactionExplorerProvider.notifier).load(),
      onRowTap: (tx) => context.push('${Routes.transactions}/${tx.id}'),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: l10n.txNoTransactions,
        subtitle: l10n.txNoTransactionsSubtitle,
      ),
      cellBuilder: (tx, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(tx.transactionNumber, style: const TextStyle(fontWeight: FontWeight.w600));
          case 1:
            return PosBadge(label: _typeLabel(tx.type, l10n), variant: _typeVariant(tx.type));
          case 2:
            return PosBadge(label: _statusLabel(tx.status, l10n), variant: _statusVariant(tx.status));
          case 3:
            return Text(tx.subtotal.toStringAsFixed(3));
          case 4:
            return Text(tx.taxAmount.toStringAsFixed(3));
          case 5:
            return Text(tx.totalAmount.toStringAsFixed(3), style: const TextStyle(fontWeight: FontWeight.w600));
          case 6:
            return Text(
              tx.createdAt != null
                  ? '${tx.createdAt!.day}/${tx.createdAt!.month}/${tx.createdAt!.year} ${tx.createdAt!.hour.toString().padLeft(2, '0')}:${tx.createdAt!.minute.toString().padLeft(2, '0')}'
                  : '-',
            );
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 25,
      onPreviousPage: loaded != null ? () => ref.read(transactionExplorerProvider.notifier).previousPage() : null,
      onNextPage: loaded != null ? () => ref.read(transactionExplorerProvider.notifier).nextPage() : null,
    );
  }

  Widget _buildMobileList(TransactionExplorerState state, AppLocalizations l10n) {
    if (state is TransactionExplorerLoading || state is TransactionExplorerInitial) {
      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    }
    if (state is TransactionExplorerError) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.message, style: const TextStyle(color: AppColors.error)),
              AppSpacing.gapH8,
              PosButton(onPressed: () => ref.read(transactionExplorerProvider.notifier).load(), variant: PosButtonVariant.ghost, label: l10n.commonRetry),
            ],
          ),
        ),
      );
    }
    final loaded = state as TransactionExplorerLoaded;
    if (loaded.transactions.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textMutedLight),
              AppSpacing.gapH8,
              Text(l10n.txNoTransactions, style: AppTypography.bodyMedium),
            ],
          ),
        ),
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        ...loaded.transactions.map((tx) => _buildMobileCard(tx, l10n, isDark)),
        AppSpacing.gapH12,
        _buildPaginationBar(loaded, l10n),
      ],
    );
  }

  Widget _buildMobileCard(Transaction tx, AppLocalizations l10n, bool isDark) {
    return PosCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: () => context.push('${Routes.transactions}/${tx.id}'),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(tx.transactionNumber, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
              ),
              PosBadge(label: _typeLabel(tx.type, l10n), variant: _typeVariant(tx.type), isSmall: true),
            ],
          ),
          AppSpacing.gapH4,
          Row(
            children: [
              PosBadge(label: _statusLabel(tx.status, l10n), variant: _statusVariant(tx.status), isSmall: true),
              const Spacer(),
              Text(
                tx.totalAmount.toStringAsFixed(3),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          if (tx.createdAt != null) ...[
            AppSpacing.gapH4,
            Text(
              '${tx.createdAt!.day}/${tx.createdAt!.month}/${tx.createdAt!.year} ${tx.createdAt!.hour.toString().padLeft(2, '0')}:${tx.createdAt!.minute.toString().padLeft(2, '0')}',
              style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaginationBar(TransactionExplorerLoaded loaded, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: loaded.currentPage > 1 ? () => ref.read(transactionExplorerProvider.notifier).previousPage() : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text('${loaded.currentPage} / ${loaded.lastPage}', style: AppTypography.bodySmall),
        IconButton(
          onPressed: loaded.hasMore ? () => ref.read(transactionExplorerProvider.notifier).nextPage() : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
