import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminSecurityAlertListPage extends ConsumerStatefulWidget {
  const AdminSecurityAlertListPage({super.key});

  @override
  ConsumerState<AdminSecurityAlertListPage> createState() => _AdminSecurityAlertListPageState();
}

class _AdminSecurityAlertListPageState extends ConsumerState<AdminSecurityAlertListPage> {
  final _searchController = TextEditingController();
  String? _severityFilter;
  String? _statusFilter;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_severityFilter != null) params['severity'] = _severityFilter;
    if (_statusFilter != null) params['status'] = _statusFilter;
    ref.read(securityAlertListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  Color _severityColor(String? severity) => switch (severity) {
    'critical' => AppColors.errorDark,
    'high' => AppColors.error,
    'medium' => AppColors.warning,
    'low' => AppColors.info,
    _ => AppColors.textSecondary,
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
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                final searchField = TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search alerts...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                );
                final severityDropdown = DropdownButton<String>(
                  value: _severityFilter,
                  hint: const Text('Severity'),
                  isExpanded: context.isPhone,
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
                );
                final statusDropdown = DropdownButton<String>(
                  value: _statusFilter,
                  hint: const Text('Status'),
                  isExpanded: context.isPhone,
                  items: const [
                    DropdownMenuItem(value: 'new', child: Text('New')),
                    DropdownMenuItem(value: 'investigating', child: Text('Investigating')),
                    DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                  ],
                  onChanged: (v) {
                    setState(() => _statusFilter = v);
                    _applyFilters();
                  },
                );
                if (context.isPhone) {
                  return Column(
                    children: [
                      searchField,
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: severityDropdown),
                          const SizedBox(width: 8),
                          Expanded(child: statusDropdown),
                        ],
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 12),
                    severityDropdown,
                    const SizedBox(width: 8),
                    statusDropdown,
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: switch (state) {
              SecurityAlertListInitial() || SecurityAlertListLoading() => const Center(child: CircularProgressIndicator()),
              SecurityAlertListLoaded(data: final data) => _buildList(data),
              SecurityAlertListError(message: final msg) => Center(
                child: Text(msg, style: const TextStyle(color: AppColors.error)),
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
              backgroundColor: status == 'resolved'
                  ? AppColors.success.withValues(alpha: 0.08)
                  : AppColors.warning.withValues(alpha: 0.08),
              side: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
