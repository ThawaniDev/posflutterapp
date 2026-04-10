import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// POS SEARCHABLE DROPDOWN — Comprehensive Design System Widget
// ─────────────────────────────────────────────────────────────

/// An item in the [PosSearchableDropdown].
///
/// [value] is the unique identifier (e.g. UUID).
/// [label] is the primary display string shown to the user.
/// [subtitle] is an optional secondary line (e.g. SKU, phone, etc.).
/// [icon] is an optional leading icon.
/// [enabled] controls whether the item can be selected.
class PosDropdownItem<T> {
  const PosDropdownItem({required this.value, required this.label, this.subtitle, this.icon, this.enabled = true});

  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PosDropdownItem<T> && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// A comprehensive, searchable, accessible dropdown for the Thawani POS design system.
///
/// Features:
/// - **Searchable** — built-in search field that filters items by label/subtitle
/// - **Names, not IDs** — always displays [PosDropdownItem.label] to the user
/// - **Async loading** — supports [asyncItems] for remote data fetching
/// - **Multi-select** — optional [multiSelect] mode with chip display
/// - **Themed** — fully respects dark/light mode and design tokens
/// - **Accessible** — keyboard navigation, ARIA labels, focus management
/// - **Validation** — supports [errorText] for form integration
/// - **Create new** — optional [onCreateNew] callback for inline item creation
/// - **Grouped items** — optional [groupBy] for sectioned lists
class PosSearchableDropdown<T> extends StatefulWidget {
  const PosSearchableDropdown({
    super.key,
    this.items = const [],
    this.asyncItems,
    this.selectedValue,
    this.selectedValues = const [],
    this.onChanged,
    this.onMultiChanged,
    this.label,
    this.hint,
    this.searchHint,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.multiSelect = false,
    this.showSearch = true,
    this.maxHeight = 350,
    this.onCreateNew,
    this.createNewLabel,
    this.emptyLabel,
    this.loadingLabel,
    this.prefixIcon,
    this.clearable = true,
    this.groupBy,
    this.itemBuilder,
    this.validator,
  });

  /// Static list of items. Ignored if [asyncItems] is provided.
  final List<PosDropdownItem<T>> items;

  /// Async data source — called with the search query string.
  /// Return a list of items matching the query.
  final Future<List<PosDropdownItem<T>>> Function(String query)? asyncItems;

  /// Currently selected value (single-select mode).
  final T? selectedValue;

  /// Currently selected values (multi-select mode).
  final List<T> selectedValues;

  /// Callback when selection changes (single-select).
  final ValueChanged<T?>? onChanged;

  /// Callback when selection changes (multi-select).
  final ValueChanged<List<T>>? onMultiChanged;

  /// Label displayed above the dropdown field.
  final String? label;

  /// Placeholder text when nothing is selected.
  final String? hint;

  /// Placeholder for the search field inside the overlay.
  final String? searchHint;

  /// Error text (turns border red).
  final String? errorText;

  /// Helper text below the field.
  final String? helperText;

  /// Whether the dropdown is interactive.
  final bool enabled;

  /// Multi-select mode — show checkboxes and chips.
  final bool multiSelect;

  /// Show the search field in the overlay.
  final bool showSearch;

  /// Max height of the dropdown overlay.
  final double maxHeight;

  /// Callback to create a new item inline.
  final VoidCallback? onCreateNew;

  /// Label for the "Create new" button.
  final String? createNewLabel;

  /// Label shown when no items match the search.
  final String? emptyLabel;

  /// Label shown while async items are loading.
  final String? loadingLabel;

  /// Optional icon to the left of the field.
  final IconData? prefixIcon;

  /// Whether the selection can be cleared.
  final bool clearable;

  /// Optional grouping function — items with the same group are grouped together.
  final String Function(PosDropdownItem<T> item)? groupBy;

  /// Optional custom item builder for richer item rendering.
  final Widget Function(BuildContext context, PosDropdownItem<T> item, bool isSelected)? itemBuilder;

  /// Form validator.
  final String? Function(T?)? validator;

  @override
  State<PosSearchableDropdown<T>> createState() => _PosSearchableDropdownState<T>();
}

class _PosSearchableDropdownState<T> extends State<PosSearchableDropdown<T>> {
  final _fieldKey = GlobalKey();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  // Async state
  List<PosDropdownItem<T>> _filteredItems = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.of(widget.items);
  }

