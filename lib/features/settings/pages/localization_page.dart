import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/settings/providers/localization_providers.dart';
import 'package:wameedpos/features/settings/providers/localization_state.dart';
import 'package:wameedpos/features/settings/widgets/locale_selector.dart';
import 'package:wameedpos/features/settings/widgets/translation_string_card.dart';
import 'package:wameedpos/features/settings/widgets/version_history_list.dart';

class LocalizationPage extends ConsumerStatefulWidget {
  const LocalizationPage({super.key});

  @override
  ConsumerState<LocalizationPage> createState() => _LocalizationPageState();
}

class _LocalizationPageState extends ConsumerState<LocalizationPage> with SingleTickerProviderStateMixin {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late final TabController _tabController;
  String _selectedLocale = 'en';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(localeListProvider.notifier).load();
      ref.read(translationListProvider.notifier).load(locale: _selectedLocale);
      ref.read(versionListProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.localizationTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.language), text: AppLocalizations.of(context)!.localizationLanguage),
            Tab(icon: const Icon(Icons.translate), text: AppLocalizations.of(context)!.localizationTranslations),
            Tab(icon: const Icon(Icons.history), text: AppLocalizations.of(context)!.autoUpdateHistory),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildLocalesTab(theme), _buildTranslationsTab(theme), _buildVersionsTab(theme)],
      ),
    );
  }

  Widget _buildLocalesTab(ThemeData theme) {
    final localeState = ref.watch(localeListProvider);
    return switch (localeState) {
      LocaleListLoading() => const Center(child: CircularProgressIndicator()),
      LocaleListError(:final message) => Center(child: Text(message)),
      LocaleListLoaded(:final locales) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: LocaleSelector(
          locales: locales,
          selectedCode: _selectedLocale,
          onSelected: (locale) {
            setState(() => _selectedLocale = locale.localeCode);
            ref.read(translationListProvider.notifier).load(locale: _selectedLocale);
          },
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildTranslationsTab(ThemeData theme) {
    final translationState = ref.watch(translationListProvider);
    return switch (translationState) {
      TranslationListLoading() => const Center(child: CircularProgressIndicator()),
      TranslationListError(:final message) => Center(child: Text(message)),
      TranslationListLoaded(:final translations, :final total) => Column(
        children: [
          Padding(
            padding: AppSpacing.paddingAll12,
            child: Row(
              children: [
                Text('$total translations', style: theme.textTheme.titleSmall),
                const Spacer(),
                Text('Locale: $_selectedLocale', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: AppSpacing.paddingH16,
              itemCount: translations.length,
              itemBuilder: (context, index) {
                return TranslationStringCard(translation: translations[index]);
              },
            ),
          ),
        ],
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildVersionsTab(ThemeData theme) {
    final versionState = ref.watch(versionListProvider);
    return switch (versionState) {
      VersionListLoading() => const Center(child: CircularProgressIndicator()),
      VersionListError(:final message) => Center(child: Text(message)),
      VersionListLoaded(:final versions) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.translationVersions, style: theme.textTheme.titleMedium),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () async {
                    await ref.read(versionListProvider.notifier).load();
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.commonRefresh),
                ),
              ],
            ),
            AppSpacing.gapH12,
            VersionHistoryList(versions: versions),
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
