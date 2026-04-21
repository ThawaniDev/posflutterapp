import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/pos_customization/models/cfd_theme.dart';
import 'package:wameedpos/features/pos_customization/models/label_layout_template.dart';
import 'package:wameedpos/features/pos_customization/models/receipt_layout_template.dart';
import 'package:wameedpos/features/pos_customization/repositories/customization_repository.dart';

// ─── Receipt Layout Templates ──────────────────────────────

sealed class ReceiptLayoutListState {
  const ReceiptLayoutListState();
}

class ReceiptLayoutListInitial extends ReceiptLayoutListState {
  const ReceiptLayoutListInitial();
}

class ReceiptLayoutListLoading extends ReceiptLayoutListState {
  const ReceiptLayoutListLoading();
}

class ReceiptLayoutListLoaded extends ReceiptLayoutListState {
  const ReceiptLayoutListLoaded({required this.templates});
  final List<ReceiptLayoutTemplate> templates;
}

class ReceiptLayoutListError extends ReceiptLayoutListState {
  const ReceiptLayoutListError({required this.message});
  final String message;
}

final receiptLayoutListProvider = StateNotifierProvider<ReceiptLayoutListNotifier, ReceiptLayoutListState>((ref) {
  return ReceiptLayoutListNotifier(ref.watch(customizationRepositoryProvider));
});

class ReceiptLayoutListNotifier extends StateNotifier<ReceiptLayoutListState> {

  ReceiptLayoutListNotifier(this._repo) : super(const ReceiptLayoutListInitial());
  final CustomizationRepository _repo;

  Future<void> load() async {
    state = const ReceiptLayoutListLoading();
    try {
      final templates = await _repo.listReceiptLayoutTemplates();
      state = ReceiptLayoutListLoaded(templates: templates);
    } on DioException catch (e) {
      state = ReceiptLayoutListError(message: _extractError(e));
    } catch (e) {
      state = ReceiptLayoutListError(message: e.toString());
    }
  }
}

// ─── Receipt Layout Template Detail ────────────────────────

sealed class ReceiptLayoutDetailState {
  const ReceiptLayoutDetailState();
}

class ReceiptLayoutDetailInitial extends ReceiptLayoutDetailState {
  const ReceiptLayoutDetailInitial();
}

class ReceiptLayoutDetailLoading extends ReceiptLayoutDetailState {
  const ReceiptLayoutDetailLoading();
}

class ReceiptLayoutDetailLoaded extends ReceiptLayoutDetailState {
  const ReceiptLayoutDetailLoaded({required this.template});
  final ReceiptLayoutTemplate template;
}

class ReceiptLayoutDetailError extends ReceiptLayoutDetailState {
  const ReceiptLayoutDetailError({required this.message});
  final String message;
}

final receiptLayoutDetailProvider = StateNotifierProvider.family<ReceiptLayoutDetailNotifier, ReceiptLayoutDetailState, String>((
  ref,
  slug,
) {
  return ReceiptLayoutDetailNotifier(ref.watch(customizationRepositoryProvider), slug);
});

class ReceiptLayoutDetailNotifier extends StateNotifier<ReceiptLayoutDetailState> {

  ReceiptLayoutDetailNotifier(this._repo, this._slug) : super(const ReceiptLayoutDetailInitial());
  final CustomizationRepository _repo;
  final String _slug;

  Future<void> load() async {
    state = const ReceiptLayoutDetailLoading();
    try {
      final template = await _repo.getReceiptLayoutTemplate(_slug);
      state = ReceiptLayoutDetailLoaded(template: template);
    } on DioException catch (e) {
      state = ReceiptLayoutDetailError(message: _extractError(e));
    } catch (e) {
      state = ReceiptLayoutDetailError(message: e.toString());
    }
  }
}

// ─── CFD Themes ────────────────────────────────────────────

sealed class CfdThemeListState {
  const CfdThemeListState();
}

class CfdThemeListInitial extends CfdThemeListState {
  const CfdThemeListInitial();
}

class CfdThemeListLoading extends CfdThemeListState {
  const CfdThemeListLoading();
}

class CfdThemeListLoaded extends CfdThemeListState {
  const CfdThemeListLoaded({required this.themes});
  final List<CfdTheme> themes;
}

class CfdThemeListError extends CfdThemeListState {
  const CfdThemeListError({required this.message});
  final String message;
}

final cfdThemeListProvider = StateNotifierProvider<CfdThemeListNotifier, CfdThemeListState>((ref) {
  return CfdThemeListNotifier(ref.watch(customizationRepositoryProvider));
});

class CfdThemeListNotifier extends StateNotifier<CfdThemeListState> {

  CfdThemeListNotifier(this._repo) : super(const CfdThemeListInitial());
  final CustomizationRepository _repo;

