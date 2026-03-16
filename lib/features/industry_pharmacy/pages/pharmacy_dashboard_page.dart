import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_pharmacy/providers/pharmacy_providers.dart';
import 'package:thawani_pos/features/industry_pharmacy/providers/pharmacy_state.dart';

class PharmacyDashboardPage extends ConsumerStatefulWidget {
  const PharmacyDashboardPage({super.key});

  @override
  ConsumerState<PharmacyDashboardPage> createState() => _PharmacyDashboardPageState();
}

class _PharmacyDashboardPageState extends ConsumerState<PharmacyDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => ref.read(pharmacyProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Prescriptions'),
            Tab(text: 'Drug Schedules'),
          ],
        ),
      ),
      body: switch (state) {
        PharmacyInitial() || PharmacyLoading() => const Center(child: CircularProgressIndicator()),
        PharmacyError(:final message) => Center(child: Text(message)),
        PharmacyLoaded(:final prescriptions, :final drugSchedules) => TabBarView(
          controller: _tabController,
          children: [
            prescriptions.isEmpty
                ? const Center(child: Text('No prescriptions'))
                : ListView.builder(
                    itemCount: prescriptions.length,
                    itemBuilder: (context, i) {
                      final p = prescriptions[i];
                      return ListTile(
                        title: Text(p.prescriptionNumber),
                        subtitle: Text('${p.patientName} — Dr. ${p.doctorName ?? ''}'),
                        trailing: p.insuranceClaimAmount != null
                            ? Text('${p.insuranceClaimAmount?.toStringAsFixed(2)} OMR')
                            : null,
                      );
                    },
                  ),
            drugSchedules.isEmpty
                ? const Center(child: Text('No drug schedules'))
                : ListView.builder(
                    itemCount: drugSchedules.length,
                    itemBuilder: (context, i) {
                      final d = drugSchedules[i];
                      return ListTile(
                        title: Text(d.activeIngredient ?? d.productId),
                        subtitle: Text('${d.scheduleType.value} — ${d.dosageForm ?? ''} ${d.strength ?? ''}'),
                        trailing: d.requiresPrescription == true
                            ? const Icon(Icons.medical_services, color: Colors.red)
                            : const Icon(Icons.check_circle, color: Colors.green),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
