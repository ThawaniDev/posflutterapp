import 'package:wameedpos/features/layout_builder/models/layout_canvas.dart';
import 'package:wameedpos/features/layout_builder/models/layout_widget.dart';
import 'package:wameedpos/features/layout_builder/models/pos_layout_template.dart';
import 'package:wameedpos/features/layout_builder/models/template_version.dart';
import 'package:wameedpos/features/layout_builder/models/widget_placement.dart';

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
  const LayoutTemplatesLoaded({required this.templates});
  final List<PosLayoutTemplate> templates;
}

class LayoutTemplatesError extends LayoutTemplatesState {
  const LayoutTemplatesError({required this.message});
  final String message;
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

  const CanvasBuilderLoaded({
    required this.canvas,
    required this.placements,
    this.availableWidgets = const [],
    this.versions = const [],
  });
  final LayoutCanvas canvas;
  final List<WidgetPlacement> placements;
  final List<LayoutWidget> availableWidgets;
  final List<TemplateVersion> versions;

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
  const CanvasBuilderError({required this.message});
  final String message;
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

  const WidgetCatalogLoaded({required this.widgets, this.selectedCategory});
  final List<LayoutWidget> widgets;
  final String? selectedCategory;

  WidgetCatalogLoaded copyWith({List<LayoutWidget>? widgets, String? selectedCategory}) {
    return WidgetCatalogLoaded(widgets: widgets ?? this.widgets, selectedCategory: selectedCategory ?? this.selectedCategory);
  }
}

class WidgetCatalogError extends WidgetCatalogState {
  const WidgetCatalogError({required this.message});
  final String message;
}
