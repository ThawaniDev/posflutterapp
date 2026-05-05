import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityAuditLogPage extends ConsumerStatefulWidget {
  const AdminSecurityAuditLogPage({super.key});

  @override
  ConsumerState<AdminSecurityAuditLogPage> createState() => _AdminSecurityAuditLogPageState();
}

class _AdminSecurityAuditLogPageState extends ConsumerState<AdminSecurityAuditLogPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  String? _actionFilter;
  String? _userTypeFilter;
  String _searchQuery = '';
  int _currentPage = 1;

  static const _actions = ['login', 'logout', 'pin_override', 'failed_login', 'settings_change', 'remote_wipe', 'terminal_credential_update'];
  static const _userTypes = ['staff', 'owner', 'system'];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  void _loadData() {
    final params = <String, dynamic>{
      'page': _currentPage,
      if (_actionFilter != null) 'action': _actionFilter!,
      if (_userTypeFilter != null) 'user_type': _userTypeFilter!,
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
    };
    ref.read(securityAuditLogListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityAuditLogListProvider);

    return PosListPage(
      title: 'Security Audit Log',
      showSearch: true,
      onSearchChanged: (q) {
        _searchQuery = q;
        _currentPage = 1;
        _loadData();
      },
      child: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: switch (state) {
              SecurityAuditLogListLoading() => const PosLoading(),
              SecurityAuditLogListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadData),
              SecurityAuditLogListLoaded(data: final data) => _buildContent(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          SizedBox(
            width: 180,
            child: PosDropdown<String?>(
              value: _actionFilter,
              label: 'Action',
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.all)),
                ..._actions.map((a) => DropdownMenuItem(value: a, child: Text(_formatLabel(a)))),
              ],
              onChanged: (v) {
                setState(() => _actionFilter = v);
                _currentPage = 1;
                _loadData();
              },
            ),
          ),
          SizedBox(
            width: 140,
            child: PosDropdown<String?>(
              value: _userTypeFilter,
              label: 'User Type',
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.all)),
                ..._userTypes.map((u) => DropdownMenuItem(value: u, child: Text(_capitalize(u)))),
              ],
              onChanged: (v) {
                setState(() => _userTypeFilter = v);
                _currentPage = 1;
                _loadData();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    final meta = data['meta'] as Map<String, dynamic>?;

    if (items.isEmpty) {
      return const PosEmptyState(title: 'No audit log entries');
    }

    final rows = items.cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosDataTable<Map<String, dynamic>>(
          columns: const [
            PosTableColumn(title: 'Action', width: 160),
            PosTableColumn(title: 'User', flex: 2),
            PosTableColumn(title: 'User Type', width: 100),
            PosTableColumn(title: 'IP Address', width: 130),
            PosTableColumn(title: 'Store', flex: 1),
            PosTableColumn(title: 'Timestamp', width: 140),
          ],
          items: rows,
          cellBuilder: (item, colIndex, _) => switch (colIndex) {
            0 => PosBadge(label: _formatLabel(item['action']?.toString() ?? '–'), variant: _actionVariant(item['action']?.toString() ?? '')),
            1 => _buildUserCell(item),
            2 => Text(_capitalize(item['user_type']?.toString() ?? '–'), style: const TextStyle(fontSize: 12)),
            3 => Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            4 => _buildStoreCell(item),
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

  Widget _buildUserCell(Map<String, dynamic> item) {
    final userId = item['user_id']?.toString() ?? '–';
    final userType = item['user_type']?.toString() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(userId, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        Text(userType, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStoreCell(Map<String, dynamic> item) {
    final store = item['store'] as Map<String, dynamic>?;
    return Text(store?['name']?.toString() ?? item['store_id']?.toString() ?? '–', style: const TextStyle(fontSize: 12));
  }

  PosBadgeVariant _actionVariant(String action) => switch (action) {
    'failed_login' => PosBadgeVariant.error,
    'remote_wipe' => PosBadgeVariant.error,
    'pin_override' => PosBadgeVariant.warning,
    'settings_change' => PosBadgeVariant.warning,
    'login' => PosBadgeVariant.success,
    'logout' => PosBadgeVariant.neutral,
    _ => PosBadgeVariant.info,
  };

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
