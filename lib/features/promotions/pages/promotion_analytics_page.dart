import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/promotions/models/promotion_usage_log.dart';
import 'package:wameedpos/features/promotions/providers/promotion_providers.dart';
import 'package:wameedpos/features/promotions/providers/promotion_state.dart';

class PromotionAnalyticsPage extends ConsumerStatefulWidget {
  const PromotionAnalyticsPage({super.key, required this.promotionId});
  final String promotionId;

  @override
  ConsumerState<PromotionAnalyticsPage> createState() => _PromotionAnalyticsPageState();
}

class _PromotionAnalyticsPageState extends ConsumerState<PromotionAnalyticsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(promotionAnalyticsProvider(widget.promotionId).notifier).load();
      ref.read(promotionUsageLogProvider(widget.promotionId).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(promotionAnalyticsProvider(widget.promotionId));
    final isLoading = analyticsState is PromotionAnalyticsInitial || analyticsState is PromotionAnalyticsLoading;
    final hasError = analyticsState is PromotionAnalyticsError;

    return PermissionGuardPage(
      permission: Permissions.promotionsViewAnalytics,
      child: PosListPage(
        title: l10n.promotionsAnalytics,
        showSearch: false,
        isLoading: isLoading,
        hasError: hasError,
        errorMessage: hasError ? (analyticsState as PromotionAnalyticsError).message : null,
        onRetry: () => ref.read(promotionAnalyticsProvider(widget.promotionId).notifier).load(),
        child: analyticsState is PromotionAnalyticsLoaded
            ? _buildContent(context, analyticsState.analytics)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ─── KPI Grid ─────────────────────────────────────────────
        PosKpiGrid(
          desktopCols: 4,
          mobileCols: 2,
          cards: [
            PosKpiCard(
              label: l10n.promotionsTotalUses,
              value: '${data['usage_count'] ?? 0}',
              icon: Icons.receipt_long_rounded,
              iconColor: AppColors.primary,
            ),
            PosKpiCard(
              label: l10n.promotionsTotalDiscount,
              value: 'SAR ${_fmt(data['total_discount_given'])}',
              icon: Icons.discount_rounded,
              iconColor: AppColors.info,
            ),
            PosKpiCard(
              label: l10n.promotionsUniqueCustomers,
              value: '${data['unique_customers'] ?? 0}',
              icon: Icons.people_alt_rounded,
              iconColor: AppColors.success,
            ),
            PosKpiCard(
              label: l10n.promotionsActiveCoupons,
              value: '${data['active_coupons'] ?? 0} / ${data['total_coupons'] ?? 0}',
              icon: Icons.confirmation_number_rounded,
              iconColor: AppColors.warning,
            ),
          ],
        ),

        AppSpacing.gapH24,

        // ─── Daily Usage Chart ────────────────────────────────────
        _DailyUsageChart(dailyData: _parseDailyUsage(data['daily_usage'])),

        AppSpacing.gapH24,

        // ─── Performance breakdown ────────────────────────────────
        Text(l10n.promotionsPerformance, style: theme.textTheme.titleMedium),
        AppSpacing.gapH12,
        PosCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _InfoRow(label: l10n.promotionsAvgDiscountPerUse, value: 'SAR ${_avgDiscount(data)}'),
                const Divider(height: 1),
                _InfoRow(label: l10n.promotionsCouponRedemptionRate, value: _redemptionRate(data)),
                const Divider(height: 1),
                _InfoRow(label: l10n.couponUses, value: '${data['coupon_uses'] ?? 0}'),
                const Divider(height: 1),
                _InfoRow(label: l10n.autoUses, value: '${data['auto_uses'] ?? 0}'),
                if (data['max_uses'] != null) ...[
                  const Divider(height: 1),
                  _InfoRow(
                    label: l10n.usageLimitProgress,
                    value: '${data['usage_count'] ?? 0} / ${data['max_uses']}',
                    showProgress: true,
                    progressValue: (data['max_uses'] as num) > 0
                        ? ((data['usage_count'] as num? ?? 0) / (data['max_uses'] as num)).clamp(0.0, 1.0).toDouble()
                        : 0.0,
                  ),
                ],
              ],
            ),
          ),
        ),

        AppSpacing.gapH24,

        // ─── Usage History ─────────────────────────────────────────
        _UsageHistorySection(promotionId: widget.promotionId),

        AppSpacing.gapH24,
      ],
    );
  }

  List<Map<String, dynamic>> _parseDailyUsage(dynamic raw) {
    if (raw is! List) return [];
    return raw.cast<Map<String, dynamic>>();
  }

  String _fmt(dynamic value) => (double.tryParse(value?.toString() ?? '') ?? 0.0).toStringAsFixed(2);

  String _avgDiscount(Map<String, dynamic> data) {
    final total = double.tryParse(data['total_discount_given']?.toString() ?? '') ?? 0;
    final count = (data['usage_count'] as num?)?.toInt() ?? 0;
    if (count == 0) return '0.00';
    return (total / count).toStringAsFixed(2);
  }

  String _redemptionRate(Map<String, dynamic> data) {
    final totalCoupons = (data['total_coupons'] as num?)?.toInt() ?? 0;
    final activeCoupons = (data['active_coupons'] as num?)?.toInt() ?? 0;
    if (totalCoupons == 0) return l10n.notApplicable;
    final used = totalCoupons - activeCoupons;
    return '${(used / totalCoupons * 100).toStringAsFixed(1)}%';
  }
}

