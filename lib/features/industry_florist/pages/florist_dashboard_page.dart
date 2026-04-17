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

class _FloristDashboardPageState extends ConsumerState<FloristDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(floristProvider.notifier).load());
  }

  void _onFabPressed() {
    final page = switch (_currentTab) {
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
    final isLoading = state is FloristInitial || state is FloristLoading;
    final hasError = state is FloristError;

    return PosListPage(
      title: l10n.floristTitle,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(floristProvider.notifier).load(),
      actions: [PosButton(label: l10n.add, icon: Icons.add, onPressed: _onFabPressed)],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.floristArrangements),
              PosTabItem(label: 'Freshness'),
              PosTabItem(label: l10n.subscriptions),
            ],
          ),
          Expanded(
            child: state is FloristLoaded
                ? IndexedStack(
                    index: _currentTab,
                    children: [
                      state.arrangements.isEmpty
                          ? const PosEmptyState(title: 'No arrangements', icon: Icons.local_florist)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.arrangements.length,
                              itemBuilder: (context, i) {
                                final a = state.arrangements[i];
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
                      state.freshnessLogs.isEmpty
                          ? const PosEmptyState(title: 'No freshness logs', icon: Icons.eco)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.freshnessLogs.length,
                              itemBuilder: (context, i) {
                                final l = state.freshnessLogs[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: FreshnessLogCard(log: l, onTap: () {}),
                                );
                              },
                            ),
                      state.subscriptions.isEmpty
                          ? const PosEmptyState(title: 'No subscriptions', icon: Icons.repeat)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.subscriptions.length,
                              itemBuilder: (context, i) {
                                final s = state.subscriptions[i];
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
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
