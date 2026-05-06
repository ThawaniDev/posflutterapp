import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/providers/label_providers.dart';
import 'package:wameedpos/features/labels/providers/label_state.dart';

/// Print History page — shows print-job stats KPIs and a filterable table of
/// all past print jobs, using the [labelHistoryProvider] and
/// [labelPrintStatsProvider] state notifiers.
class LabelHistoryPage extends ConsumerStatefulWidget {
  const LabelHistoryPage({super.key});

  @override
  ConsumerState<LabelHistoryPage> createState() => _LabelHistoryPageState();
}

class _LabelHistoryPageState extends ConsumerState<LabelHistoryPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  final _dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

  // Filter state
  DateTime? _filterFrom;
  DateTime? _filterTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  void _loadAll() {
    ref.read(labelHistoryProvider.notifier).load(from: _filterFrom, to: _filterTo);
    ref.read(labelPrintStatsProvider.notifier).load();
  }

  Future<void> _pickDateFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterFrom ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _filterFrom = picked);
    }
  }

  Future<void> _pickDateTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterTo ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _filterTo = picked);
    }
  }

  void _applyFilters() {
    ref.read(labelHistoryProvider.notifier).load(from: _filterFrom, to: _filterTo);
  }

  void _clearFilters() {
    setState(() {
      _filterFrom = null;
      _filterTo = null;
    });
    ref.read(labelHistoryProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(labelHistoryProvider);
    final statsState = ref.watch(labelPrintStatsProvider);

    final isLoading = historyState is LabelHistoryLoading;
    final hasError = historyState is LabelHistoryError;
    final items = historyState is LabelHistoryLoaded ? historyState.history : <LabelPrintHistory>[];

    return PermissionGuardPage(
      permission: Permissions.labelsView,
      child: PosListPage(
        title: l10n.labelPrintHistory,
        showSearch: false,
        onBack: () => context.pop(),
        isLoading: false,
        hasError: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stats KPI row ───────────────────────────────────────
            if (statsState is LabelPrintStatsLoaded)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                child: PosKpiGrid(
                  cards: [
                    PosKpiCard(
                      label: l10n.labelJobsLast30Days,
                      value: '${statsState.stats.jobsLast30Days}',
                      icon: Icons.print_rounded,
                      iconBgColor: AppColors.primary,
                    ),
                    PosKpiCard(
                      label: l10n.labelProductsLast30Days,
                      value: '${statsState.stats.productsLast30Days}',
                      icon: Icons.inventory_2_rounded,
                      iconBgColor: AppColors.success,
                    ),
                    PosKpiCard(
                      label: l10n.labelLabelsLast30Days,
                      value: '${statsState.stats.labelsLast30Days}',
                      icon: Icons.label_rounded,
                      iconBgColor: AppColors.info,
                    ),
                  ],
                ),
              )
            else if (statsState is LabelPrintStatsLoading)
              const Padding(padding: EdgeInsets.all(AppSpacing.md), child: LinearProgressIndicator()),

            // ── Date filter row ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _FilterChip(
                    label: _filterFrom != null
                        ? '${l10n.labelFilterFrom}: ${DateFormat('dd/MM/yy').format(_filterFrom!)}'
                        : l10n.labelFilterFrom,
                    isActive: _filterFrom != null,
                    onTap: _pickDateFrom,
                    onClear: _filterFrom != null ? () => setState(() => _filterFrom = null) : null,
                  ),
                  _FilterChip(
                    label: _filterTo != null
                        ? '${l10n.labelFilterTo}: ${DateFormat('dd/MM/yy').format(_filterTo!)}'
                        : l10n.labelFilterTo,
                    isActive: _filterTo != null,
                    onTap: _pickDateTo,
                    onClear: _filterTo != null ? () => setState(() => _filterTo = null) : null,
                  ),
                  if (_filterFrom != null || _filterTo != null) ...[
                    FilledButton.icon(
                      onPressed: _applyFilters,
                      icon: const Icon(Icons.filter_alt_rounded, size: 16),
                      label: Text(l10n.labelApplyFilter),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      label: Text(l10n.labelClearFilter),
                      style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                    ),
                  ],
                ],
              ),
            ),

            // ── History table ───────────────────────────────────────
            Expanded(
              child: PosDataTable<LabelPrintHistory>(
                columns: [
                  PosTableColumn(title: l10n.txColDate),
                  PosTableColumn(title: l10n.labelTemplate),
                  PosTableColumn(title: l10n.products, numeric: true),
                  PosTableColumn(title: l10n.labelsTitle, numeric: true),
                  PosTableColumn(title: l10n.hardwarePrinter),
                  PosTableColumn(title: l10n.labelPrinterLanguage),
                  PosTableColumn(title: l10n.labelsPrintedBy),
                ],
                items: items,
                isLoading: isLoading,
                error: hasError ? (historyState as LabelHistoryError).message : null,
                onRetry: _loadAll,
                emptyConfig: PosTableEmptyConfig(
                  icon: Icons.history_rounded,
                  title: l10n.labelNoHistory,
                  subtitle: l10n.labelNoHistorySubtitle,
                ),
                cellBuilder: (item, colIndex, col) {
                  switch (colIndex) {
                    case 0: // Date
                      return Text(item.printedAt != null ? _dateFormatter.format(item.printedAt!) : '—');
                    case 1: // Template
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderSm,
                            ),
                            child: const Icon(Icons.label_rounded, size: 14, color: AppColors.info),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(item.templateName ?? item.templateId?.substring(0, 8) ?? '—'),
                        ],
                      );
                    case 2: // Product count
                      return Text('${item.productCount}');
                    case 3: // Total labels
                      return PosBadge(label: '${item.totalLabels}', variant: PosBadgeVariant.primary, isSmall: true);
                    case 4: // Printer name
                      return Text(item.printerName ?? '—');
                    case 5: // Printer language
                      return item.printerLanguage != null ? _LanguageBadge(language: item.printerLanguage!) : const Text('—');
                    case 6: // Printed by
                      return Text(item.printedByName ?? item.printedBy);
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private widgets ─────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isActive, required this.onTap, this.onClear});

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.12) : AppColors.borderSubtleLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.primary : AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_rounded, size: 14, color: isActive ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 13, color: isActive ? AppColors.primary : AppColors.textSecondary)),
            if (onClear != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close_rounded, size: 14, color: isActive ? AppColors.primary : AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguageBadge extends StatelessWidget {
  const _LanguageBadge({required this.language});

  final String language;

  static const _colors = {
    'zpl': AppColors.primary,
    'tspl': AppColors.info,
    'escpos': AppColors.warning,
    'image': AppColors.textMutedLight,
  };

  static const _labels = {'zpl': 'ZPL', 'tspl': 'TSPL', 'escpos': 'ESC/POS', 'image': 'IMG'};

  @override
  Widget build(BuildContext context) {
    final color = _colors[language] ?? AppColors.textSecondaryLight;
    final label = _labels[language] ?? language.toUpperCase();
    return PosBadge(label: label, variant: PosBadgeVariant.neutral, customColor: color, isSmall: true);
  }
}
