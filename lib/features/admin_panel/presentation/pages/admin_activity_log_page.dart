import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Read-only admin activity log page (platform-level activity log, not security audit log).
class AdminActivityLogPage extends ConsumerStatefulWidget {
  const AdminActivityLogPage({super.key});

  @override
  ConsumerState<AdminActivityLogPage> createState() => _AdminActivityLogPageState();
}

class _AdminActivityLogPageState extends ConsumerState<AdminActivityLogPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  String _searchQuery = '';
  String? _actionFilter;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  void _loadData() {
    final params = <String, dynamic>{
      'page': _currentPage,
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
      if (_actionFilter != null) 'action': _actionFilter!,
    };
    ref.read(securityActivityLogListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityActivityLogListProvider);

    return PosListPage(
      title: l10n.adminActivityLogs,
      showSearch: true,
      onSearchChanged: (q) {
        _searchQuery = q;
        _currentPage = 1;
        _loadData();
      },
      child: switch (state) {
        SecurityActivityLogListLoading() => const PosLoading(),
        SecurityActivityLogListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadData),
        SecurityActivityLogListLoaded(data: final data) => _buildContent(data),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    final meta = data['meta'] as Map<String, dynamic>?;

    if (items.isEmpty) {
      return const PosEmptyState(title: 'No activity logs');
    }

    final rows = items.cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosDataTable<Map<String, dynamic>>(
          columns: const [
            PosTableColumn(title: 'Admin', flex: 2),
            PosTableColumn(title: 'Action', width: 160),
            PosTableColumn(title: 'Entity', flex: 1),
            PosTableColumn(title: 'Description', flex: 3),
            PosTableColumn(title: 'IP Address', width: 130),
            PosTableColumn(title: 'Timestamp', width: 140),
          ],
          items: rows,
          cellBuilder: (item, colIndex, _) => switch (colIndex) {
            0 => _buildAdminCell(item),
            1 => PosBadge(label: _formatLabel(item['action']?.toString() ?? '–'), variant: PosBadgeVariant.info),
            2 => Text(
              '${item['entity_type']?.toString() ?? '–'} ${item['entity_id'] != null ? '#${item['entity_id']}' : ''}'.trim(),
              style: const TextStyle(fontSize: 12),
            ),
            3 => Text(
              item['description']?.toString() ?? '–',
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            4 => Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            5 => Text(_formatDate(item['created_at']?.toString()), style: const TextStyle(fontSize: 12)),
            _ => const SizedBox.shrink(),
          },
          currentPage: meta?['current_page'] as int?,
          totalPages: meta?['last_page'] as int?,
          totalItems: meta?['total'] as int?,
          onPreviousPage: () {
            if (_currentPage > 1) {
              _currentPage--;
              _loadData();
            }
          },
          onNextPage: () {
            _currentPage++;
            _loadData();
          },
        ),
      ),
    );
  }

  Widget _buildAdminCell(Map<String, dynamic> item) {
    final admin = item['admin'] as Map<String, dynamic>?;
    final name = admin?['name']?.toString() ?? item['admin_user_id']?.toString() ?? '–';
    final email = admin?['email']?.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        if (email != null) Text(email, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  String _formatLabel(String key) => key.replaceAll('_', ' ').split(' ').map(_capitalize).join(' ');
  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String _formatDate(String? iso) {
    if (iso == null) return '–';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
