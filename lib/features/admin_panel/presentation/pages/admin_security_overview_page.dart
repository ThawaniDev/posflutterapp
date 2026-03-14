import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';

class AdminSecurityOverviewPage extends ConsumerStatefulWidget {
  const AdminSecurityOverviewPage({super.key});

  @override
  ConsumerState<AdminSecurityOverviewPage> createState() => _AdminSecurityOverviewPageState();
}

class _AdminSecurityOverviewPageState extends ConsumerState<AdminSecurityOverviewPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(securityOverviewProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Security Center'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: switch (state) {
        SecurityOverviewLoading() => const Center(child: CircularProgressIndicator()),
        SecurityOverviewError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: AppSpacing.md),
              Text(msg, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: () => ref.read(securityOverviewProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        SecurityOverviewLoaded(data: final data) => _buildOverview(data),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildOverview(Map<String, dynamic> data) {
    final overview = data['data'] as Map<String, dynamic>? ?? data;
    return RefreshIndicator(
      onRefresh: () => ref.read(securityOverviewProvider.notifier).load(),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionCard(
            title: 'Security Alerts',
            icon: Icons.warning_amber_rounded,
            color: Colors.red,
            stats: overview['security_alerts'] as Map<String, dynamic>? ?? {},
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Active Sessions',
            icon: Icons.devices,
            color: Colors.blue,
            stats: overview['sessions'] as Map<String, dynamic>? ?? {},
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Devices',
            icon: Icons.phone_android,
            color: Colors.green,
            stats: overview['devices'] as Map<String, dynamic>? ?? {},
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Login Attempts',
            icon: Icons.login,
            color: Colors.orange,
            stats: overview['login_attempts'] as Map<String, dynamic>? ?? {},
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'IP Management',
            icon: Icons.shield,
            color: Colors.purple,
            stats: overview['ip_management'] as Map<String, dynamic>? ?? {},
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Map<String, dynamic> stats;

  const _SectionCard({required this.title, required this.icon, required this.color, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...stats.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key.replaceAll('_', ' ').toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
                    Text('${e.value}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
