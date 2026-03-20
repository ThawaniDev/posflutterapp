import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/industry_electronics/providers/electronics_providers.dart';
import 'package:thawani_pos/features/industry_electronics/providers/electronics_state.dart';
import 'package:thawani_pos/features/industry_electronics/widgets/imei_record_card.dart';
import 'package:thawani_pos/features/industry_electronics/widgets/repair_job_card.dart';
import 'package:thawani_pos/features/industry_electronics/widgets/trade_in_card.dart';
import 'package:thawani_pos/features/industry_electronics/pages/imei_record_form_page.dart';
import 'package:thawani_pos/features/industry_electronics/pages/repair_job_form_page.dart';
import 'package:thawani_pos/features/industry_electronics/pages/trade_in_form_page.dart';

class ElectronicsDashboardPage extends ConsumerStatefulWidget {
  const ElectronicsDashboardPage({super.key});

  @override
  ConsumerState<ElectronicsDashboardPage> createState() => _ElectronicsDashboardPageState();
}

class _ElectronicsDashboardPageState extends ConsumerState<ElectronicsDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    Future.microtask(() => ref.read(electronicsProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    final page = switch (_tabController.index) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electronics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'IMEI Records'),
            Tab(text: 'Repair Jobs'),
            Tab(text: 'Trade-Ins'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onFabPressed, child: const Icon(Icons.add)),
      body: switch (state) {
        ElectronicsInitial() || ElectronicsLoading() => const PosLoadingSkeleton(),
        ElectronicsError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(electronicsProvider.notifier).load(),
        ),
        ElectronicsLoaded(:final imeiRecords, :final repairJobs, :final tradeIns) => TabBarView(
          controller: _tabController,
          children: [
            imeiRecords.isEmpty
                ? const PosEmptyState(message: 'No IMEI records', icon: Icons.phone_android)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: imeiRecords.length,
                    itemBuilder: (context, i) {
                      final r = imeiRecords[i];
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
            repairJobs.isEmpty
                ? const PosEmptyState(message: 'No repair jobs', icon: Icons.build)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: repairJobs.length,
                    itemBuilder: (context, i) {
                      final j = repairJobs[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RepairJobCard(
                          job: j,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => RepairJobFormPage(job: j)))
                                .then((_) => ref.read(electronicsProvider.notifier).load());
                          },
                          onStatusChange: (status) {
                            ref.read(electronicsProvider.notifier).updateRepairJobStatus(j.id, status);
                          },
                        ),
                      );
                    },
                  ),
            tradeIns.isEmpty
                ? const PosEmptyState(message: 'No trade-in records', icon: Icons.swap_horiz)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: tradeIns.length,
                    itemBuilder: (context, i) {
                      final t = tradeIns[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TradeInCard(record: t),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
