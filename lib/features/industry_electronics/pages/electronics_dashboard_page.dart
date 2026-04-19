import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_electronics/providers/electronics_providers.dart';
import 'package:wameedpos/features/industry_electronics/providers/electronics_state.dart';
import 'package:wameedpos/features/industry_electronics/widgets/imei_record_card.dart';
import 'package:wameedpos/features/industry_electronics/widgets/repair_job_card.dart';
import 'package:wameedpos/features/industry_electronics/widgets/trade_in_card.dart';
import 'package:wameedpos/features/industry_electronics/pages/imei_record_form_page.dart';
import 'package:wameedpos/features/industry_electronics/pages/repair_job_form_page.dart';
import 'package:wameedpos/features/industry_electronics/pages/trade_in_form_page.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ElectronicsDashboardPage extends ConsumerStatefulWidget {
  const ElectronicsDashboardPage({super.key});

  @override
  ConsumerState<ElectronicsDashboardPage> createState() => _ElectronicsDashboardPageState();
}

class _ElectronicsDashboardPageState extends ConsumerState<ElectronicsDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(electronicsProvider.notifier).load());
  }

  void _onFabPressed() {
    final page = switch (_currentTab) {
      0 => const ImeiRecordFormPage(),
      1 => const RepairJobFormPage(),
      _ => const TradeInFormPage(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      ref.read(electronicsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(electronicsProvider);
    final isLoading = state is ElectronicsInitial || state is ElectronicsLoading;
    final hasError = state is ElectronicsError;

    return PosListPage(
      title: l10n.electronicsTitle,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(electronicsProvider.notifier).load(),
      actions: [PosButton(label: l10n.add, icon: Icons.add, onPressed: _onFabPressed)],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.electronicsImeiRecords),
              PosTabItem(label: l10n.electronicsRepairJobs),
              PosTabItem(label: l10n.electronicsTradeIns),
            ],
          ),
          Expanded(
            child: state is ElectronicsLoaded
                ? IndexedStack(
                    index: _currentTab,
                    children: [
                      state.imeiRecords.isEmpty
                          ? PosEmptyState(title: l10n.electronicsNoImei, icon: Icons.phone_android)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.imeiRecords.length,
                              itemBuilder: (context, i) {
                                final r = state.imeiRecords[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ImeiRecordCard(
                                    record: r,
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (_) => ImeiRecordFormPage(record: r)))
                                          .then((_) => ref.read(electronicsProvider.notifier).load());
                                    },
                                  ),
                                );
                              },
                            ),
                      state.repairJobs.isEmpty
                          ? PosEmptyState(title: l10n.electronicsNoRepair, icon: Icons.build)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.repairJobs.length,
                              itemBuilder: (context, i) {
                                final j = state.repairJobs[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: RepairJobCard(
                                    job: j,
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (_) => RepairJobFormPage(job: j)))
                                          .then((_) => ref.read(electronicsProvider.notifier).load());
                                    },
                                  ),
                                );
                              },
                            ),
                      state.tradeIns.isEmpty
                          ? PosEmptyState(title: l10n.electronicsNoTradeIn, icon: Icons.swap_horiz)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.tradeIns.length,
                              itemBuilder: (context, i) {
                                final t = state.tradeIns[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: TradeInCard(record: t),
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
