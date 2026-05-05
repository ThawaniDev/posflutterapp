import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/labels/providers/label_state.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';

// ─── Label Templates Provider ───────────────────────────────────

final labelTemplatesProvider = StateNotifierProvider<LabelTemplatesNotifier, LabelTemplatesState>((ref) {
  return LabelTemplatesNotifier(ref.watch(labelRepositoryProvider));
});

class LabelTemplatesNotifier extends StateNotifier<LabelTemplatesState> {
  LabelTemplatesNotifier(this._repo) : super(const LabelTemplatesInitial());
  final LabelRepository _repo;

  Future<void> load({String? search, String? type}) async {
    state = const LabelTemplatesLoading();
    try {
      final templates = await _repo.listTemplates(search: search, type: type);
      state = LabelTemplatesLoaded(templates: templates);
    } on DioException catch (e) {
      state = LabelTemplatesError(message: _extractError(e));
    } catch (e) {
      state = LabelTemplatesError(message: e.toString());
    }
  }

  Future<void> loadPresets() async {
    try {
      final presets = await _repo.getPresets();
      if (state is LabelTemplatesLoaded) {
        state = (state as LabelTemplatesLoaded).copyWith(presets: presets);
      }
    } on DioException catch (e) {
      state = LabelTemplatesError(message: _extractError(e));
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await _repo.deleteTemplate(id);
      await load();
    } on DioException catch (e) {
      state = LabelTemplatesError(message: _extractError(e));
    }
  }

  Future<bool> duplicateTemplate(String id) async {
    try {
      final copy = await _repo.duplicateTemplate(id);
      if (state is LabelTemplatesLoaded) {
        final current = (state as LabelTemplatesLoaded).templates;
        state = (state as LabelTemplatesLoaded).copyWith(templates: [...current, copy]);
      }
      return true;
    } on DioException catch (e) {
      state = LabelTemplatesError(message: _extractError(e));
      return false;
    } catch (e) {
      state = LabelTemplatesError(message: e.toString());
      return false;
    }
  }

  Future<bool> setDefaultTemplate(String id) async {
    try {
      final updated = await _repo.setDefaultTemplate(id);
      if (state is LabelTemplatesLoaded) {
        final current = (state as LabelTemplatesLoaded).templates;
        final newList = current.map((t) {
          if (t.id == updated.id) return updated;
          if (t.isDefault == true) return t.copyWith(isDefault: false);
          return t;
        }).toList();
        state = (state as LabelTemplatesLoaded).copyWith(templates: newList);
      }
      return true;
    } on DioException catch (e) {
      state = LabelTemplatesError(message: _extractError(e));
      return false;
    }
  }
}

// ─── Label Detail Provider ──────────────────────────────────────

final labelDetailProvider = StateNotifierProvider.family<LabelDetailNotifier, LabelDetailState, String?>((ref, templateId) {
  return LabelDetailNotifier(ref.watch(labelRepositoryProvider), templateId);
});

class LabelDetailNotifier extends StateNotifier<LabelDetailState> {
  LabelDetailNotifier(this._repo, this._templateId) : super(const LabelDetailInitial());
  final LabelRepository _repo;
  final String? _templateId;

  Future<void> load() async {
    if (_templateId == null) return;
    state = const LabelDetailLoading();
    try {
      final template = await _repo.getTemplate(_templateId);
      state = LabelDetailLoaded(template: template);
    } on DioException catch (e) {
      state = LabelDetailError(message: _extractError(e));
    } catch (e) {
      state = LabelDetailError(message: e.toString());
    }
  }

  Future<void> save(Map<String, dynamic> data) async {
    state = const LabelDetailSaving();
    try {
      final template = _templateId != null ? await _repo.updateTemplate(_templateId, data) : await _repo.createTemplate(data);
      state = LabelDetailSaved(template: template);
    } on DioException catch (e) {
      state = LabelDetailError(message: _extractError(e));
    } catch (e) {
      state = LabelDetailError(message: e.toString());
    }
  }
}

// ─── Helper ─────────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}

// ─── Label History Provider ──────────────────────────────────────

final labelHistoryProvider = StateNotifierProvider<LabelHistoryNotifier, LabelHistoryState>((ref) {
  return LabelHistoryNotifier(ref.watch(labelRepositoryProvider));
});

class LabelHistoryNotifier extends StateNotifier<LabelHistoryState> {
  LabelHistoryNotifier(this._repo) : super(const LabelHistoryInitial());
  final LabelRepository _repo;

  Future<void> load({
    DateTime? from,
    DateTime? to,
    String? templateId,
    int? perPage,
  }) async {
    state = const LabelHistoryLoading();
    try {
      final history = await _repo.getPrintHistory(
        from: from,
        to: to,
        templateId: templateId,
        perPage: perPage,
      );
      state = LabelHistoryLoaded(history: history);
    } on DioException catch (e) {
      state = LabelHistoryError(message: _extractError(e));
    } catch (e) {
      state = LabelHistoryError(message: e.toString());
    }
  }
}

// ─── Label Print Stats Provider ──────────────────────────────────

final labelPrintStatsProvider = StateNotifierProvider<LabelPrintStatsNotifier, LabelPrintStatsState>((ref) {
  return LabelPrintStatsNotifier(ref.watch(labelRepositoryProvider));
});

class LabelPrintStatsNotifier extends StateNotifier<LabelPrintStatsState> {
  LabelPrintStatsNotifier(this._repo) : super(const LabelPrintStatsInitial());
  final LabelRepository _repo;

  Future<void> load() async {
    state = const LabelPrintStatsLoading();
    try {
      final stats = await _repo.getPrintHistoryStats();
      state = LabelPrintStatsLoaded(stats: stats);
    } on DioException catch (e) {
      state = LabelPrintStatsError(message: _extractError(e));
    } catch (e) {
      state = LabelPrintStatsError(message: e.toString());
    }
  }
}

