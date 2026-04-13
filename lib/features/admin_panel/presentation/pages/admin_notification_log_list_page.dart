import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_stats_kpi_section.dart';

class AdminNotificationLogListPage extends ConsumerStatefulWidget {
  const AdminNotificationLogListPage({super.key});

  @override
  ConsumerState<AdminNotificationLogListPage> createState() => _AdminNotificationLogListPageState();
}

class _AdminNotificationLogListPageState extends ConsumerState<AdminNotificationLogListPage> {
  final _searchController = TextEditingController();
  String? _channelFilter;
  String? _statusFilter;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilters();
      ref.read(logStatsProvider.notifier).load();
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
    if (_channelFilter != null) params['channel'] = _channelFilter;
    if (_statusFilter != null) params['status'] = _statusFilter;
    ref.read(notificationLogListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  Color _channelColor(String? channel) => switch (channel) {
    'push' => AppColors.info,
    'email' => AppColors.info,
    'sms' => AppColors.purple,
    'whatsapp' => AppColors.success,
    'in_app' => AppColors.primary,
    _ => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationLogListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Logs')),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          AdminStatsKpiSection(
            provider: logStatsProvider,
            cardBuilder: (data) {
              final n = data['notifications'] as Map<String, dynamic>? ?? {};
              return [
                kpi('Total Sent', n['total'] ?? 0, AppColors.primary),
                kpi('Today', n['today'] ?? 0, AppColors.info),
                kpi('Failed', n['failed'] ?? 0, AppColors.error),
                kpi('Channels', (n['channel_breakdown'] as Map?)?.length ?? 0, AppColors.success),
              ];
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                final searchField = TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notification logs...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                );
                final channelDropdown = PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'push', label: 'Push'),
                    PosDropdownItem(value: 'email', label: 'Email'),
                    PosDropdownItem(value: 'sms', label: 'SMS'),
                    PosDropdownItem(value: 'whatsapp', label: 'WhatsApp'),
                    PosDropdownItem(value: 'in_app', label: 'In-App'),
                  ],
                  selectedValue: _channelFilter,
                  onChanged: (v) {
                    setState(() => _channelFilter = v);
                    _applyFilters();
                  },
                  hint: 'Channel',
                  showSearch: false,
                  clearable: true,
                );
                final statusDropdown = PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'pending', label: 'Pending'),
                    PosDropdownItem(value: 'sent', label: 'Sent'),
                    PosDropdownItem(value: 'delivered', label: 'Delivered'),
                    PosDropdownItem(value: 'failed', label: 'Failed'),
                  ],
                  selectedValue: _statusFilter,
                  onChanged: (v) {
                    setState(() => _statusFilter = v);
                    _applyFilters();
                  },
                  hint: 'Status',
                  showSearch: false,
                  clearable: true,
                );
                if (context.isPhone) {
                  return Column(
                    children: [
                      searchField,
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: channelDropdown),
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
                    channelDropdown,
                    const SizedBox(width: 8),
                    statusDropdown,
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: switch (state) {
              NotificationLogListInitial() || NotificationLogListLoading() => const Center(child: CircularProgressIndicator()),
              NotificationLogListLoaded(data: final data) => _buildList(data),
              NotificationLogListError(message: final msg) => Center(
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
      return const Center(child: Text('No notification logs found'));
    }
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final log = items[index] as Map<String, dynamic>;
        final channel = log['channel']?.toString();
        final status = log['status']?.toString() ?? 'pending';
        final isFailed = status == 'failed';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _channelColor(channel).withValues(alpha: 0.15),
              child: Icon(Icons.notifications_outlined, color: _channelColor(channel)),
            ),
            title: Text(
              '${channel?.replaceAll('_', ' ').toUpperCase() ?? 'UNKNOWN'} • $status',
              style: TextStyle(fontWeight: FontWeight.w600, color: isFailed ? AppColors.error : null),
            ),
            subtitle: isFailed
                ? Text(log['error_message']?.toString() ?? '', style: const TextStyle(color: AppColors.error))
                : Text('Sent: ${log['sent_at'] ?? 'N/A'}'),
          ),
        );
      },
    );
  }
}
