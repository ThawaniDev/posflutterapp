import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';

class AdminSecurityAlertsPage extends ConsumerStatefulWidget {
  const AdminSecurityAlertsPage({super.key});

  @override
  ConsumerState<AdminSecurityAlertsPage> createState() => _AdminSecurityAlertsPageState();
}

class _AdminSecurityAlertsPageState extends ConsumerState<AdminSecurityAlertsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(secCenterAlertListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(secCenterAlertListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Security Alerts'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: switch (state) {
        SecCenterAlertListLoading() => const Center(child: CircularProgressIndicator()),
        SecCenterAlertListError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(msg, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: () => ref.read(secCenterAlertListProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        SecCenterAlertListLoaded(data: final data) => _buildList(data),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No security alerts'));
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(secCenterAlertListProvider.notifier).load(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;
          final severity = item['severity']?.toString() ?? '';
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              leading: Icon(
                Icons.warning_amber_rounded,
                color: severity == 'critical'
                    ? AppColors.error
                    : severity == 'high'
                    ? AppColors.warning
                    : AppColors.warning,
              ),
              title: Text(item['alert_type']?.toString() ?? 'Alert'),
              subtitle: Text('Severity: $severity\nStatus: ${item['status'] ?? 'unknown'}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
