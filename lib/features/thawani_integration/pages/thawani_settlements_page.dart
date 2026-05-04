import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';

class ThawaniSettlementsPage extends ConsumerStatefulWidget {
  const ThawaniSettlementsPage({super.key});

  @override
  ConsumerState<ThawaniSettlementsPage> createState() => _ThawaniSettlementsPageState();
}

class _ThawaniSettlementsPageState extends ConsumerState<ThawaniSettlementsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(thawaniSettlementsProvider.notifier).load());
  }

  void _refresh() => ref.read(thawaniSettlementsProvider.notifier).load();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(thawaniSettlementsProvider);

    return PosListPage(
      title: l10n.thawaniSettlementsTitle,
      showSearch: false,
      actions: [PosButton.icon(icon: Icons.refresh, onPressed: _refresh)],
      child: switch (state) {
        ThawaniSettlementsLoading() => const Center(child: CircularProgressIndicator()),
        ThawaniSettlementsError(:final message) => PosErrorState(message: message, onRetry: _refresh),
        ThawaniSettlementsLoaded(:final settlements) when settlements.isEmpty => PosEmptyState(
          title: l10n.thawaniNoSettlements,
          subtitle: l10n.thawaniNoSettlementsDesc,
        ),
        ThawaniSettlementsLoaded(:final settlements) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKpiRow(settlements),
            AppSpacing.gapH16,
            Expanded(child: _buildTable(settlements)),
          ],
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildKpiRow(List<dynamic> settlements) {
    double totalGross = 0;
    double totalNet = 0;
    double totalCommission = 0;

    for (final raw in settlements) {
      final s = raw as Map<String, dynamic>;
      totalGross += (s['gross_amount'] as num?)?.toDouble() ?? 0;
      totalNet += (s['net_amount'] as num?)?.toDouble() ?? 0;
      totalCommission += (s['commission_amount'] as num?)?.toDouble() ?? 0;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: PosStatsGrid(
        desktopCols: 3,
        tabletCols: 3,
        children: [
          PosKpiCard(
            label: l10n.thawaniGrossAmount,
            value: totalGross.toStringAsFixed(3),
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.primary,
            iconBgColor: AppColors.primary.withValues(alpha: 0.1),
          ),
          PosKpiCard(
            label: l10n.thawaniCommissionAmount,
            value: totalCommission.toStringAsFixed(3),
            icon: Icons.percent,
            iconColor: AppColors.warning,
            iconBgColor: AppColors.warning.withValues(alpha: 0.1),
          ),
          PosKpiCard(
            label: l10n.thawaniNetAmount,
            value: totalNet.toStringAsFixed(3),
            icon: Icons.payments_outlined,
            iconColor: AppColors.success,
            iconBgColor: AppColors.success.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<dynamic> settlements) {
    final typed = settlements.cast<Map<String, dynamic>>().toList();
    return PosDataTable<Map<String, dynamic>>(
      items: typed,
      emptyConfig: PosTableEmptyConfig(icon: Icons.receipt_long_outlined, title: l10n.thawaniNoSettlements),
      columns: [
        PosTableColumn(title: l10n.commonDate),
        PosTableColumn(title: l10n.thawaniReferenceCol, flex: 2),
        PosTableColumn(title: l10n.thawaniGrossAmount, numeric: true),
        PosTableColumn(title: l10n.thawaniCommissionAmount, numeric: true),
        PosTableColumn(title: l10n.thawaniNetAmount, numeric: true),
        PosTableColumn(title: l10n.orders, numeric: true),
        PosTableColumn(title: l10n.status),
      ],
      cellBuilder: (s, colIndex, col) {
        final isReconciled = s['reconciled'] as bool? ?? false;
        final rawDate = s['settlement_date'] as String? ?? '';
        final date = rawDate.length >= 10 ? rawDate.substring(0, 10) : rawDate;

        switch (colIndex) {
          case 0:
            return Text(date, style: AppTypography.bodySmall);
          case 1:
            return Text(s['thawani_reference'] as String? ?? '-', style: AppTypography.bodySmall);
          case 2:
            return Text((s['gross_amount'] as num?)?.toStringAsFixed(3) ?? '0', style: AppTypography.bodySmall);
          case 3:
            return Text(
              (s['commission_amount'] as num?)?.toStringAsFixed(3) ?? '0',
              style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
            );
          case 4:
            return Text(
              (s['net_amount'] as num?)?.toStringAsFixed(3) ?? '0',
              style: AppTypography.bodySmall.copyWith(color: AppColors.success),
            );
          case 5:
            return Text('${s['order_count'] ?? 0}');
          case 6:
            return PosStatusBadge(
              label: isReconciled ? l10n.thawaniReconciled : l10n.thawaniUnreconciled,
              variant: isReconciled ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.warning,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
