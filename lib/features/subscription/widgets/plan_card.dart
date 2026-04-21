import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Card widget displaying a single subscription plan.
class PlanCard extends StatelessWidget {

  const PlanCard({super.key, required this.plan, required this.isAnnual, required this.onSelect});
  final SubscriptionPlan plan;
  final bool isAnnual;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final price = isAnnual ? (plan.annualPrice ?? plan.monthlyPrice) : plan.monthlyPrice;
    final period = isAnnual ? l10n.subPerYear : l10n.subPerMonth;
    final isHighlighted = plan.isHighlighted;

    return PosCard(
      elevation: isHighlighted ? 4 : 1,
      borderRadius: AppRadius.borderLg,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: AppSpacing.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(plan.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                if (isHighlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.borderXxl),
                    child: Text(
                      l10n.subscriptionPopular,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),

            AppSpacing.verticalSm,

            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${price.toStringAsFixed(2)} \u0081',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(period, style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),

            if (plan.trialDays != null && plan.trialDays! > 0) ...[
              AppSpacing.verticalXs,
              Text(
                l10n.subFreeTrialDays(plan.trialDays!),
                style: const TextStyle(color: AppColors.successDark, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],

            AppSpacing.verticalMd,

            // CTA
            SizedBox(
              width: double.infinity,
              child: PosButton(onPressed: onSelect, label: l10n.subscriptionSelectPlan),
            ),
          ],
        ),
      ),
    );
  }
}
