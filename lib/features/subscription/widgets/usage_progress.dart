import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';

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
                      ? Colors.red
                      : isWarning
                      ? Colors.orange
                      : Colors.grey[600],
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
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(
                isDanger
                    ? Colors.red
                    : isWarning
                    ? Colors.orange
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
