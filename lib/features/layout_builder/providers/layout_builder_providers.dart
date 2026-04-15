import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/layout_builder/providers/layout_builder_state.dart';
import 'package:wameedpos/features/layout_builder/repositories/layout_builder_repository.dart';

// ─── Layout Templates Provider ─────────────────────────────

final layoutTemplatesProvider = StateNotifierProvider<LayoutTemplatesNotifier, LayoutTemplatesState>((ref) {
  return LayoutTemplatesNotifier(ref.watch(layoutBuilderRepositoryProvider));
});

class LayoutTemplatesNotifier extends StateNotifier<LayoutTemplatesState> {
  final LayoutBuilderRepository _repo;

  LayoutTemplatesNotifier(this._repo) : super(const LayoutTemplatesInitial());

  Future<void> load() async {
    state = const LayoutTemplatesLoading();
    try {
      final templates = await _repo.listLayouts();
      state = LayoutTemplatesLoaded(templates: templates);
    } on DioException catch (e) {
      state = LayoutTemplatesError(message: _extractError(e));
    } catch (e) {
      state = LayoutTemplatesError(message: e.toString());
    }
  }
}

// ─── Canvas Builder Provider ───────────────────────────────

final canvasBuilderProvider = StateNotifierProvider<CanvasBuilderNotifier, CanvasBuilderState>((ref) {
  return CanvasBuilderNotifier(ref.watch(layoutBuilderRepositoryProvider));
});

class CanvasBuilderNotifier extends StateNotifier<CanvasBuilderState> {
  final LayoutBuilderRepository _repo;

  CanvasBuilderNotifier(this._repo) : super(const CanvasBuilderInitial());

  Future<void> load() async {
    state = const CanvasBuilderLoading();
    try {
      final results = await Future.wait([_repo.getCanvas(), _repo.listPlacements(), _repo.listWidgets(), _repo.listVersions()]);
      state = CanvasBuilderLoaded(
        canvas: results[0] as dynamic,
        placements: results[1] as dynamic,
        availableWidgets: results[2] as dynamic,
        versions: results[3] as dynamic,
      );
    } on DioException catch (e) {
      state = CanvasBuilderError(message: _extractError(e));
    } catch (e) {
      state = CanvasBuilderError(message: e.toString());
    }
  }

  Future<void> addPlacement(Map<String, dynamic> data) async {
    if (state is! CanvasBuilderLoaded) return;
    try {
      final placement = await _repo.createPlacement(data);
      final current = state as CanvasBuilderLoaded;
      state = current.copyWith(placements: [...current.placements, placement]);
    } on DioException catch (e) {
      state = CanvasBuilderError(message: _extractError(e));
    }
  }

  Future<void> updatePlacement(String id, Map<String, dynamic> data) async {
    if (state is! CanvasBuilderLoaded) return;
    try {
      final updated = await _repo.updatePlacement(id, data);
      final current = state as CanvasBuilderLoaded;
      state = current.copyWith(placements: current.placements.map((p) => p.id == id ? updated : p).toList());
    } on DioException catch (e) {
      state = CanvasBuilderError(message: _extractError(e));
    }
  }

  Future<void> removePlacement(String id) async {
    if (state is! CanvasBuilderLoaded) return;
    try {
      await _repo.deletePlacement(id);
      final current = state as CanvasBuilderLoaded;
      state = current.copyWith(placements: current.placements.where((p) => p.id != id).toList());
    } on DioException catch (e) {
      state = CanvasBuilderError(message: _extractError(e));
    }
  }

  Future<void> saveCanvas(Map<String, dynamic> data) async {
    state = const CanvasBuilderSaving();
    try {
      final canvas = await _repo.updateCanvas(data);
      final placements = await _repo.listPlacements();
      final widgets = await _repo.listWidgets();
      final versions = await _repo.listVersions();
      state = CanvasBuilderLoaded(canvas: canvas, placements: placements, availableWidgets: widgets, versions: versions);
    } on DioException catch (e) {
      state = CanvasBuilderError(message: _extractError(e));
    }
  }

  Future<void> createVersion(Map<String, dynamic> data) async {
    if (state is! CanvasBuilderLoaded) return;
    try {
      final version = await _repo.createVersion(data);
      final current = state as CanvasBuilderLoaded;
      state = current.copyWith(versions: [...current.versions, version]);
    } on DioException catch (e) {
      state = CanvasBuilderError(message: _extractError(e));
    }
  }

  Future<void> cloneCanvas(Map<String, dynamic> data) async {
    state = const CanvasBuilderSaving();
    try {
      await _repo.cloneCanvas(data);
      await load();
    } on DioException catch (e) {
      state = CanvasBuilderError(message: _extractError(e));
    }
  }
}

// ─── Widget Catalog Provider ───────────────────────────────

final widgetCatalogProvider = StateNotifierProvider<WidgetCatalogNotifier, WidgetCatalogState>((ref) {
  return WidgetCatalogNotifier(ref.watch(layoutBuilderRepositoryProvider));
});

class WidgetCatalogNotifier extends StateNotifier<WidgetCatalogState> {
  final LayoutBuilderRepository _repo;

  WidgetCatalogNotifier(this._repo) : super(const WidgetCatalogInitial());

  Future<void> load({String? category}) async {
    state = const WidgetCatalogLoading();
    try {
      final widgets = await _repo.listWidgets(category: category);
      state = WidgetCatalogLoaded(widgets: widgets, selectedCategory: category);
    } on DioException catch (e) {
      state = WidgetCatalogError(message: _extractError(e));
    } catch (e) {
      state = WidgetCatalogError(message: e.toString());
    }
  }
}

// ─── Helper ─────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
