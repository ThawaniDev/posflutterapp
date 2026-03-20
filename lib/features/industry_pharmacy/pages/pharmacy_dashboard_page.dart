import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/industry_pharmacy/providers/pharmacy_providers.dart';
import 'package:thawani_pos/features/industry_pharmacy/providers/pharmacy_state.dart';
import 'package:thawani_pos/features/industry_pharmacy/widgets/prescription_card.dart';
import 'package:thawani_pos/features/industry_pharmacy/widgets/drug_schedule_card.dart';
import 'package:thawani_pos/features/industry_pharmacy/pages/prescription_form_page.dart';
import 'package:thawani_pos/features/industry_pharmacy/pages/drug_schedule_form_page.dart';

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
    _tabController.addListener(() => setState(() {}));
    Future.microtask(() => ref.read(pharmacyProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    final page = switch (_tabController.index) {
      0 => const PrescriptionFormPage(),
      _ => const DrugScheduleFormPage(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      ref.read(pharmacyProvider.notifier).load();
    });
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
      floatingActionButton: FloatingActionButton(onPressed: _onFabPressed, child: const Icon(Icons.add)),
      body: switch (state) {
        PharmacyInitial() || PharmacyLoading() => const PosLoadingSkeleton(),
        PharmacyError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(pharmacyProvider.notifier).load(),
        ),
        PharmacyLoaded(:final prescriptions, :final drugSchedules) => TabBarView(
          controller: _tabController,
          children: [
            prescriptions.isEmpty
                ? const PosEmptyState(message: 'No prescriptions', icon: Icons.medical_services)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: prescriptions.length,
                    itemBuilder: (context, i) {
                      final p = prescriptions[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PrescriptionCard(
                          prescription: p,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => PrescriptionFormPage(prescription: p)))
                                .then((_) => ref.read(pharmacyProvider.notifier).load());
                          },
                        ),
                      );
                    },
                  ),
            drugSchedules.isEmpty
                ? const PosEmptyState(message: 'No drug schedules', icon: Icons.medication)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: drugSchedules.length,
                    itemBuilder: (context, i) {
                      final d = drugSchedules[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: DrugScheduleCard(
                          schedule: d,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => DrugScheduleFormPage(schedule: d)))
                                .then((_) => ref.read(pharmacyProvider.notifier).load());
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
