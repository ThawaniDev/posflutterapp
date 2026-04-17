import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';
import 'package:wameedpos/features/cashier_gamification/widgets/leaderboard_card.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class GamificationHomePage extends ConsumerStatefulWidget {
  const GamificationHomePage({super.key});

  @override
  ConsumerState<GamificationHomePage> createState() => _GamificationHomePageState();
}

class _GamificationHomePageState extends ConsumerState<GamificationHomePage> {
  String _sortBy = 'total_revenue';
  String _periodType = 'daily';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  void _loadData() {
    ref
        .read(leaderboardProvider.notifier)
        .load(date: DateTime.now().toIso8601String().substring(0, 10), periodType: _periodType, sortBy: _sortBy);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(leaderboardProvider);
    final isMobile = context.isPhone;

    return PosListPage(
  title: l10n.gamificationTitle,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.workspace_premium_rounded, onPressed: () => context.push(Routes.gamificationBadges), tooltip: l10n.gamificationBadges,
  ),
  PosButton.icon(
    icon: Icons.warning_amber_rounded, onPressed: () => context.push(Routes.gamificationAnomalies), tooltip: l10n.gamificationAnomalies,
  ),
  PosButton.icon(
    icon: Icons.assessment_rounded, onPressed: () => context.push(Routes.gamificationShiftReports), tooltip: l10n.gamificationShiftReports,
  ),
  PosButton.icon(
    icon: Icons.settings_rounded, onPressed: () => context.push(Routes.gamificationSettings), tooltip: l10n.gamificationSettings,
  ),
  PosButton.icon(
    icon: Icons.refresh, onPressed: _loadData, tooltip: l10n.commonRefresh,
  ),
],
  child: Column(
        children: [
          // Filters
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.gamificationDaily),
                  selected: _periodType == 'daily',
                  onSelected: (_) {
                    setState(() => _periodType = 'daily');
                    _loadData();
                  },
                  selectedColor: AppColors.primary20,
                ),
                ChoiceChip(
                  label: Text(l10n.gamificationShift),
                  selected: _periodType == 'shift',
                  onSelected: (_) {
                    setState(() => _periodType = 'shift');
                    _loadData();
                  },
                  selectedColor: AppColors.primary20,
                ),
                AppSpacing.gapW8,
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox.shrink(),
                  isDense: true,
                  items: [
                    DropdownMenuItem(value: 'total_revenue', child: Text(l10n.gamificationRevenue)),
                    DropdownMenuItem(value: 'total_transactions', child: Text(l10n.gamificationTransactions)),
                    DropdownMenuItem(value: 'items_per_minute', child: Text(l10n.gamificationItemsPerMinute)),
                    DropdownMenuItem(value: 'risk_score', child: Text(l10n.gamificationRiskScore)),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _sortBy = v);
                      _loadData();
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(child: _buildContent(state, l10n)),
        ],
      ),
);
  }

  Widget _buildContent(LeaderboardState state, AppLocalizations l10n) {
    return switch (state) {
      LeaderboardInitial() || LeaderboardLoading() => const Center(child: CircularProgressIndicator()),
      LeaderboardError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH8,
            Text(message, textAlign: TextAlign.center),
            AppSpacing.gapH12,
            PosButton(onPressed: _loadData, label: l10n.commonRetry),
          ],
        ),
      ),
      LeaderboardLoaded(:final snapshots) =>
        snapshots.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.leaderboard_rounded, size: 64, color: Colors.grey.shade400),
                    AppSpacing.gapH12,
                    Text(l10n.gamificationNoData, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: snapshots.length,
                itemBuilder: (context, index) {
                  final snapshot = snapshots[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: LeaderboardCard(
                      snapshot: snapshot,
                      rank: index + 1,
                      onTap: () => context.push('${Routes.gamificationLeaderboard}/history/${snapshot.cashierId}'),
                    ),
                  );
                },
              ),
    };
  }
}
