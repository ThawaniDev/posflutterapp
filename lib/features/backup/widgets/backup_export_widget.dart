import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/providers/backup_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class BackupExportWidget extends ConsumerStatefulWidget {
  const BackupExportWidget({super.key});

  @override
  ConsumerState<BackupExportWidget> createState() => _BackupExportWidgetState();
}

class _BackupExportWidgetState extends ConsumerState<BackupExportWidget> {
  final Map<String, bool> _selectedTables = {
    'products': true,
    'customers': true,
    'orders': true,
    'inventory': false,
    'settings': false,
    'staff': false,
    'categories': true,
  };
  String _format = 'json';
  bool _includeImages = false;
  Map<String, dynamic>? _result;

  List<String> get _activeTables => _selectedTables.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final opState = ref.watch(backupOperationProvider);
    final isLoading = opState is BackupOperationRunning;

    if (_result != null) {
      return _buildResultView(context, l10n, _result!);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Table selection ──────────────────────────────
          Text(l10n.backupExportTables, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          PosCard(
            padding: AppSpacing.paddingAll16,
            child: Column(
              children: [
                _tableCheckbox(l10n, 'products', l10n.backupExportTableProducts, Icons.inventory_2_outlined),
                _tableCheckbox(l10n, 'customers', l10n.backupExportTableCustomers, Icons.people_outline),
                _tableCheckbox(l10n, 'orders', l10n.backupExportTableOrders, Icons.receipt_long_outlined),
                _tableCheckbox(l10n, 'inventory', l10n.backupExportTableInventory, Icons.warehouse_outlined),
                _tableCheckbox(l10n, 'settings', l10n.backupExportTableSettings, Icons.settings_outlined),
                _tableCheckbox(l10n, 'staff', l10n.backupExportTableStaff, Icons.badge_outlined),
                _tableCheckbox(l10n, 'categories', l10n.backupExportTableCategories, Icons.category_outlined),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Format ──────────────────────────────────────
          Text(l10n.backupExportFormat, style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _formatOption(context, l10n, 'json', l10n.backupExportFormatJson, Icons.data_object_rounded),
              const SizedBox(width: AppSpacing.md),
              _formatOption(context, l10n, 'csv', l10n.backupExportFormatCsv, Icons.table_chart_outlined),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Include images ───────────────────────────────
          PosToggle(
            label: l10n.backupExportIncludeImages,
            subtitle: l10n.backupExportIncludeImagesDesc,
            value: _includeImages,
            onChanged: (v) => setState(() => _includeImages = v),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // ── Export button ────────────────────────────────
          PosButton(
            label: l10n.backupExport,
            icon: Icons.download_rounded,
            isLoading: isLoading,
            isFullWidth: true,
            onPressed: _activeTables.isNotEmpty ? () => _export(l10n) : null,
          ),

          if (opState is BackupOperationError) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              opState.message,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _tableCheckbox(AppLocalizations l10n, String key, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: PosCheckboxTile(
        label: label,
        value: _selectedTables[key] ?? false,
        onChanged: (v) => setState(() => _selectedTables[key] = v ?? false),
      ),
    );
  }

  Widget _formatOption(BuildContext context, AppLocalizations l10n, String value, String label, IconData icon) {
    final isSelected = _format == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _format = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: AppSpacing.paddingAll16,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : (Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight),
            borderRadius: AppRadius.borderLg,
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderFor(context), width: isSelected ? 2 : 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : AppColors.mutedFor(context), size: 22),
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: AppTypography.titleSmall.copyWith(color: isSelected ? AppColors.primary : null)),
              const Spacer(),
              if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _export(AppLocalizations l10n) async {
    await ref
        .read(backupOperationProvider.notifier)
        .exportData(tables: _activeTables, format: _format, includeImages: _includeImages);
    if (!mounted) return;
    final opState = ref.read(backupOperationProvider);
    if (opState is BackupOperationSuccess) {
      setState(() => _result = opState.data);
    } else if (opState is BackupOperationError) {
      showPosErrorSnackbar(context, opState.message);
    }
  }

  Widget _buildResultView(BuildContext context, AppLocalizations l10n, Map<String, dynamic> result) {
    final exportData = result['data'] as Map<String, dynamic>? ?? result;
    final exportId = exportData['export_id'] as String? ?? '—';
    final filePath = exportData['file_path'] as String? ?? '—';
    final totalRecords = (exportData['total_records'] as num?)?.toInt() ?? 0;
    final tables = exportData['tables'] as List? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Success header ───────────────────────────────
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.success.withValues(alpha: 0.30)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.backupExportSuccess, style: AppTypography.titleMedium.copyWith(color: AppColors.success)),
                      Text(
                        '${l10n.backupExportTotalRecords}: $totalRecords',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Result details ───────────────────────────────
          PosCard(
            padding: AppSpacing.paddingAll20,
            child: Column(
              children: [
                _resultRow(context, l10n.backupExportId, exportId),
                _resultRow(context, l10n.backupExportFilePath, filePath),
                _resultRow(context, l10n.backupExportFormat, _format.toUpperCase()),
                _resultRow(context, l10n.backupExportTotalRecords, '$totalRecords'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Per-table breakdown ──────────────────────────
          if (tables.isNotEmpty) ...[
            Text(l10n.backupByType, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            PosCard(
              padding: AppSpacing.paddingAll16,
              child: Column(
                children: tables.map((t) {
                  final tbl = t as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        Text(tbl['table'] as String? ?? '—', style: AppTypography.bodyMedium),
                        const Spacer(),
                        Text(
                          '${tbl['records_count'] ?? 0} records',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── New export button ────────────────────────────
          PosButton(
            label: l10n.backupExportData,
            variant: PosButtonVariant.outline,
            icon: Icons.refresh,
            isFullWidth: true,
            onPressed: () {
              setState(() => _result = null);
              ref.read(backupOperationProvider.notifier).reset();
            },
          ),
        ],
      ),
    );
  }

  Widget _resultRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
          ),
          Expanded(flex: 3, child: Text(value, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }
}
