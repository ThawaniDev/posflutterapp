import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/layout_builder/models/layout_canvas.dart';
import 'package:wameedpos/features/layout_builder/models/layout_widget.dart';
import 'package:wameedpos/features/layout_builder/models/pos_layout_template.dart';
import 'package:wameedpos/features/layout_builder/models/template_version.dart';
import 'package:wameedpos/features/layout_builder/models/widget_placement.dart';

final layoutBuilderApiServiceProvider = Provider<LayoutBuilderApiService>((ref) {
  return LayoutBuilderApiService(ref.watch(dioClientProvider));
});

class LayoutBuilderApiService {

  LayoutBuilderApiService(this._dio);
  final Dio _dio;

  // ── Layout Templates ──────────────────────────────────────

  Future<List<PosLayoutTemplate>> listLayouts() async {
    final response = await _dio.get(ApiEndpoints.uiLayouts);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => PosLayoutTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ── Widget Catalog ────────────────────────────────────────

  Future<List<LayoutWidget>> listWidgets({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    final response = await _dio.get(ApiEndpoints.layoutBuilderWidgets, queryParameters: queryParams);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => LayoutWidget.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<LayoutWidget> getWidget(String id) async {
    final response = await _dio.get(ApiEndpoints.layoutBuilderWidgetById(id));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LayoutWidget.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ── Canvas ────────────────────────────────────────────────

  Future<LayoutCanvas> getCanvas() async {
    final response = await _dio.get(ApiEndpoints.layoutBuilderCanvas);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LayoutCanvas.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<LayoutCanvas> updateCanvas(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.layoutBuilderCanvas, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LayoutCanvas.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ── Placements ────────────────────────────────────────────

  Future<List<WidgetPlacement>> listPlacements() async {
    final response = await _dio.get(ApiEndpoints.layoutBuilderPlacements);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => WidgetPlacement.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<WidgetPlacement> createPlacement(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.layoutBuilderPlacements, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return WidgetPlacement.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<WidgetPlacement> updatePlacement(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.layoutBuilderPlacementById(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return WidgetPlacement.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deletePlacement(String id) async {
    await _dio.delete(ApiEndpoints.layoutBuilderPlacementById(id));
  }

  // ── Theme Overrides ───────────────────────────────────────

  Future<void> updateThemeOverrides(Map<String, dynamic> data) async {
    await _dio.put(ApiEndpoints.layoutBuilderThemeOverrides, data: data);
  }

  Future<void> deleteThemeOverride(String id) async {
    await _dio.delete(ApiEndpoints.layoutBuilderThemeOverrideById(id));
  }

  // ── Clone & Versions ──────────────────────────────────────

  Future<LayoutCanvas> cloneCanvas(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.layoutBuilderClone, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return LayoutCanvas.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<TemplateVersion>> listVersions() async {
    final response = await _dio.get(ApiEndpoints.layoutBuilderVersions);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => TemplateVersion.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<TemplateVersion> createVersion(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.layoutBuilderVersions, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TemplateVersion.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ── Full Layout (canvas + placements + overrides) ─────────

  Future<Map<String, dynamic>> getFullLayout() async {
    final response = await _dio.get(ApiEndpoints.layoutBuilderFull);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }
}
