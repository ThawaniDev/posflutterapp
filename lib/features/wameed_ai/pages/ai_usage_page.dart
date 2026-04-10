import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

class AIUsagePage extends ConsumerStatefulWidget {
  const AIUsagePage({super.key});

  @override
  ConsumerState<AIUsagePage> createState() => _AIUsagePageState();
}

class _AIUsagePageState extends ConsumerState<AIUsagePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aiUsageProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiUsageProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wameedAIUsage),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(aiUsageProvider.notifier).load())],
      ),
      body: switch (state) {
        AIUsageInitial() || AIUsageLoading() => const Center(child: CircularProgressIndicator()),
        AIUsageError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 16),
              PosButton(label: l10n.commonRetry, onPressed: () => ref.read(aiUsageProvider.notifier).load()),
            ],
          ),
        ),
        AIUsageLoaded(:final summary) => SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wameedAIUsageOverview,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 2 : 4,
                childAspectRatio: isMobile ? 1.5 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _kpiCard(l10n.wameedAITodayRequests, '${summary.today.requestCount}', Icons.today, AppColors.primary),
                  _kpiCard(
                    l10n.wameedAITodayCost,
                    '\$${summary.today.totalCost.toStringAsFixed(4)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                  _kpiCard(
                    l10n.wameedAIMonthlyRequests,
                    '${summary.monthly.requestCount}',
                    Icons.calendar_month,
                    AppColors.primary,
                  ),
                  _kpiCard(
                    l10n.wameedAIMonthlyCost,
                    '\$${summary.monthly.totalCost.toStringAsFixed(4)}',
                    Icons.account_balance_wallet,
                    Colors.green,
                  ),
                ],
              ),
              if (summary.byFeature.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l10n.wameedAIUsageByFeature,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ...summary.byFeature.map(
                  (f) => ListTile(
                    leading: const Icon(Icons.auto_awesome, color: AppColors.primary),
                    title: Text(f.featureSlug.replaceAll('_', ' ')),
                    subtitle: Text('${f.requestCount} ${l10n.wameedAIRequests}'),
                    trailing: Text(
                      '\$${f.totalCost.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      },
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
        ],
      ),
    );
  }
}
