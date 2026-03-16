import 'package:thawani_pos/features/settings/models/supported_locale.dart';
import 'package:thawani_pos/features/settings/models/master_translation_string.dart';
import 'package:thawani_pos/features/settings/models/translation_override.dart';
import 'package:thawani_pos/features/settings/models/translation_version.dart';

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
  final List<SupportedLocale> locales;
  const LocaleListLoaded(this.locales);
}

final class LocaleListError extends LocaleListState {
  final String message;
  const LocaleListError(this.message);
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
  final List<MasterTranslationString> translations;
  final int total;
  const TranslationListLoaded(this.translations, {this.total = 0});
}

final class TranslationListError extends TranslationListState {
  final String message;
  const TranslationListError(this.message);
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
  final List<TranslationOverride> overrides;
  const OverrideListLoaded(this.overrides);
}

final class OverrideListError extends OverrideListState {
  final String message;
  const OverrideListError(this.message);
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
  final List<TranslationVersion> versions;
  const VersionListLoaded(this.versions);
}

final class VersionListError extends VersionListState {
  final String message;
  const VersionListError(this.message);
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
  final Map<String, String> translations;
  const TranslationExportLoaded(this.translations);
}

final class TranslationExportError extends TranslationExportState {
  final String message;
  const TranslationExportError(this.message);
}
