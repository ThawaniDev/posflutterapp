import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/catalog/repositories/catalog_repository.dart';

/// Four-step wizard for bulk product import:
/// 1. Pick file (CSV/XLSX)
/// 2. Map columns (header row → canonical product fields)
/// 3. Preview rows
/// 4. Run import + show outcome
class ProductBulkImportPage extends ConsumerStatefulWidget {
  const ProductBulkImportPage({super.key});

  @override
  ConsumerState<ProductBulkImportPage> createState() => _ProductBulkImportPageState();
}

class _ProductBulkImportPageState extends ConsumerState<ProductBulkImportPage> {
  int _step = 0;

  // Step 1
  PlatformFile? _pickedFile;
  bool _previewLoading = false;
  String? _previewError;

  // Step 2/3
  ImportPreview? _preview;
  final Map<String, int> _mapping = {}; // canonical field → column idx

  // Step 4
  bool _importing = false;
  ImportResult? _result;
  String? _importError;

  static const List<String> _requiredFields = ['name', 'sell_price'];

  Future<void> _pickFile() async {
    final res = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      withReadStream: false,
    );
    if (res == null || res.files.isEmpty) return;
    setState(() {
      _pickedFile = res.files.first;
      _previewError = null;
      _preview = null;
      _mapping.clear();
    });
  }

  Future<void> _loadPreview() async {
    final file = _pickedFile;
    if (file == null || file.path == null) return;
    setState(() {
      _previewLoading = true;
      _previewError = null;
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final preview = await repo.importPreview(filePath: file.path!, fileName: file.name);
      // auto-map by exact header match (case-insensitive)
      final lowerHeader = preview.header.map((h) => h.trim().toLowerCase()).toList();
      for (final field in preview.availableFields) {
        final i = lowerHeader.indexOf(field.toLowerCase());
        if (i != -1) _mapping[field] = i;
      }
      setState(() {
        _preview = preview;
        _step = 1;
      });
    } catch (e) {
      setState(() => _previewError = e.toString());
    } finally {
      if (mounted) setState(() => _previewLoading = false);
    }
  }

  Future<void> _runImport() async {
    final file = _pickedFile;
    if (file == null || file.path == null) return;
    setState(() {
      _importing = true;
      _importError = null;
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final res = await repo.bulkImport(filePath: file.path!, fileName: file.name, mapping: _mapping);
      setState(() {
        _result = res;
        _step = 3;
      });
    } catch (e) {
      setState(() => _importError = e.toString());
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  bool get _mappingValid => _requiredFields.every((f) => _mapping.containsKey(f));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosFormPage(
      title: l10n.catalogBulkImportTitle,
      subtitle: l10n.catalogBulkImportSubtitle,
      onBack: () => context.go(Routes.products),
      bottomBar: _buildBottomBar(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PosStepIndicator(
            totalSteps: 4,
            currentStep: _step,
            labels: [
              l10n.catalogImportStepFile,
              l10n.catalogImportStepMap,
              l10n.catalogImportStepPreview,
              l10n.catalogImportStepResult,
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildStepBody(l10n),
        ],
      ),
    );
  }

  Widget _buildStepBody(AppLocalizations l10n) {
    switch (_step) {
      case 0:
        return _buildPickStep(l10n);
      case 1:
        return _buildMapStep(l10n);
      case 2:
        return _buildPreviewStep(l10n);
      case 3:
        return _buildResultStep(l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── Step 1 ─────────────────────────────────────────────

  Widget _buildPickStep(AppLocalizations l10n) {
    return PosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.catalogImportPickFileHeading, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.catalogImportPickFileHint, style: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedLight)),
            const SizedBox(height: AppSpacing.lg),
            DottedDropZone(
              file: _pickedFile,
              onPick: _pickFile,
              labelEmpty: l10n.catalogImportSelectFile,
              labelChange: l10n.catalogImportChangeFile,
            ),
            if (_previewError != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_previewError!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ],
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary5,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.primary20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(l10n.catalogImportFormatTip, style: AppTypography.bodySmall)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 2 ─────────────────────────────────────────────

  Widget _buildMapStep(AppLocalizations l10n) {
    final p = _preview!;
    final headerOptions = [
      const DropdownMenuItem<int?>(value: null, child: Text('—')),
      for (var i = 0; i < p.header.length; i++)
        DropdownMenuItem<int?>(value: i, child: Text(p.header[i].isEmpty ? 'Col ${i + 1}' : p.header[i])),
    ];

    return PosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.catalogImportMapHeading, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.catalogImportMapHint, style: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedLight)),
            const SizedBox(height: AppSpacing.lg),
            ...p.availableFields.map((field) {
              final isRequired = _requiredFields.contains(field);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Row(
                        children: [
                          Text(field, style: AppTypography.bodyMedium),
                          if (isRequired) ...[
                            const SizedBox(width: 4),
                            const Text('*', style: TextStyle(color: AppColors.error)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: _mapping[field],
                        items: headerOptions,
                        onChanged: (v) => setState(() {
                          if (v == null) {
                            _mapping.remove(field);
                          } else {
                            _mapping[field] = v;
                          }
                        }),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── Step 3 ─────────────────────────────────────────────

  Widget _buildPreviewStep(AppLocalizations l10n) {
    final p = _preview!;
    final mappedFields = _mapping.keys.toList();

    return PosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.catalogImportPreviewHeading, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.catalogImportPreviewHint(p.totalRows),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedLight),
            ),
            const SizedBox(height: AppSpacing.lg),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [for (final f in mappedFields) DataColumn(label: Text(f))],
                rows: [
                  for (final row in p.preview)
                    DataRow(cells: [for (final f in mappedFields) DataCell(Text(_cellAt(row, _mapping[f]!)))]),
                ],
              ),
            ),
            if (_importError != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_importError!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ],
          ],
        ),
      ),
    );
  }

  String _cellAt(List<String> row, int idx) {
    if (idx < 0 || idx >= row.length) return '';
    return row[idx];
  }

  // ─── Step 4 ─────────────────────────────────────────────

  Widget _buildResultStep(AppLocalizations l10n) {
    final r = _result!;
    final hasErrors = r.failed > 0;

    return PosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasErrors ? Icons.warning_rounded : Icons.check_circle,
                  color: hasErrors ? AppColors.warning : AppColors.success,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  hasErrors ? l10n.catalogImportPartialTitle : l10n.catalogImportSuccessTitle,
                  style: AppTypography.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.md,
              children: [
                _StatTile(label: l10n.catalogImportCreated, value: r.created.toString(), color: AppColors.success),
                _StatTile(
                  label: l10n.catalogImportFailed,
                  value: r.failed.toString(),
                  color: r.failed > 0 ? AppColors.error : AppColors.textMutedLight,
                ),
              ],
            ),
            if (r.errors.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.catalogImportErrorsHeading, style: AppTypography.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: r.errors.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final e = r.errors[i];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                      title: Text('Row ${e.row}: ${e.message}'),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Bottom bar ─────────────────────────────────────────

  Widget _buildBottomBar() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PosButton(variant: PosButtonVariant.ghost, label: l10n.commonCancel, onPressed: () => context.go(Routes.products)),
        Row(
          children: [
            if (_step > 0 && _step < 3)
              PosButton(variant: PosButtonVariant.outline, label: l10n.commonBack, onPressed: () => setState(() => _step -= 1)),
            const SizedBox(width: AppSpacing.sm),
            _buildPrimaryAction(l10n),
          ],
        ),
      ],
    );
  }

  Widget _buildPrimaryAction(AppLocalizations l10n) {
    switch (_step) {
      case 0:
        return PosButton(
          label: l10n.commonNext,
          isLoading: _previewLoading,
          onPressed: _pickedFile == null ? null : _loadPreview,
        );
      case 1:
        return PosButton(label: l10n.commonNext, onPressed: _mappingValid ? () => setState(() => _step = 2) : null);
      case 2:
        return PosButton(label: l10n.catalogImportRun, icon: Icons.upload_rounded, isLoading: _importing, onPressed: _runImport);
      case 3:
        return PosButton(label: l10n.commonDone, onPressed: () => context.go(Routes.products));
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── helpers ─────────────────────────────────────────────────

class DottedDropZone extends StatelessWidget {
  const DottedDropZone({
    super.key,
    required this.file,
    required this.onPick,
    required this.labelEmpty,
    required this.labelChange,
  });

  final PlatformFile? file;
  final VoidCallback onPick;
  final String labelEmpty;
  final String labelChange;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: AppColors.primary5,
        ),
        child: Column(
          children: [
            Icon(file == null ? Icons.upload_file : Icons.description, size: 40, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(file?.name ?? labelEmpty, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              file == null ? '.csv, .xlsx, .xls' : labelChange,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTypography.headlineSmall.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
