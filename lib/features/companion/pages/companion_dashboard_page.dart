import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/features/companion/providers/companion_providers.dart';
import 'package:thawani_pos/features/companion/widgets/quick_stats_widget.dart';
import 'package:thawani_pos/features/companion/widgets/quick_actions_widget.dart';
import 'package:thawani_pos/features/companion/widgets/preferences_widget.dart';

class CompanionDashboardPage extends ConsumerStatefulWidget {
  const CompanionDashboardPage({super.key});

  @override
  ConsumerState<CompanionDashboardPage> createState() => _CompanionDashboardPageState();
}

class _CompanionDashboardPageState extends ConsumerState<CompanionDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(quickStatsProvider.notifier).load();
      ref.read(quickActionsProvider.notifier).load();
      ref.read(preferencesProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.companionTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.dashboard), text: AppLocalizations.of(context)!.companionQuickStats),
            Tab(icon: const Icon(Icons.touch_app), text: AppLocalizations.of(context)!.companionQuickActions),
            Tab(icon: const Icon(Icons.settings), text: AppLocalizations.of(context)!.companionPreferences),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [QuickStatsWidget(), QuickActionsWidget(), PreferencesWidget()],
      ),
    );
  }
}
