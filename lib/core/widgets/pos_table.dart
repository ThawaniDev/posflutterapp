import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

// ═════════════════════════════════════════════════════════════
// POS TABLE COLUMN DEFINITION
// ═════════════════════════════════════════════════════════════

/// Defines a column for [PosDataTable].
///
/// Unlike Flutter's [DataColumn], this carries layout metadata (flex, width,
/// alignment, freeze) so the table can be configured declaratively.
class PosTableColumn {
  const PosTableColumn({
    required this.title,
    this.key,
    this.width,
    this.flex,
    this.numeric = false,
    this.sortable = false,
    this.alignment = Alignment.centerLeft,
    this.frozen = false,
    this.visible = true,
    this.tooltip,
  });

  /// Column header text.
  final String title;

  /// Logical key — useful for sorting callbacks. Defaults to [title].
  final String? key;

  /// Fixed pixel width. When null the column uses [flex].
  final double? width;

  /// Flex factor when [width] is null. Defaults to 1.
  final int? flex;

  /// Right-align header & cell text (e.g. numbers, prices).
  final bool numeric;

  /// Whether this column triggers sort callbacks.
  final bool sortable;

  /// Cell content alignment override.
  final Alignment alignment;

  /// Freeze this column to the leading edge (not yet implemented — reserved).
  final bool frozen;

  /// Whether to render this column. Allows toggling columns without removing
  /// them from the list.
  final bool visible;

  /// Tooltip on the header cell.
  final String? tooltip;

  String get resolvedKey => key ?? title;
}

// ═════════════════════════════════════════════════════════════
// POS TABLE ROW ACTION
// ═════════════════════════════════════════════════════════════

/// A single action for the trailing actions column.
class PosTableRowAction<T> {
  const PosTableRowAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
    this.isDestructive = false,
    this.isVisible,
  });

  final String label;
  final IconData icon;
  final void Function(T item) onTap;
  final Color? color;
  final bool isDestructive;

  /// Return `false` to hide this action for a given row.
  final bool Function(T item)? isVisible;
}

// ═════════════════════════════════════════════════════════════
// POS TABLE EMPTY STATE
// ═════════════════════════════════════════════════════════════

