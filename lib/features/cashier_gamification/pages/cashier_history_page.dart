import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';
import 'package:wameedpos/features/cashier_gamification/widgets/risk_score_gauge.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class CashierHistoryPage extends ConsumerStatefulWidget {
  final String cashierId;
  const CashierHistoryPage({super.key, required this.cashierId});

  @override
  ConsumerState<CashierHistoryPage> createState() => _CashierHistoryPageState();
}

class _CashierHistoryPageState extends ConsumerState<CashierHistoryPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cashierHistoryProvider.notifier).load(widget.cashierId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(cashierHistoryProvider);
    final isMobile = context.isPhone;

    return PosListPage(
  title: l10n.gamificationCashierHistory,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(cashierHistoryProvider.notifier).load(widget.cashierId), tooltip: l10n.commonRefresh,
  ),
],
  child: _buildContent(state, l10n, isMobile),
);
  }

  Widget _buildContent(CashierHistoryState state, AppLocalizations l10n, bool isMobile) {
    return switch (state) {
      CashierHistoryInitial() || CashierHistoryLoading() => const Center(child: CircularProgressIndicator()),
      CashierHistoryError(:final message) => Center(child: Text(message)),
      CashierHistoryLoaded(:final history) =>
        history.isEmpty
            ? Center(child: Text(l10n.gamificationNoData))
            : ListView.builder(
                padding: context.responsivePagePadding,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final snap = history[index];
                  return PosCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: context.responsivePagePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snap.date,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${snap.periodType} • ${snap.activeMinutes} min',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              RiskScoreGauge(score: snap.riskScore, size: isMobile ? 56 : 68),
                            ],
                          ),
                          AppSpacing.gapH12,
                          Wrap(
                            spacing: isMobile ? 12 : 20,
                            runSpacing: 8,
                            children: [
                              _Stat(label: l10n.gamificationTransactions, value: snap.totalTransactions.toString()),
                              _Stat(label: l10n.gamificationRevenue, value: snap.totalRevenue.toStringAsFixed(0)),
                              _Stat(label: l10n.gamificationItemsPerMinute, value: snap.itemsPerMinute.toStringAsFixed(1)),
                              _Stat(label: l10n.posVoids, value: snap.voidCount.toString()),
                              _Stat(label: 'Basket', value: snap.avgBasketSize.toStringAsFixed(1)),
                              _Stat(label: 'Upsell', value: '${(snap.upsellRate * 100).toStringAsFixed(0)}%'),
                            ],
                          ),
                          if (snap.anomalyFlags.isNotEmpty) ...[
                            AppSpacing.gapH8,
                            Wrap(
                              spacing: 4,
                              children: snap.anomalyFlags
                                  .map(
                                    (f) => Chip(
                                      label: Text(f, style: const TextStyle(fontSize: 11)),
                                      backgroundColor: AppColors.warning.withValues(alpha: 0.12),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
    };
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
