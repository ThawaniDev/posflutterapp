import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

class InventoryReportPage extends ConsumerStatefulWidget {
  const InventoryReportPage({super.key});

  @override
  ConsumerState<InventoryReportPage> createState() => _InventoryReportPageState();
}

class _InventoryReportPageState extends ConsumerState<InventoryReportPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryValuationProvider.notifier).load();
      ref.read(inventoryLowStockProvider.notifier).load();
    });
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) _onTabChanged(_tabController.index);
    });
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        ref.read(inventoryValuationProvider.notifier).load();
      case 1:
        ref.read(inventoryTurnoverProvider.notifier).load();
      case 2:
        ref.read(inventoryShrinkageProvider.notifier).load();
      case 3:
        ref.read(inventoryLowStockProvider.notifier).load();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: const Text('Inventory Reports'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Valuation'),
            Tab(text: 'Turnover'),
            Tab(text: 'Shrinkage'),
            Tab(text: 'Low Stock'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_ValuationTab(), _TurnoverTab(), _ShrinkageTab(), _LowStockTab()],
      ),
    );
  }
}

// ─── Valuation Tab ───────────────────────────────────────────

class _ValuationTab extends ConsumerWidget {
  const _ValuationTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryValuationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state) {
      InventoryValuationInitial() || InventoryValuationLoading() => PosLoadingSkeleton.list(),
      InventoryValuationError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(inventoryValuationProvider.notifier).load(),
      ),
      InventoryValuationLoaded(:final data) => RefreshIndicator(
        onRefresh: () => ref.read(inventoryValuationProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: 'Total Stock Value',
                  value: formatCurrency((data['total_stock_value'] as num?) ?? 0),
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: 'Total Items',
                  value: formatCompact((data['total_items'] as num?) ?? 0),
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: 'Product Count',
                  value: '${data['product_count'] ?? 0}',
                  icon: Icons.category_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ReportSectionHeader(title: 'Products', icon: Icons.list_rounded),
            if ((data['products'] as List?)?.isEmpty ?? true)
              const PosEmptyState(title: 'No stock data', icon: Icons.inventory_2)
            else
              ReportDataCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: List.generate((data['products'] as List).length, (i) {
                    final p = (data['products'] as List).cast<Map<String, dynamic>>()[i];
                    final qty = (p['quantity'] as num?)?.toInt() ?? 0;
                    final avgCost = (p['average_cost'] as num?)?.toDouble() ?? 0;
                    final stockVal = (p['stock_value'] as num?)?.toDouble() ?? 0;
                    return Column(
                      children: [
                        if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ReportRankedItem(
                          rank: i + 1,
                          title: p['product_name'] as String? ?? '',
                          subtitle: 'Qty: $qty × ${formatCurrency(avgCost)}',
                          trailingValue: formatCurrency(stockVal),
                          trailingColor: AppColors.success,
                        ),
                      ],
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    };
  }
}

// ─── Turnover Tab ────────────────────────────────────────────

class _TurnoverTab extends ConsumerWidget {
  const _TurnoverTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryTurnoverProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state) {
      InventoryTurnoverInitial() || InventoryTurnoverLoading() => PosLoadingSkeleton.list(),
      InventoryTurnoverError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(inventoryTurnoverProvider.notifier).load(),
      ),
      InventoryTurnoverLoaded(:final products) => RefreshIndicator(
        onRefresh: () => ref.read(inventoryTurnoverProvider.notifier).load(),
        child: products.isEmpty
            ? ListView(
                children: const [PosEmptyState(title: 'No turnover data', icon: Icons.sync)],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const ReportSectionHeader(title: 'Product Turnover', icon: Icons.sync_rounded),
                  ReportDataCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: List.generate(products.length, (i) {
                        final p = products[i];
                        final ratio = (p['turnover_ratio'] as num?)?.toDouble() ?? 0;
                        final cogs = (p['cogs'] as num?)?.toDouble() ?? 0;
                        final stock = (p['current_stock'] as num?)?.toInt() ?? 0;
                        final ratioColor = ratio > 2
                            ? AppColors.success
                            : ratio > 1
                            ? AppColors.warning
                            : AppColors.error;

                        return Column(
                          children: [
                            if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ReportRankedItem(
                              rank: i + 1,
                              title: p['product_name'] as String? ?? '',
                              subtitle: 'COGS: ${formatCurrency(cogs)} · Stock: $stock',
                              trailingValue: '${ratio.toStringAsFixed(2)}x',
                              trailingColor: ratioColor,
                              badges: [ReportBadge(label: ratio > 1 ? 'Healthy' : 'Slow', color: ratioColor)],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
      ),
    };
  }
}

// ─── Shrinkage Tab ───────────────────────────────────────────

class _ShrinkageTab extends ConsumerWidget {
  const _ShrinkageTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryShrinkageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state) {
      InventoryShrinkageInitial() || InventoryShrinkageLoading() => PosLoadingSkeleton.list(),
      InventoryShrinkageError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(inventoryShrinkageProvider.notifier).load(),
      ),
      InventoryShrinkageLoaded(:final data) => RefreshIndicator(
        onRefresh: () => ref.read(inventoryShrinkageProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // By Reason
            const ReportSectionHeader(title: 'Shrinkage by Reason', icon: Icons.warning_amber_rounded),
            if ((data['by_reason'] as List?)?.isEmpty ?? true)
              const PosEmptyState(title: 'No shrinkage data', icon: Icons.warning_amber)
            else
              ReportDataCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: List.generate((data['by_reason'] as List).length, (i) {
                    final r = (data['by_reason'] as List).cast<Map<String, dynamic>>()[i];
                    final qty = (r['total_quantity'] as num?)?.abs().toInt() ?? 0;
                    final cost = (r['total_cost'] as num?)?.abs().toDouble() ?? 0;
                    return Column(
                      children: [
                        if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r['reason'] as String? ?? 'Unknown',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '$qty units',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '-${formatCurrency(cost)}',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

            const SizedBox(height: 24),

            // By Product
            const ReportSectionHeader(title: 'Shrinkage by Product', icon: Icons.inventory_rounded),
            if ((data['by_product'] as List?)?.isNotEmpty ?? false)
              ReportDataCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: List.generate((data['by_product'] as List).length, (i) {
                    final p = (data['by_product'] as List).cast<Map<String, dynamic>>()[i];
                    final qty = (p['total_quantity'] as num?)?.abs().toInt() ?? 0;
                    final cost = (p['total_cost'] as num?)?.abs().toDouble() ?? 0;
                    return Column(
                      children: [
                        if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ReportRankedItem(
                          rank: i + 1,
                          title: p['product_name'] as String? ?? '',
                          subtitle: '$qty units lost',
                          trailingValue: '-${formatCurrency(cost)}',
                          trailingColor: AppColors.error,
                        ),
                      ],
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    };
  }
}

// ─── Low Stock Tab ───────────────────────────────────────────

class _LowStockTab extends ConsumerWidget {
  const _LowStockTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryLowStockProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state) {
      InventoryLowStockInitial() || InventoryLowStockLoading() => PosLoadingSkeleton.list(),
      InventoryLowStockError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(inventoryLowStockProvider.notifier).load(),
      ),
      InventoryLowStockLoaded(:final products) => RefreshIndicator(
        onRefresh: () => ref.read(inventoryLowStockProvider.notifier).load(),
        child: products.isEmpty
            ? ListView(
                children: const [PosEmptyState(title: 'All stock levels OK', icon: Icons.check_circle)],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const ReportSectionHeader(title: 'Low Stock Items', icon: Icons.warning_rounded),
                  ...products.map((p) {
                    final current = (p['current_stock'] as num?)?.toInt() ?? 0;
                    final reorder = (p['reorder_point'] as num?)?.toInt() ?? 0;
                    final deficit = (p['deficit'] as num?)?.toInt() ?? 0;
                    final isOutOfStock = current == 0;
                    final alertColor = isOutOfStock ? AppColors.error : AppColors.warning;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: alertColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: alertColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: alertColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isOutOfStock ? Icons.error_rounded : Icons.warning_amber_rounded,
                                color: alertColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p['product_name'] as String? ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Stock: $current · Reorder at: $reorder',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ReportBadge(label: 'Need $deficit', color: alertColor),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
      ),
    };
  }
}