/// Optional config for the empty-state placeholder shown when data is empty.
class PosTableEmptyConfig {
  const PosTableEmptyConfig({
    this.icon = Icons.inbox_outlined,
    this.title = 'No data found',
    this.subtitle,
    this.action,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;
}

// ═════════════════════════════════════════════════════════════
// POS DATA TABLE — COMPREHENSIVE
// ═════════════════════════════════════════════════════════════

/// A fully-featured, theme-aware data table widget for consistent use across
/// **all** pages in the POS app: products, categories, suppliers, inventory,
/// orders, etc.
///
/// Key capabilities:
/// - **Typed rows** — generic `<T>` for compile-time safe cell builders.
/// - **Declarative columns** — [PosTableColumn] carries width/flex/sort metadata.
/// - **Built-in sort** — tap sortable header → callback with column key + asc flag.
/// - **Selectable rows** — optional checkbox column for bulk operations.
/// - **Row actions** — trailing icon-button column auto-generated from [actions].
/// - **Integrated pagination** — shows "Showing X–Y of Z" + prev / next buttons.
/// - **Empty / Loading / Error** states — pass [isLoading], [error], [emptyConfig].
/// - **Responsive horizontal scroll** — always fills width, scrolls if needed.
/// - **Consistent theming** — uses [AppColors], [AppTypography], [AppSpacing].
class PosDataTable<T> extends StatelessWidget {
  const PosDataTable({
    super.key,
    // Data
    required this.columns,
    required this.items,
    required this.cellBuilder,

    // Sort
    this.sortColumnKey,
    this.sortAscending = true,
    this.onSort,

    // Selection
    this.selectable = false,
    this.selectedItems = const {},
    this.onSelectItem,
    this.onSelectAll,
    this.itemId,

    // Actions
    this.actions = const [],
    this.actionsColumnWidth = 100,
    this.onRowTap,

    // Pagination
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage = 10,
    this.onPreviousPage,
    this.onNextPage,
    this.onPageChanged,
    this.perPageOptions = const [10, 25, 50, 100],
    this.onPerPageChanged,

    // States
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.emptyConfig = const PosTableEmptyConfig(),

    // Appearance
    this.showBorder = true,
    this.minWidth,
    this.headerPadding,
  });

  // ── Data ──────────────────────────────────────────────────
  /// Column definitions.
  final List<PosTableColumn> columns;

  /// The data items to display. Each item maps to one row.
  final List<T> items;

  /// Builds the cell widget for column [colIndex] and the given [item].
  /// The column definition is also passed for convenience.
  final Widget Function(T item, int colIndex, PosTableColumn column) cellBuilder;

  // ── Sort ──────────────────────────────────────────────────
  /// Currently sorted column key (matches [PosTableColumn.resolvedKey]).
  final String? sortColumnKey;
  final bool sortAscending;

  /// Called when a sortable header is tapped.
  final void Function(String columnKey, bool ascending)? onSort;

  // ── Selection ─────────────────────────────────────────────
  /// Enable per-row checkbox selection.
  final bool selectable;

  /// Set of currently-selected item IDs.
  final Set<String> selectedItems;

  /// Called when a single row checkbox is toggled.
  final void Function(T item, bool selected)? onSelectItem;

  /// Called when the "select all" header checkbox is toggled.
  final void Function(bool selectAll)? onSelectAll;

  /// Returns a unique string ID for the item. Required when [selectable] is true.
  final String Function(T item)? itemId;

  // ── Actions ───────────────────────────────────────────────
  /// Row-level actions rendered in the trailing column.
  final List<PosTableRowAction<T>> actions;
  final double actionsColumnWidth;

  /// Called when a row is tapped (not on action buttons).
  final void Function(T item)? onRowTap;

  // ── Pagination ────────────────────────────────────────────
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int itemsPerPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final void Function(int page)? onPageChanged;
  final List<int> perPageOptions;
  final void Function(int perPage)? onPerPageChanged;

  // ── States ────────────────────────────────────────────────
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  final PosTableEmptyConfig emptyConfig;

  // ── Appearance ────────────────────────────────────────────
  final bool showBorder;

  /// Minimum width before horizontal scroll kicks in.
  final double? minWidth;

  /// Extra padding around the table container.
  final EdgeInsetsGeometry? headerPadding;

  // ── Helpers ───────────────────────────────────────────────
  bool get _hasPagination => currentPage != null && totalPages != null && totalItems != null;
  List<PosTableColumn> get _visibleColumns => columns.where((c) => c.visible).toList();
  bool get _hasActions => actions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (isLoading) {
      return _buildContainer(context, child: const _LoadingState());
    }

    // Error state
    if (error != null) {
      return _buildContainer(
        context,
        child: _ErrorState(message: error!, onRetry: onRetry),
      );
    }

    // Empty state
    if (items.isEmpty) {
      return _buildContainer(context, child: _EmptyState(config: emptyConfig));
    }

    // Data table + pagination
    return Column(
      children: [
        Expanded(child: _buildTableContainer(context)),
        if (_hasPagination) _buildPagination(context),
      ],
    );
  }

  Widget _buildContainer(BuildContext context, {required Widget child}) {
    return Center(child: child);
  }

  Widget _buildTableContainer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: headerPadding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderLg,
        border: showBorder ? Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: _buildDataTable(context, constraints.maxWidth),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, double availableWidth) {
    final visibleCols = _visibleColumns;

    return DataTable(
      columns: _buildColumns(context, visibleCols),
      rows: _buildRows(context, visibleCols),
      sortColumnIndex: _sortColumnIndex(visibleCols),
      sortAscending: sortAscending,
      showCheckboxColumn: selectable,
      onSelectAll: selectable && onSelectAll != null ? (selected) => onSelectAll!(selected ?? false) : null,
      headingRowHeight: 48,
      dataRowMinHeight: 48,
      dataRowMaxHeight: 64,
      horizontalMargin: 16,
      columnSpacing: 24,
    );
  }

  int? _sortColumnIndex(List<PosTableColumn> visibleCols) {
    if (sortColumnKey == null) return null;
    int offset = selectable ? 0 : 0; // DataTable adds checkbox col internally
    for (int i = 0; i < visibleCols.length; i++) {
      if (visibleCols[i].resolvedKey == sortColumnKey) return i + offset;
    }
    return null;
  }

  // ── Column headers ────────────────────────────────────────

  List<DataColumn> _buildColumns(BuildContext context, List<PosTableColumn> cols) {
    final headerCols = <DataColumn>[];

    for (final col in cols) {
      headerCols.add(
        DataColumn(
          label: _ColumnHeader(column: col, isSorted: col.resolvedKey == sortColumnKey, ascending: sortAscending),
          numeric: col.numeric,
          tooltip: col.tooltip,
          onSort: col.sortable && onSort != null
              ? (_, asc) => onSort!(col.resolvedKey, col.resolvedKey == sortColumnKey ? !sortAscending : true)
              : null,
        ),
      );
    }

    // Actions column
    if (_hasActions) {
      headerCols.add(const DataColumn(label: Text('ACTIONS')));
    }

    return headerCols;
  }

  // ── Data rows ─────────────────────────────────────────────

