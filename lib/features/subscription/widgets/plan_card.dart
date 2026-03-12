import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/subscription/models/subscription_plan.dart';

/// Card widget displaying a single subscription plan.
class PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isAnnual;
  final VoidCallback onSelect;

  const PlanCard({super.key, required this.plan, required this.isAnnual, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final price = isAnnual ? (plan.annualPrice ?? plan.monthlyPrice) : plan.monthlyPrice;
    final period = isAnnual ? '/year' : '/month';
    final isHighlighted = plan.isHighlighted;

    return Card(
      elevation: isHighlighted ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHighlighted ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
      ),
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
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Popular',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                  '${price.toStringAsFixed(2)} OMR',
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
                '${plan.trialDays}-day free trial',
                style: TextStyle(color: Colors.green[700], fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],

            AppSpacing.verticalMd,

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isHighlighted ? AppColors.primary : null,
                  foregroundColor: isHighlighted ? Colors.white : null,
                ),
                child: const Text('Select Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
