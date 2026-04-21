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

class AdminAnalyticsFeaturesPage extends ConsumerStatefulWidget {
  const AdminAnalyticsFeaturesPage({super.key});

  @override
  ConsumerState<AdminAnalyticsFeaturesPage> createState() => _AdminAnalyticsFeaturesPageState();
}

class _AdminAnalyticsFeaturesPageState extends ConsumerState<AdminAnalyticsFeaturesPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(analyticsFeaturesProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(analyticsFeaturesProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsFeaturesProvider);

    return PosListPage(
  title: l10n.adminFeatureAdoption,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              AnalyticsFeaturesLoading() => const Center(child: CircularProgressIndicator()),
              AnalyticsFeaturesLoaded(features: final features, trend: final trend) => RefreshIndicator(
                onRefresh: () => ref.read(analyticsFeaturesProvider.notifier).load(storeId: _storeId),
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    const Text('Feature Adoption', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.sm),
                    if (features.isEmpty)
                      PosCard(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Text(l10n.adminNoFeatureDataAvailable)),
                      )
                    else
                      ...features.map((f) {
                        final adoption = (f['adoption_percentage'] as num? ?? 0).toDouble();
                        return PosCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        f['feature_key'] as String? ?? 'Unknown',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      '${adoption.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: adoption > 50 ? AppColors.success : AppColors.warning,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: adoption / 100,
                                  backgroundColor: AppColors.borderFor(context),
                                  color: adoption > 50 ? AppColors.success : AppColors.warning,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${f['stores_using'] ?? 0} of ${f['total_eligible'] ?? 0} stores',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                    if (trend.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const Text('Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      ...trend.map(
                        (t) => PosCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ListTile(
                            title: Text(t['date'] as String? ?? ''),
                            subtitle: Text('Using: ${t['total_stores'] ?? 0} | Eligible: ${t['total_eligible'] ?? 0}'),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AnalyticsFeaturesError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError(msg)),
                    const SizedBox(height: AppSpacing.sm),
                    PosButton(
                      onPressed: () => ref.read(analyticsFeaturesProvider.notifier).load(storeId: _storeId),
                      label: l10n.retry,
                    ),
                  ],
                ),
              ),
              _ => Center(child: Text(l10n.adminLoadingFeatureData)),
            },
          ),
        ],
      ),
);
  }
}
