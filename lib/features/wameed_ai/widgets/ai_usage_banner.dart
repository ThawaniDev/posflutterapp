import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

class AIUsageBanner extends ConsumerWidget {
  const AIUsageBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiUsageProvider);

    if (state is! AIUsageLoaded) return const SizedBox.shrink();

    final summary = state.summary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          _usageStat(context, l10n.wameedAITodayRequests, '${summary.today.requestCount}', Icons.today, AppColors.primary),
          _divider(context),
          _usageStat(context, l10n.wameedAITodayCost, '\$${summary.today.totalCost.toStringAsFixed(4)}', Icons.attach_money, Colors.green),
          _divider(context),
          _usageStat(context, l10n.wameedAIMonthlyRequests, '${summary.monthly.requestCount}', Icons.calendar_month, AppColors.primary),
          _divider(context),
          _usageStat(context, l10n.wameedAIMonthlyCost, '\$${summary.monthly.totalCost.toStringAsFixed(4)}', Icons.account_balance_wallet, Colors.green),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(width: 1, height: 40, margin: const EdgeInsets.symmetric(horizontal: 12), color: Theme.of(context).dividerColor);
  }

  Widget _usageStat(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
