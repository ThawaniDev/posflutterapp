import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// A colored badge indicating subscription status.
class SubscriptionBadge extends StatelessWidget {
  final String status;

  const SubscriptionBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = _getConfig(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: config.backgroundColor, borderRadius: BorderRadius.circular(20)),
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
        label: 'Trial',
        backgroundColor: AppColors.info.withValues(alpha: 0.15),
        textColor: AppColors.infoDark,
      ),
      'grace' => _BadgeConfig(
        label: 'Grace Period',
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
        backgroundColor: AppColors.textSecondary.withValues(alpha: 0.15),
        textColor: AppColors.textSecondary,
      ),
      'past_due' => _BadgeConfig(
        label: 'Past Due',
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        textColor: AppColors.errorDark,
      ),
      _ => _BadgeConfig(
        label: status,
        backgroundColor: AppColors.textSecondary.withValues(alpha: 0.15),
        textColor: AppColors.textSecondary,
      ),
    };
  }
}

class _BadgeConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _BadgeConfig({required this.label, required this.backgroundColor, required this.textColor});
}
