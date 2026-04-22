import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsSubscriptionsPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSubscriptionsPage({super.key});

  @override
  ConsumerState<AdminAnalyticsSubscriptionsPage> createState() => _AdminAnalyticsSubscriptionsPageState();
}

class _AdminAnalyticsSubscriptionsPageState extends ConsumerState<AdminAnalyticsSubscriptionsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId);
  }

  Color _statusColor(String status) {
    return switch (status) {
      'active' => AppColors.success,
      'trial' => AppColors.info,
      'cancelled' => AppColors.error,
      'past_due' => AppColors.warning,
      'expired' => AppColors.textSecondary,
      _ => AppColors.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsSubscriptionsProvider);

    return PosListPage(
  title: l10n.analyticsSubscriptions,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.download, onPressed: () => ref.read(analyticsExportProvider.notifier).exportSubscriptions(), tooltip: l10n.adminExportSubscriptions,
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              AnalyticsSubscriptionsLoading() => const Center(child: CircularProgressIndicator()),
              AnalyticsSubscriptionsLoaded(
                statusCounts: final counts,
                averageSubscriptionAgeDays: final avgAge,
                totalChurnInPeriod: final churn,
                trialToPaidConversionRate: final conversion,
                lifecycleTrend: final trend,
              ) =>
                RefreshIndicator(
                  onRefresh: () => ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      // Conversion & Churn highlights
                      PosKpiGrid(
                        desktopCols: 3,
                        mobileCols: 2,
                        cards: [
                          PosKpiCard(
                            label: l10n.adminConversionRate,
                            value: '${conversion.toStringAsFixed(1)}%',
                            iconColor: AppColors.success,
                          ),
                          PosKpiCard(label: l10n.adminChurnPeriod, value: '$churn', iconColor: AppColors.error),
                          PosKpiCard(label: l10n.adminAvgSubAge, value: '${avgAge.toStringAsFixed(0)} days', iconColor: AppColors.info),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Status breakdown
                      Text(l10n.adminStatusBreakdown, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      ...counts.entries.map(
                        (e) => PosCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _statusColor(e.key).withValues(alpha: 0.2),
                              child: Icon(Icons.circle, color: _statusColor(e.key), size: 16),
                            ),
                            title: Text(e.key.toUpperCase()),
                            trailing: Text('${e.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Lifecycle trend
                      Text(l10n.adminLifecycleTrend, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (trend.isEmpty)
                        PosCard(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Text(l10n.adminNoTrendData)),
                        )
                      else
                        ...trend.map(
                          (t) => PosCard(
                            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: ListTile(
                              title: Text(t['date'] as String? ?? ''),
                              subtitle: Text(
                                'Active: ${t['active'] ?? 0} | Trial: ${t['trial'] ?? 0} | Churned: ${t['churned'] ?? 0}',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              AnalyticsSubscriptionsError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError(msg)),
                    const SizedBox(height: AppSpacing.sm),
                    PosButton(
                      onPressed: () => ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId),
                      label: l10n.retry,
                    ),
                  ],
                ),
              ),
              _ => Center(child: Text(l10n.adminLoadingSubAnalytics)),
            },
          ),
        ],
      ),
);
  }
}
