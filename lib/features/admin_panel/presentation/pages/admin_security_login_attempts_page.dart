import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityLoginAttemptsPage extends ConsumerStatefulWidget {
  const AdminSecurityLoginAttemptsPage({super.key});

  @override
  ConsumerState<AdminSecurityLoginAttemptsPage> createState() => _AdminSecurityLoginAttemptsPageState();
}

class _AdminSecurityLoginAttemptsPageState extends ConsumerState<AdminSecurityLoginAttemptsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  bool _failedOnly = false;
  String _searchQuery = '';
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  void _loadData() {
    final params = <String, dynamic>{
      'page': _currentPage,
      if (_failedOnly) 'status': 'failed',
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
    };
    ref.read(securityLoginAttemptListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityLoginAttemptListProvider);

    return PosListPage(
      title: l10n.adminLoginAttempts,
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
              SecurityLoginAttemptListLoading() => const PosLoading(),
              SecurityLoginAttemptListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadData),
              SecurityLoginAttemptListLoaded(data: final data) => _buildContent(data),
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
      child: Row(
        children: [
          Switch(
            value: _failedOnly,
            onChanged: (v) {
              setState(() => _failedOnly = v);
              _currentPage = 1;
              _loadData();
            },
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(l10n.failedOnly, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    final meta = data['meta'] as Map<String, dynamic>?;

    if (items.isEmpty) {
      return PosEmptyState(title: l10n.noLoginAttemptsFound);
    }

    final rows = items.cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosDataTable<Map<String, dynamic>>(
          columns: [
            PosTableColumn(title: l10n.ipAddress, width: 130),
            PosTableColumn(title: l10n.emailIdentifier, flex: 2),
            PosTableColumn(title: l10n.userAgent, flex: 2),
            PosTableColumn(title: l10n.status, width: 100),
            PosTableColumn(title: l10n.failureReason, flex: 1),
            PosTableColumn(title: l10n.attemptedAt, width: 140),
          ],
          items: rows,
          cellBuilder: (item, colIndex, _) => switch (colIndex) {
            0 => Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            1 => Text(item['email']?.toString() ?? item['identifier']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            2 => Text(
              _truncate(item['user_agent']?.toString() ?? '–', 40),
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            3 => _buildStatusBadge(_resolveStatus(item)),
            4 => Text(item['failure_reason']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            5 => Text(
              _formatDate(item['attempted_at']?.toString() ?? item['created_at']?.toString()),
              style: const TextStyle(fontSize: 12),
            ),
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

  Widget _buildStatusBadge(String status) {
    return PosBadge(
      label: status.isEmpty ? '–' : _capitalize(status),
      variant: switch (status) {
        'success' => PosBadgeVariant.success,
        'failed' => PosBadgeVariant.error,
        _ => PosBadgeVariant.neutral,
      },
    );
  }

  String _resolveStatus(Map<String, dynamic> item) {
    final s = item['status']?.toString();
    if (s != null && s.isNotEmpty) return s;
    final wasSuccessful = item['was_successful'];
    if (wasSuccessful == true) return 'success';
    if (wasSuccessful == false) return 'failed';
    return '–';
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _truncate(String s, int max) => s.length > max ? '${s.substring(0, max)}…' : s;

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
