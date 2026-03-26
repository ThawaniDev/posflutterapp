import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminGatewayListPage extends ConsumerStatefulWidget {
  const AdminGatewayListPage({super.key});

  @override
  ConsumerState<AdminGatewayListPage> createState() => _AdminGatewayListPageState();
}

class _AdminGatewayListPageState extends ConsumerState<AdminGatewayListPage> {
  String _envFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(gatewayListProvider.notifier).loadGateways());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gatewayListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Gateways'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Environment filter
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                _filterChip('All', 'all'),
                const SizedBox(width: AppSpacing.xs),
                _filterChip('Production', 'production'),
                const SizedBox(width: AppSpacing.xs),
                _filterChip('Sandbox', 'sandbox'),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              GatewayListLoading() => const Center(child: CircularProgressIndicator()),
              GatewayListLoaded(gateways: final items) =>
                items.isEmpty
                    ? const Center(child: Text('No gateways configured'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final gw = items[index];
                          return _gatewayCard(gw);
                        },
                      ),
              GatewayListError(message: final msg) => Center(child: Text('Error: $msg')),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _envFilter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      onSelected: (_) {
        setState(() => _envFilter = value);
        ref.read(gatewayListProvider.notifier).loadGateways(environment: value == 'all' ? null : value);
      },
    );
  }

  Widget _gatewayCard(Map<String, dynamic> gw) {
    final isActive = gw['is_active'] == true;
    final env = gw['environment'] ?? '';
    final hasCreds = gw['has_credentials'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(gw['gateway_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: env == 'production' ? AppColors.success.withValues(alpha: 0.15) : AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    env.toUpperCase(),
                    style: TextStyle(fontSize: 11, color: env == 'production' ? AppColors.successDark : AppColors.warningDark),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(isActive ? Icons.check_circle : Icons.cancel, color: isActive ? AppColors.success : AppColors.error, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (gw['webhook_url'] != null)
              Text('Webhook: ${gw['webhook_url']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Row(
              children: [
                Icon(hasCreds ? Icons.key : Icons.key_off, size: 14, color: hasCreds ? AppColors.success : AppColors.error),
                const SizedBox(width: 4),
                Text(
                  hasCreds ? 'Credentials configured' : 'No credentials',
                  style: TextStyle(fontSize: 12, color: hasCreds ? AppColors.success : AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.wifi_tethering, size: 16),
                  label: const Text('Test'),
                  onPressed: () => _testConnection(gw['id']),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  onPressed: () => _showEditDialog(gw),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 16, color: AppColors.error),
                  label: const Text('Delete', style: TextStyle(color: AppColors.error)),
                  onPressed: () => _confirmDelete(gw['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _testConnection(int id) async {
    try {
      await ref.read(gatewayActionProvider.notifier).testConnection(id.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connection test successful')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connection test failed: $e')));
      }
    }
  }

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    final webhookCtrl = TextEditingController();
    String env = 'sandbox';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Gateway'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Gateway Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: webhookCtrl,
                decoration: const InputDecoration(labelText: 'Webhook URL'),
              ),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setInnerState) => DropdownButtonFormField<String>(
                  value: env,
                  items: ['sandbox', 'production'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setInnerState(() => env = v ?? env),
                  decoration: const InputDecoration(labelText: 'Environment'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              await ref.read(gatewayActionProvider.notifier).createGateway({
                'gateway_name': nameCtrl.text,
                'webhook_url': webhookCtrl.text,
                'environment': env,
                'credentials': {'key': 'placeholder'},
                'is_active': true,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(gatewayListProvider.notifier).loadGateways();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> gw) {
    final nameCtrl = TextEditingController(text: gw['gateway_name']);
    final webhookCtrl = TextEditingController(text: gw['webhook_url']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Gateway'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Gateway Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: webhookCtrl,
                decoration: const InputDecoration(labelText: 'Webhook URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              await ref.read(gatewayActionProvider.notifier).updateGateway(gw['id'], {
                'gateway_name': nameCtrl.text,
                'webhook_url': webhookCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(gatewayListProvider.notifier).loadGateways();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Gateway'),
        content: const Text('Are you sure you want to delete this gateway?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              await ref.read(gatewayActionProvider.notifier).deleteGateway(id.toString());
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(gatewayListProvider.notifier).loadGateways();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
