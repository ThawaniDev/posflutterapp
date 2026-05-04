import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityAlertsPage extends ConsumerStatefulWidget {
  const AdminSecurityAlertsPage({super.key});

  @override
  ConsumerState<AdminSecurityAlertsPage> createState() => _AdminSecurityAlertsPageState();
}

class _AdminSecurityAlertsPageState extends ConsumerState<AdminSecurityAlertsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  String? _storeId;
  String? _severityFilter;
  String? _statusFilter;
  String? _typeFilter;
  String _searchQuery = '';

  static const _severities = ['critical', 'high', 'medium', 'low'];
  static const _statuses = ['open', 'investigating', 'resolved'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadData();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadData();
  }

  void _loadData() {
    final params = <String, dynamic>{
      if (_storeId != null) 'store_id': _storeId!,
      if (_severityFilter != null) 'severity': _severityFilter!,
      if (_statusFilter != null) 'status': _statusFilter!,
      if (_typeFilter != null) 'alert_type': _typeFilter!,
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
    };
    ref.read(secCenterAlertListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(secCenterAlertListProvider);

    return PosListPage(
      title: l10n.securityAlerts,
      showSearch: true,
      onSearchChanged: (q) {
        _searchQuery = q;
        _loadData();
      },
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          _FilterBar(),
          Expanded(
            child: switch (state) {
              SecCenterAlertListLoading() => const PosLoading(),
              SecCenterAlertListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadData),
              SecCenterAlertListLoaded(data: final data) => _buildTable(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _FilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          SizedBox(
            width: 140,
            child: PosDropdown<String?>(
              value: _severityFilter,
              label: 'Severity',
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.all)),
                ..._severities.map((s) => DropdownMenuItem(value: s, child: Text(_capitalize(s)))),
              ],
              onChanged: (v) {
                setState(() => _severityFilter = v);
                _loadData();
              },
            ),
          ),
          SizedBox(
            width: 140,
            child: PosDropdown<String?>(
              value: _statusFilter,
              label: l10n.status,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.all)),
                ..._statuses.map((s) => DropdownMenuItem(value: s, child: Text(_capitalize(s)))),
              ],
              onChanged: (v) {
                setState(() => _statusFilter = v);
                _loadData();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];

    if (items.isEmpty) {
      return PosEmptyState(title: l10n.adminNoSecurityAlertsShort);
    }

    final rows = items.cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            PosDataTable<Map<String, dynamic>>(
              columns: [
                const PosTableColumn(title: 'Severity', width: 100),
                PosTableColumn(title: l10n.adminAlertType, width: 160),
                PosTableColumn(title: l10n.adminDescription, flex: 2),
                PosTableColumn(title: l10n.adminIpAddress, width: 140),
                PosTableColumn(title: l10n.status, width: 120),
                const PosTableColumn(title: 'Created At', width: 140),
                PosTableColumn(title: l10n.actions, width: 80),
              ],
              items: rows,
              cellBuilder: (item, colIndex, _) {
                switch (colIndex) {
                  case 0:
                    return _SeverityBadge(item['severity']?.toString() ?? '');
                  case 1:
                    return Text(_formatAlertType(item['alert_type']?.toString() ?? ''), style: const TextStyle(fontSize: 13));
                  case 2:
                    return Text(
                      item['description']?.toString() ?? '',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    );
                  case 3:
                    return Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12));
                  case 4:
                    return _StatusBadge(item['status']?.toString() ?? '');
                  case 5:
                    return Text(_formatDate(item['created_at']?.toString()), style: const TextStyle(fontSize: 12));
                  case 6:
                    return _AlertActions(alert: item, onResolved: _loadData);
                  default:
                    return const SizedBox.shrink();
                }
              },
              // Pagination
              currentPage: (data['meta'] as Map<String, dynamic>?)?['current_page'] as int?,
              totalPages: (data['meta'] as Map<String, dynamic>?)?['last_page'] as int?,
              totalItems: (data['meta'] as Map<String, dynamic>?)?['total'] as int?,
              onPreviousPage: () {},
              onNextPage: () {},
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String _formatAlertType(String type) => type.replaceAll('_', ' ').split(' ').map(_capitalize).join(' ');

  String _formatDate(String? iso) {
    if (iso == null) return '–';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge(this.severity);
  final String severity;

  @override
  Widget build(BuildContext context) {
    final variant = switch (severity) {
      'critical' => PosBadgeVariant.error,
      'high' => PosBadgeVariant.warning,
      'medium' => PosBadgeVariant.info,
      'low' => PosBadgeVariant.success,
      _ => PosBadgeVariant.neutral,
    };
    return PosBadge(label: severity.isEmpty ? '–' : '${severity[0].toUpperCase()}${severity.substring(1)}', variant: variant);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);
  final String status;

  @override
  Widget build(BuildContext context) {
    final variant = switch (status) {
      'open' => PosStatusBadgeVariant.error,
      'investigating' => PosStatusBadgeVariant.warning,
      'resolved' => PosStatusBadgeVariant.success,
      _ => PosStatusBadgeVariant.neutral,
    };
    return PosStatusBadge(label: status, variant: variant);
  }
}

class _AlertActions extends ConsumerWidget {
  const _AlertActions({required this.alert, required this.onResolved});
  final Map<String, dynamic> alert;
  final VoidCallback onResolved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final status = alert['status']?.toString() ?? '';
    final id = alert['id']?.toString() ?? '';

    if (status == 'resolved') return const Icon(Icons.check_circle, color: AppColors.success, size: 18);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      onSelected: (action) async {
        if (action == 'resolve') {
          await _resolveAlert(context, ref, l10n, id);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'resolve',
          child: Row(children: [const Icon(Icons.check, size: 16), const SizedBox(width: 8), Text(l10n.adminResolveAlert)]),
        ),
      ],
    );
  }

  Future<void> _resolveAlert(BuildContext context, WidgetRef ref, AppLocalizations l10n, String id) async {
    final notes = await showDialog<String?>(
      context: context,
      builder: (ctx) => _ResolveAlertDialog(l10n: l10n),
    );
    if (notes == null) return;

    await ref.read(secCenterAlertActionProvider.notifier).resolve(id, {'resolution_notes': notes});

    final state = ref.read(secCenterAlertActionProvider);
    if (context.mounted) {
      if (state is SecCenterAlertActionSuccess) {
        showPosSuccessSnackbar(context, l10n.adminAlertResolved);
        onResolved();
      } else if (state is SecCenterAlertActionError) {
        showPosErrorSnackbar(context, state.message);
      }
    }
  }
}

class _ResolveAlertDialog extends StatefulWidget {
  const _ResolveAlertDialog({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_ResolveAlertDialog> createState() => _ResolveAlertDialogState();
}

class _ResolveAlertDialogState extends State<_ResolveAlertDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.adminResolveAlert),
      content: PosTextField(
        controller: _controller,
        label: widget.l10n.adminResolutionNotes,
        maxLines: 3,
        hint: widget.l10n.adminResolutionNotesHint,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(widget.l10n.cancel)),
        PosButton(label: widget.l10n.adminResolveAlert, onPressed: () => Navigator.pop(context, _controller.text)),
      ],
    );
  }
}
