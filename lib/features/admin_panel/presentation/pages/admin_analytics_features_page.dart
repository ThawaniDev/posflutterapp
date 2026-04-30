import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsFeaturesPage extends ConsumerStatefulWidget {
  const AdminAnalyticsFeaturesPage({super.key});
  @override
  ConsumerState<AdminAnalyticsFeaturesPage> createState() => _State();
}

class _State extends ConsumerState<AdminAnalyticsFeaturesPage> {
  late String _dateFrom;
  late String _dateTo;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateTo   = now.toIso8601String().substring(0, 10);
    _dateFrom = now.subtract(const Duration(days: 30)).toIso8601String().substring(0, 10);
    Future.microtask(_load);
  }

  void _load() => ref.read(analyticsFeaturesProvider.notifier).load(dateFrom: _dateFrom, dateTo: _dateTo);

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showPosDateRangePicker(context, firstDate: DateTime(now.year - 2), lastDate: now);
    if (r != null && mounted) {
      setState(() {
        _dateFrom = r.start.toIso8601String().substring(0, 10);
        _dateTo   = r.end.toIso8601String().substring(0, 10);
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsFeaturesProvider);

    return PosListPage(
      title: l10n.analyticsFeatureAdoption,
      showSearch: false,
      actions: [
        IconButton(icon: const Icon(Icons.date_range_outlined), onPressed: _pickRange, tooltip: l10n.analyticsSelectDateRange),
      ],
      child: switch (state) {
        AnalyticsFeaturesLoading() => PosLoadingSkeleton.list(),
        AnalyticsFeaturesLoaded(features: final featureList, trend: final _) =>
          RefreshIndicator(
            onRefresh: () async => _load(),
            child: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
              Chip(
                avatar: const Icon(Icons.date_range, size: 14),
                label: Text('$_dateFrom → $_dateTo', style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: AppSpacing.md),
              // Bar chart
              Text(l10n.analyticsFeatureAdoptionRates, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              PosCard(
                child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: featureList.isEmpty
                  ? PosEmptyState(title: l10n.adminNoFeatureData)
                  : ReportBarChart(
                      data: featureList,
                      labelKey: 'feature_key',
                      valueKey: 'adoption_percentage',
                      barColor: AppColors.primary,
                      height: 260,
                      horizontal: featureList.length > 6,
                    )),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Feature list with progress bars
              Text(l10n.analyticsFeatureDetails, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              if (featureList.isEmpty)
                PosEmptyState(title: l10n.adminNoFeatureData)
              else
                ...featureList.map((f) {
                  final pct = (f['adoption_percentage'] as num? ?? 0).toDouble();
                  return PosCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: Text(f['feature_key'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                          Text('${pct.toStringAsFixed(1)}%', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pct >= 75 ? AppColors.success : pct >= 40 ? AppColors.warning : AppColors.error,
                          )),
                        ]),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: (pct / 100).clamp(0.0, 1.0),
                          backgroundColor: AppColors.borderLight,
                          color: pct >= 75 ? AppColors.success : pct >= 40 ? AppColors.warning : AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 4),
                        Text('${f['stores_using'] ?? 0} of ${f['total_eligible'] ?? 0} stores',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ]),
                    ),
                  );
                }),
            ]),
          ),
        AnalyticsFeaturesError(message: final msg) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          PosErrorState(message: msg), const SizedBox(height: AppSpacing.sm),
          PosButton(onPressed: _load, label: l10n.retry),
        ])),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }
}
