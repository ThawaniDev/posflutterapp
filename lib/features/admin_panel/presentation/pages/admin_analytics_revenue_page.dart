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

class AdminAnalyticsRevenuePage extends ConsumerStatefulWidget {
  const AdminAnalyticsRevenuePage({super.key});

  @override
  ConsumerState<AdminAnalyticsRevenuePage> createState() => _AdminAnalyticsRevenuePageState();
}

class _AdminAnalyticsRevenuePageState extends ConsumerState<AdminAnalyticsRevenuePage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(analyticsRevenueProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(analyticsRevenueProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsRevenueProvider);

    return PosListPage(
  title: l10n.analyticsRevenue,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.download, onPressed: () => ref.read(analyticsExportProvider.notifier).exportRevenue(), tooltip: 'Export Revenue',
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              AnalyticsRevenueLoading() => const Center(child: CircularProgressIndicator()),
              AnalyticsRevenueLoaded(
                mrr: final mrr,
                arr: final arr,
                revenueByPlan: final byPlan,
                failedPaymentsCount: final failed,
                upcomingRenewals: final renewals,
                revenueTrend: final trend,
              ) =>
                RefreshIndicator(
                  onRefresh: () => ref.read(analyticsRevenueProvider.notifier).load(storeId: _storeId),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      // MRR & ARR cards
                      PosKpiGrid(
                        desktopCols: 4,
                        mobileCols: 2,
                        cards: [
                          PosKpiCard(label: 'MRR', value: '\u0081${mrr.toStringAsFixed(2)}', iconColor: AppColors.success),
                          PosKpiCard(label: 'ARR', value: '\u0081${arr.toStringAsFixed(2)}', iconColor: AppColors.info),
                          PosKpiCard(label: l10n.failedPayments, value: '$failed', iconColor: AppColors.error),
                          PosKpiCard(label: 'Upcoming Renewals', value: '$renewals', iconColor: AppColors.warning),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Revenue by Plan
                      const Text('Revenue by Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (byPlan.isEmpty)
                        const PosCard(
                          child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No plan data available')),
                        )
                      else
                        ...byPlan.map(
                          (p) => PosCard(
                            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Icon(Icons.workspace_premium, color: Colors.white),
                              ),
                              title: Text(p['plan_name'] as String? ?? 'Unknown'),
                              subtitle: Text('${p['active_count'] ?? 0} active stores'),
                              trailing: Text(
                                '\u0081${(p['mrr'] as num? ?? 0).toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: AppSpacing.lg),

                      // Revenue Trend
                      Text(l10n.reportsRevenueTrend, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (trend.isEmpty)
                        const PosCard(
                          child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No trend data')),
                        )
                      else
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: trend.length,
                            itemBuilder: (context, index) {
                              final t = trend[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: AppSpacing.xs),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\u0081${(t['mrr'] as num? ?? 0).toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    Container(
                                      width: 30,
                                      height: ((t['mrr'] as num? ?? 0).toDouble() / (mrr > 0 ? mrr : 1) * 120).clamp(4.0, 150.0),
                                      color: AppColors.primary.withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(height: 4),
                                    Text((t['date'] as String? ?? '').substring(5), style: const TextStyle(fontSize: 8)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              AnalyticsRevenueError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $msg'),
                    const SizedBox(height: AppSpacing.sm),
                    PosButton(
                      onPressed: () => ref.read(analyticsRevenueProvider.notifier).load(storeId: _storeId),
                      label: l10n.retry,
                    ),
                  ],
                ),
              ),
              _ => const Center(child: Text('Loading revenue data...')),
            },
          ),
        ],
      ),
);
  }
}
