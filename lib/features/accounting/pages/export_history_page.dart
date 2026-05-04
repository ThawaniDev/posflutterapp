import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/accounting/providers/accounting_providers.dart';
import 'package:wameedpos/features/accounting/providers/accounting_state.dart';

class ExportHistoryPage extends ConsumerStatefulWidget {
  const ExportHistoryPage({super.key});

  @override
  ConsumerState<ExportHistoryPage> createState() => _ExportHistoryPageState();
}

class _ExportHistoryPageState extends ConsumerState<ExportHistoryPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(accountingExportsProvider.notifier).loadExports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final exportsState = ref.watch(accountingExportsProvider);

    final isLoading = exportsState is AccountingExportsInitial || exportsState is AccountingExportsLoading;
    final hasError = exportsState is AccountingExportsError;
    final isEmpty = exportsState is AccountingExportsLoaded && exportsState.exports.isEmpty;

    return PosListPage(
      title: l10n.accountingExportHistory,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? exportsState.message : null,
      onRetry: () => ref.read(accountingExportsProvider.notifier).loadExports(),
      isEmpty: isEmpty,
      emptyTitle: 'No exports yet\nTap + to create your first export',
      emptyIcon: Icons.file_download_off,
      actions: [PosButton(label: l10n.newExport, icon: Icons.add, onPressed: _showNewExportDialog)],
      filters: [_buildStatusFilter()],
      child: _buildExportList(exportsState),
    );
  }

  Widget _buildStatusFilter() {
    const statuses = ['pending', 'processing', 'success', 'failed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: Text(l10n.all),
            selected: _statusFilter == null,
            onSelected: (_) {
              setState(() => _statusFilter = null);
              ref.read(accountingExportsProvider.notifier).loadExports();
            },
          ),
          AppSpacing.gapW8,
          ...statuses.map(
            (s) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: FilterChip(
                label: Text(s[0].toUpperCase() + s.substring(1)),
                selected: _statusFilter == s,
                avatar: Icon(_statusIcon(s), size: 16),
                onSelected: (_) {
                  setState(() => _statusFilter = s);
                  ref.read(accountingExportsProvider.notifier).loadExports(status: s);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportList(AccountingExportsState state) {
    return switch (state) {
      AccountingExportsLoaded(:final exports) => RefreshIndicator(
        onRefresh: () => ref.read(accountingExportsProvider.notifier).loadExports(status: _statusFilter),
        child: ListView.separated(
          itemCount: exports.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) => _buildExportTile(exports[index]),
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildExportTile(Map<String, dynamic> export) {
    final status = export['status'] as String? ?? 'pending';
    final startDate = export['start_date'] as String? ?? '';
    final endDate = export['end_date'] as String? ?? '';
    final entriesCount = export['entries_count'] as int? ?? 0;
    final createdAt = export['created_at'] as String?;
    final triggeredBy = export['triggered_by'] as String? ?? 'manual';
    final errorMessage = export['error_message'] as String?;
    final id = export['id'] as String;
    final exportTypes = export['export_types'] as List<dynamic>?;

    final Color statusColor = _statusColor(status);
    final IconData statusIcon = _statusIcon(status);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.15),
        child: Icon(statusIcon, color: statusColor, size: 20),
      ),
      title: Text('$startDate → $endDate', style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatusChip(status, statusColor),
              AppSpacing.gapW8,
              Text(
                l10n.accountingEntriesCount(entriesCount),
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              AppSpacing.gapW8,
              Icon(triggeredBy == 'scheduled' ? Icons.schedule : Icons.touch_app, size: 14, color: AppColors.textSecondary),
              AppSpacing.gapW4,
              Text(triggeredBy, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          if (exportTypes != null && exportTypes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 4,
                children: exportTypes
                    .take(3)
                    .map(
                      (t) => Chip(
                        label: Text((t as String).replaceAll('_', ' '), style: const TextStyle(fontSize: 10)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    )
                    .toList(),
              ),
            ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                errorMessage,
                style: const TextStyle(color: AppColors.errorDark, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (createdAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_formatDate(createdAt), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ),
        ],
      ),
      isThreeLine: true,
      trailing: status == 'failed'
          ? IconButton(
              icon: const Icon(Icons.replay, color: AppColors.warning),
              tooltip: l10n.adminFinOpsRetryExport,
              onPressed: () => ref.read(accountingExportsProvider.notifier).retryExport(id),
            )
          : null,
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showNewExportDialog() {
    final startController = TextEditingController();
    final endController = TextEditingController();
    final selectedTypes = <String>{};
    const allTypes = [
      'daily_summary',
      'payment_breakdown',
      'category_breakdown',
      'expense_entries',
      'payroll_summary',
      'full_reconciliation',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.newExport),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: startController,
                  decoration: InputDecoration(
                    labelText: l10n.accountingExportStartDate,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      startController.text =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                  readOnly: true,
                ),
                AppSpacing.gapH12,
                TextField(
                  controller: endController,
                  decoration: InputDecoration(
                    labelText: l10n.accountingExportEndDate,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      endController.text =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                  readOnly: true,
                ),
                AppSpacing.gapH16,
                Text(l10n.acctExportTypesOptional, style: const TextStyle(fontWeight: FontWeight.w600)),
                AppSpacing.gapH8,
                ...allTypes.map(
                  (t) => CheckboxListTile(
                    title: Text(
                      t.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' '),
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: selectedTypes.contains(t),
                    dense: true,
                    onChanged: (val) {
                      setDialogState(() {
                        if (val == true) {
                          selectedTypes.add(t);
                        } else {
                          selectedTypes.remove(t);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            PosButton(onPressed: () => Navigator.of(ctx).pop(), variant: PosButtonVariant.ghost, label: l10n.cancel),
            PosButton(
              onPressed: () {
                if (startController.text.isEmpty || endController.text.isEmpty) {
                  showPosWarningSnackbar(ctx, AppLocalizations.of(ctx)!.pleaseSelectBothDates);
                  return;
                }
                Navigator.of(ctx).pop();
                ref
                    .read(accountingExportsProvider.notifier)
                    .triggerExport(
                      startDate: startController.text,
                      endDate: endController.text,
                      exportTypes: selectedTypes.isNotEmpty ? selectedTypes.toList() : null,
                    );
              },
              label: l10n.accountingExport,
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'pending' => Icons.hourglass_empty,
      'processing' => Icons.sync,
      'success' => Icons.check_circle,
      'failed' => Icons.error,
      _ => Icons.help_outline,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'pending' => AppColors.warning,
      'processing' => AppColors.info,
      'success' => AppColors.success,
      'failed' => AppColors.error,
      _ => AppColors.textSecondary,
    };
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
