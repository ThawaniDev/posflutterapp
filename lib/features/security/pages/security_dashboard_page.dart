import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/security/providers/security_providers.dart';
import 'package:thawani_pos/features/security/providers/security_state.dart';
import 'package:thawani_pos/features/security/widgets/audit_log_list_widget.dart';
import 'package:thawani_pos/features/security/widgets/device_list_widget.dart';
import 'package:thawani_pos/features/security/widgets/security_policy_editor.dart';

class SecurityDashboardPage extends ConsumerStatefulWidget {
  const SecurityDashboardPage({super.key});

  @override
  ConsumerState<SecurityDashboardPage> createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends ConsumerState<SecurityDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Replace with actual store ID from auth/session
  final _storeId = 'current-store-id';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() {
      ref.read(securityPolicyProvider.notifier).loadPolicy(_storeId);
      ref.read(auditLogListProvider.notifier).loadLogs(_storeId);
      ref.read(deviceListProvider.notifier).loadDevices(_storeId);
      ref.read(loginAttemptsProvider.notifier).loadAttempts(_storeId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Policy'),
            Tab(text: 'Audit Logs'),
            Tab(text: 'Devices'),
            Tab(text: 'Logins'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPolicyTab(), _buildAuditTab(), _buildDevicesTab(), _buildLoginsTab()],
      ),
    );
  }

  Widget _buildPolicyTab() {
    final state = ref.watch(securityPolicyProvider);
    return switch (state) {
      SecurityPolicyInitial() || SecurityPolicyLoading() => const Center(child: CircularProgressIndicator()),
      SecurityPolicyLoaded(policy: final p) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: SecurityPolicyEditor(policy: p),
      ),
      SecurityPolicyError(message: final m) => Center(child: Text('Error: $m')),
    };
  }

  Widget _buildAuditTab() {
    final state = ref.watch(auditLogListProvider);
    return switch (state) {
      AuditLogListInitial() || AuditLogListLoading() => const Center(child: CircularProgressIndicator()),
      AuditLogListLoaded(logs: final logs) => AuditLogListWidget(logs: logs),
      AuditLogListError(message: final m) => Center(child: Text('Error: $m')),
    };
  }

  Widget _buildDevicesTab() {
    final state = ref.watch(deviceListProvider);
    return switch (state) {
      DeviceListInitial() || DeviceListLoading() => const Center(child: CircularProgressIndicator()),
      DeviceListLoaded(devices: final devices) => DeviceListWidget(devices: devices, onDeactivate: (_) {}, onRemoteWipe: (_) {}),
      DeviceListError(message: final m) => Center(child: Text('Error: $m')),
    };
  }

  Widget _buildLoginsTab() {
    final state = ref.watch(loginAttemptsProvider);
    return switch (state) {
      LoginAttemptsInitial() || LoginAttemptsLoading() => const Center(child: CircularProgressIndicator()),
      LoginAttemptsLoaded(attempts: final attempts) => _buildLoginList(attempts),
      LoginAttemptsError(message: final m) => Center(child: Text('Error: $m')),
    };
  }

  Widget _buildLoginList(List attempts) {
    if (attempts.isEmpty) {
      return const Center(child: Text('No login attempts.'));
    }
    return ListView.builder(
      itemCount: attempts.length,
      itemBuilder: (context, index) {
        final a = attempts[index];
        final color = a.isSuccessful ? AppColors.success : AppColors.error;
        return ListTile(
          leading: Icon(a.isSuccessful ? Icons.check_circle : Icons.cancel, color: color),
          title: Text(a.userIdentifier),
          subtitle: Text('${a.attemptType.value} • ${a.ipAddress ?? 'N/A'}'),
          trailing: Text(
            a.isSuccessful ? 'Success' : 'Failed',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}
