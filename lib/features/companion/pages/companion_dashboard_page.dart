import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';
import 'package:wameedpos/features/companion/widgets/companion_home_dashboard.dart';
import 'package:wameedpos/features/companion/widgets/quick_stats_widget.dart';
import 'package:wameedpos/features/companion/widgets/quick_actions_widget.dart';
import 'package:wameedpos/features/companion/widgets/preferences_widget.dart';
import 'package:wameedpos/features/companion/widgets/mobile_summary_widget.dart';
import 'package:wameedpos/features/companion/widgets/sales_summary_widget.dart';
import 'package:wameedpos/features/companion/widgets/active_orders_widget.dart';
import 'package:wameedpos/features/companion/widgets/inventory_alerts_widget.dart';
import 'package:wameedpos/features/companion/widgets/active_staff_widget.dart';

class CompanionDashboardPage extends ConsumerStatefulWidget {
  const CompanionDashboardPage({super.key});

  @override
  ConsumerState<CompanionDashboardPage> createState() => _CompanionDashboardPageState();
}

class _CompanionDashboardPageState extends ConsumerState<CompanionDashboardPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(companionDashboardProvider.notifier).load();
      ref.read(quickStatsProvider.notifier).load();
      ref.read(quickActionsProvider.notifier).load();
      ref.read(preferencesProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: l10n.companionTitle,
      showSearch: false,
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.companionDashboard, icon: Icons.home),
              PosTabItem(label: l10n.companionQuickStats, icon: Icons.dashboard),
              PosTabItem(label: l10n.companionSummary, icon: Icons.summarize),
              PosTabItem(label: l10n.companionSales, icon: Icons.bar_chart),
              PosTabItem(label: l10n.companionActiveOrdersTitle, icon: Icons.shopping_cart),
              PosTabItem(label: l10n.companionInventory, icon: Icons.inventory_2),
              PosTabItem(label: l10n.companionStaff, icon: Icons.people),
              PosTabItem(label: l10n.companionQuickActions, icon: Icons.touch_app),
              PosTabItem(label: l10n.companionPreferences, icon: Icons.settings),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: const [
                CompanionHomeDashboard(),
                QuickStatsWidget(),
                MobileSummaryWidget(),
                SalesSummaryWidget(),
                ActiveOrdersWidget(),
                InventoryAlertsWidget(),
                ActiveStaffWidget(),
                QuickActionsWidget(),
                PreferencesWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
