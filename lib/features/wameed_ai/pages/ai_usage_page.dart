import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';

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

    return PosListPage(
  title: l10n.wameedAIUsage,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(aiUsageProvider.notifier).load(),
  ),
],
  child: switch (state) {
        AIUsageInitial() || AIUsageLoading() => const PosLoading(),
        AIUsageError(:final message) => PosErrorState(message: message, onRetry: () => ref.read(aiUsageProvider.notifier).load()),
        AIUsageLoaded(:final summary) => SingleChildScrollView(
          padding: context.responsivePagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wameedAIUsageOverview,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              AppSpacing.gapH16,
              PosKpiGrid(
                desktopCols: 4,
                mobileCols: 2,
                cards: [
                  PosKpiCard(
                    label: l10n.wameedAITodayRequests,
                    value: '${summary.today.requestCount}',
                    icon: Icons.today,
                    iconColor: AppColors.primary,
                  ),
                  PosKpiCard(
                    label: l10n.wameedAITodayCost,
                    value: '\$${summary.today.totalCost.toStringAsFixed(4)}',
                    icon: Icons.attach_money,
                    iconColor: AppColors.success,
                  ),
                  PosKpiCard(
                    label: l10n.wameedAIMonthlyRequests,
                    value: '${summary.monthly.requestCount}',
                    icon: Icons.calendar_month,
                    iconColor: AppColors.primary,
                  ),
                  PosKpiCard(
                    label: l10n.wameedAIMonthlyCost,
                    value: '\$${summary.monthly.totalCost.toStringAsFixed(4)}',
                    icon: Icons.account_balance_wallet,
                    iconColor: AppColors.success,
                  ),
                ],
              ),
              if (summary.byFeature.isNotEmpty) ...[
                AppSpacing.gapH24,
                Text(
                  l10n.wameedAIUsageByFeature,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                AppSpacing.gapH12,
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
}
