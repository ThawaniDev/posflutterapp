import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

/// Card widget for displaying a subscription add-on.
class AddOnCard extends StatelessWidget {
  final String name;
  final String? description;
  final double price;
  final String billingCycle;
  final bool isActive;
  final DateTime? expiresAt;
  final VoidCallback? onToggle;

  const AddOnCard({
    super.key,
    required this.name,
    this.description,
    required this.price,
    required this.billingCycle,
    this.isActive = false,
    this.expiresAt,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isActive ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive ? const BorderSide(color: AppColors.success, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: AppSpacing.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            if (description != null && description!.isNotEmpty) ...[
              AppSpacing.verticalSm,
              Text(description!, style: Theme.of(context).textTheme.bodySmall),
            ],
            AppSpacing.verticalMd,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${price.toStringAsFixed(2)} \u0081',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    Text('/${billingCycle == 'yearly' ? 'yr' : 'mo'}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                if (onToggle != null)
                  isActive
                      ? OutlinedButton(
                          onPressed: onToggle,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                            foregroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Remove'),
                        )
                      : ElevatedButton(
                          onPressed: onToggle,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                          child: const Text('Add'),
                        ),
              ],
            ),
            if (isActive && expiresAt != null) ...[
              AppSpacing.verticalSm,
              Text(
                'Renews: ${_formatDate(expiresAt!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
