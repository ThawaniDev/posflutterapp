import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/subscription/models/subscription_plan.dart';

/// Widget that displays a list of plan features with check/cross indicators.
class FeatureListWidget extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool showLimits;

  const FeatureListWidget({super.key, required this.plan, this.showLimits = true});

  @override
  Widget build(BuildContext context) {
    final features = plan.features ?? [];
    final limits = plan.limits ?? [];

    if (features.isEmpty && limits.isEmpty) {
      return const Text('No features listed for this plan.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (features.isNotEmpty) ...[
          Text('Features', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          AppSpacing.verticalSm,
          ...features.map(
            (f) => _buildFeatureRow(context, _formatKey(f['feature_key']?.toString() ?? ''), f['is_enabled'] as bool? ?? false),
          ),
        ],
        if (showLimits && limits.isNotEmpty) ...[
          AppSpacing.verticalMd,
          Text('Limits', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          AppSpacing.verticalSm,
          ...limits.map(
            (l) => _buildLimitRow(context, _formatKey(l['limit_key']?.toString() ?? ''), (l['limit_value'] as num?)?.toInt()),
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureRow(BuildContext context, String label, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? AppColors.success : AppColors.error.withValues(alpha: 0.5),
            size: 18,
          ),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: enabled ? null : AppColors.textSecondaryLight,
                decoration: enabled ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitRow(BuildContext context, String label, int? maxValue) {
    final isUnlimited = maxValue == -1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isUnlimited ? Icons.all_inclusive : Icons.data_usage,
            color: isUnlimited ? AppColors.success : AppColors.info,
            size: 18,
          ),
          AppSpacing.horizontalSm,
          Expanded(child: Text(label)),
          Text(
            isUnlimited ? 'Unlimited' : '${maxValue ?? 0}',
            style: TextStyle(fontWeight: FontWeight.w600, color: isUnlimited ? AppColors.success : null),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}