// ─── Daily Usage Chart ──────────────────────────────────────────

class _DailyUsageChart extends StatelessWidget {
  const _DailyUsageChart({required this.dailyData});
  final List<Map<String, dynamic>> dailyData;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasData = dailyData.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dailyUsageLast30Days, style: theme.textTheme.titleMedium),
        AppSpacing.gapH12,
        PosCard(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: SizedBox(
              height: 180,
              child: hasData
                  ? _buildChart(context)
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bar_chart_rounded, size: 40, color: AppColors.neutral300),
                          AppSpacing.gapH8,
                          Text(l10n.noUsageData, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.neutral400)),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    final spots = <BarChartGroupData>[];
    final dates = <int, String>{};
    final maxY = dailyData.fold<double>(
      0,
      (max, d) => (d['uses'] as num? ?? 0).toDouble() > max ? (d['uses'] as num).toDouble() : max,
    );

    for (var i = 0; i < dailyData.length; i++) {
      final d = dailyData[i];
      final uses = (d['uses'] as num? ?? 0).toDouble();
      dates[i] = (d['date'] as String).substring(5); // MM-DD
      spots.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: uses,
              color: AppColors.primary,
              width: dailyData.length <= 7
                  ? 16
                  : dailyData.length <= 14
                  ? 10
                  : 6,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        maxY: (maxY + 1).ceilToDouble(),
        alignment: BarChartAlignment.spaceAround,
        barGroups: spots,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.neutral200, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (v, meta) =>
                  Text(v.toInt().toString(), style: TextStyle(fontSize: 10, color: AppColors.neutral400)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: dailyData.length <= 14,
              reservedSize: 20,
              getTitlesWidget: (v, meta) {
                final idx = v.toInt();
                final label = dates[idx] ?? '';
                return Text(label, style: TextStyle(fontSize: 9, color: AppColors.neutral400));
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, _, rod, __) =>
                BarTooltipItem('${dates[group.x] ?? ''}\n${rod.toY.toInt()} uses', TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ),
      ),
    );
  }
}

// ─── Usage History Section ──────────────────────────────────────

class _UsageHistorySection extends ConsumerWidget {
  const _UsageHistorySection({required this.promotionId});
  final String promotionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final logState = ref.watch(promotionUsageLogProvider(promotionId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.usageHistory, style: theme.textTheme.titleMedium),
            const Spacer(),
            if (logState is PromotionUsageLogLoaded && logState.hasMore)
              TextButton(
                onPressed: () => ref.read(promotionUsageLogProvider(promotionId).notifier).loadMore(),
                child: Text(l10n.loadMore),
              ),
          ],
        ),
        AppSpacing.gapH12,
        switch (logState) {
          PromotionUsageLogInitial() || PromotionUsageLogLoading() => const Center(child: PosLoading()),
          PromotionUsageLogError(:final message) => PosErrorState(
            message: message,
            onRetry: () => ref.read(promotionUsageLogProvider(promotionId).notifier).load(),
          ),
          PromotionUsageLogLoaded(:final items) =>
            items.isEmpty ? PosEmptyState(icon: Icons.history_rounded, title: l10n.noUsageHistory) : _UsageLogTable(items: items),
        },
      ],
    );
  }
}

