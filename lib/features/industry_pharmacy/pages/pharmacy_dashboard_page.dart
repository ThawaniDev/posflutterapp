import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_pharmacy/providers/pharmacy_providers.dart';
import 'package:wameedpos/features/industry_pharmacy/providers/pharmacy_state.dart';
import 'package:wameedpos/features/industry_pharmacy/widgets/prescription_card.dart';
import 'package:wameedpos/features/industry_pharmacy/widgets/drug_schedule_card.dart';
import 'package:wameedpos/features/industry_pharmacy/pages/prescription_form_page.dart';
import 'package:wameedpos/features/industry_pharmacy/pages/drug_schedule_form_page.dart';
import 'package:wameedpos/features/industry_pharmacy/pages/expiry_alerts_page.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class PharmacyDashboardPage extends ConsumerStatefulWidget {
  const PharmacyDashboardPage({super.key});

  @override
  ConsumerState<PharmacyDashboardPage> createState() => _PharmacyDashboardPageState();
}

class _PharmacyDashboardPageState extends ConsumerState<PharmacyDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pharmacyProvider.notifier).load());
  }

  void _onFabPressed() {
    final page = switch (_currentTab) {
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
    final isLoading = state is PharmacyInitial || state is PharmacyLoading;
    final hasError = state is PharmacyError;

    final content = PosListPage(
      title: l10n.pharmacyTitle,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(pharmacyProvider.notifier).load(),
      actions: [
        PosButton(
          label: l10n.pharmacyExpiryAlerts,
          icon: Icons.warning_amber_rounded,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PharmacyExpiryAlertsPage()));
          },
        ),
        const SizedBox(width: 8),
        PosButton(label: l10n.add, icon: Icons.add, onPressed: _onFabPressed),
      ],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.pharmacyPrescriptions),
              PosTabItem(label: l10n.pharmacyDrugSchedules),
            ],
          ),
          Expanded(
            child: state is PharmacyLoaded
                ? IndexedStack(
                    index: _currentTab,
                    children: [
                      state.prescriptions.isEmpty
                          ? PosEmptyState(title: l10n.pharmacyNoPrescriptions, icon: Icons.medical_services)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.prescriptions.length,
                              itemBuilder: (context, i) {
                                final p = state.prescriptions[i];
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
                      state.drugSchedules.isEmpty
                          ? PosEmptyState(title: l10n.pharmacyNoDrugSchedules, icon: Icons.medication)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.drugSchedules.length,
                              itemBuilder: (context, i) {
                                final d = state.drugSchedules[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: DrugScheduleCard(
                                    drug: d,
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
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
    return PermissionGuardPage(permission: Permissions.pharmacyView, child: content);
  }
}
