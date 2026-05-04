import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Displays a bottom-sheet for choosing an export format (PDF / CSV) and
/// triggering the export API call. Shows progress, success, and error states.
Future<void> showReportExportSheet({required BuildContext context, required String reportType, required ReportFilters filters}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReportExportSheet(reportType: reportType, filters: filters),
  );
}

class _ReportExportSheet extends ConsumerStatefulWidget {
  const _ReportExportSheet({required this.reportType, required this.filters});
  final String reportType;
  final ReportFilters filters;

  @override
  ConsumerState<_ReportExportSheet> createState() => _ReportExportSheetState();
}

class _ReportExportSheetState extends ConsumerState<_ReportExportSheet> {
  String _format = 'pdf';

  @override
  void initState() {
    super.initState();
    // Reset any previous export state when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportExportProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(reportExportProvider);

    ref.listen<ReportExportState>(reportExportProvider, (_, next) {
      if (next is ReportExportSuccess) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.reportsExportSuccess), backgroundColor: AppColors.success));
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppColors.borderFor(context), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.reportsExportFormatTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          // Format selection
          Row(
            children: [
              Expanded(
                child: _FormatOption(
                  label: l10n.reportsExportPdf,
                  icon: Icons.picture_as_pdf_rounded,
                  color: AppColors.error,
                  isSelected: _format == 'pdf',
                  onTap: () => setState(() => _format = 'pdf'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormatOption(
                  label: l10n.reportsExportCsv,
                  icon: Icons.table_chart_rounded,
                  color: AppColors.success,
                  isSelected: _format == 'csv',
                  onTap: () => setState(() => _format = 'csv'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (state is ReportExportError) ...[
            Text(
              state.message,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: state is ReportExportLoading
                ? const Center(child: CircularProgressIndicator())
                : PosButton(
                    label: l10n.reportsExportGenerating,
                    icon: Icons.download_rounded,
                    onPressed: () {
                      ref
                          .read(reportExportProvider.notifier)
                          .export(reportType: widget.reportType, format: _format, filters: widget.filters);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FormatOption extends StatelessWidget {
  const _FormatOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: isSelected ? color : AppColors.borderFor(context), width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : AppColors.mutedFor(context), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
