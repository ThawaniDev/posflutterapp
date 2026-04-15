import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/settings/models/store_settings.dart';
import 'package:wameedpos/features/settings/providers/settings_providers.dart';

/// Base class for all settings sub-pages.
///
/// Handles loading, saving, snackbar feedback, and provides
/// the current [StoreSettings] via [settings] getter.
abstract class SettingsSubPage extends ConsumerStatefulWidget {
  const SettingsSubPage({super.key});
}

abstract class SettingsSubPageState<T extends SettingsSubPage> extends ConsumerState<T> {
  String? _storeId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _storeId = await ref.read(authLocalStorageProvider).getStoreId();
      if (_storeId != null) {
        ref.read(storeSettingsProvider.notifier).load(_storeId!);
      }
    });
  }

  String? get storeId => _storeId;

  /// Subclasses build the body given the loaded settings.
  Widget buildSettingsBody(BuildContext context, StoreSettings settings);

  /// The page title.
  String pageTitle(AppLocalizations l10n);

  /// Optional list of extra action widgets for the AppBar.
  List<Widget> extraActions(BuildContext context) => const [];

  /// Send a partial update map to the API.
  Future<void> saveSettings(Map<String, dynamic> data) async {
    if (_storeId == null || _saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(storeSettingsProvider.notifier).update(_storeId!, data);
      if (mounted) {
        showPosSuccessSnackbar(context, AppLocalizations.of(context)!.settingsSaved);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsState = ref.watch(storeSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle(l10n)),
        actions: [
          ...extraActions(context),
          if (_saving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),
        ],
      ),
      body: switch (settingsState) {
        StoreSettingsLoading() => const Center(child: CircularProgressIndicator()),
        StoreSettingsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              AppSpacing.gapH12,
              FilledButton(onPressed: () => ref.read(storeSettingsProvider.notifier).load(_storeId!), child: Text(l10n.retry)),
            ],
          ),
        ),
        StoreSettingsLoaded(:final settings) || StoreSettingsSaved(:final settings) || StoreSettingsSaving(:final settings) =>
          SingleChildScrollView(padding: AppSpacing.paddingAll16, child: buildSettingsBody(context, settings)),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
