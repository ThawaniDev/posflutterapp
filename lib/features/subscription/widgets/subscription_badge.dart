import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

/// A colored badge indicating subscription status.
class SubscriptionBadge extends StatelessWidget {

  const SubscriptionBadge({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: config.backgroundColor, borderRadius: AppRadius.borderXxl),
      child: Text(
        config.label,
        style: TextStyle(color: config.textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  _BadgeConfig _getConfig(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    return switch (status.toLowerCase()) {
      'active' => _BadgeConfig(
        label: l10n.active,
        backgroundColor: AppColors.success.withValues(alpha: 0.15),
        textColor: AppColors.successDark,
      ),
      'trial' => _BadgeConfig(
        label: l10n.subBadgeTrial,
        backgroundColor: AppColors.info.withValues(alpha: 0.15),
        textColor: AppColors.infoDark,
      ),
      'grace' => _BadgeConfig(
        label: l10n.subBadgeGracePeriod,
        backgroundColor: AppColors.warning.withValues(alpha: 0.15),
        textColor: AppColors.warning,
      ),
      'cancelled' => _BadgeConfig(
        label: l10n.ordersCancelled,
        backgroundColor: AppColors.error.withValues(alpha: 0.15),
        textColor: AppColors.errorDark,
      ),
      'expired' => _BadgeConfig(
        label: l10n.expired,
        backgroundColor: AppColors.mutedFor(context).withValues(alpha: 0.15),
        textColor: AppColors.mutedFor(context),
      ),
      'past_due' => _BadgeConfig(
        label: l10n.subBadgePastDue,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        textColor: AppColors.errorDark,
      ),
      _ => _BadgeConfig(
        label: status,
        backgroundColor: AppColors.mutedFor(context).withValues(alpha: 0.15),
        textColor: AppColors.mutedFor(context),
      ),
    };
  }
}

class _BadgeConfig {

  const _BadgeConfig({required this.label, required this.backgroundColor, required this.textColor});
  final String label;
  final Color backgroundColor;
  final Color textColor;
}
