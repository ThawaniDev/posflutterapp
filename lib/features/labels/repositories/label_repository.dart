import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/labels/data/remote/label_api_service.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';

final labelRepositoryProvider = Provider<LabelRepository>((ref) {
  return LabelRepository(apiService: ref.watch(labelApiServiceProvider));
});

class LabelRepository {
  LabelRepository({required LabelApiService apiService}) : _apiService = apiService;
  final LabelApiService _apiService;

  Future<List<LabelTemplate>> listTemplates() => _apiService.listTemplates();
  Future<List<LabelTemplate>> getPresets() => _apiService.getPresets();
  Future<LabelTemplate> getTemplate(String id) => _apiService.getTemplate(id);
  Future<LabelTemplate> createTemplate(Map<String, dynamic> data) => _apiService.createTemplate(data);
  Future<LabelTemplate> updateTemplate(String id, Map<String, dynamic> data) => _apiService.updateTemplate(id, data);
  Future<void> deleteTemplate(String id) => _apiService.deleteTemplate(id);
  Future<List<LabelPrintHistory>> getPrintHistory() => _apiService.getPrintHistory();
  Future<void> recordPrint(Map<String, dynamic> data) => _apiService.recordPrint(data);
  Future<LabelTemplate> duplicateTemplate(String id) => _apiService.duplicateTemplate(id);
  Future<LabelTemplate> setDefaultTemplate(String id) => _apiService.setDefaultTemplate(id);
}
