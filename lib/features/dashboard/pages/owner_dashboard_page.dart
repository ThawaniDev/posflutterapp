import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/dashboard/providers/dashboard_providers.dart';
import 'package:thawani_pos/features/dashboard/providers/dashboard_state.dart';
import 'package:thawani_pos/features/dashboard/widgets/active_cashiers_list.dart';
import 'package:thawani_pos/features/dashboard/widgets/branch_overview_card.dart';
import 'package:thawani_pos/features/dashboard/widgets/dashboard_kpi_cards.dart';
import 'package:thawani_pos/features/dashboard/widgets/financial_summary_card.dart';
import 'package:thawani_pos/features/dashboard/widgets/hourly_sales_chart.dart';
import 'package:thawani_pos/features/dashboard/widgets/low_stock_alerts.dart';
import 'package:thawani_pos/features/dashboard/widgets/recent_orders_list.dart';
import 'package:thawani_pos/features/dashboard/widgets/sales_trend_chart.dart';
import 'package:thawani_pos/features/dashboard/widgets/staff_performance_card.dart';
import 'package:thawani_pos/features/dashboard/widgets/top_products_table.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_dashboard_widget.dart';

class OwnerDashboardPage extends ConsumerStatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  ConsumerState<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends ConsumerState<OwnerDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ownerDashboardProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(ownerDashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state) {
      OwnerDashboardInitial() || OwnerDashboardLoading() => const Center(child: CircularProgressIndicator()),
      OwnerDashboardError(:final message) => Center(
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              AppSpacing.gapH12,
              Text(
                message,
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapH16,
              FilledButton.icon(
                onPressed: () => ref.read(ownerDashboardProvider.notifier).load(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
      OwnerDashboardLoaded(
        :final stats,
        :final salesTrend,
        :final topProducts,
        :final lowStock,
        :final activeCashiers,
        :final recentOrders,
        :final financialSummary,
        :final hourlySales,
        :final staffPerformance,
        :final branches,
      ) =>
        RefreshIndicator(
          onRefresh: () => ref.read(ownerDashboardProvider.notifier).load(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isMobile = context.isPhone;
              final gap = isMobile ? 12.0 : 16.0;
              final padding = isMobile ? const EdgeInsets.all(12.0) : AppSpacing.paddingAll16;

              return ListView(
                padding: padding,
                children: [
                  // ─── KPI Cards ───────────────────────────────
                  DashboardKpiCards(stats: stats),
                  SizedBox(height: gap),

                  // ─── Wameed AI Insights ──────────────────────
                  const AIDashboardWidget(),
                  SizedBox(height: gap),

                  // ─── Sales Trend + Hourly Sales ──────────────
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: SalesTrendChart(salesTrend: salesTrend)),
                        SizedBox(width: gap),
                        Expanded(flex: 2, child: HourlySalesChart(data: hourlySales)),
                      ],
                    )
                  else ...[
                    SalesTrendChart(salesTrend: salesTrend),
                    SizedBox(height: gap),
                    HourlySalesChart(data: hourlySales),
                  ],
                  SizedBox(height: gap),

                  // ─── Financial Summary + Top Products ────────
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: FinancialSummaryCard(data: financialSummary)),
                        SizedBox(width: gap),
                        Expanded(child: TopProductsTable(products: topProducts)),
                      ],
                    )
                  else ...[
                    FinancialSummaryCard(data: financialSummary),
                    SizedBox(height: gap),
                    TopProductsTable(products: topProducts),
                  ],
                  SizedBox(height: gap),

                  // ─── Staff Performance + Active Cashiers ─────
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: StaffPerformanceCard(staff: staffPerformance)),
                        SizedBox(width: gap),
                        Expanded(flex: 2, child: ActiveCashiersList(cashiers: activeCashiers)),
                      ],
                    )
                  else ...[
                    StaffPerformanceCard(staff: staffPerformance),
                    SizedBox(height: gap),
                    ActiveCashiersList(cashiers: activeCashiers),
                  ],
                  SizedBox(height: gap),

                  // ─── Branch Overview (only if multiple) ──────
                  BranchOverviewCard(branches: branches),
                  if (branches.length > 1) SizedBox(height: gap),

                  // ─── Low Stock + Recent Orders ───────────────
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: LowStockAlerts(items: lowStock)),
                        SizedBox(width: gap),
                        Expanded(child: RecentOrdersList(orders: recentOrders)),
                      ],
                    )
                  else ...[
                    LowStockAlerts(items: lowStock),
                    SizedBox(height: gap),
                    RecentOrdersList(orders: recentOrders),
                  ],
                ],
              );
            },
          ),
        ),
    };
  }
}