  List<DataRow> _buildRows(BuildContext context, List<PosTableColumn> cols) {
    return items.map((item) {
      final id = itemId?.call(item) ?? '';
      final isSelected = selectable && selectedItems.contains(id);

      final cells = <DataCell>[];

      // Data cells
      for (int i = 0; i < cols.length; i++) {
        cells.add(DataCell(cellBuilder(item, i, cols[i])));
      }

      // Actions cell
      if (_hasActions) {
        cells.add(DataCell(_RowActionsCell<T>(item: item, actions: actions)));
      }

      return DataRow(
        selected: isSelected,
        onSelectChanged: selectable && onSelectItem != null
            ? (selected) => onSelectItem!(item, selected ?? false)
            : onRowTap != null
            ? (_) => onRowTap!(item)
            : null,
        cells: cells,
      );
    }).toList();
  }

  // ── Pagination ────────────────────────────────────────────

  Widget _buildPagination(BuildContext context) {
    final start = (currentPage! - 1) * itemsPerPage + 1;
    final end = (start + itemsPerPage - 1).clamp(1, totalItems!);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // "Showing X–Y of Z"
          Text('Showing $start–$end of $totalItems', style: AppTypography.bodySmall.copyWith(color: mutedColor)),

          const Spacer(),

          // Per-page selector
          if (onPerPageChanged != null) ...[
            Text('Rows: ', style: AppTypography.bodySmall.copyWith(color: mutedColor)),
            SizedBox(
              height: 32,
              child: DropdownButton<int>(
                value: itemsPerPage,
                underline: const SizedBox.shrink(),
                isDense: true,
                style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                items: perPageOptions.map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                onChanged: (v) {
                  if (v != null) onPerPageChanged!(v);
                },
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Prev / page / Next
          IconButton(
            onPressed: currentPage! > 1 ? onPreviousPage : null,
            icon: const Icon(Icons.chevron_left_rounded, size: 20),
            iconSize: 20,
            splashRadius: 16,
            tooltip: 'Previous page',
          ),
          Text('$currentPage / $totalPages', style: AppTypography.labelMedium),
          IconButton(
            onPressed: currentPage! < totalPages! ? onNextPage : null,
            icon: const Icon(Icons.chevron_right_rounded, size: 20),
            iconSize: 20,
            splashRadius: 16,
            tooltip: 'Next page',
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// BACKWARD COMPAT — PosTablePagination (standalone)
// ═════════════════════════════════════════════════════════════

/// Standalone pagination footer. Kept for backward compatibility.
/// Prefer using [PosDataTable]'s integrated pagination instead.
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

// ═════════════════════════════════════════════════════════════
// PRIVATE WIDGETS
// ═════════════════════════════════════════════════════════════

/// Column header widget with sort indicator.
class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader({required this.column, required this.isSorted, required this.ascending});

  final PosTableColumn column;
  final bool isSorted;
  final bool ascending;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(column.title.toUpperCase()),
        if (column.sortable && isSorted) ...[
          const SizedBox(width: 4),
          Icon(ascending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, size: 14),
        ],
      ],
    );
  }
}

/// Renders the trailing actions cell.
///
/// - 1 action → icon button
/// - 2 actions → icon buttons
/// - 3+ actions → popup menu
class _RowActionsCell<T> extends StatelessWidget {
  const _RowActionsCell({required this.item, required this.actions});

  final T item;
  final List<PosTableRowAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    final visible = actions.where((a) => a.isVisible == null || a.isVisible!(item)).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    // Up to 2 actions as direct icon buttons
    if (visible.length <= 2) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: visible.map((action) {
          return IconButton(
            icon: Icon(action.icon, size: 18, color: action.isDestructive ? AppColors.error : action.color),
            tooltip: action.label,
            splashRadius: 16,
            onPressed: () => action.onTap(item),
          );
        }).toList(),
      );
    }

    // 3+ actions as popup menu
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      tooltip: 'Actions',
      splashRadius: 16,
      itemBuilder: (_) => visible.asMap().entries.map((e) {
        final action = e.value;
        return PopupMenuItem<int>(
          value: e.key,
          child: Row(
            children: [
              Icon(action.icon, size: 18, color: action.isDestructive ? AppColors.error : action.color),
              const SizedBox(width: 8),
              Text(action.label, style: TextStyle(color: action.isDestructive ? AppColors.error : null)),
            ],
          ),
        );
      }).toList(),
      onSelected: (index) => visible[index].onTap(item),
    );
  }
}

/// Full-width loading state with shimmer-like pulsing rows.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: AppSpacing.md),
        Text('Loading...', style: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedLight)),
      ],
    );
  }
}

/// Error state with retry button.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
        const SizedBox(height: AppSpacing.md),
        Text(message, style: AppTypography.bodyMedium, textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Retry')),
        ],
      ],
    );
  }
}

/// Empty state with icon, title, and optional action button.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.config});

  final PosTableEmptyConfig config;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(config.icon, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: AppSpacing.md),
        Text(config.title, style: Theme.of(context).textTheme.titleMedium),
        if (config.subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            config.subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
        if (config.action != null) ...[
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(onPressed: config.action, child: Text(config.actionLabel ?? 'Get Started')),
        ],
      ],
    );
  }
}
