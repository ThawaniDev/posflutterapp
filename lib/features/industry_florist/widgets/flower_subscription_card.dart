import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pos_status_badge.dart';
import '../models/flower_subscription.dart';

class FlowerSubscriptionCard extends StatelessWidget {
  final FlowerSubscription subscription;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const FlowerSubscriptionCard({super.key, required this.subscription, this.onTap, this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isActive = subscription.isActive ?? true;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(Icons.autorenew, size: 18, color: AppColors.primary),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(
                      subscription.frequency.value.replaceAll('_', ' '),
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  PosStatusBadge(
                    label: isActive ? 'Active' : 'Paused',
                    variant: isActive ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.neutral,
                  ),
                ],
              ),
              AppSpacing.gapH8,
              Text(
                subscription.deliveryAddress,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapH4,
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 3),
                  Text(
                    'Next: ${_formatDate(subscription.nextDeliveryDate)}',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  if (subscription.deliveryDay != null) ...[
                    AppSpacing.gapW8,
                    Text(subscription.deliveryDay!, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                  const Spacer(),
                  Text(
                    '${subscription.pricePerDelivery.toStringAsFixed(2)} OMR',
                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              if (onToggle != null) ...[
                AppSpacing.gapH8,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onToggle,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isActive ? AppColors.warning : AppColors.success,
                      side: BorderSide(color: isActive ? AppColors.warning : AppColors.success),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      textStyle: AppTypography.labelSmall,
                    ),
                    child: Text(isActive ? 'Pause' : 'Resume'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
