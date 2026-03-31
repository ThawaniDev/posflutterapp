import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';

/// Banner widget shown when the subscription is in a grace period or about to expire.
class GracePeriodBanner extends StatelessWidget {
  final DateTime gracePeriodEndsAt;
  final VoidCallback? onRenewPressed;
  final bool isExpired;

  const GracePeriodBanner({super.key, required this.gracePeriodEndsAt, this.onRenewPressed, this.isExpired = false});

  @override
  Widget build(BuildContext context) {
    final daysLeft = gracePeriodEndsAt.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft <= 3 || isExpired;
    final bannerColor = isUrgent ? AppColors.error : AppColors.warning;
    final textColor = isUrgent ? Colors.white : AppColors.textPrimaryLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: isUrgent ? 0.9 : 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bannerColor, width: 1),
      ),
      child: Row(
        children: [
          Icon(isExpired ? Icons.error : Icons.warning_amber_rounded, color: isUrgent ? Colors.white : bannerColor, size: 24),
          AppSpacing.horizontalSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpired ? 'Subscription Expired' : 'Grace Period Active',
                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  isExpired
                      ? 'Your subscription has expired. Renew now to restore access.'
                      : daysLeft > 0
                      ? '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining in grace period. Renew to avoid losing access.'
                      : 'Grace period ends today. Renew immediately.',
                  style: TextStyle(color: textColor.withValues(alpha: 0.85), fontSize: 12),
                ),
              ],
            ),
          ),
          if (onRenewPressed != null) ...[
            AppSpacing.horizontalSm,
            ElevatedButton(
              onPressed: onRenewPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isUrgent ? Colors.white : bannerColor,
                foregroundColor: isUrgent ? bannerColor : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Renew Now'),
            ),
          ],
        ],
      ),
    );
  }
}
