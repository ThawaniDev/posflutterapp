import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Banner widget shown when the subscription is in a grace period or about to expire.
class GracePeriodBanner extends StatelessWidget {
  final DateTime gracePeriodEndsAt;
  final VoidCallback? onRenewPressed;
  final bool isExpired;

  const GracePeriodBanner({super.key, required this.gracePeriodEndsAt, this.onRenewPressed, this.isExpired = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final daysLeft = gracePeriodEndsAt.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft <= 3 || isExpired;
    final bannerColor = isUrgent ? AppColors.error : AppColors.warning;
    final textColor = isUrgent ? Colors.white : AppColors.textPrimaryLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: isUrgent ? 0.9 : 0.15),
        borderRadius: AppRadius.borderMd,
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
                  isExpired ? l10n.subSubscriptionExpired : l10n.subGracePeriodActive,
                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  isExpired
                      ? l10n.subExpiredRenewMessage
                      : daysLeft > 0
                      ? l10n.subGraceDaysRemaining(daysLeft)
                      : l10n.subGraceEndsToday,
                  style: TextStyle(color: textColor.withValues(alpha: 0.85), fontSize: 12),
                ),
              ],
            ),
          ),
          if (onRenewPressed != null) ...[
            AppSpacing.horizontalSm,
            PosButton(onPressed: onRenewPressed, label: l10n.subscriptionRenewNow),
          ],
        ],
      ),
    );
  }
}
