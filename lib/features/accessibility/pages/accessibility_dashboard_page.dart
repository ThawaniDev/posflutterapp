import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_providers.dart';
import 'package:thawani_pos/features/accessibility/widgets/accessibility_prefs_widget.dart';
import 'package:thawani_pos/features/accessibility/widgets/shortcuts_widget.dart';

class AccessibilityDashboardPage extends ConsumerStatefulWidget {
  const AccessibilityDashboardPage({super.key});

  @override
  ConsumerState<AccessibilityDashboardPage> createState() => _AccessibilityDashboardPageState();
}

class _AccessibilityDashboardPageState extends ConsumerState<AccessibilityDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(accessibilityPrefsProvider.notifier).load();
      ref.read(shortcutsProvider.notifier).load();
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
        title: Text(AppLocalizations.of(context)!.accessibilityTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.accessibilityPreferences),
            Tab(text: AppLocalizations.of(context)!.accessibilityShortcuts),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [AccessibilityPrefsWidget(), ShortcutsWidget()]),
    );
  }
}
