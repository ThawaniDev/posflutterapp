import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminRevenueDashboardPage extends ConsumerStatefulWidget {
  const AdminRevenueDashboardPage({super.key});

  @override
  ConsumerState<AdminRevenueDashboardPage> createState() => _AdminRevenueDashboardPageState();
}

class _AdminRevenueDashboardPageState extends ConsumerState<AdminRevenueDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadDashboard();
    });
  }

  void _loadDashboard() {
    ref.read(revenueDashboardProvider.notifier).loadDashboard(storeId: _storeId);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(revenueDashboardProvider);
    final isLoading = state is RevenueDashboardLoading;
    final hasError = state is RevenueDashboardError;

    return PosListPage(
      title: l10n.revenueDashboard,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => _loadDashboard(),
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              final RevenueDashboardLoaded loaded => SingleChildScrollView(
                padding: AppSpacing.paddingAll16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Subscriptions Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    AppSpacing.gapH16,
                    PosKpiGrid(
                      desktopCols: 4,
                      mobileCols: 2,
                      cards: [
                        PosKpiCard(
                          label: l10n.active,
                          value: '${loaded.paidInvoices}',
                          iconColor: AppColors.success,
                          icon: Icons.check_circle,
                        ),
                        PosKpiCard(
                          label: l10n.adminUpcomingRenewals,
                          value: '${loaded.upcomingRenewals}',
                          iconColor: AppColors.warning,
                          icon: Icons.hourglass_empty,
                        ),
                        PosKpiCard(
                          label: l10n.deliveryFailed,
                          value: '${loaded.failedInvoices}',
                          iconColor: AppColors.warning,
                          icon: Icons.warning_amber,
                        ),
                        PosKpiCard(
                          label: l10n.posTotal,
                          value: '${loaded.totalInvoices}',
                          iconColor: AppColors.error,
                          icon: Icons.receipt_long,
                        ),
                      ],
                    ),
                    AppSpacing.gapH24,
                    Text(l10n.reportsRevenue, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    AppSpacing.gapH16,
                    PosCard(
                      child: Padding(
                        padding: AppSpacing.paddingAll16,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Monthly Revenue (MRR)', style: TextStyle(fontSize: 16)),
                                Text(
                                  '\u0081${loaded.mrr.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Annual Revenue (ARR)', style: TextStyle(fontSize: 16)),
                                Text(
                                  '\u0081${loaded.arr.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}
