import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
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

class _CompanionDashboardPageState extends ConsumerState<CompanionDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    Future.microtask(() {
      ref.read(companionDashboardProvider.notifier).load();
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.companionTitle),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(icon: const Icon(Icons.home), text: l10n.companionDashboard),
            Tab(icon: const Icon(Icons.dashboard), text: l10n.companionQuickStats),
            Tab(icon: const Icon(Icons.summarize), text: l10n.companionSummary),
            Tab(icon: const Icon(Icons.bar_chart), text: l10n.companionSales),
            Tab(icon: const Icon(Icons.shopping_cart), text: l10n.companionActiveOrdersTitle),
            Tab(icon: const Icon(Icons.inventory_2), text: l10n.companionInventory),
            Tab(icon: const Icon(Icons.people), text: l10n.companionStaff),
            Tab(icon: const Icon(Icons.touch_app), text: l10n.companionQuickActions),
            Tab(icon: const Icon(Icons.settings), text: l10n.companionPreferences),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
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
    );
  }
}
