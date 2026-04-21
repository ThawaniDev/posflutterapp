import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Card widget for displaying a subscription add-on.
class AddOnCard extends StatelessWidget {

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
  final String name;
  final String? description;
  final double price;
  final String billingCycle;
  final bool isActive;
  final DateTime? expiresAt;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosCard(
      elevation: isActive ? 2 : 1,
      borderRadius: AppRadius.borderLg,
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
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
                    child: Text(
                      l10n.active,
                      style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
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
                    Text(
                      '/${billingCycle == 'yearly' ? l10n.subPerYearShort : l10n.subPerMonthShort}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                if (onToggle != null)
                  isActive
                      ? PosButton(onPressed: onToggle, variant: PosButtonVariant.outline, label: l10n.remove)
                      : PosButton(onPressed: onToggle, label: l10n.add),
              ],
            ),
            if (isActive && expiresAt != null) ...[
              AppSpacing.verticalSm,
              Text(
                l10n.subRenewsOn(_formatDate(expiresAt!)),
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
