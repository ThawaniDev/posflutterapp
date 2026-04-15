import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

/// Widget showing a usage progress bar for a plan limit.
class UsageProgress extends StatelessWidget {
  final String label;
  final int current;
  final int? limit;
  final double percentage;

  const UsageProgress({super.key, required this.label, required this.current, required this.limit, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final isUnlimited = limit == null;
    final progress = (percentage / 100).clamp(0.0, 1.0);
    final isWarning = percentage >= 80;
    final isDanger = percentage >= 95;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatLabel(label), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              Text(
                isUnlimited ? '$current / ∞' : '$current / $limit',
                style: TextStyle(
                  color: isDanger
                      ? AppColors.error
                      : isWarning
                      ? AppColors.warning
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          AppSpacing.verticalXs,
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: isUnlimited ? 0 : progress,
              minHeight: 8,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation(
                isDanger
                    ? AppColors.error
                    : isWarning
                    ? AppColors.warning
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLabel(String key) {
    return key.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w).join(' ');
  }
}
