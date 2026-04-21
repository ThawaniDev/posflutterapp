import 'package:flutter/material.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_stats_kpi_section.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminFeatureFlagListPage extends ConsumerStatefulWidget {
  const AdminFeatureFlagListPage({super.key});

  @override
  ConsumerState<AdminFeatureFlagListPage> createState() => _AdminFeatureFlagListPageState();
}

class _AdminFeatureFlagListPageState extends ConsumerState<AdminFeatureFlagListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadFlags();
      ref.read(featureFlagStatsProvider.notifier).load();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadFlags();
  }

  void _loadFlags() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    ref.read(featureFlagListProvider.notifier).loadFlags(params: params.isEmpty ? null : params);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(featureFlagListProvider);

    return PosListPage(
  title: l10n.adminFeatureFlags,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.add, onPressed: () {},
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          AdminStatsKpiSection(
            provider: featureFlagStatsProvider,
            cardBuilder: (data) {
              final flags = data['flags'] as Map<String, dynamic>? ?? {};
              final ab = data['ab_tests'] as Map<String, dynamic>? ?? {};
              return [
                kpi('Total Flags', flags['total'] ?? 0, AppColors.primary),
                kpi('Enabled', flags['enabled'] ?? 0, AppColors.success),
                kpi('Disabled', flags['disabled'] ?? 0, AppColors.textSecondary),
                kpi('Partial Rollout', flags['partial_rollout'] ?? 0, AppColors.warning),
                kpi('With Targeting', flags['with_targeting'] ?? 0, AppColors.info),
                kpi('A/B Tests', ab['total'] ?? 0, const Color(0xFF8B5CF6), '${ab['running'] ?? 0} running'),
              ];
            },
          ),
          Expanded(
            child: switch (state) {
              FeatureFlagListInitial() || FeatureFlagListLoading() => const Center(child: CircularProgressIndicator()),
              FeatureFlagListLoaded(:final flags, :final total) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('$total feature flags', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Expanded(
                    child: flags.isEmpty
                        ? Center(child: Text(l10n.adminNoFeatureFlags))
                        : ListView.builder(
                            itemCount: flags.length,
                            itemBuilder: (context, index) {
                              final flag = flags[index];
                              return PosCard(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: ListTile(
                                  title: Text(flag['flag_key'] as String? ?? ''),
                                  subtitle: Text(flag['description'] as String? ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${flag['rollout_percentage'] ?? 100}%'),
                                      const SizedBox(width: 8),
                                      Switch(value: flag['is_enabled'] as bool? ?? false, onChanged: (_) {}),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              FeatureFlagListError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 8),
                    Text(message),
                    const SizedBox(height: 16),
                    PosButton(onPressed: () => _loadFlags(), label: l10n.retry),
                  ],
                ),
              ),
            },
          ),
        ],
      ),
);
  }
}
