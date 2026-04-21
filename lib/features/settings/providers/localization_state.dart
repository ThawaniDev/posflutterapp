import 'package:wameedpos/features/settings/models/supported_locale.dart';
import 'package:wameedpos/features/settings/models/master_translation_string.dart';
import 'package:wameedpos/features/settings/models/translation_override.dart';
import 'package:wameedpos/features/settings/models/translation_version.dart';

// ─── Locale list state ──────────────────────────────────────────────────────

sealed class LocaleListState {
  const LocaleListState();
}

final class LocaleListInitial extends LocaleListState {
  const LocaleListInitial();
}

final class LocaleListLoading extends LocaleListState {
  const LocaleListLoading();
}

final class LocaleListLoaded extends LocaleListState {
  const LocaleListLoaded(this.locales);
  final List<SupportedLocale> locales;
}

final class LocaleListError extends LocaleListState {
  const LocaleListError(this.message);
  final String message;
}

// ─── Translation list state ─────────────────────────────────────────────────

sealed class TranslationListState {
  const TranslationListState();
}

final class TranslationListInitial extends TranslationListState {
  const TranslationListInitial();
}

final class TranslationListLoading extends TranslationListState {
  const TranslationListLoading();
}

final class TranslationListLoaded extends TranslationListState {
  const TranslationListLoaded(this.translations, {this.total = 0});
  final List<MasterTranslationString> translations;
  final int total;
}

final class TranslationListError extends TranslationListState {
  const TranslationListError(this.message);
  final String message;
}

// ─── Override list state ────────────────────────────────────────────────────

sealed class OverrideListState {
  const OverrideListState();
}

final class OverrideListInitial extends OverrideListState {
  const OverrideListInitial();
}

final class OverrideListLoading extends OverrideListState {
  const OverrideListLoading();
}

final class OverrideListLoaded extends OverrideListState {
  const OverrideListLoaded(this.overrides);
  final List<TranslationOverride> overrides;
}

final class OverrideListError extends OverrideListState {
  const OverrideListError(this.message);
  final String message;
}

// ─── Version list state ─────────────────────────────────────────────────────

sealed class VersionListState {
  const VersionListState();
}

final class VersionListInitial extends VersionListState {
  const VersionListInitial();
}

final class VersionListLoading extends VersionListState {
  const VersionListLoading();
}

final class VersionListLoaded extends VersionListState {
  const VersionListLoaded(this.versions);
  final List<TranslationVersion> versions;
}

final class VersionListError extends VersionListState {
  const VersionListError(this.message);
  final String message;
}

// ─── Export state ───────────────────────────────────────────────────────────

sealed class TranslationExportState {
  const TranslationExportState();
}

final class TranslationExportInitial extends TranslationExportState {
  const TranslationExportInitial();
}

final class TranslationExportLoading extends TranslationExportState {
  const TranslationExportLoading();
}

final class TranslationExportLoaded extends TranslationExportState {
  const TranslationExportLoaded(this.translations);
  final Map<String, String> translations;
}

final class TranslationExportError extends TranslationExportState {
  const TranslationExportError(this.message);
  final String message;
}
