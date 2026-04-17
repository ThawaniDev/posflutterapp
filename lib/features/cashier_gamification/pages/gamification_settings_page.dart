import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/models/gamification_settings.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class GamificationSettingsPage extends ConsumerStatefulWidget {
  const GamificationSettingsPage({super.key});

  @override
  ConsumerState<GamificationSettingsPage> createState() => _GamificationSettingsPageState();
}

class _GamificationSettingsPageState extends ConsumerState<GamificationSettingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(gamificationSettingsProvider.notifier).load());
  }

  void _toggleSetting(GamificationSettings settings, String key, bool value) {
    ref.read(gamificationSettingsProvider.notifier).update({key: value});
  }

  void _updateWeight(GamificationSettings settings, String key, double value) {
    ref.read(gamificationSettingsProvider.notifier).update({key: value});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gamificationSettingsProvider);
    final isMobile = context.isPhone;

    return PosListPage(
  title: l10n.gamificationSettings,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(gamificationSettingsProvider.notifier).load(), tooltip: l10n.commonRefresh,
  ),
],
  child: _buildContent(state, l10n, isMobile),
);
  }

  Widget _buildContent(GamificationSettingsState state, AppLocalizations l10n, bool isMobile) {
    return switch (state) {
      GamificationSettingsInitial() || GamificationSettingsLoading() => const Center(child: CircularProgressIndicator()),
      GamificationSettingsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH8,
            Text(message, textAlign: TextAlign.center),
            AppSpacing.gapH12,
            PosButton(
              onPressed: () => ref.read(gamificationSettingsProvider.notifier).load(),
              label: l10n.commonRetry,
            ),
          ],
        ),
      ),
      GamificationSettingsLoaded(:final settings) => ListView(
        padding: context.responsivePagePadding,
        children: [
          // Feature toggles
          PosCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.gamificationFeatureToggles,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  title: Text(l10n.gamificationLeaderboard),
                  subtitle: Text(l10n.gamificationLeaderboardDesc),
                  value: settings.leaderboardEnabled,
                  onChanged: (v) => _toggleSetting(settings, 'leaderboard_enabled', v),
                  activeThumbColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: Text(l10n.gamificationBadges),
                  subtitle: Text(l10n.gamificationBadgesDesc),
                  value: settings.badgesEnabled,
                  onChanged: (v) => _toggleSetting(settings, 'badges_enabled', v),
                  activeThumbColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: Text(l10n.gamificationAnomalyDetection),
                  subtitle: Text(l10n.gamificationAnomalyDetectionDesc),
                  value: settings.anomalyDetectionEnabled,
                  onChanged: (v) => _toggleSetting(settings, 'anomaly_detection_enabled', v),
                  activeThumbColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: Text(l10n.gamificationShiftReports),
                  subtitle: Text(l10n.gamificationShiftReportsDesc),
                  value: settings.shiftReportsEnabled,
                  onChanged: (v) => _toggleSetting(settings, 'shift_reports_enabled', v),
                  activeThumbColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: Text(l10n.gamificationAutoGenerate),
                  subtitle: Text(l10n.gamificationAutoGenerateDesc),
                  value: settings.autoGenerateOnSessionClose,
                  onChanged: (v) => _toggleSetting(settings, 'auto_generate_on_session_close', v),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,
          // Anomaly detection thresholds
          PosCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gamificationAnomalyThresholds,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSpacing.gapH12,
                  _SliderSetting(
                    label: l10n.gamificationZScoreThreshold,
                    value: settings.anomalyZScoreThreshold,
                    min: 1.0,
                    max: 4.0,
                    divisions: 30,
                    onChanged: (v) => _updateWeight(settings, 'anomaly_z_score_threshold', v),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapH16,
          // Risk score weights
          PosCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gamificationRiskWeights,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSpacing.gapH12,
                  _SliderSetting(
                    label: l10n.gamificationVoidWeight,
                    value: settings.riskScoreVoidWeight,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    onChanged: (v) => _updateWeight(settings, 'risk_score_void_weight', v),
                  ),
                  _SliderSetting(
                    label: l10n.gamificationNoSaleWeight,
                    value: settings.riskScoreNoSaleWeight,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    onChanged: (v) => _updateWeight(settings, 'risk_score_no_sale_weight', v),
                  ),
                  _SliderSetting(
                    label: l10n.gamificationDiscountWeight,
                    value: settings.riskScoreDiscountWeight,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    onChanged: (v) => _updateWeight(settings, 'risk_score_discount_weight', v),
                  ),
                  _SliderSetting(
                    label: l10n.gamificationPriceOverrideWeight,
                    value: settings.riskScorePriceOverrideWeight,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    onChanged: (v) => _updateWeight(settings, 'risk_score_price_override_weight', v),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    };
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(value.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