  Future<void> load() async {
    state = const CfdThemeListLoading();
    try {
      final themes = await _repo.listCfdThemes();
      state = CfdThemeListLoaded(themes: themes);
    } on DioException catch (e) {
      state = CfdThemeListError(message: _extractError(e));
    } catch (e) {
      state = CfdThemeListError(message: e.toString());
    }
  }
}

// ─── CFD Theme Detail ──────────────────────────────────────

sealed class CfdThemeDetailState {
  const CfdThemeDetailState();
}

class CfdThemeDetailInitial extends CfdThemeDetailState {
  const CfdThemeDetailInitial();
}

class CfdThemeDetailLoading extends CfdThemeDetailState {
  const CfdThemeDetailLoading();
}

class CfdThemeDetailLoaded extends CfdThemeDetailState {
  const CfdThemeDetailLoaded({required this.theme});
  final CfdTheme theme;
}

class CfdThemeDetailError extends CfdThemeDetailState {
  const CfdThemeDetailError({required this.message});
  final String message;
}

final cfdThemeDetailProvider = StateNotifierProvider.family<CfdThemeDetailNotifier, CfdThemeDetailState, String>((ref, slug) {
  return CfdThemeDetailNotifier(ref.watch(customizationRepositoryProvider), slug);
});

class CfdThemeDetailNotifier extends StateNotifier<CfdThemeDetailState> {

  CfdThemeDetailNotifier(this._repo, this._slug) : super(const CfdThemeDetailInitial());
  final CustomizationRepository _repo;
  final String _slug;

  Future<void> load() async {
    state = const CfdThemeDetailLoading();
    try {
      final theme = await _repo.getCfdTheme(_slug);
      state = CfdThemeDetailLoaded(theme: theme);
    } on DioException catch (e) {
      state = CfdThemeDetailError(message: _extractError(e));
    } catch (e) {
      state = CfdThemeDetailError(message: e.toString());
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
// ─── Label Layout Templates ─────────────────────────────────────────

sealed class LabelLayoutListState {
  const LabelLayoutListState();
}

class LabelLayoutListInitial extends LabelLayoutListState {
  const LabelLayoutListInitial();
}

class LabelLayoutListLoading extends LabelLayoutListState {
  const LabelLayoutListLoading();
}

class LabelLayoutListLoaded extends LabelLayoutListState {
  const LabelLayoutListLoaded({required this.templates});
  final List<LabelLayoutTemplate> templates;
}

class LabelLayoutListError extends LabelLayoutListState {
  const LabelLayoutListError({required this.message});
  final String message;
}

final labelLayoutListProvider = StateNotifierProvider<LabelLayoutListNotifier, LabelLayoutListState>((ref) {
  return LabelLayoutListNotifier(ref.watch(customizationRepositoryProvider));
});

class LabelLayoutListNotifier extends StateNotifier<LabelLayoutListState> {

  LabelLayoutListNotifier(this._repo) : super(const LabelLayoutListInitial());
  final CustomizationRepository _repo;

  Future<void> load() async {
    state = const LabelLayoutListLoading();
    try {
      final templates = await _repo.listLabelLayoutTemplates();
      state = LabelLayoutListLoaded(templates: templates);
    } on DioException catch (e) {
      state = LabelLayoutListError(message: _extractError(e));
    } catch (e) {
      state = LabelLayoutListError(message: e.toString());
    }
  }
}

// ─── Label Layout Template Detail ───────────────────────────────────

sealed class LabelLayoutDetailState {
  const LabelLayoutDetailState();
}

class LabelLayoutDetailInitial extends LabelLayoutDetailState {
  const LabelLayoutDetailInitial();
}

class LabelLayoutDetailLoading extends LabelLayoutDetailState {
  const LabelLayoutDetailLoading();
}

class LabelLayoutDetailLoaded extends LabelLayoutDetailState {
  const LabelLayoutDetailLoaded({required this.template});
  final LabelLayoutTemplate template;
}

class LabelLayoutDetailError extends LabelLayoutDetailState {
  const LabelLayoutDetailError({required this.message});
  final String message;
}

final labelLayoutDetailProvider = StateNotifierProvider.family<LabelLayoutDetailNotifier, LabelLayoutDetailState, String>((
  ref,
  slug,
) {
  return LabelLayoutDetailNotifier(ref.watch(customizationRepositoryProvider), slug);
});

class LabelLayoutDetailNotifier extends StateNotifier<LabelLayoutDetailState> {

  LabelLayoutDetailNotifier(this._repo, this._slug) : super(const LabelLayoutDetailInitial());
  final CustomizationRepository _repo;
  final String _slug;

  Future<void> load() async {
    state = const LabelLayoutDetailLoading();
    try {
      final template = await _repo.getLabelLayoutTemplate(_slug);
      state = LabelLayoutDetailLoaded(template: template);
    } on DioException catch (e) {
      state = LabelLayoutDetailError(message: _extractError(e));
    } catch (e) {
      state = LabelLayoutDetailError(message: e.toString());
    }
  }
}
