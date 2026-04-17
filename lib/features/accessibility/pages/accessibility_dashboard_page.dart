import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_providers.dart';
import 'package:wameedpos/features/accessibility/widgets/accessibility_prefs_widget.dart';
import 'package:wameedpos/features/accessibility/widgets/shortcuts_widget.dart';

class AccessibilityDashboardPage extends ConsumerStatefulWidget {
  const AccessibilityDashboardPage({super.key});

  @override
  ConsumerState<AccessibilityDashboardPage> createState() => _AccessibilityDashboardPageState();
}

class _AccessibilityDashboardPageState extends ConsumerState<AccessibilityDashboardPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(accessibilityPrefsProvider.notifier).load();
      ref.read(shortcutsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: l10n.accessibilityTitle,
      showSearch: false,
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.accessibilityPreferences),
              PosTabItem(label: l10n.accessibilityShortcuts),
            ],
          ),
          Expanded(
            child: IndexedStack(index: _currentTab, children: const [AccessibilityPrefsWidget(), ShortcutsWidget()]),
          ),
        ],
      ),
    );
  }
}
