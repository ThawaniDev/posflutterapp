import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_export_sheet.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class InventoryReportPage extends ConsumerStatefulWidget {
  const InventoryReportPage({super.key});

  @override
  ConsumerState<InventoryReportPage> createState() => _InventoryReportPageState();
}

class _InventoryReportPageState extends ConsumerState<InventoryReportPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryValuationProvider.notifier).load(filters: _filters);
      ref.read(inventoryLowStockProvider.notifier).load(filters: _filters);
    });
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        ref.read(inventoryValuationProvider.notifier).load(filters: _filters);
      case 1:
        ref.read(inventoryTurnoverProvider.notifier).load(filters: _filters);
      case 2:
        ref.read(inventoryShrinkageProvider.notifier).load(filters: _filters);
      case 3:
        ref.read(inventoryLowStockProvider.notifier).load(filters: _filters);
      case 4:
        ref.read(inventoryExpiryProvider.notifier).load(filters: _filters);
    }
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _onTabChanged(_currentTab);
  }

  // null means the current tab has no export support
  String? get _exportType => const [
    'inventory_valuation',
    null,
    null,
    'inventory_low_stock',
    'inventory_expiry',
  ][_currentTab];

  @override
  Widget build(BuildContext context) {
    return PermissionGuardPage(
      permission: Permissions.reportsInventory,
      child: PosListPage(
        title: l10n.reportsInventory,
        showSearch: false,
        actions: [
          if (_exportType != null)
            PosButton.icon(
              icon: Icons.download_rounded,
              tooltip: l10n.reportsExportFormatTitle,
              variant: PosButtonVariant.ghost,
              onPressed: () => showReportExportSheet(
                context: context,
                reportType: _exportType!,
                filters: _filters,
              ),
            ),
        ],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PosTabs(
                selectedIndex: _currentTab,
                onChanged: (i) => setState(() {
                  _currentTab = i;
                  _onTabChanged(i);
                }),
                tabs: [
                  PosTabItem(label: l10n.reportsValuation),
                  PosTabItem(label: l10n.reportsTurnover),
                  PosTabItem(label: l10n.reportsShrinkage),
                  PosTabItem(label: l10n.reportsLowStock),
                  PosTabItem(label: l10n.reportsExpiryTab),
                ],
              ),
            ),
            ReportFilterPanel(
              filters: _filters,
              onFiltersChanged: _onFiltersChanged,
              onRefresh: () => _onTabChanged(_currentTab),
              showCategoryFilter: true,
            ),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: const [_ValuationTab(), _TurnoverTab(), _ShrinkageTab(), _LowStockTab(), _ExpiryTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Valuation Tab ───────────────────────────────────────────

class _ValuationTab extends ConsumerWidget {
  const _ValuationTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(inventoryValuationProvider);

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
                  label: l10n.reportsTotalStockValue,
                  value: formatCurrency((data['total_stock_value'] as num?) ?? 0),
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: l10n.reportsTotalItems,
                  value: formatCompact((data['total_items'] as num?) ?? 0),
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: l10n.reportsProductCount,
                  value: '${data['product_count'] ?? 0}',
                  icon: Icons.category_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Bar chart — Top products by stock value
            if ((data['products'] as List?)?.isNotEmpty ?? false) ...[
              ReportSectionHeader(title: l10n.reportsStockValueDistribution, icon: Icons.bar_chart_rounded),
              ReportDataCard(
                child: ReportBarChart(
                  data: (data['products'] as List).cast<Map<String, dynamic>>().take(10).toList(),
                  labelKey: 'product_name',
                  valueKey: 'stock_value',
                  barColor: AppColors.success,
                  horizontal: true,
                ),
              ),
              const SizedBox(height: 24),
            ],
            ReportSectionHeader(title: l10n.products, icon: Icons.list_rounded),
            if ((data['products'] as List?)?.isEmpty ?? true)
              PosEmptyState(title: l10n.reportsNoStockData, icon: Icons.inventory_2)
            else
              ReportDataCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: List.generate((data['products'] as List).length, (i) {
                    final p = (data['products'] as List).cast<Map<String, dynamic>>()[i];
                    final qty = (p['quantity'] as num?)?.toInt() ?? 0;
                    final avgCost = (p['average_cost'] != null ? double.tryParse(p['average_cost'].toString()) : null) ?? 0;
                    final stockVal = (p['stock_value'] != null ? double.tryParse(p['stock_value'].toString()) : null) ?? 0;
                    return Column(
                      children: [
                        if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                        ReportRankedItem(
                          rank: i + 1,
                          title: p['product_name'] as String? ?? '',
                          subtitle: l10n.reportQtyTimesAvg(qty.toString(), formatCurrency(avgCost)),
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(inventoryTurnoverProvider);

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
                children: [PosEmptyState(title: l10n.reportsNoTurnoverData, icon: Icons.sync)],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ReportSectionHeader(title: l10n.reportsProductTurnover, icon: Icons.sync_rounded),
                  ReportDataCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: List.generate(products.length, (i) {
                        final p = products[i];
                        final ratio = (p['turnover_ratio'] != null ? double.tryParse(p['turnover_ratio'].toString()) : null) ?? 0;
                        final cogs = (p['cogs'] != null ? double.tryParse(p['cogs'].toString()) : null) ?? 0;
                        final stock = (p['current_stock'] as num?)?.toInt() ?? 0;
                        final ratioColor = ratio > 2
                            ? AppColors.success
                            : ratio > 1
                            ? AppColors.warning
                            : AppColors.error;

                        return Column(
                          children: [
                            if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                            ReportRankedItem(
                              rank: i + 1,
                              title: p['product_name'] as String? ?? '',
                              subtitle: l10n.reportCogsStock(formatCurrency(cogs), stock.toString()),
                              trailingValue: '${ratio.toStringAsFixed(2)}x',
                              trailingColor: ratioColor,
                              badges: [ReportBadge(label: ratio > 1 ? l10n.reportHealthy : l10n.reportSlow, color: ratioColor)],
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(inventoryShrinkageProvider);

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
            ReportSectionHeader(title: l10n.reportsShrinkageByReason, icon: Icons.warning_amber_rounded),
            if ((data['by_reason'] as List?)?.isEmpty ?? true)
              PosEmptyState(title: l10n.reportsNoShrinkageData, icon: Icons.warning_amber)
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
                        if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: AppRadius.borderMd,
                                ),
                                child: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
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
                                      l10n.reportNUnits(qty.toString()),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.mutedFor(context),
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
            ReportSectionHeader(title: l10n.reportsShrinkageByProduct, icon: Icons.inventory_rounded),
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
                        if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                        ReportRankedItem(
                          rank: i + 1,
                          title: p['product_name'] as String? ?? '',
                          subtitle: l10n.reportNUnitsLost(qty.toString()),
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(inventoryLowStockProvider);

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
                children: [PosEmptyState(title: l10n.reportsAllStockLevelsOk, icon: Icons.check_circle)],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ReportSectionHeader(title: l10n.companionLowStock, icon: Icons.warning_rounded),
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
                          borderRadius: AppRadius.borderLg,
                          border: Border.all(color: alertColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: alertColor.withValues(alpha: 0.1),
                                borderRadius: AppRadius.borderMd,
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
                                    l10n.reportStockReorder(current.toString(), reorder.toString()),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.mutedFor(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ReportBadge(label: l10n.reportNeedN(deficit.toString()), color: alertColor),
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

// ─── Expiry Tab ──────────────────────────────────────────────

class _ExpiryTab extends ConsumerWidget {
  const _ExpiryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(inventoryExpiryProvider);

    return switch (state) {
      InventoryExpiryInitial() || InventoryExpiryLoading() => PosLoadingSkeleton.list(),
      InventoryExpiryError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(inventoryExpiryProvider.notifier).load(),
      ),
      InventoryExpiryLoaded(:final data) => RefreshIndicator(
        onRefresh: () => ref.read(inventoryExpiryProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // KPI totals row
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: l10n.reportsExpiryExpired,
                  value: '${(data['totals'] as Map?)?.cast<String, dynamic>()['expired_count'] ?? 0}',
                  icon: Icons.error_rounded,
                  color: AppColors.error,
                ),
                ReportKpiCard(
                  label: l10n.reportsExpiryCritical,
                  value: '${(data['totals'] as Map?)?.cast<String, dynamic>()['critical_count'] ?? 0}',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.warning,
                ),
                ReportKpiCard(
                  label: l10n.reportsExpiryWarning,
                  value: '${(data['totals'] as Map?)?.cast<String, dynamic>()['warning_count'] ?? 0}',
                  icon: Icons.info_rounded,
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Expired section
            if ((data['expired'] as List?)?.isNotEmpty ?? false) ...[
              ReportSectionHeader(
                title: l10n.reportsExpiryExpired,
                icon: Icons.error_rounded,
              ),
              _ExpiryItemList(
                items: (data['expired'] as List).cast<Map<String, dynamic>>(),
                badgeColor: AppColors.error,
                l10n: l10n,
              ),
              const SizedBox(height: 20),
            ],

            // Critical section
            if ((data['critical'] as List?)?.isNotEmpty ?? false) ...[
              ReportSectionHeader(
                title: l10n.reportsExpiryCritical,
                icon: Icons.warning_amber_rounded,
              ),
              _ExpiryItemList(
                items: (data['critical'] as List).cast<Map<String, dynamic>>(),
                badgeColor: AppColors.warning,
                l10n: l10n,
              ),
              const SizedBox(height: 20),
            ],

            // Warning section
            if ((data['warning'] as List?)?.isNotEmpty ?? false) ...[
              ReportSectionHeader(
                title: l10n.reportsExpiryWarning,
                icon: Icons.info_rounded,
              ),
              _ExpiryItemList(
                items: (data['warning'] as List).cast<Map<String, dynamic>>(),
                badgeColor: AppColors.info,
                l10n: l10n,
              ),
            ],

            if ((data['expired'] as List?)?.isEmpty == true &&
                (data['critical'] as List?)?.isEmpty == true &&
                (data['warning'] as List?)?.isEmpty == true)
              PosEmptyState(title: l10n.reportsNoExpiryData, icon: Icons.check_circle),
          ],
        ),
      ),
    };
  }
}

class _ExpiryItemList extends StatelessWidget {
  const _ExpiryItemList({
    required this.items,
    required this.badgeColor,
    required this.l10n,
  });
  final List<Map<String, dynamic>> items;
  final Color badgeColor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ReportDataCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final days = (item['days_until_expiry'] as num?)?.toInt() ?? 0;
          final qty = (item['quantity'] as num?)?.toInt() ?? 0;
          final expDate = item['expiry_date'] as String? ?? '';
          return Column(
            children: [
              if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
              ReportRankedItem(
                rank: i + 1,
                title: item['product_name'] as String? ?? '',
                subtitle: item['sku'] as String?,
                trailingValue: days < 0 ? l10n.reportsExpiryExpired : l10n.reportsExpiryDaysLeft(days),
                trailingColor: badgeColor,
                badges: [
                  ReportBadge(label: l10n.reportsExpiryDate(expDate), color: badgeColor),
                  ReportBadge(label: l10n.reportNInStock(qty), color: AppColors.info),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
