import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/cashier_gamification/data/gamification_repository.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_providers.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';
import 'package:wameedpos/features/cashier_gamification/widgets/shift_report_card.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class GamificationShiftReportsPage extends ConsumerStatefulWidget {
  const GamificationShiftReportsPage({super.key});

  @override
  ConsumerState<GamificationShiftReportsPage> createState() => _GamificationShiftReportsPageState();
}

class _GamificationShiftReportsPageState extends ConsumerState<GamificationShiftReportsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(shiftReportsProvider.notifier).load());
  }

  void _showReportDetail(String reportId) {
    // Navigate to detail or show bottom sheet
    final isMobile = context.isPhone;
    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (ctx) => _ReportDetailSheet(reportId: reportId),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: _ReportDetailSheet(reportId: reportId),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(shiftReportsProvider);
    final isMobile = context.isPhone;

    return PosListPage(
  title: l10n.gamificationShiftReports,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(shiftReportsProvider.notifier).load(), tooltip: l10n.commonRefresh,
  ),
],
  child: _buildContent(state, l10n, isMobile),
);
  }

  Widget _buildContent(ShiftReportsState state, AppLocalizations l10n, bool isMobile) {
    return switch (state) {
      ShiftReportsInitial() || ShiftReportsLoading() => const Center(child: CircularProgressIndicator()),
      ShiftReportsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH8,
            Text(message, textAlign: TextAlign.center),
            AppSpacing.gapH12,
            PosButton(onPressed: () => ref.read(shiftReportsProvider.notifier).load(), label: l10n.commonRetry),
          ],
        ),
      ),
      ShiftReportsLoaded(:final reports) =>
        reports.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assessment_outlined, size: 64, color: Colors.grey.shade400),
                    AppSpacing.gapH12,
                    Text(l10n.gamificationNoReports, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              )
            : ListView.builder(
                padding: context.responsivePagePadding,
                itemCount: reports.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ShiftReportCard(report: reports[index], onTap: () => _showReportDetail(reports[index].id)),
                ),
              ),
    };
  }
}

class _ReportDetailSheet extends ConsumerStatefulWidget {
  final String reportId;
  const _ReportDetailSheet({required this.reportId});

  @override
  ConsumerState<_ReportDetailSheet> createState() => _ReportDetailSheetState();
}

class _ReportDetailSheetState extends ConsumerState<_ReportDetailSheet> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _report;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    try {
      final repo = ref.read(gamificationRepositoryProvider);
      final report = await repo.getShiftReport(widget.reportId);
      if (mounted) {
        setState(() {
          _loading = false;
          _report = {
            'cashier': report.cashier?.name ?? 'Cashier',
            'date': report.reportDate,
            'transactions': report.totalTransactions,
            'revenue': report.totalRevenue,
            'items': report.totalItems,
            'ipm': report.itemsPerMinute,
            'voids': report.voidCount,
            'returns': report.returnCount,
            'risk': report.riskScore,
            'risk_level': report.riskLevel,
            'summary_en': report.summaryEn ?? '',
            'summary_ar': report.summaryAr ?? '',
          };
        });
      }
    } catch (e) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = e.toString();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    if (_loading)
      return const Center(
        child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
      );
    if (_error != null)
      return Center(
        child: Padding(padding: const EdgeInsets.all(24), child: Text(_error!)),
      );

    final r = _report!;
    final summary = locale == 'ar' ? r['summary_ar'] : r['summary_en'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${r['cashier']} — ${r['date']}', style: Theme.of(context).textTheme.titleMedium),
            AppSpacing.gapH16,
            _DetailRow(l10n.gamificationTransactions, '${r['transactions']}'),
            _DetailRow(l10n.gamificationRevenue, '${(r['revenue'] as double).toStringAsFixed(2)}'),
            _DetailRow(l10n.gamificationItemsPerMinute, '${(r['ipm'] as double).toStringAsFixed(2)}'),
            _DetailRow('Voids', '${r['voids']}'),
            _DetailRow('Returns', '${r['returns']}'),
            _DetailRow(l10n.gamificationRiskScore, '${(r['risk'] as double).toStringAsFixed(0)} (${r['risk_level']})'),
            if ((summary as String).isNotEmpty) ...[
              AppSpacing.gapH12,
              Text(l10n.gamificationSummary, style: const TextStyle(fontWeight: FontWeight.bold)),
              AppSpacing.gapH4,
              Text(summary),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
