import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/inventory/models/stock_batch.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

class ExpiryDashboardPage extends ConsumerStatefulWidget {
  const ExpiryDashboardPage({super.key});

  @override
  ConsumerState<ExpiryDashboardPage> createState() => _ExpiryDashboardPageState();
}

class _ExpiryDashboardPageState extends ConsumerState<ExpiryDashboardPage> {
  int _daysAhead = 30;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(expiryAlertsProvider.notifier).load(daysAhead: _daysAhead));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(expiryAlertsProvider);

    return PosListPage(
      title: l10n.inventoryExpiryDashboard,
      showSearch: false,
      actions: [
        // Days ahead selector
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<int>(
            value: _daysAhead,
            isDense: true,
            decoration: InputDecoration(
              labelText: l10n.inventoryExpiryLookAhead,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            ),
            items: [7, 14, 30, 60, 90].map((d) => DropdownMenuItem(value: d, child: Text('$d ${l10n.inventoryDays}'))).toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _daysAhead = v);
                ref.read(expiryAlertsProvider.notifier).load(daysAhead: v);
              }
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(expiryAlertsProvider.notifier).load(daysAhead: _daysAhead),
          variant: PosButtonVariant.ghost,
        ),
      ],
      child: _buildBody(state, l10n),
    );
  }

  Widget _buildBody(ExpiryAlertsState state, AppLocalizations l10n) {
    if (state is ExpiryAlertsInitial || state is ExpiryAlertsLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (state is ExpiryAlertsError) {
      return PosErrorState(
        message: state.message,
        onRetry: () => ref.read(expiryAlertsProvider.notifier).load(daysAhead: _daysAhead),
      );
    }

    if (state is! ExpiryAlertsLoaded) return const SizedBox.shrink();

    final expired = state.expired;
    final soon7 = state.expiringSoon7;
    final soon30 = state.expiringSoon30;
    final total = expired.length + soon7.length + soon30.length;

    if (total == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.inventoryNoExpiryIssues,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.success),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.inventoryAllBatchesSafe(_daysAhead), style: TextStyle(color: AppColors.textMutedLight)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              _ExpiryCard(
                count: expired.length,
                label: l10n.inventoryExpired,
                color: AppColors.error,
                icon: Icons.warning_amber_rounded,
              ),
              const SizedBox(width: AppSpacing.md),
              _ExpiryCard(
                count: soon7.length,
                label: l10n.inventoryExpiring7Days,
                color: AppColors.warning,
                icon: Icons.timer_outlined,
              ),
              const SizedBox(width: AppSpacing.md),
              _ExpiryCard(count: soon30.length, label: l10n.inventoryExpiring30Days, color: AppColors.info, icon: Icons.schedule),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Expired section
          if (expired.isNotEmpty) ...[
            _SectionHeader(title: l10n.inventoryExpiredBatches, count: expired.length, color: AppColors.error),
            const SizedBox(height: AppSpacing.sm),
            _BatchTable(batches: expired, l10n: l10n, onMarkAsWasted: _markAsWasted),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Expiring in <7 days
          if (soon7.isNotEmpty) ...[
            _SectionHeader(title: l10n.inventoryExpiringIn7Days, count: soon7.length, color: AppColors.warning),
            const SizedBox(height: AppSpacing.sm),
            _BatchTable(batches: soon7, l10n: l10n, onMarkAsWasted: _markAsWasted),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Expiring in 7–30 days
          if (soon30.isNotEmpty) ...[
            _SectionHeader(title: l10n.inventoryExpiringIn30Days, count: soon30.length, color: AppColors.info),
            const SizedBox(height: AppSpacing.sm),
            _BatchTable(batches: soon30, l10n: l10n, onMarkAsWasted: _markAsWasted),
          ],
        ],
      ),
    );
  }

  Future<void> _markAsWasted(StockBatch batch) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: '${l10n.inventoryMarkAsWasted}?',
      message: l10n.inventoryMarkAsWastedConfirm(batch.quantity, batch.productName ?? batch.productId),
      confirmLabel: l10n.inventoryMarkAsWasted,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(wasteRecordsProvider.notifier).createWasteRecord({
        'product_id': batch.productId,
        'quantity': batch.quantity,
        'reason': 'expired',
        if (batch.batchNumber != null) 'batch_number': batch.batchNumber,
        if (batch.unitCost != null) 'unit_cost': batch.unitCost,
        'notes': 'Marked as wasted from Expiry Dashboard — Batch ${batch.batchNumber ?? batch.id.substring(0, 8)}',
      });
      if (mounted) {
        showPosSuccessSnackbar(context, l10n.inventoryWasteRecorded);
        // Refresh expiry alerts
        ref.read(expiryAlertsProvider.notifier).load(daysAhead: _daysAhead);
      }
    } catch (e) {
      if (mounted) showPosErrorSnackbar(context, e.toString());
    }
  }
}

