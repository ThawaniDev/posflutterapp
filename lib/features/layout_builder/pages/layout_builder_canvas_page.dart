import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/core/widgets/pos_loading_skeleton.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/layout_builder/models/layout_widget.dart';
import 'package:thawani_pos/features/layout_builder/models/widget_placement.dart';
import 'package:thawani_pos/features/layout_builder/providers/layout_builder_providers.dart';
import 'package:thawani_pos/features/layout_builder/providers/layout_builder_state.dart';

class LayoutBuilderCanvasPage extends ConsumerStatefulWidget {
  const LayoutBuilderCanvasPage({super.key});

  @override
  ConsumerState<LayoutBuilderCanvasPage> createState() => _LayoutBuilderCanvasPageState();
}

class _LayoutBuilderCanvasPageState extends ConsumerState<LayoutBuilderCanvasPage> {
  String? _selectedPlacementId;
  String _widgetCategoryFilter = '';
  final _versionLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(canvasBuilderProvider.notifier).load();
      ref.read(widgetCatalogProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _versionLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasBuilderProvider);
    final catalogState = ref.watch(widgetCatalogProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.layoutBuilder),
        actions: [
          if (canvasState is CanvasBuilderLoaded) ...[
            PosButton.icon(
              icon: Icons.save_alt_rounded,
              tooltip: l10n.layoutCreateVersion,
              onPressed: () => _showCreateVersionDialog(l10n),
            ),
            AppSpacing.gapW8,
            PosButton.icon(icon: Icons.copy_rounded, tooltip: l10n.layoutClone, onPressed: () => _showCloneDialog(l10n)),
            AppSpacing.gapW8,
            PosButton(
              label: l10n.layoutSave,
              icon: Icons.check_rounded,
              size: PosButtonSize.sm,
              onPressed: () => _saveCanvas(canvasState),
            ),
          ],
          AppSpacing.gapW16,
        ],
      ),
      body: switch (canvasState) {
        CanvasBuilderInitial() || CanvasBuilderLoading() => PosLoadingSkeleton.list(),
        CanvasBuilderSaving() => const Center(child: CircularProgressIndicator()),
        CanvasBuilderError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(canvasBuilderProvider.notifier).load(),
        ),
        CanvasBuilderLoaded(:final canvas, :final placements, :final versions) =>
          context.isPhone
              ? _buildMobileBody(canvas, placements, versions, canvasState, catalogState, l10n, isDark)
              : Row(
                  children: [
                    // Left panel: Widget catalog
                    SizedBox(width: 260, child: _buildWidgetCatalog(catalogState, l10n, isDark)),
                    // Center: Canvas grid
                    Expanded(child: _buildCanvasGrid(canvas.gridColumns, canvas.gridRows, placements, canvasState, isDark, l10n)),
                    // Right panel: Properties + versions
                    SizedBox(width: 280, child: _buildPropertiesPanel(placements, versions, canvasState, l10n, isDark)),
                  ],
                ),
      },
    );
  }

  // ─── Mobile Body ──────────────────────────────────────────────

  Widget _buildMobileBody(
    dynamic canvas,
    List<WidgetPlacement> placements,
    List<dynamic> versions,
    CanvasBuilderLoaded canvasState,
    WidgetCatalogState catalogState,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Stack(
      children: [
        _buildCanvasGrid(canvas.gridColumns, canvas.gridRows, placements, canvasState, isDark, l10n),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: l10n.layoutWidgetCatalog,
                      icon: Icons.widgets_rounded,
                      size: PosButtonSize.sm,
                      variant: PosButtonVariant.outline,
                      onPressed: () => _showCatalogSheet(catalogState, l10n, isDark),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(
                      label: l10n.layoutProperties,
                      icon: Icons.tune_rounded,
                      size: PosButtonSize.sm,
                      variant: PosButtonVariant.outline,
                      onPressed: () => _showPropertiesSheet(placements, versions, canvasState, l10n, isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCatalogSheet(WidgetCatalogState catalogState, AppLocalizations l10n, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.textMutedLight, borderRadius: BorderRadius.circular(2)),
            ),
            Expanded(child: _buildWidgetCatalog(catalogState, l10n, isDark)),
          ],
        ),
      ),
    );
  }

  void _showPropertiesSheet(
    List<WidgetPlacement> placements,
    List<dynamic> versions,
    CanvasBuilderLoaded canvasState,
    AppLocalizations l10n,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.textMutedLight, borderRadius: BorderRadius.circular(2)),
            ),
            Expanded(child: _buildPropertiesPanel(placements, versions, canvasState, l10n, isDark)),
          ],
        ),
      ),
    );
  }

  // ─── Widget Catalog (Left Panel) ──────────────────────────────

  Widget _buildWidgetCatalog(WidgetCatalogState catalogState, AppLocalizations l10n, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(right: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(l10n.layoutWidgetCatalog, style: AppTypography.titleSmall),
          ),
          // Category filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _categoryChip('', l10n.layoutAllWidgets, l10n),
                _categoryChip('core', l10n.layoutCategoryCore, l10n),
                _categoryChip('data', l10n.layoutCategoryData, l10n),
                _categoryChip('payment', l10n.layoutCategoryPayment, l10n),
                _categoryChip('display', l10n.layoutCategoryDisplay, l10n),
              ],
            ),
          ),
          AppSpacing.gapH8,
          // Widget list
          Expanded(
            child: switch (catalogState) {
              WidgetCatalogInitial() || WidgetCatalogLoading() => PosLoadingSkeleton.list(),
              WidgetCatalogError(:final message) => Center(
                child: Text(message, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
              ),
              WidgetCatalogLoaded(:final widgets) => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: widgets.length,
                separatorBuilder: (_, __) => AppSpacing.gapH4,
                itemBuilder: (context, index) {
                  final widget = widgets[index];
                  return _buildDraggableWidget(widget, isDark);
                },
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String category, String label, AppLocalizations l10n) {
    final isSelected = _widgetCategoryFilter == category;
    return PosButton.pill(
      label: label,
      isSelected: isSelected,
      onPressed: () {
        setState(() => _widgetCategoryFilter = category);
        ref.read(widgetCatalogProvider.notifier).load(category: category.isEmpty ? null : category);
      },
    );
  }

  Widget _buildDraggableWidget(LayoutWidget widget, bool isDark) {
    return Draggable<LayoutWidget>(
      data: widget,
      feedback: Material(
        elevation: 8,
        borderRadius: AppRadius.borderMd,
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: AppRadius.borderMd,
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_widgetIcon(widget.category), size: 18, color: AppColors.primary),
              AppSpacing.gapW8,
              Flexible(child: Text(widget.name, style: AppTypography.labelSmall)),
            ],
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
          borderRadius: AppRadius.borderSm,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
              child: Icon(_widgetIcon(widget.category), size: 16, color: AppColors.primary),
            ),
            AppSpacing.gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: AppTypography.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    '${widget.minWidth}×${widget.minHeight} – ${widget.maxWidth}×${widget.maxHeight}',
                    style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                ],
              ),
            ),
            Icon(Icons.drag_indicator_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ],
        ),
      ),
    );
  }

  // ─── Canvas Grid (Center) ─────────────────────────────────────

  Widget _buildCanvasGrid(
    int columns,
    int rows,
    List<WidgetPlacement> placements,
    CanvasBuilderLoaded canvasState,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellW = constraints.maxWidth / columns;
          final cellH = (constraints.maxHeight - 40) / rows; // leave space for header

          return Column(
            children: [
              // Grid info bar
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.grid_on_rounded, size: 16, color: AppColors.primary),
                    AppSpacing.gapW8,
                    Text('${l10n.layoutGrid}: ${columns}×$rows', style: AppTypography.labelSmall),
                    const Spacer(),
                    Text(
                      '${placements.length} ${l10n.layoutWidgetsPlaced}',
                      style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  ],
                ),
              ),
              // Grid area
              Expanded(
                child: DragTarget<LayoutWidget>(
                  onAcceptWithDetails: (details) {
                    final widget = details.data;
                    ref.read(canvasBuilderProvider.notifier).addPlacement({
                      'widget_id': widget.id,
                      'grid_x': 0,
                      'grid_y': 0,
                      'grid_width': widget.minWidth,
                      'grid_height': widget.minHeight,
                      'sort_order': placements.length,
                      'config': widget.defaultConfig,
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isHovering = candidateData.isNotEmpty;

                    return Stack(
                      children: [
                        // Grid background
                        CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxHeight - 40),
                          painter: _GridPainter(
                            columns: columns,
                            rows: rows,
                            color: isDark
                                ? AppColors.borderDark.withValues(alpha: 0.3)
                                : AppColors.borderLight.withValues(alpha: 0.5),
                          ),
                        ),
                        // Hover overlay
                        if (isHovering) Positioned.fill(child: Container(color: AppColors.primary.withValues(alpha: 0.05))),
                        // Placed widgets
                        ...placements.map((p) {
                          final isSelected = p.id == _selectedPlacementId;
                          // Find widget name from catalog
                          final widgetMatch = canvasState.availableWidgets.where((w) => w.id == p.widgetId);
                          final widgetName = widgetMatch.isNotEmpty ? widgetMatch.first.name : 'Widget';
                          final widgetCategory = widgetMatch.isNotEmpty ? widgetMatch.first.category : 'core';

                          return Positioned(
                            left: p.gridX * cellW,
                            top: p.gridY * cellH,
                            width: p.gridWidth * cellW,
                            height: p.gridHeight * cellH,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedPlacementId = p.id),
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight).withValues(alpha: 0.95),
                                  borderRadius: AppRadius.borderSm,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected ? AppShadows.primarySm : AppShadows.sm,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(_widgetIcon(widgetCategory), size: 20, color: AppColors.primary),
                                    AppSpacing.gapH4,
                                    Text(
                                      widgetName,
                                      style: AppTypography.micro.copyWith(fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${p.gridWidth}×${p.gridHeight}',
                                      style: AppTypography.micro.copyWith(
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Properties Panel (Right) ─────────────────────────────────

  Widget _buildPropertiesPanel(
    List<WidgetPlacement> placements,
    List<dynamic> versions,
    CanvasBuilderLoaded canvasState,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final selected = _selectedPlacementId != null ? placements.where((p) => p.id == _selectedPlacementId).firstOrNull : null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(left: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: l10n.layoutProperties),
                Tab(text: l10n.layoutVersions),
              ],
              labelStyle: AppTypography.labelSmall,
              indicatorColor: AppColors.primary,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Properties tab
                  selected != null
                      ? _buildPlacementProperties(selected, canvasState, l10n, isDark)
                      : Center(
                          child: Text(
                            l10n.layoutSelectWidget,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  // Versions tab
                  _buildVersionsList(versions, l10n, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacementProperties(
    WidgetPlacement placement,
    CanvasBuilderLoaded canvasState,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final widgetMatch = canvasState.availableWidgets.where((w) => w.id == placement.widgetId);
    final widgetName = widgetMatch.isNotEmpty ? widgetMatch.first.name : 'Widget';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget name
          Text(widgetName, style: AppTypography.titleSmall),
          AppSpacing.gapH12,
          // Position
          PosCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.layoutPosition, style: AppTypography.labelSmall),
                AppSpacing.gapH8,
                Row(
                  children: [
                    Expanded(child: _propField('X', placement.gridX.toString())),
                    AppSpacing.gapW8,
                    Expanded(child: _propField('Y', placement.gridY.toString())),
                  ],
                ),
                AppSpacing.gapH8,
                Row(
                  children: [
                    Expanded(child: _propField(l10n.layoutWidth, placement.gridWidth.toString())),
                    AppSpacing.gapW8,
                    Expanded(child: _propField(l10n.layoutHeight, placement.gridHeight.toString())),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapH12,
          // Actions
          PosButton(
            label: l10n.layoutRemoveWidget,
            variant: PosButtonVariant.danger,
            size: PosButtonSize.sm,
            icon: Icons.delete_outline_rounded,
            isFullWidth: true,
            onPressed: () {
              ref.read(canvasBuilderProvider.notifier).removePlacement(placement.id);
              setState(() => _selectedPlacementId = null);
            },
          ),
        ],
      ),
    );
  }

  Widget _propField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.micro.copyWith(fontWeight: FontWeight.w600)),
        AppSpacing.gapH4,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.inputBgDark : AppColors.inputBgLight,
            borderRadius: AppRadius.borderSm,
          ),
          child: Text(value, style: AppTypography.bodySmall),
        ),
      ],
    );
  }

  Widget _buildVersionsList(List<dynamic> versions, AppLocalizations l10n, bool isDark) {
    if (versions.isEmpty) {
      return Center(
        child: Text(
          l10n.layoutNoVersions,
          style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: versions.length,
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, index) {
        final version = versions[index];
        return PosCard(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                child: Center(
                  child: Text(
                    'v${version.versionNumber}',
                    style: AppTypography.micro.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              AppSpacing.gapW8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(version.label ?? 'Version ${version.versionNumber}', style: AppTypography.labelSmall),
                    if (version.createdAt != null)
                      Text(
                        _formatDate(version.createdAt!),
                        style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Dialogs ──────────────────────────────────────────────────

  void _saveCanvas(CanvasBuilderLoaded state) {
    ref.read(canvasBuilderProvider.notifier).saveCanvas({
      'name': state.canvas.name,
      'grid_columns': state.canvas.gridColumns,
      'grid_rows': state.canvas.gridRows,
      'theme_overrides': state.canvas.themeOverrides,
    });
    showPosSuccessSnackbar(context, AppLocalizations.of(context)!.layoutSavedSuccess);
  }

  void _showCreateVersionDialog(AppLocalizations l10n) {
    _versionLabelController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.layoutCreateVersion),
        content: TextField(
          controller: _versionLabelController,
          decoration: InputDecoration(labelText: l10n.layoutVersionLabel, hintText: l10n.layoutVersionLabelHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.layoutCancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(canvasBuilderProvider.notifier).createVersion({'label': _versionLabelController.text.trim()});
            },
            child: Text(l10n.layoutCreate),
          ),
        ],
      ),
    );
  }

  void _showCloneDialog(AppLocalizations l10n) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.layoutClone),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: l10n.layoutCloneName, hintText: l10n.layoutCloneNameHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.layoutCancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(canvasBuilderProvider.notifier).cloneCanvas({'name': nameController.text.trim()});
              nameController.dispose();
            },
            child: Text(l10n.layoutCreate),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────

  IconData _widgetIcon(String category) {
    return switch (category) {
      'core' => Icons.widgets_rounded,
      'data' => Icons.table_chart_rounded,
      'payment' => Icons.payment_rounded,
      'display' => Icons.monitor_rounded,
      _ => Icons.extension_rounded,
    };
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ─── Grid Painter ─────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  _GridPainter({required this.columns, required this.rows, required this.color});

  final int columns;
  final int rows;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    final cellW = size.width / columns;
    final cellH = size.height / rows;

    for (var i = 0; i <= columns; i++) {
      canvas.drawLine(Offset(i * cellW, 0), Offset(i * cellW, size.height), paint);
    }
    for (var j = 0; j <= rows; j++) {
      canvas.drawLine(Offset(0, j * cellH), Offset(size.width, j * cellH), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      columns != oldDelegate.columns || rows != oldDelegate.rows || color != oldDelegate.color;
}