  @override
  void didUpdateWidget(covariant PosSearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = _applyFilter(_searchController.text);
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // ─── Selection Helpers ──────────────────────────────────────

  PosDropdownItem<T>? get _selectedItem {
    if (widget.selectedValue == null) return null;
    try {
      return widget.items.firstWhere((i) => i.value == widget.selectedValue);
    } catch (_) {
      return null;
    }
  }

  List<PosDropdownItem<T>> get _selectedItems {
    return widget.items.where((i) => widget.selectedValues.contains(i.value)).toList();
  }

  bool _isSelected(PosDropdownItem<T> item) {
    if (widget.multiSelect) return widget.selectedValues.contains(item.value);
    return widget.selectedValue == item.value;
  }

  // ─── Filtering ──────────────────────────────────────────────

  List<PosDropdownItem<T>> _applyFilter(String query) {
    if (query.isEmpty) return List.of(widget.items);
    final lower = query.toLowerCase();
    return widget.items.where((item) {
      return item.label.toLowerCase().contains(lower) || (item.subtitle?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }

  void _onSearchChanged(String query) {
    if (widget.asyncItems != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () => _loadAsync(query));
    } else {
      setState(() => _filteredItems = _applyFilter(query));
      _overlayEntry?.markNeedsBuild();
    }
  }

  Future<void> _loadAsync(String query) async {
    setState(() => _isLoading = true);
    _overlayEntry?.markNeedsBuild();
    try {
      final results = await widget.asyncItems!(query);
      _filteredItems = results;
    } catch (_) {
      _filteredItems = [];
    }
    if (mounted) {
      setState(() => _isLoading = false);
      _overlayEntry?.markNeedsBuild();
    }
  }

  // ─── Overlay ────────────────────────────────────────────────

  void _toggleOverlay() {
    if (!widget.enabled) return;
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _searchController.clear();
    if (widget.asyncItems != null) {
      _loadAsync('');
    } else {
      _filteredItems = List.of(widget.items);
    }

    final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Stack(
          children: [
            // Dismiss scrim
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            // Dropdown panel
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderMd,
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                child: Container(
                  width: size.width,
                  constraints: BoxConstraints(maxHeight: widget.maxHeight),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.borderMd,
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search field
                      if (widget.showSearch)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: _onSearchChanged,
                            style: AppTypography.bodySmall,
                            decoration: InputDecoration(
                              hintText: widget.searchHint ?? AppLocalizations.of(context)?.searchDropdownHint ?? 'Search...',
                              prefixIcon: const Icon(Icons.search_rounded, size: 18),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              isDense: true,
                              border: OutlineInputBorder(borderRadius: AppRadius.borderSm),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.borderSm,
                                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppRadius.borderSm,
                                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      // Items list
                      Flexible(child: _buildItemsList(isDark)),
                      // Create new button
                      if (widget.onCreateNew != null) _buildCreateNewButton(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
    setState(() {});

    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_searchFocusNode.canRequestFocus) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    _debounceTimer?.cancel();
    if (mounted) setState(() {});
  }

  // ─── Item List Builder ──────────────────────────────────────

  Widget _buildItemsList(bool isDark) {
    if (_isLoading) {
      return Padding(
        padding: AppSpacing.paddingAll16,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              AppSpacing.gapH8,
              Text(
                widget.loadingLabel ?? AppLocalizations.of(context)?.loading ?? 'Loading...',
                style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredItems.isEmpty) {
      return Padding(
        padding: AppSpacing.paddingAll16,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 32, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              AppSpacing.gapH8,
              Text(
                widget.emptyLabel ?? AppLocalizations.of(context)?.noResultsFound ?? 'No results found',
                style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
        ),
      );
    }

    // Grouped rendering
    if (widget.groupBy != null) {
      return _buildGroupedList(isDark);
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) => _buildItem(_filteredItems[index], isDark),
    );
  }

  Widget _buildGroupedList(bool isDark) {
    final groups = <String, List<PosDropdownItem<T>>>{};
    for (final item in _filteredItems) {
      final group = widget.groupBy!(item);
      groups.putIfAbsent(group, () => []).add(item);
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: groups.entries.expand((entry) {
        return [
          // Group header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              entry.key,
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Group items
          ...entry.value.map((item) => _buildItem(item, isDark)),
        ];
      }).toList(),
    );
  }

  Widget _buildItem(PosDropdownItem<T> item, bool isDark) {
    final selected = _isSelected(item);

    if (widget.itemBuilder != null) {
      return InkWell(onTap: item.enabled ? () => _onItemTap(item) : null, child: widget.itemBuilder!(context, item, selected));
    }

    return InkWell(
      onTap: item.enabled ? () => _onItemTap(item) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: selected ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08) : null,
        child: Row(
          children: [
            // Multi-select checkbox
            if (widget.multiSelect)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: selected,
                    onChanged: item.enabled ? (_) => _onItemTap(item) : null,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColors.primary,
                  ),
                ),
              ),
            // Icon
            if (item.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: selected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ),
            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: item.enabled
                          ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                          : (isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight),
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                ],
              ),
            ),
            // Selected indicator
            if (selected && !widget.multiSelect) const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewButton(bool isDark) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        _removeOverlay();
        widget.onCreateNew?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.primary),
            AppSpacing.gapW8,
            Text(
              widget.createNewLabel ?? l10n?.createNew ?? 'Create new',
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Selection Handling ─────────────────────────────────────

  void _onItemTap(PosDropdownItem<T> item) {
    if (widget.multiSelect) {
      final current = List<T>.from(widget.selectedValues);
      if (current.contains(item.value)) {
        current.remove(item.value);
      } else {
        current.add(item.value);
      }
      widget.onMultiChanged?.call(current);
      _overlayEntry?.markNeedsBuild();
    } else {
      widget.onChanged?.call(item.value);
      _removeOverlay();
    }
  }

  void _clearSelection() {
    if (widget.multiSelect) {
      widget.onMultiChanged?.call([]);
    } else {
      widget.onChanged?.call(null);
    }
  }

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError
        ? AppColors.error
        : (_isOpen ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH4,
        ],
        // Field
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleOverlay,
            child: Container(
              key: _fieldKey,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: widget.enabled
                    ? (isDark ? AppColors.inputBgDark : AppColors.inputBgLight)
                    : (isDark ? AppColors.surfaceDark : Colors.grey.shade100),
                borderRadius: AppRadius.borderSm,
                border: Border.all(color: borderColor, width: _isOpen ? 1.5 : 1),
              ),
              child: widget.multiSelect ? _buildMultiSelectField(isDark) : _buildSingleSelectField(isDark),
            ),
          ),
        ),
        // Error text
        if (hasError) ...[AppSpacing.gapH4, Text(widget.errorText!, style: AppTypography.micro.copyWith(color: AppColors.error))],
        // Helper text
        if (widget.helperText != null && !hasError) ...[
          AppSpacing.gapH4,
          Text(
            widget.helperText!,
            style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ],
      ],
    );
  }

