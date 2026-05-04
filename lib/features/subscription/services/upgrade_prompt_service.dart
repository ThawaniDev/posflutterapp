import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Provider for UpgradePromptService.
final upgradePromptServiceProvider = Provider<UpgradePromptService>((ref) {
  return UpgradePromptService(ref.watch(featureGateServiceProvider));
});

/// Service that shows upgrade dialogs when users hit plan limits or try to
/// access gated features.
class UpgradePromptService {
  UpgradePromptService(this._featureGateService);
  final FeatureGateService _featureGateService;

  /// Show a feature gate prompt dialog when a feature is not enabled.
  ///
  /// Returns true if the user chose to proceed (upgrade initiated), false otherwise.
  Future<bool> showFeatureGatePrompt({
    required BuildContext context,
    required String featureKey,
    required String featureName,
    String? currentPlanName,
    String? requiredPlanName,
    VoidCallback? onUpgrade,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _FeatureGateDialog(
        featureName: featureName,
        featureKey: featureKey,
        currentPlanName: currentPlanName,
        requiredPlanName: requiredPlanName,
        onUpgrade: onUpgrade,
      ),
    );
    return result ?? false;
  }

  /// Show a limit reached prompt when a resource limit is exceeded.
  Future<bool> showLimitReachedPrompt({
    required BuildContext context,
    required String limitKey,
    required String resourceName,
    int? currentUsage,
    int? planLimit,
    VoidCallback? onUpgrade,
  }) async {
    final usage = currentUsage ?? _featureGateService.getCurrentUsage(limitKey);
    final limit = planLimit ?? _featureGateService.getLimit(limitKey);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) =>
          _LimitReachedDialog(resourceName: resourceName, currentUsage: usage, planLimit: limit ?? 0, onUpgrade: onUpgrade),
    );
    return result ?? false;
  }

  /// Check feature and show prompt if not enabled.
  ///
  /// Returns true if the feature is enabled, false if blocked.
  bool checkAndPrompt({
    required BuildContext context,
    required String featureKey,
    required String featureName,
    VoidCallback? onUpgrade,
  }) {
    if (_featureGateService.isFeatureEnabled(featureKey)) {
      return true;
    }

    showFeatureGatePrompt(context: context, featureKey: featureKey, featureName: featureName, onUpgrade: onUpgrade);
    return false;
  }

  /// Check limit and show prompt if at capacity.
  ///
  /// Returns true if within limit, false if blocked.
  bool checkLimitAndPrompt({
    required BuildContext context,
    required String limitKey,
    required String resourceName,
    VoidCallback? onUpgrade,
  }) {
    if (_featureGateService.canPerformAction(limitKey)) {
      return true;
    }

    showLimitReachedPrompt(context: context, limitKey: limitKey, resourceName: resourceName, onUpgrade: onUpgrade);
    return false;
  }
}

// ─── Feature Gate Dialog ─────────────────────────────────────────

class _FeatureGateDialog extends ConsumerWidget {
  const _FeatureGateDialog({
    required this.featureName,
    required this.featureKey,
    this.currentPlanName,
    this.requiredPlanName,
    this.onUpgrade,
  });
  final String featureName;
  final String featureKey;
  final String? currentPlanName;
  final String? requiredPlanName;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final plansState = ref.watch(plansProvider);
    List<SubscriptionPlan> plans = [];
    if (plansState is PlansLoaded) {
      plans = plansState.plans;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.all(16),
      title: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), borderRadius: AppRadius.borderLg),
            child: const Icon(Icons.lock_outline, color: AppColors.warning, size: 24),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.subFeatureLocked, style: AppTypography.titleMedium),
                AppSpacing.gapH4,
                Text(featureName, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.subscriptionUpgradePrompt(featureName), style: AppTypography.bodyMedium),
          if (currentPlanName != null || requiredPlanName != null) ...[
            AppSpacing.gapH16,
            Container(
              padding: AppSpacing.paddingAll12,
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.06),
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentPlanName != null)
                    Row(
                      children: [
                        Text(l10n.subCurrent, style: AppTypography.labelSmall.copyWith(color: AppColors.mutedFor(context))),
                        Text(currentPlanName!, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  if (requiredPlanName != null) ...[
                    AppSpacing.gapH4,
                    Row(
                      children: [
                        Text(l10n.subRequired, style: AppTypography.labelSmall.copyWith(color: AppColors.mutedFor(context))),
                        Text(
                          requiredPlanName!,
                          style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
          // Mini plan comparison if plans are loaded
          if (plans.length >= 2) ...[
            AppSpacing.gapH16,
            Text(l10n.subAvailablePlans, style: AppTypography.labelMedium),
            AppSpacing.gapH8,
            ...plans
                .take(3)
                .map(
                  (plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          plan.isHighlighted ? Icons.star : Icons.circle,
                          size: 12,
                          color: plan.isHighlighted ? AppColors.primary : AppColors.mutedFor(context),
                        ),
                        AppSpacing.gapW8,
                        Expanded(child: Text(plan.name, style: AppTypography.bodySmall)),
                        Text(
                          '${plan.monthlyPrice.toStringAsFixed(0)} \u0081/mo',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
      actions: [
        PosButton(onPressed: () => Navigator.pop(context, false), variant: PosButtonVariant.ghost, label: l10n.subNotNow),
        PosButton(
          onPressed: () {
            Navigator.pop(context, true);
            onUpgrade?.call();
          },
          icon: Icons.upgrade,
          label: l10n.subscriptionUpgrade,
        ),
      ],
    );
  }
}

// ─── Limit Reached Dialog ────────────────────────────────────────

class _LimitReachedDialog extends StatelessWidget {
  const _LimitReachedDialog({required this.resourceName, required this.currentUsage, required this.planLimit, this.onUpgrade});
  final String resourceName;
  final int currentUsage;
  final int planLimit;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentage = planLimit > 0 ? (currentUsage / planLimit * 100).clamp(0.0, 100.0) : 100.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.all(16),
      title: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), borderRadius: AppRadius.borderLg),
            child: const Icon(Icons.block, color: AppColors.error, size: 24),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.subscriptionLimitReached, style: AppTypography.titleMedium),
                AppSpacing.gapH4,
                Text(resourceName, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have reached the maximum number of $resourceName allowed on your current plan.',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.gapH16,
          // Usage bar
          Container(
            padding: AppSpacing.paddingAll12,
            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.06), borderRadius: AppRadius.borderMd),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.usage, style: AppTypography.labelSmall),
                    Text(
                      '$currentUsage / $planLimit',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                AppSpacing.gapH8,
                ClipRRect(
                  borderRadius: AppRadius.borderXs,
                  child: LinearProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.borderFor(context),
                    valueColor: const AlwaysStoppedAnimation(AppColors.error),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapH12,
          Text(
            'Upgrade your plan to increase your $resourceName limit.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
          ),
        ],
      ),
      actions: [
        PosButton(onPressed: () => Navigator.pop(context, false), variant: PosButtonVariant.ghost, label: l10n.subNotNow),
        PosButton(
          onPressed: () {
            Navigator.pop(context, true);
            onUpgrade?.call();
          },
          icon: Icons.upgrade,
          label: l10n.subscriptionUpgrade,
        ),
      ],
    );
  }
}
