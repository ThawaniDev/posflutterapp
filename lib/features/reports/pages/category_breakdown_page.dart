import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_export_sheet.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class CategoryBreakdownPage extends ConsumerStatefulWidget {
  const CategoryBreakdownPage({super.key});

  @override
  ConsumerState<CategoryBreakdownPage> createState() => _CategoryBreakdownPageState();
}

class _CategoryBreakdownPageState extends ConsumerState<CategoryBreakdownPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref.read(categoryBreakdownProvider.notifier).load(filters: _filters);
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryBreakdownProvider);

    return PermissionGuardPage(
      permission: Permissions.reportsSales,
      child: ReportPageScaffold(
        title: l10n.sidebarCategoryBreakdown,
        actions: [
          PosButton.icon(
            icon: Icons.download_rounded,
            tooltip: l10n.reportsExportFormatTitle,
            variant: PosButtonVariant.ghost,
            onPressed: () => showReportExportSheet(
              context: context,
              reportType: 'category_breakdown',
              filters: _filters,
            ),
          ),
        ],
        filterPanel: ReportFilterPanel(filters: _filters, onFiltersChanged: _onFiltersChanged, onRefresh: _loadData),
        body: switch (state) {
          CategoryBreakdownInitial() || CategoryBreakdownLoading() => PosLoadingSkeleton.list(),
          CategoryBreakdownError(:final message) => PosErrorState(message: message, onRetry: _loadData),
          CategoryBreakdownLoaded(:final categories) =>
            categories.isEmpty
                ? PosEmptyState(title: l10n.reportsNoCategoryData, icon: Icons.category)
                : _CategoryList(categories: categories),
        },
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {

  const _CategoryList({required this.categories});
  final List<Map<String, dynamic>> categories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalRevenue = categories.fold<double>(0, (sum, c) => sum + (double.tryParse(c['total_revenue'].toString()) ?? 0.0));
    final maxRevenue = categories.isEmpty
        ? 1.0
        : categories.map((c) => double.tryParse(c['total_revenue'].toString()) ?? 0.0).reduce((a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(
              label: l10n.categories,
              value: '${categories.length}',
              icon: Icons.category_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: l10n.totalRevenue,
              value: formatCurrency(totalRevenue),
              icon: Icons.attach_money_rounded,
              color: AppColors.success,
            ),
          ],
        ),

        // Pie Chart — Category revenue share
        if (categories.isNotEmpty) ...[
          const SizedBox(height: 20),
          ReportSectionHeader(title: l10n.reportsRevenueShare, icon: Icons.donut_large_rounded),
          ReportDataCard(
            child: ReportPieChart(
              data: categories.take(8).toList(),
              labelKey: 'category_name',
              valueKey: 'total_revenue',
              donut: true,
            ),
          ),
        ],

        const SizedBox(height: 24),
        ReportSectionHeader(title: l10n.reportsRevenueByCategory, icon: Icons.pie_chart_rounded),

        ReportDataCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: List.generate(categories.length, (i) {
              final c = categories[i];
              final revenue = double.tryParse(c['total_revenue'].toString()) ?? 0.0;
              final pct = totalRevenue > 0 ? revenue / totalRevenue : 0.0;
              final profit = double.tryParse(c['profit'].toString()) ?? 0.0;
              final qty = (c['total_quantity'] as num).toInt();

              return Column(
                children: [
                  if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: AppRadius.borderMd,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['category_name'] as String? ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  if (c['category_name_ar'] != null)
                                    Text(
                                      c['category_name_ar'] as String,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.mutedFor(context),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency(revenue),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  formatPercent(pct * 100),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.mutedFor(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ReportBar(value: revenue, maxValue: maxRevenue, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: [
                            ReportBadge(label: l10n.reportNProducts(c['product_count'].toString()), color: AppColors.info),
                            ReportBadge(label: l10n.reportNSold(qty.toString()), color: AppColors.primary),
                            ReportBadge(
                              label: l10n.reportProfitAmount(formatCurrency(profit)),
                              color: profit >= 0 ? AppColors.success : AppColors.error,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
