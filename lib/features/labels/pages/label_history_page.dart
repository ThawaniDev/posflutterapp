import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_app_bar.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';

/// Print History page shows a table of all past print jobs.
class LabelHistoryPage extends ConsumerStatefulWidget {
  const LabelHistoryPage({super.key});

  @override
  ConsumerState<LabelHistoryPage> createState() => _LabelHistoryPageState();
}

class _LabelHistoryPageState extends ConsumerState<LabelHistoryPage> {
  List<LabelPrintHistory> _history = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final history = await ref.read(labelRepositoryProvider).getPrintHistory();
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PosAppBar(title: l10n.labelPrintHistory, showBackButton: true, onBackPressed: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: PosDataTable<LabelPrintHistory>(
          columns: const [
            PosTableColumn(title: 'Date'),
            PosTableColumn(title: 'Template'),
            PosTableColumn(title: 'Products', numeric: true),
            PosTableColumn(title: 'Labels', numeric: true),
            PosTableColumn(title: 'Printer'),
            PosTableColumn(title: 'Printed By'),
          ],
          items: _history,
          isLoading: _isLoading,
          error: _error,
          onRetry: _loadHistory,
          emptyConfig: PosTableEmptyConfig(
            icon: Icons.history_rounded,
            title: l10n.labelNoHistory,
            subtitle: l10n.labelNoHistorySubtitle,
          ),
          cellBuilder: (item, colIndex, col) {
            switch (colIndex) {
              case 0: // Date
                return Text(
                  item.printedAt != null
                      ? '${item.printedAt!.day}/${item.printedAt!.month}/${item.printedAt!.year} ${item.printedAt!.hour.toString().padLeft(2, '0')}:${item.printedAt!.minute.toString().padLeft(2, '0')}'
                      : '—',
                );
              case 1: // Template
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.label_rounded, size: 14, color: AppColors.info),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(item.templateId?.substring(0, 8) ?? '—'),
                  ],
                );
              case 2: // Product count
                return Text('${item.productCount}');
              case 3: // Total labels
                return PosBadge(label: '${item.totalLabels}', variant: PosBadgeVariant.primary, isSmall: true);
              case 4: // Printer
                return Text(item.printerName ?? '—');
              case 5: // Printed by
                return Text(item.printedBy.length > 8 ? item.printedBy.substring(0, 8) : item.printedBy);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
