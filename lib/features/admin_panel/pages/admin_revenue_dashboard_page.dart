import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminRevenueDashboardPage extends ConsumerStatefulWidget {
  const AdminRevenueDashboardPage({super.key});

  @override
  ConsumerState<AdminRevenueDashboardPage> createState() => _AdminRevenueDashboardPageState();
}

class _AdminRevenueDashboardPageState extends ConsumerState<AdminRevenueDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(revenueDashboardProvider.notifier).loadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(revenueDashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Revenue Dashboard')),
      body: switch (state) {
        RevenueDashboardLoading() => const Center(child: CircularProgressIndicator()),
        RevenueDashboardError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: AppColors.error)),
              AppSpacing.verticalGap16,
              PosButton(
                label: 'Retry',
                variant: PosButtonVariant.outline,
                onPressed: () => ref.read(revenueDashboardProvider.notifier).loadDashboard(),
              ),
            ],
          ),
        ),
        RevenueDashboardLoaded(:final subscriptions, :final revenue) => SingleChildScrollView(
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Subscriptions Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              AppSpacing.verticalGap16,
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.8,
                children: [
                  _StatCard(
                    label: 'Active',
                    value: '${subscriptions['active'] ?? 0}',
                    color: AppColors.success,
                    icon: Icons.check_circle,
                  ),
                  _StatCard(
                    label: 'Trial',
                    value: '${subscriptions['trial'] ?? 0}',
                    color: AppColors.warning,
                    icon: Icons.hourglass_empty,
                  ),
                  _StatCard(
                    label: 'Grace',
                    value: '${subscriptions['grace'] ?? 0}',
                    color: Colors.orange,
                    icon: Icons.warning_amber,
                  ),
                  _StatCard(
                    label: 'Cancelled',
                    value: '${subscriptions['cancelled'] ?? 0}',
                    color: AppColors.error,
                    icon: Icons.cancel,
                  ),
                ],
              ),
              AppSpacing.verticalGap24,
              const Text('Revenue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              AppSpacing.verticalGap16,
              Card(
                child: Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Monthly Revenue', style: TextStyle(fontSize: 16)),
                          Text(
                            '\$${revenue['monthly'] ?? 0}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pending Invoices', style: TextStyle(fontSize: 16)),
                          Text(
                            '${revenue['pending_invoices'] ?? 0}',
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                AppSpacing.horizontalGap8,
                Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
            AppSpacing.verticalGap4,
            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
