import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/auto_update/providers/auto_update_providers.dart';
import 'package:thawani_pos/features/auto_update/providers/auto_update_state.dart';
import 'package:thawani_pos/features/auto_update/widgets/update_status_widget.dart';
import 'package:thawani_pos/features/auto_update/widgets/changelog_widget.dart';

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
    Future.microtask(() {
      ref.read(updateCheckProvider.notifier).check(currentVersion: '1.0.0', platform: 'ios');
      ref.read(changelogProvider.notifier).load(platform: 'ios');
      ref.read(updateHistoryProvider.notifier).load();
    });
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
        title: const Text('Auto Updates'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Status'),
            Tab(text: 'Changelog'),
            Tab(text: 'History'),
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
                                ? Colors.green
                                : e['status'] == 'failed'
                                ? Colors.red
                                : Colors.orange,
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
