import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminRevenueDashboardPage extends ConsumerStatefulWidget {
  const AdminRevenueDashboardPage({super.key});

  @override
  ConsumerState<AdminRevenueDashboardPage> createState() => _AdminRevenueDashboardPageState();
}

class _AdminRevenueDashboardPageState extends ConsumerState<AdminRevenueDashboardPage> {
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
    final state = ref.watch(revenueDashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Revenue Dashboard')),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              RevenueDashboardLoading() => const Center(child: CircularProgressIndicator()),
              RevenueDashboardError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, style: const TextStyle(color: AppColors.error)),
                    AppSpacing.gapH16,
                    PosButton(label: 'Retry', variant: PosButtonVariant.outline, onPressed: () => _loadDashboard()),
                  ],
                ),
              ),
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
                          label: 'Active',
                          value: '${loaded.paidInvoices}',
                          iconColor: AppColors.success,
                          icon: Icons.check_circle,
                        ),
                        PosKpiCard(
                          label: 'Upcoming Renewals',
                          value: '${loaded.upcomingRenewals}',
                          iconColor: AppColors.warning,
                          icon: Icons.hourglass_empty,
                        ),
                        PosKpiCard(
                          label: 'Failed',
                          value: '${loaded.failedInvoices}',
                          iconColor: AppColors.warning,
                          icon: Icons.warning_amber,
                        ),
                        PosKpiCard(
                          label: 'Total',
                          value: '${loaded.totalInvoices}',
                          iconColor: AppColors.error,
                          icon: Icons.receipt_long,
                        ),
                      ],
                    ),
                    AppSpacing.gapH24,
                    const Text('Revenue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    AppSpacing.gapH16,
                    Card(
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
