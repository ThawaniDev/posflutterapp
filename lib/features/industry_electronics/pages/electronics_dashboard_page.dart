import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_electronics/providers/electronics_providers.dart';
import 'package:thawani_pos/features/industry_electronics/providers/electronics_state.dart';

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
    Future.microtask(() => ref.read(electronicsProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: switch (state) {
        ElectronicsInitial() || ElectronicsLoading() => const Center(child: CircularProgressIndicator()),
        ElectronicsError(:final message) => Center(child: Text(message)),
        ElectronicsLoaded(:final imeiRecords, :final repairJobs, :final tradeIns) => TabBarView(
          controller: _tabController,
          children: [
            imeiRecords.isEmpty
                ? const Center(child: Text('No IMEI records'))
                : ListView.builder(
                    itemCount: imeiRecords.length,
                    itemBuilder: (context, i) {
                      final r = imeiRecords[i];
                      return ListTile(
                        title: Text(r.imei),
                        subtitle: Text('S/N: ${r.serialNumber ?? 'N/A'} • ${r.status?.value ?? 'unknown'}'),
                        trailing: r.conditionGrade != null ? Text('Grade ${r.conditionGrade!.value}') : null,
                      );
                    },
                  ),
            repairJobs.isEmpty
                ? const Center(child: Text('No repair jobs'))
                : ListView.builder(
                    itemCount: repairJobs.length,
                    itemBuilder: (context, i) {
                      final j = repairJobs[i];
                      return ListTile(
                        title: Text(j.deviceDescription),
                        subtitle: Text(j.issueDescription),
                        trailing: Chip(label: Text(j.status?.value ?? 'received')),
                      );
                    },
                  ),
            tradeIns.isEmpty
                ? const Center(child: Text('No trade-in records'))
                : ListView.builder(
                    itemCount: tradeIns.length,
                    itemBuilder: (context, i) {
                      final t = tradeIns[i];
                      return ListTile(
                        title: Text(t.deviceDescription),
                        subtitle: Text('Grade ${t.conditionGrade} • IMEI: ${t.imei ?? 'N/A'}'),
                        trailing: Text('${t.assessedValue.toStringAsFixed(2)} OMR'),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
