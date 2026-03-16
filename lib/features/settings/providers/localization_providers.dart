import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/settings/models/master_translation_string.dart';
import 'package:thawani_pos/features/settings/models/supported_locale.dart';
import 'package:thawani_pos/features/settings/models/translation_override.dart';
import 'package:thawani_pos/features/settings/models/translation_version.dart';
import 'package:thawani_pos/features/settings/providers/localization_state.dart';
import 'package:thawani_pos/features/settings/repositories/localization_repository.dart';

// ─── Locale list provider ──────────────────────────────────────────────

final localeListProvider = StateNotifierProvider<LocaleListNotifier, LocaleListState>((ref) {
  return LocaleListNotifier(ref.watch(localizationRepositoryProvider));
});

class LocaleListNotifier extends StateNotifier<LocaleListState> {
  final LocalizationRepository _repo;
  LocaleListNotifier(this._repo) : super(const LocaleListInitial());

  Future<void> load({bool? activeOnly}) async {
    state = const LocaleListLoading();
    try {
      final res = await _repo.listLocales(activeOnly: activeOnly);
      final list = (res.data['data'] as List).map((e) => SupportedLocale.fromJson(e as Map<String, dynamic>)).toList();
      state = LocaleListLoaded(list);
    } catch (e) {
      state = LocaleListError(e.toString());
    }
  }
}

// ─── Translation list provider ─────────────────────────────────────────

final translationListProvider = StateNotifierProvider<TranslationListNotifier, TranslationListState>((ref) {
  return TranslationListNotifier(ref.watch(localizationRepositoryProvider));
});

class TranslationListNotifier extends StateNotifier<TranslationListState> {
  final LocalizationRepository _repo;
  TranslationListNotifier(this._repo) : super(const TranslationListInitial());

  Future<void> load({required String locale, String? category, String? search, String? storeId, int? perPage}) async {
    state = const TranslationListLoading();
    try {
      final res = await _repo.getTranslations(
        locale: locale,
        category: category,
        search: search,
        storeId: storeId,
        perPage: perPage,
      );
      final data = res.data['data'];
      final items = (data['data'] as List).map((e) => MasterTranslationString.fromJson(e as Map<String, dynamic>)).toList();
      state = TranslationListLoaded(items, total: data['total'] as int? ?? items.length);
    } catch (e) {
      state = TranslationListError(e.toString());
    }
  }
}

// ─── Override list provider ────────────────────────────────────────────

final overrideListProvider = StateNotifierProvider<OverrideListNotifier, OverrideListState>((ref) {
  return OverrideListNotifier(ref.watch(localizationRepositoryProvider));
});

class OverrideListNotifier extends StateNotifier<OverrideListState> {
  final LocalizationRepository _repo;
  OverrideListNotifier(this._repo) : super(const OverrideListInitial());

  Future<void> load({required String storeId, String? locale}) async {
    state = const OverrideListLoading();
    try {
      final res = await _repo.getOverrides(storeId: storeId, locale: locale);
      final list = (res.data['data'] as List).map((e) => TranslationOverride.fromJson(e as Map<String, dynamic>)).toList();
      state = OverrideListLoaded(list);
    } catch (e) {
      state = OverrideListError(e.toString());
    }
  }
}

// ─── Version list provider ────────────────────────────────────────────

final versionListProvider = StateNotifierProvider<VersionListNotifier, VersionListState>((ref) {
  return VersionListNotifier(ref.watch(localizationRepositoryProvider));
});

class VersionListNotifier extends StateNotifier<VersionListState> {
  final LocalizationRepository _repo;
  VersionListNotifier(this._repo) : super(const VersionListInitial());

  Future<void> load({int? perPage}) async {
    state = const VersionListLoading();
    try {
      final res = await _repo.listVersions(perPage: perPage);
      final data = res.data['data'];
      final items = (data['data'] as List).map((e) => TranslationVersion.fromJson(e as Map<String, dynamic>)).toList();
      state = VersionListLoaded(items);
    } catch (e) {
      state = VersionListError(e.toString());
    }
  }
}

// ─── Export provider ──────────────────────────────────────────────────

final translationExportProvider = StateNotifierProvider<TranslationExportNotifier, TranslationExportState>((ref) {
  return TranslationExportNotifier(ref.watch(localizationRepositoryProvider));
});

class TranslationExportNotifier extends StateNotifier<TranslationExportState> {
  final LocalizationRepository _repo;
  TranslationExportNotifier(this._repo) : super(const TranslationExportInitial());

  Future<void> load({required String locale, String? storeId}) async {
    state = const TranslationExportLoading();
    try {
      final res = await _repo.exportTranslations(locale: locale, storeId: storeId);
      final raw = res.data['data'] as Map<String, dynamic>;
      final map = raw.map((k, v) => MapEntry(k, v.toString()));
      state = TranslationExportLoaded(map);
    } catch (e) {
      state = TranslationExportError(e.toString());
    }
  }
}
