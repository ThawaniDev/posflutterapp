import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/layout_builder/data/remote/layout_builder_api_service.dart';
import 'package:wameedpos/features/layout_builder/models/layout_canvas.dart';
import 'package:wameedpos/features/layout_builder/models/layout_widget.dart';
import 'package:wameedpos/features/layout_builder/models/pos_layout_template.dart';
import 'package:wameedpos/features/layout_builder/models/template_version.dart';
import 'package:wameedpos/features/layout_builder/models/widget_placement.dart';

final layoutBuilderRepositoryProvider = Provider<LayoutBuilderRepository>((ref) {
  return LayoutBuilderRepository(apiService: ref.watch(layoutBuilderApiServiceProvider));
});

class LayoutBuilderRepository {

  LayoutBuilderRepository({required LayoutBuilderApiService apiService}) : _apiService = apiService;
  final LayoutBuilderApiService _apiService;

  Future<List<PosLayoutTemplate>> listLayouts() => _apiService.listLayouts();
  Future<List<LayoutWidget>> listWidgets({String? category}) => _apiService.listWidgets(category: category);
  Future<LayoutWidget> getWidget(String id) => _apiService.getWidget(id);
  Future<LayoutCanvas> getCanvas() => _apiService.getCanvas();
  Future<LayoutCanvas> updateCanvas(Map<String, dynamic> data) => _apiService.updateCanvas(data);
  Future<List<WidgetPlacement>> listPlacements() => _apiService.listPlacements();
  Future<WidgetPlacement> createPlacement(Map<String, dynamic> data) => _apiService.createPlacement(data);
  Future<WidgetPlacement> updatePlacement(String id, Map<String, dynamic> data) => _apiService.updatePlacement(id, data);
  Future<void> deletePlacement(String id) => _apiService.deletePlacement(id);
  Future<void> updateThemeOverrides(Map<String, dynamic> data) => _apiService.updateThemeOverrides(data);
  Future<void> deleteThemeOverride(String id) => _apiService.deleteThemeOverride(id);
  Future<LayoutCanvas> cloneCanvas(Map<String, dynamic> data) => _apiService.cloneCanvas(data);
  Future<List<TemplateVersion>> listVersions() => _apiService.listVersions();
  Future<TemplateVersion> createVersion(Map<String, dynamic> data) => _apiService.createVersion(data);
  Future<Map<String, dynamic>> getFullLayout() => _apiService.getFullLayout();
}
