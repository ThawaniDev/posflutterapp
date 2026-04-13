import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/cashier_gamification/models/gamification_settings.dart';
import 'package:thawani_pos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:thawani_pos/features/cashier_gamification/providers/gamification_state.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.settings_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.gamificationSettings),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(gamificationSettingsProvider.notifier).load(),
          ),
        ],
      ),
      body: _buildContent(state, l10n, isMobile),
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
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.read(gamificationSettingsProvider.notifier).load(),
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
      GamificationSettingsLoaded(:final settings) => ListView(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        children: [
          // Feature toggles
          Card(
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
          const SizedBox(height: 16),
          // Anomaly detection thresholds
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gamificationAnomalyThresholds,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          // Risk score weights
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gamificationRiskWeights,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
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
