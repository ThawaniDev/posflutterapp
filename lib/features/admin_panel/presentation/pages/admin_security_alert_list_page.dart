import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_state.dart';

class AdminSecurityAlertListPage extends ConsumerStatefulWidget {
  const AdminSecurityAlertListPage({super.key});

  @override
  ConsumerState<AdminSecurityAlertListPage> createState() => _AdminSecurityAlertListPageState();
}

class _AdminSecurityAlertListPageState extends ConsumerState<AdminSecurityAlertListPage> {
  final _searchController = TextEditingController();
  String? _severityFilter;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(securityAlertListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_severityFilter != null) params['severity'] = _severityFilter;
    if (_statusFilter != null) params['status'] = _statusFilter;
    ref.read(securityAlertListProvider.notifier).load(params: params);
  }

  Color _severityColor(String? severity) => switch (severity) {
    'critical' => Colors.red.shade800,
    'high' => Colors.red,
    'medium' => Colors.orange,
    'low' => Colors.blue,
    _ => Colors.grey,
  };

  IconData _severityIcon(String? severity) => switch (severity) {
    'critical' => Icons.error,
    'high' => Icons.warning_amber,
    'medium' => Icons.info_outline,
    'low' => Icons.shield_outlined,
    _ => Icons.help_outline,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityAlertListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Security Alerts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search alerts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _severityFilter,
                  hint: const Text('Severity'),
                  items: const [
                    DropdownMenuItem(value: 'critical', child: Text('Critical')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                  ],
                  onChanged: (v) {
                    setState(() => _severityFilter = v);
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _statusFilter,
                  hint: const Text('Status'),
                  items: const [
                    DropdownMenuItem(value: 'new', child: Text('New')),
                    DropdownMenuItem(value: 'investigating', child: Text('Investigating')),
                    DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                  ],
                  onChanged: (v) {
                    setState(() => _statusFilter = v);
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              SecurityAlertListInitial() || SecurityAlertListLoading() => const Center(child: CircularProgressIndicator()),
              SecurityAlertListLoaded(data: final data) => _buildList(data),
              SecurityAlertListError(message: final msg) => Center(
                child: Text(msg, style: const TextStyle(color: Colors.red)),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data']?['data'] as List?) ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No security alerts found'));
    }
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final alert = items[index] as Map<String, dynamic>;
        final severity = alert['severity']?.toString();
        final status = alert['status']?.toString() ?? 'new';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _severityColor(severity).withValues(alpha: 0.15),
              child: Icon(_severityIcon(severity), color: _severityColor(severity)),
            ),
            title: Text(
              alert['alert_type']?.toString().replaceAll('_', ' ').toUpperCase() ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(alert['description']?.toString() ?? ''),
            trailing: Chip(
              label: Text(status, style: const TextStyle(fontSize: 11)),
              backgroundColor: status == 'resolved' ? Colors.green.shade50 : Colors.orange.shade50,
              side: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
