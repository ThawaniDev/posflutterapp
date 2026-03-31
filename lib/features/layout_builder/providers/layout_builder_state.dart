import 'package:thawani_pos/features/layout_builder/models/layout_canvas.dart';
import 'package:thawani_pos/features/layout_builder/models/layout_widget.dart';
import 'package:thawani_pos/features/layout_builder/models/pos_layout_template.dart';
import 'package:thawani_pos/features/layout_builder/models/template_version.dart';
import 'package:thawani_pos/features/layout_builder/models/widget_placement.dart';

// ─── Layout Templates State ────────────────────────────────

sealed class LayoutTemplatesState {
  const LayoutTemplatesState();
}

class LayoutTemplatesInitial extends LayoutTemplatesState {
  const LayoutTemplatesInitial();
}

class LayoutTemplatesLoading extends LayoutTemplatesState {
  const LayoutTemplatesLoading();
}

class LayoutTemplatesLoaded extends LayoutTemplatesState {
  final List<PosLayoutTemplate> templates;
  const LayoutTemplatesLoaded({required this.templates});
}

class LayoutTemplatesError extends LayoutTemplatesState {
  final String message;
  const LayoutTemplatesError({required this.message});
}

// ─── Canvas Builder State ──────────────────────────────────

sealed class CanvasBuilderState {
  const CanvasBuilderState();
}

class CanvasBuilderInitial extends CanvasBuilderState {
  const CanvasBuilderInitial();
}

class CanvasBuilderLoading extends CanvasBuilderState {
  const CanvasBuilderLoading();
}

class CanvasBuilderLoaded extends CanvasBuilderState {
  final LayoutCanvas canvas;
  final List<WidgetPlacement> placements;
  final List<LayoutWidget> availableWidgets;
  final List<TemplateVersion> versions;

  const CanvasBuilderLoaded({
    required this.canvas,
    required this.placements,
    this.availableWidgets = const [],
    this.versions = const [],
  });

  CanvasBuilderLoaded copyWith({
    LayoutCanvas? canvas,
    List<WidgetPlacement>? placements,
    List<LayoutWidget>? availableWidgets,
    List<TemplateVersion>? versions,
  }) {
    return CanvasBuilderLoaded(
      canvas: canvas ?? this.canvas,
      placements: placements ?? this.placements,
      availableWidgets: availableWidgets ?? this.availableWidgets,
      versions: versions ?? this.versions,
    );
  }
}

class CanvasBuilderSaving extends CanvasBuilderState {
  const CanvasBuilderSaving();
}

class CanvasBuilderError extends CanvasBuilderState {
  final String message;
  const CanvasBuilderError({required this.message});
}

// ─── Widget Catalog State ──────────────────────────────────

sealed class WidgetCatalogState {
  const WidgetCatalogState();
}

class WidgetCatalogInitial extends WidgetCatalogState {
  const WidgetCatalogInitial();
}

class WidgetCatalogLoading extends WidgetCatalogState {
  const WidgetCatalogLoading();
}

class WidgetCatalogLoaded extends WidgetCatalogState {
  final List<LayoutWidget> widgets;
  final String? selectedCategory;

  const WidgetCatalogLoaded({required this.widgets, this.selectedCategory});

  WidgetCatalogLoaded copyWith({List<LayoutWidget>? widgets, String? selectedCategory}) {
    return WidgetCatalogLoaded(widgets: widgets ?? this.widgets, selectedCategory: selectedCategory ?? this.selectedCategory);
  }
}

class WidgetCatalogError extends WidgetCatalogState {
  final String message;
  const WidgetCatalogError({required this.message});
}
