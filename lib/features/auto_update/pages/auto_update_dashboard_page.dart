import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_providers.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';
import 'package:wameedpos/features/auto_update/widgets/update_status_widget.dart';
import 'package:wameedpos/features/auto_update/widgets/changelog_widget.dart';

class AutoUpdateDashboardPage extends ConsumerStatefulWidget {
  const AutoUpdateDashboardPage({super.key});

  @override
  ConsumerState<AutoUpdateDashboardPage> createState() => _AutoUpdateDashboardPageState();
}

class _AutoUpdateDashboardPageState extends ConsumerState<AutoUpdateDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final info = await PackageInfo.fromPlatform();
    final platform = _currentPlatform();
    ref.read(updateCheckProvider.notifier).check(currentVersion: info.version, platform: platform);
    ref.read(changelogProvider.notifier).load(platform: platform);
    ref.read(updateHistoryProvider.notifier).load();
  }

  String _currentPlatform() {
    if (kIsWeb) return 'ios';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    return 'ios';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(updateHistoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.autoUpdateTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.syncStatus),
            Tab(text: AppLocalizations.of(context)!.autoUpdateChangelog),
            Tab(text: AppLocalizations.of(context)!.autoUpdateHistory),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const UpdateStatusWidget(),
          const ChangelogWidget(),
          // History tab
          switch (historyState) {
            HistoryInitial() => const Center(child: Text('Loading history...')),
            HistoryLoading() => const Center(child: CircularProgressIndicator()),
            HistoryError(:final message) => Center(
              child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
            ),
            HistoryLoaded(:final entries) =>
              entries.isEmpty
                  ? const Center(child: Text('No update history'))
                  : ListView.builder(
                      padding: AppSpacing.paddingAll16,
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final e = entries[index];
                        final rel = e['app_release'] as Map<String, dynamic>? ?? {};
                        return ListTile(
                          leading: Icon(
                            e['status'] == 'installed'
                                ? Icons.check_circle
                                : e['status'] == 'failed'
                                ? Icons.error
                                : Icons.downloading,
                            color: e['status'] == 'installed'
                                ? AppColors.success
                                : e['status'] == 'failed'
                                ? AppColors.error
                                : AppColors.warning,
                          ),
                          title: Text('v${rel['version_number'] ?? '?'}'),
                          subtitle: Text(e['status']?.toString() ?? ''),
                          trailing: e['error_message'] != null
                              ? Tooltip(message: e['error_message'].toString(), child: const Icon(Icons.info_outline))
                              : null,
                        );
                      },
                    ),
          },
        ],
      ),
    );
  }
}
