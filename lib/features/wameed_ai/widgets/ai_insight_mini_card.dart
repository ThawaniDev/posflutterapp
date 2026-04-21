import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class AIInsightMiniCard extends StatelessWidget {

  const AIInsightMiniCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.trend,
    this.onTap,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? trend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;

    return PosCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      border: Border.all(color: cardColor.withValues(alpha: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: cardColor.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
                child: Icon(icon, size: 18, color: cardColor),
              ),
              const Spacer(),
              if (trend != null)
                Text(
                  trend!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: trend!.startsWith('+')
                        ? AppColors.success
                        : (trend!.startsWith('-') ? AppColors.error : Theme.of(context).hintColor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
