import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_florist/providers/florist_providers.dart';
import 'package:wameedpos/features/industry_florist/providers/florist_state.dart';
import 'package:wameedpos/features/industry_florist/widgets/arrangement_card.dart';
import 'package:wameedpos/features/industry_florist/widgets/freshness_log_card.dart';
import 'package:wameedpos/features/industry_florist/widgets/flower_subscription_card.dart';
import 'package:wameedpos/features/industry_florist/pages/arrangement_form_page.dart';
import 'package:wameedpos/features/industry_florist/pages/freshness_log_form_page.dart';
import 'package:wameedpos/features/industry_florist/pages/subscription_form_page.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class FloristDashboardPage extends ConsumerStatefulWidget {
  const FloristDashboardPage({super.key});

  @override
  ConsumerState<FloristDashboardPage> createState() => _FloristDashboardPageState();
}

class _FloristDashboardPageState extends ConsumerState<FloristDashboardPage> with SingleTickerProviderStateMixin {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    Future.microtask(() => ref.read(floristProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    final page = switch (_tabController.index) {
      0 => const ArrangementFormPage(),
      1 => const FreshnessLogFormPage(),
      _ => const SubscriptionFormPage(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      ref.read(floristProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(floristProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.floristTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.floristArrangements),
            Tab(text: 'Freshness'),
            Tab(text: l10n.subscriptions),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onFabPressed, child: const Icon(Icons.add)),
      body: switch (state) {
        FloristInitial() || FloristLoading() => PosLoadingSkeleton.list(),
        FloristError(:final message) => PosErrorState(message: message, onRetry: () => ref.read(floristProvider.notifier).load()),
        FloristLoaded(:final arrangements, :final freshnessLogs, :final subscriptions) => TabBarView(
          controller: _tabController,
          children: [
            arrangements.isEmpty
                ? const PosEmptyState(title: 'No arrangements', icon: Icons.local_florist)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: arrangements.length,
                    itemBuilder: (context, i) {
                      final a = arrangements[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ArrangementCard(
                          arrangement: a,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => ArrangementFormPage(arrangement: a)))
                                .then((_) => ref.read(floristProvider.notifier).load());
                          },
                        ),
                      );
                    },
                  ),
            freshnessLogs.isEmpty
                ? const PosEmptyState(title: 'No freshness logs', icon: Icons.eco)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: freshnessLogs.length,
                    itemBuilder: (context, i) {
                      final l = freshnessLogs[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FreshnessLogCard(
                          log: l,
                          onTap: () {
                            // View freshness log details
                          },
                        ),
                      );
                    },
                  ),
            subscriptions.isEmpty
                ? const PosEmptyState(title: 'No subscriptions', icon: Icons.repeat)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: subscriptions.length,
                    itemBuilder: (context, i) {
                      final s = subscriptions[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FlowerSubscriptionCard(
                          subscription: s,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => SubscriptionFormPage(subscription: s)))
                                .then((_) => ref.read(floristProvider.notifier).load());
                          },
                          onToggle: () {
                            ref.read(floristProvider.notifier).toggleSubscription(s.id);
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