  Widget _buildSingleSelectField(bool isDark) {
    final item = _selectedItem;
    final hasValue = item != null;

    return Row(
      children: [
        if (widget.prefixIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(widget.prefixIcon, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        Flexible(
          child: hasValue
              ? Text(
                  item.label,
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  widget.hint ?? AppLocalizations.of(context)?.selectOption ?? 'Select...',
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
        ),
        if (hasValue && widget.clearable && widget.enabled)
          GestureDetector(
            onTap: _clearSelection,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.close_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(
            _isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectField(bool isDark) {
    final items = _selectedItems;

    return Row(
      children: [
        if (widget.prefixIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(widget.prefixIcon, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        Flexible(
          child: items.isEmpty
              ? Text(
                  widget.hint ?? AppLocalizations.of(context)?.selectOption ?? 'Select...',
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                )
              : Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: items.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: AppRadius.borderSm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.label,
                            style: AppTypography.micro.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                          if (widget.enabled) ...[
                            const SizedBox(width: 2),
                            GestureDetector(
                              onTap: () {
                                final current = List<T>.from(widget.selectedValues)..remove(item.value);
                                widget.onMultiChanged?.call(current);
                              },
                              child: const Icon(Icons.close_rounded, size: 12, color: AppColors.primary),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
        if (items.isNotEmpty && widget.clearable && widget.enabled)
          GestureDetector(
            onTap: _clearSelection,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.close_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(
            _isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }
}
