import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';

class AIUsageBanner extends ConsumerWidget {
  const AIUsageBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiUsageProvider);

    if (state is! AIUsageLoaded) return const SizedBox.shrink();

    final summary = state.summary;
    final isMobile = context.isPhone;

    final stats = [
      _StatData(l10n.wameedAITodayRequests, '${summary.today.requestCount}', Icons.today, AppColors.primary),
      _StatData(l10n.wameedAITodayCost, '\$${summary.today.totalCost.toStringAsFixed(4)}', Icons.attach_money, AppColors.success),
      _StatData(l10n.wameedAIMonthlyRequests, '${summary.monthly.requestCount}', Icons.calendar_month, AppColors.primary),
      _StatData(
        l10n.wameedAIMonthlyCost,
        '\$${summary.monthly.totalCost.toStringAsFixed(4)}',
        Icons.account_balance_wallet,
        AppColors.success,
      ),
    ];

    return PosCard(
      padding: context.responsivePagePadding,
      child: isMobile ? _buildMobileGrid(context, stats) : _buildDesktopRow(context, stats),
    );
  }

  Widget _buildDesktopRow(BuildContext context, List<_StatData> stats) {
    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          _usageStat(context, stats[i].label, stats[i].value, stats[i].icon, stats[i].color),
          if (i < stats.length - 1) _divider(context),
        ],
      ],
    );
  }

  Widget _buildMobileGrid(BuildContext context, List<_StatData> stats) {
    return Column(
      children: [
        Row(
          children: [
            _usageStat(context, stats[0].label, stats[0].value, stats[0].icon, stats[0].color),
            _divider(context),
            _usageStat(context, stats[1].label, stats[1].value, stats[1].icon, stats[1].color),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(height: 1, color: Theme.of(context).dividerColor),
        ),
        Row(
          children: [
            _usageStat(context, stats[2].label, stats[2].value, stats[2].icon, stats[2].color),
            _divider(context),
            _usageStat(context, stats[3].label, stats[3].value, stats[3].icon, stats[3].color),
          ],
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Theme.of(context).dividerColor,
    );
  }

  Widget _usageStat(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          AppSpacing.gapH4,
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: color),
          ),
          AppSpacing.gapH2,
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData(this.label, this.value, this.icon, this.color);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
}
