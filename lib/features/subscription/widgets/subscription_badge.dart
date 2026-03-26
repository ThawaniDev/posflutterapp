import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';

/// A colored badge indicating subscription status.
class SubscriptionBadge extends StatelessWidget {
  final String status;

  const SubscriptionBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: config.backgroundColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        config.label,
        style: TextStyle(color: config.textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  _BadgeConfig _getConfig(String status) {
    return switch (status.toLowerCase()) {
      'active' => _BadgeConfig(
        label: 'Active',
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
        label: 'Cancelled',
        backgroundColor: AppColors.error.withValues(alpha: 0.15),
        textColor: AppColors.errorDark,
      ),
      'expired' => _BadgeConfig(
        label: 'Expired',
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