// ─── Widgets ──────────────────────────────────────────────────────

class _ExpiryCard extends StatelessWidget {
  const _ExpiryCard({required this.count, required this.label, required this.color, required this.icon});
  final int count;
  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PosCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
                  ),
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count, required this.color});
  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$title ($count)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _BatchTable extends StatelessWidget {
  const _BatchTable({required this.batches, required this.l10n, required this.onMarkAsWasted});
  final List<StockBatch> batches;
  final AppLocalizations l10n;
  final ValueChanged<StockBatch> onMarkAsWasted;

  String _daysUntilExpiry(DateTime? expiryDate) {
    if (expiryDate == null) return '-';
    final diff = expiryDate.difference(DateTime.now()).inDays;
    if (diff < 0) return '${-diff}d ago';
    return '${diff}d';
  }

  Color _daysColor(DateTime? expiryDate) {
    if (expiryDate == null) return AppColors.textMutedLight;
    final diff = expiryDate.difference(DateTime.now()).inDays;
    if (diff < 0) return AppColors.error;
    if (diff < 7) return AppColors.warning;
    return AppColors.info;
  }

  @override
  Widget build(BuildContext context) {
    return PosDataTable<StockBatch>(
      columns: [
        PosTableColumn(title: l10n.inventoryProduct),
        PosTableColumn(title: l10n.inventoryBatchNumber),
        PosTableColumn(title: l10n.inventoryExpiryDate),
        PosTableColumn(title: l10n.inventoryDaysUntilExpiry),
        PosTableColumn(title: l10n.inventoryQuantity),
        PosTableColumn(title: l10n.inventoryUnitCost),
        PosTableColumn(title: l10n.commonAction),
      ],
      items: batches,
      isLoading: false,
      emptyConfig: PosTableEmptyConfig(icon: Icons.timer_off_outlined, title: l10n.inventoryNoBatches),
      cellBuilder: (batch, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(
              batch.productName ?? batch.productId.substring(0, 8),
              style: const TextStyle(fontWeight: FontWeight.w500),
            );
          case 1:
            return Text(batch.batchNumber ?? '-');
          case 2:
            return Text(
              batch.expiryDate != null ? '${batch.expiryDate!.day}/${batch.expiryDate!.month}/${batch.expiryDate!.year}' : '-',
            );
          case 3:
            return Text(
              _daysUntilExpiry(batch.expiryDate),
              style: TextStyle(color: _daysColor(batch.expiryDate), fontWeight: FontWeight.w600),
            );
          case 4:
            return Text(batch.quantity.toStringAsFixed(3));
          case 5:
            return Text(batch.unitCost != null ? 'SAR ${batch.unitCost!.toStringAsFixed(4)}' : '-');
          case 6:
            return PosButton.icon(
              icon: Icons.delete_sweep_outlined,
              tooltip: l10n.inventoryMarkAsWasted,
              onPressed: () => onMarkAsWasted(batch),
              variant: PosButtonVariant.ghost,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
