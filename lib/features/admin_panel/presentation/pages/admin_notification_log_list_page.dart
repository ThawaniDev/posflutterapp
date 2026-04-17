import 'package:flutter/material.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_stats_kpi_section.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AdminNotificationLogListPage extends ConsumerStatefulWidget {
  const AdminNotificationLogListPage({super.key});

  @override
  ConsumerState<AdminNotificationLogListPage> createState() => _AdminNotificationLogListPageState();
}

class _AdminNotificationLogListPageState extends ConsumerState<AdminNotificationLogListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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

    return PosListPage(
      title: l10n.notificationLogs,
      showSearch: false,
      child: Column(
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
                    border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                );
                final channelDropdown = PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'push', label: l10n.notificationsPush),
                    PosDropdownItem(value: 'email', label: l10n.email),
                    PosDropdownItem(value: 'sms', label: l10n.notifPrefSms),
                    PosDropdownItem(value: 'whatsapp', label: 'WhatsApp'),
                    PosDropdownItem(value: 'in_app', label: l10n.notificationsInApp),
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
                    PosDropdownItem(value: 'pending', label: l10n.pending),
                    PosDropdownItem(value: 'sent', label: l10n.notifLogSent),
                    PosDropdownItem(value: 'delivered', label: l10n.ordersDelivered),
                    PosDropdownItem(value: 'failed', label: l10n.deliveryFailed),
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
                return ResponsiveSearchFilterBar(searchField: searchField, filters: [channelDropdown, statusDropdown]);
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
        return PosCard(
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
