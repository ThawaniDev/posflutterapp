import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Side-by-side plan comparison table widget.
class PlanComparisonTable extends StatelessWidget {
  final List<SubscriptionPlan> plans;
  final String? currentPlanId;
  final bool isAnnual;
  final void Function(SubscriptionPlan plan)? onSelectPlan;

  const PlanComparisonTable({super.key, required this.plans, this.currentPlanId, this.isAnnual = false, this.onSelectPlan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (plans.isEmpty) return const SizedBox.shrink();

    // Gather all unique feature keys across all plans
    final allFeatureKeys = <String>{};
    final allLimitKeys = <String>{};
    for (final plan in plans) {
      if (plan.features != null) {
        for (final f in plan.features!) {
          final key = f['feature_key']?.toString() ?? '';
          if (key.isNotEmpty) allFeatureKeys.add(key);
        }
      }
      if (plan.limits != null) {
        for (final l in plan.limits!) {
          final key = l['limit_key']?.toString() ?? '';
          if (key.isNotEmpty) allLimitKeys.add(key);
        }
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primary10),
          columnSpacing: 24,
          horizontalMargin: 16,
          columns: [
            DataColumn(
              label: Text(l10n.feature, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...plans.map((plan) {
              final isCurrent = plan.id == currentPlanId;
              return DataColumn(
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      plan.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: isCurrent ? AppColors.primary : null),
                    ),
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: Text(l10n.subscriptionCurrent, style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                  ],
                ),
              );
            }),
          ],
          rows: [
            // Price row
            _buildRow(
              'Price',
              plans.map((p) {
                final price = isAnnual ? (p.annualPrice ?? p.monthlyPrice) : p.monthlyPrice;
                final period = isAnnual ? '/yr' : '/mo';
                return Text('${price.toStringAsFixed(2)} \u0081$period', style: const TextStyle(fontWeight: FontWeight.w600));
              }).toList(),
            ),

            // Trial days row
            _buildRow(
              'Trial Days',
              plans.map((p) => Text(p.trialDays != null && p.trialDays! > 0 ? '${p.trialDays} days' : '—')).toList(),
            ),

            // Feature toggles
            ...allFeatureKeys.map((key) {
              return _buildRow(
                _formatKey(key),
                plans.map((plan) {
                  final feature = plan.features?.where((f) => f['feature_key'] == key).firstOrNull;
                  if (feature == null) {
                    return const Icon(Icons.close, color: AppColors.error, size: 18);
                  }
                  final isEnabled = feature['is_enabled'] as bool? ?? false;
                  return isEnabled
                      ? const Icon(Icons.check_circle, color: AppColors.success, size: 18)
                      : const Icon(Icons.close, color: AppColors.error, size: 18);
                }).toList(),
              );
            }),

            // Limits
            ...allLimitKeys.map((key) {
              return _buildRow(
                _formatKey(key),
                plans.map((plan) {
                  final limit = plan.limits?.where((l) => l['limit_key'] == key).firstOrNull;
                  if (limit == null) {
                    return const Text('—');
                  }
                  final maxValue = (limit['limit_value'] as num?)?.toInt();
                  return Text(
                    maxValue == -1 ? 'Unlimited' : '${maxValue ?? 0}',
                    style: TextStyle(fontWeight: FontWeight.w500, color: maxValue == -1 ? AppColors.success : null),
                  );
                }).toList(),
              );
            }),

            // Action row
            if (onSelectPlan != null)
              _buildRow(
                '',
                plans.map((plan) {
                  final isCurrent = plan.id == currentPlanId;
                  if (isCurrent) {
                    return Text(l10n.subscriptionCurrentPlan,
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () => onSelectPlan!(plan),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                    child: Text(l10n.subscriptionSelect),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(String label, List<Widget> cells) {
    return DataRow(
      cells: [
        DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
        ...cells.map((c) => DataCell(Center(child: c))),
      ],
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
