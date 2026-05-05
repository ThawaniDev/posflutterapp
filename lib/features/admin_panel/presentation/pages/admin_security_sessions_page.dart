import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecuritySessionsPage extends ConsumerStatefulWidget {
  const AdminSecuritySessionsPage({super.key});

  @override
  ConsumerState<AdminSecuritySessionsPage> createState() => _AdminSecuritySessionsPageState();
}

class _AdminSecuritySessionsPageState extends ConsumerState<AdminSecuritySessionsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  bool _activeOnly = false;
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
      if (_activeOnly) 'active_only': '1',
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
    };
    ref.read(securitySessionListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securitySessionListProvider);

    return PosListPage(
      title: 'Admin Sessions',
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
              SecuritySessionListLoading() => const PosLoading(),
              SecuritySessionListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadData),
              SecuritySessionListLoaded(data: final data) => _buildContent(data),
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
          Row(
            children: [
              Switch(
                value: _activeOnly,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  setState(() => _activeOnly = v);
                  _currentPage = 1;
                  _loadData();
                },
              ),
              const SizedBox(width: AppSpacing.xs),
              const Text('Active only', style: TextStyle(fontSize: 13)),
            ],
          ),
          const Spacer(),
          PosButton(
            label: 'Revoke All Sessions',
            variant: PosButtonVariant.danger,
            onPressed: _showRevokeAllDialog,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    final meta = data['meta'] as Map<String, dynamic>?;

    if (items.isEmpty) {
      return const PosEmptyState(title: 'No sessions found');
    }

    final rows = items.cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosDataTable<Map<String, dynamic>>(
          columns: const [
            PosTableColumn(title: 'Admin', flex: 2),
            PosTableColumn(title: 'IP Address', width: 130),
            PosTableColumn(title: 'User Agent', flex: 2),
            PosTableColumn(title: 'Last Active', width: 140),
            PosTableColumn(title: 'Status', width: 100),
            PosTableColumn(title: 'Actions', width: 80),
          ],
          items: rows,
          cellBuilder: (item, colIndex, _) => switch (colIndex) {
            0 => _buildAdminCell(item),
            1 => Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            2 => Text(
              _truncate(item['user_agent']?.toString() ?? '–', 40),
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            3 => Text(
              _formatDate(item['last_active_at']?.toString() ?? item['updated_at']?.toString()),
              style: const TextStyle(fontSize: 12),
            ),
            4 => _buildStatusBadge(item),
            5 => _SessionActions(sessionId: item['id']?.toString() ?? '', onRevoked: _loadData),
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
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        if (email != null) Text(email, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStatusBadge(Map<String, dynamic> item) {
    final revokedAt = item['revoked_at'];
    if (revokedAt != null) {
      return PosBadge(label: 'Revoked', variant: PosBadgeVariant.error);
    }
    return PosBadge(label: 'Active', variant: PosBadgeVariant.success);
  }

  void _showRevokeAllDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => _RevokeAllDialog(onConfirmed: _revokeAll),
    );
  }

  Future<void> _revokeAll({String? adminUserId}) async {
    final data = <String, dynamic>{if (adminUserId != null && adminUserId.isNotEmpty) 'admin_user_id': adminUserId};
    await ref.read(securitySessionActionProvider.notifier).revokeAll(data);
    if (!mounted) return;
    final state = ref.read(securitySessionActionProvider);
    if (state is SecuritySessionActionSuccess) {
      showPosSuccessSnackbar(context, 'Sessions revoked successfully');
      _loadData();
    } else if (state is SecuritySessionActionError) {
      showPosErrorSnackbar(context, state.message);
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return '–';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  String _truncate(String s, int max) => s.length > max ? '${s.substring(0, max)}…' : s;
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SessionActions extends ConsumerWidget {
  const _SessionActions({required this.sessionId, required this.onRevoked});
  final String sessionId;
  final VoidCallback onRevoked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.logout, size: 18, color: AppColors.error),
      tooltip: 'Revoke session',
      onPressed: () => _revoke(context, ref),
    );
  }

  Future<void> _revoke(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Session'),
        content: const Text('Are you sure you want to revoke this session? The user will be logged out immediately.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(securitySessionActionProvider.notifier).revoke(sessionId);
    final state = ref.read(securitySessionActionProvider);
    if (context.mounted) {
      if (state is SecuritySessionActionSuccess) {
        showPosSuccessSnackbar(context, 'Session revoked');
        onRevoked();
      } else if (state is SecuritySessionActionError) {
        showPosErrorSnackbar(context, state.message);
      }
    }
  }
}

class _RevokeAllDialog extends StatefulWidget {
  const _RevokeAllDialog({required this.onConfirmed});
  final Future<void> Function({String? adminUserId}) onConfirmed;

  @override
  State<_RevokeAllDialog> createState() => _RevokeAllDialogState();
}

class _RevokeAllDialogState extends State<_RevokeAllDialog> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Revoke All Sessions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This will revoke all active sessions. Optionally specify an admin user ID to revoke only their sessions.'),
          const SizedBox(height: AppSpacing.sm),
          PosTextField(controller: _controller, label: 'Admin User ID (optional)', hint: 'Leave blank to revoke all'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        PosButton(
          label: _loading ? 'Revoking…' : 'Revoke All',
          variant: PosButtonVariant.danger,
          onPressed: _loading
              ? () {}
              : () async {
                  setState(() => _loading = true);
                  await widget.onConfirmed(adminUserId: _controller.text.trim().isEmpty ? null : _controller.text.trim());
                  if (mounted) Navigator.pop(context);
                },
        ),
      ],
    );
  }
}