class _UsageLogTable extends StatelessWidget {
  const _UsageLogTable({required this.items});
  final List<PromotionUsageLog> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PosCard(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(l10n.orderId, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.neutral500)),
                ),
                Expanded(
                  flex: 2,
                  child: Text(l10n.customer, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.neutral500)),
                ),
                Expanded(
                  flex: 2,
                  child: Text(l10n.discountAmount, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.neutral500)),
                ),
                Expanded(
                  flex: 2,
                  child: Text(l10n.date, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.neutral500)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final log = entry.value;
            return Column(
              children: [
                if (idx > 0) const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          log.orderId.length > 8 ? '...${log.orderId.substring(log.orderId.length - 8)}' : log.orderId,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          log.customerId != null
                              ? (log.customerId!.length > 8
                                    ? '...${log.customerId!.substring(log.customerId!.length - 8)}'
                                    : log.customerId!)
                              : l10n.guest,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'SAR ${log.discountAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          log.createdAt != null ? _formatDate(log.createdAt!) : '-',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

// ─── Helper Widgets ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.showProgress = false, this.progressValue});
  final String label;
  final String value;
  final bool showProgress;
  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          if (showProgress && progressValue != null) ...[
            AppSpacing.gapH6,
            ClipRRect(
              borderRadius: AppRadius.borderSm,
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 6,
                backgroundColor: AppColors.neutral200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressValue! >= 0.9
                      ? AppColors.error
                      : progressValue! >= 0.6
                      ? AppColors.warning
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PromotionAnalyticsPage extends ConsumerStatefulWidget {
  const PromotionAnalyticsPage({super.key, required this.promotionId});
  final String promotionId;

  @override
  ConsumerState<PromotionAnalyticsPage> createState() => _PromotionAnalyticsPageState();
}

class _PromotionAnalyticsPageState extends ConsumerState<PromotionAnalyticsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(promotionAnalyticsProvider(widget.promotionId).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(promotionAnalyticsProvider(widget.promotionId));
    final isLoading = state is PromotionAnalyticsInitial || state is PromotionAnalyticsLoading;
    final hasError = state is PromotionAnalyticsError;

    return PosListPage(
      title: l10n.promotionsAnalytics,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(promotionAnalyticsProvider(widget.promotionId).notifier).load(),
      child: state is PromotionAnalyticsLoaded ? _buildAnalytics(context, state.analytics) : const SizedBox.shrink(),
    );
  }

  Widget _buildAnalytics(BuildContext context, Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary cards
        PosKpiGrid(
          desktopCols: 3,
          mobileCols: 2,
          cards: [
            PosKpiCard(
              label: l10n.promotionsTotalUses,
              value: '${data['usage_count'] ?? 0}',
              icon: Icons.receipt_long,
              iconColor: theme.colorScheme.primary,
            ),
            PosKpiCard(
              label: l10n.promotionsTotalDiscount,
              value: (data['total_discount_given'] as num?)?.toStringAsFixed(2) ?? '0.00',
              icon: Icons.discount,
              iconColor: theme.colorScheme.tertiary,
            ),
            PosKpiCard(
              label: l10n.promotionsUniqueCustomers,
              value: '${data['unique_customers'] ?? 0}',
              icon: Icons.people,
              iconColor: theme.colorScheme.secondary,
            ),
            PosKpiCard(
              label: l10n.promotionsActiveCoupons,
              value: '${data['active_coupons'] ?? 0}',
              icon: Icons.confirmation_number,
              iconColor: AppColors.success,
            ),
            PosKpiCard(
              label: l10n.promotionsTotalCoupons,
              value: '${data['total_coupons'] ?? 0}',
              icon: Icons.inventory_2,
              iconColor: AppColors.warning,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(l10n.promotionsPerformance, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        PosCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: l10n.promotionsAvgDiscountPerUse, value: _avgDiscount(data)),
                const Divider(),
                _InfoRow(label: l10n.promotionsCouponRedemptionRate, value: _redemptionRate(data)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _avgDiscount(Map<String, dynamic> data) {
    final total = (data['total_discount_given'] != null ? double.tryParse(data['total_discount_given'].toString()) : null) ?? 0;
    final count = (data['usage_count'] as num?)?.toInt() ?? 0;
    if (count == 0) return '0.00';
    return (total / count).toStringAsFixed(2);
  }

  String _redemptionRate(Map<String, dynamic> data) {
    final totalCoupons = (data['total_coupons'] as num?)?.toInt() ?? 0;
    final activeCoupons = (data['active_coupons'] as num?)?.toInt() ?? 0;
    if (totalCoupons == 0) return 'N/A';
    final used = totalCoupons - activeCoupons;
    return '${(used / totalCoupons * 100).toStringAsFixed(1)}%';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
