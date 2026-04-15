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
  final List<ReceiptLayoutTemplate> templates;
  const ReceiptLayoutListLoaded({required this.templates});
}

class ReceiptLayoutListError extends ReceiptLayoutListState {
  final String message;
  const ReceiptLayoutListError({required this.message});
}

final receiptLayoutListProvider = StateNotifierProvider<ReceiptLayoutListNotifier, ReceiptLayoutListState>((ref) {
  return ReceiptLayoutListNotifier(ref.watch(customizationRepositoryProvider));
});

class ReceiptLayoutListNotifier extends StateNotifier<ReceiptLayoutListState> {
  final CustomizationRepository _repo;

  ReceiptLayoutListNotifier(this._repo) : super(const ReceiptLayoutListInitial());

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
  final ReceiptLayoutTemplate template;
  const ReceiptLayoutDetailLoaded({required this.template});
}

class ReceiptLayoutDetailError extends ReceiptLayoutDetailState {
  final String message;
  const ReceiptLayoutDetailError({required this.message});
}

final receiptLayoutDetailProvider = StateNotifierProvider.family<ReceiptLayoutDetailNotifier, ReceiptLayoutDetailState, String>((
  ref,
  slug,
) {
  return ReceiptLayoutDetailNotifier(ref.watch(customizationRepositoryProvider), slug);
});

class ReceiptLayoutDetailNotifier extends StateNotifier<ReceiptLayoutDetailState> {
  final CustomizationRepository _repo;
  final String _slug;

  ReceiptLayoutDetailNotifier(this._repo, this._slug) : super(const ReceiptLayoutDetailInitial());

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
  final List<CfdTheme> themes;
  const CfdThemeListLoaded({required this.themes});
}

class CfdThemeListError extends CfdThemeListState {
  final String message;
  const CfdThemeListError({required this.message});
}

final cfdThemeListProvider = StateNotifierProvider<CfdThemeListNotifier, CfdThemeListState>((ref) {
  return CfdThemeListNotifier(ref.watch(customizationRepositoryProvider));
});

class CfdThemeListNotifier extends StateNotifier<CfdThemeListState> {
  final CustomizationRepository _repo;

  CfdThemeListNotifier(this._repo) : super(const CfdThemeListInitial());

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
  final CfdTheme theme;
  const CfdThemeDetailLoaded({required this.theme});
}

class CfdThemeDetailError extends CfdThemeDetailState {
  final String message;
  const CfdThemeDetailError({required this.message});
}

final cfdThemeDetailProvider = StateNotifierProvider.family<CfdThemeDetailNotifier, CfdThemeDetailState, String>((ref, slug) {
  return CfdThemeDetailNotifier(ref.watch(customizationRepositoryProvider), slug);
});

class CfdThemeDetailNotifier extends StateNotifier<CfdThemeDetailState> {
  final CustomizationRepository _repo;
  final String _slug;

  CfdThemeDetailNotifier(this._repo, this._slug) : super(const CfdThemeDetailInitial());

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
  final List<LabelLayoutTemplate> templates;
  const LabelLayoutListLoaded({required this.templates});
}

class LabelLayoutListError extends LabelLayoutListState {
  final String message;
  const LabelLayoutListError({required this.message});
}

final labelLayoutListProvider = StateNotifierProvider<LabelLayoutListNotifier, LabelLayoutListState>((ref) {
  return LabelLayoutListNotifier(ref.watch(customizationRepositoryProvider));
});

class LabelLayoutListNotifier extends StateNotifier<LabelLayoutListState> {
  final CustomizationRepository _repo;

  LabelLayoutListNotifier(this._repo) : super(const LabelLayoutListInitial());

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
  final LabelLayoutTemplate template;
  const LabelLayoutDetailLoaded({required this.template});
}

class LabelLayoutDetailError extends LabelLayoutDetailState {
  final String message;
  const LabelLayoutDetailError({required this.message});
}

final labelLayoutDetailProvider = StateNotifierProvider.family<LabelLayoutDetailNotifier, LabelLayoutDetailState, String>((
  ref,
  slug,
) {
  return LabelLayoutDetailNotifier(ref.watch(customizationRepositoryProvider), slug);
});

class LabelLayoutDetailNotifier extends StateNotifier<LabelLayoutDetailState> {
  final CustomizationRepository _repo;
  final String _slug;

  LabelLayoutDetailNotifier(this._repo, this._slug) : super(const LabelLayoutDetailInitial());

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
