import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// POS DATA TABLE
// ─────────────────────────────────────────────────────────────

/// Styled data table wrapper matching stitch prototypes:
/// - uppercase header row with slate-50 bg
/// - hover rows
/// - optional pagination footer
class PosDataTable extends StatelessWidget {
  const PosDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.showCheckbox = false,
    this.showBorder = true,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueSetter<bool?>? onSelectAll;
  final bool showCheckbox;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderLg,
        border: showBorder ? Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: rows,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          onSelectAll: onSelectAll,
          showCheckboxColumn: showCheckbox,
          headingRowHeight: 48,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 64,
          horizontalMargin: 16,
          columnSpacing: 24,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TABLE PAGINATION FOOTER
// ─────────────────────────────────────────────────────────────

/// Page controls: "Showing 1-10 of 56" + prev/next.
class PosTablePagination extends StatelessWidget {
  const PosTablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.itemsPerPage = 10,
    this.onPrevious,
    this.onNext,
    this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 1) * itemsPerPage + 1;
    final end = (start + itemsPerPage - 1).clamp(1, totalItems);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing $start–$end of $totalItems', style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight)),
          Row(
            children: [
              IconButton(
                onPressed: currentPage > 1 ? onPrevious : null,
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                iconSize: 20,
              ),
              Text('$currentPage / $totalPages', style: AppTypography.labelMedium),
              IconButton(
                onPressed: currentPage < totalPages ? onNext : null,
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                iconSize: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
