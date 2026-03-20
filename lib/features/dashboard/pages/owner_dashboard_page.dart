import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/features/dashboard/providers/dashboard_providers.dart';
import 'package:thawani_pos/features/dashboard/providers/dashboard_state.dart';
import 'package:thawani_pos/features/dashboard/widgets/active_cashiers_list.dart';
import 'package:thawani_pos/features/dashboard/widgets/dashboard_kpi_cards.dart';
import 'package:thawani_pos/features/dashboard/widgets/low_stock_alerts.dart';
import 'package:thawani_pos/features/dashboard/widgets/recent_orders_list.dart';
import 'package:thawani_pos/features/dashboard/widgets/sales_trend_chart.dart';
import 'package:thawani_pos/features/dashboard/widgets/top_products_table.dart';

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
                label: const Text('Retry'),
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
      ) =>
        RefreshIndicator(
          onRefresh: () => ref.read(ownerDashboardProvider.notifier).load(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;

              return ListView(
                padding: AppSpacing.paddingAll16,
                children: [
                  // KPI Cards
                  DashboardKpiCards(stats: stats),
                  AppSpacing.gapH16,

                  // Sales Trend Chart (full width)
                  SalesTrendChart(salesTrend: salesTrend),
                  AppSpacing.gapH16,

                  // Two-column layout on wide screens
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              TopProductsTable(products: topProducts),
                              AppSpacing.gapH16,
                              RecentOrdersList(orders: recentOrders),
                            ],
                          ),
                        ),
                        AppSpacing.gapW16,
                        // Right column
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              LowStockAlerts(items: lowStock),
                              AppSpacing.gapH16,
                              ActiveCashiersList(cashiers: activeCashiers),
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    TopProductsTable(products: topProducts),
                    AppSpacing.gapH16,
                    LowStockAlerts(items: lowStock),
                    AppSpacing.gapH16,
                    ActiveCashiersList(cashiers: activeCashiers),
                    AppSpacing.gapH16,
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
