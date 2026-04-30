import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsDashboardPage extends ConsumerStatefulWidget {
  const AdminAnalyticsDashboardPage({super.key});

  @override
  ConsumerState<AdminAnalyticsDashboardPage> createState() => _AdminAnalyticsDashboardPageState();
}

class _AdminAnalyticsDashboardPageState extends ConsumerState<AdminAnalyticsDashboardPage> {
  String? _dateFrom;
  String? _dateTo;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(analyticsDashboardProvider.notifier).load());
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final range = await showPosDateRangePicker(context, firstDate: DateTime(now.year - 2), lastDate: now);
    if (range != null && mounted) {
      setState(() {
        _dateFrom = range.start.toIso8601String().substring(0, 10);
        _dateTo = range.end.toIso8601String().substring(0, 10);
      });
      ref.read(analyticsDashboardProvider.notifier).load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsDashboardProvider);

    return PosListPage(
      title: l10n.analyticsDashboard,
      showSearch: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.date_range_outlined),
          onPressed: _pickDateRange,
          tooltip: l10n.analyticsSelectDateRange,
        ),
      ],
      child: switch (state) {
        AnalyticsDashboardLoading() => PosLoadingSkeleton.list(),
        AnalyticsDashboardLoaded(kpi: final kpi, recentActivity: final activity) => RefreshIndicator(
          onRefresh: () => ref.read(analyticsDashboardProvider.notifier).load(),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (_dateFrom != null && _dateTo != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Wrap(
                    children: [
                      Chip(
                        label: Text('$_dateFrom → $_dateTo', style: const TextStyle(fontSize: 12)),
                        onDeleted: () => setState(() {
                          _dateFrom = null;
                          _dateTo = null;
                        }),
                      ),
                    ],
                  ),
                ),
              Text(l10n.adminKeyMetrics, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              PosKpiGrid(
                desktopCols: 4,
                mobileCols: 2,
                cards: [
                  PosKpiCard(
                    label: l10n.analyticsActiveStores,
                    value: '${kpi['total_active_stores'] ?? 0}',
                    icon: Icons.store_outlined,
                    iconColor: AppColors.info,
                  ),
                  PosKpiCard(
                    label: l10n.adminMRR,
                    value: 'SAR ${(kpi['mrr'] as num? ?? 0).toStringAsFixed(0)}',
                    icon: Icons.payments_outlined,
                    iconColor: AppColors.success,
                  ),
                  PosKpiCard(
                    label: l10n.analyticsNewSignups,
                    value: '${kpi['new_signups_this_month'] ?? 0}',
                    icon: Icons.person_add_outlined,
                    iconColor: AppColors.primary,
                  ),
                  PosKpiCard(
                    label: l10n.analyticsChurnRate,
                    value: '${kpi['churn_rate'] ?? 0}%',
                    icon: Icons.trending_down,
                    iconColor: AppColors.error,
                  ),
                  PosKpiCard(
                    label: l10n.analyticsTotalOrders,
                    value: '${kpi['total_orders'] ?? 0}',
                    icon: Icons.shopping_cart_outlined,
                    iconColor: AppColors.purple,
                  ),
                  PosKpiCard(
                    label: l10n.analyticsTotalGmv,
                    value: 'SAR ${(kpi['total_gmv'] as num? ?? 0).toStringAsFixed(0)}',
                    icon: Icons.bar_chart,
                    iconColor: AppColors.warning,
                  ),
                  PosKpiCard(
                    label: l10n.analyticsZatcaCompliance,
                    value: '${kpi['zatca_compliance_rate'] ?? 100}%',
                    icon: Icons.verified_outlined,
                    iconColor: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.securityRecentActivity, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              if (activity.isEmpty)
                PosEmptyState(title: l10n.adminNoActivity)
              else
                ...activity.map(
                  (a) => PosCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.history_outlined, color: AppColors.primary, size: 18),
                      ),
                      title: Text(a['action'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(a['entity_type'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                      trailing: Text(
                        _shortDate(a['created_at']),
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        AnalyticsDashboardError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosErrorState(message: msg),
              const SizedBox(height: AppSpacing.sm),
              PosButton(onPressed: () => ref.read(analyticsDashboardProvider.notifier).load(), label: l10n.retry),
            ],
          ),
        ),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }

  String _shortDate(dynamic raw) {
    if (raw == null) return '';
    final s = raw.toString();
    return s.length >= 10 ? s.substring(0, 10) : s;
  }
}
