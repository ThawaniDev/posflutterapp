import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
/// Tabbed page for IP Allowlist and IP Blocklist management.
class AdminSecurityIpPage extends ConsumerStatefulWidget {
  const AdminSecurityIpPage({super.key});

  @override
  ConsumerState<AdminSecurityIpPage> createState() => _AdminSecurityIpPageState();
}

class _AdminSecurityIpPageState extends ConsumerState<AdminSecurityIpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(securityIpAllowlistProvider.notifier).load();
      ref.read(securityIpBlocklistProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Allowlist'),
            Tab(text: 'Blocklist'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AllowlistTab(),
          _BlocklistTab(),
        ],
      ),
    );
  }
}

// ── Allowlist Tab ────────────────────────────────────────────────────────────

class _AllowlistTab extends ConsumerStatefulWidget {
  const _AllowlistTab();

  @override
  ConsumerState<_AllowlistTab> createState() => _AllowlistTabState();
}

class _AllowlistTabState extends ConsumerState<_AllowlistTab> {
  void _reload() => ref.read(securityIpAllowlistProvider.notifier).load();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityIpAllowlistProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PosButton(
                label: 'Add IP / CIDR',
                icon: Icons.add,
                onPressed: () => _showAddDialog(context, isAllowlist: true),
              ),
            ],
          ),
        ),
        Expanded(
          child: switch (state) {
            SecurityIpListLoading() => const PosLoading(),
            SecurityIpListError(message: final msg) => PosErrorState(message: msg, onRetry: _reload),
            SecurityIpListLoaded(data: final data) => _buildTable(data, isAllowlist: true),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }

  Widget _buildTable(Map<String, dynamic> data, {required bool isAllowlist}) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    if (items.isEmpty) {
      return const PosEmptyState(title: 'No entries in allowlist');
    }
    final rows = items.cast<Map<String, dynamic>>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PosDataTable<Map<String, dynamic>>(
        columns: const [
          PosTableColumn(title: 'IP / CIDR', flex: 2),
          PosTableColumn(title: 'Label', flex: 2),
          PosTableColumn(title: 'Type', width: 80),
          PosTableColumn(title: 'Added By', flex: 1),
          PosTableColumn(title: 'Expires', width: 140),
          PosTableColumn(title: 'Actions', width: 70),
        ],
        items: rows,
        cellBuilder: (item, colIndex, _) => switch (colIndex) {
          0 => Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
          1 => Text(item['label']?.toString() ?? item['description']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
          2 => PosBadge(
              label: (item['is_cidr'] == true || item['is_cidr'] == 1) ? 'CIDR' : 'IP',
              variant: (item['is_cidr'] == true || item['is_cidr'] == 1) ? PosBadgeVariant.info : PosBadgeVariant.neutral,
            ),
          3 => _buildAddedByCell(item),
          4 => Text(_formatExpiry(item['expires_at']?.toString()), style: const TextStyle(fontSize: 12)),
          5 => _DeleteEntryButton(
              entryId: item['id']?.toString() ?? '',
              isAllowlist: true,
              onDeleted: _reload,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildAddedByCell(Map<String, dynamic> item) {
    final admin = item['added_by'] as Map<String, dynamic>?;
    return Text(admin?['name']?.toString() ?? '–', style: const TextStyle(fontSize: 12));
  }

  String _formatExpiry(String? iso) {
    if (iso == null) return 'Never';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  void _showAddDialog(BuildContext context, {required bool isAllowlist}) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _AddIpDialog(
        isAllowlist: isAllowlist,
        onAdded: _reload,
      ),
    );
  }
}

// ── Blocklist Tab ────────────────────────────────────────────────────────────

class _BlocklistTab extends ConsumerStatefulWidget {
  const _BlocklistTab();

  @override
  ConsumerState<_BlocklistTab> createState() => _BlocklistTabState();
}

class _BlocklistTabState extends ConsumerState<_BlocklistTab> {
  void _reload() => ref.read(securityIpBlocklistProvider.notifier).load();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityIpBlocklistProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PosButton(
                label: 'Block IP / CIDR',
                icon: Icons.block,
                variant: PosButtonVariant.danger,
                onPressed: () => _showAddDialog(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: switch (state) {
            SecurityIpListLoading() => const PosLoading(),
            SecurityIpListError(message: final msg) => PosErrorState(message: msg, onRetry: _reload),
            SecurityIpListLoaded(data: final data) => _buildTable(data),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }

  Widget _buildTable(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    if (items.isEmpty) {
      return const PosEmptyState(title: 'No entries in blocklist');
    }
    final rows = items.cast<Map<String, dynamic>>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PosDataTable<Map<String, dynamic>>(
        columns: const [
          PosTableColumn(title: 'IP / CIDR', flex: 2),
          PosTableColumn(title: 'Reason', flex: 2),
          PosTableColumn(title: 'Type', width: 80),
          PosTableColumn(title: 'Hit Count', width: 90),
          PosTableColumn(title: 'Blocked By', flex: 1),
          PosTableColumn(title: 'Expires', width: 140),
          PosTableColumn(title: 'Actions', width: 70),
        ],
        items: rows,
        cellBuilder: (item, colIndex, _) => switch (colIndex) {
          0 => Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
          1 => Text(
              item['reason']?.toString() ?? '–',
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          2 => PosBadge(
              label: (item['is_cidr'] == true || item['is_cidr'] == 1) ? 'CIDR' : 'IP',
              variant: (item['is_cidr'] == true || item['is_cidr'] == 1) ? PosBadgeVariant.info : PosBadgeVariant.neutral,
            ),
          3 => Text(item['hit_count']?.toString() ?? '0', style: const TextStyle(fontSize: 12)),
          4 => _buildBlockedByCell(item),
          5 => Text(_formatExpiry(item['expires_at']?.toString()), style: const TextStyle(fontSize: 12)),
          6 => _DeleteEntryButton(
              entryId: item['id']?.toString() ?? '',
              isAllowlist: false,
              onDeleted: _reload,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildBlockedByCell(Map<String, dynamic> item) {
    final admin = item['blocked_by'] as Map<String, dynamic>? ?? item['added_by'] as Map<String, dynamic>?;
    return Text(admin?['name']?.toString() ?? '–', style: const TextStyle(fontSize: 12));
  }

  String _formatExpiry(String? iso) {
    if (iso == null) return 'Never';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  void _showAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _AddIpDialog(isAllowlist: false, onAdded: _reload),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _DeleteEntryButton extends ConsumerWidget {
  const _DeleteEntryButton({required this.entryId, required this.isAllowlist, required this.onDeleted});
  final String entryId;
  final bool isAllowlist;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
      tooltip: 'Remove',
      onPressed: () => _delete(context, ref),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Entry'),
        content: Text('Remove this IP from the ${isAllowlist ? 'allowlist' : 'blocklist'}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    if (isAllowlist) {
      await ref.read(securityIpActionProvider.notifier).removeFromAllowlist(entryId);
    } else {
      await ref.read(securityIpActionProvider.notifier).removeFromBlocklist(entryId);
    }

    final state = ref.read(securityIpActionProvider);
    if (context.mounted) {
      if (state is SecurityIpActionSuccess) {
        showPosSuccessSnackbar(context, 'Entry removed');
        onDeleted();
      } else if (state is SecurityIpActionError) {
        showPosErrorSnackbar(context, state.message);
      }
    }
  }
}

class _AddIpDialog extends ConsumerStatefulWidget {
  const _AddIpDialog({required this.isAllowlist, required this.onAdded});
  final bool isAllowlist;
  final VoidCallback onAdded;

  @override
  ConsumerState<_AddIpDialog> createState() => _AddIpDialogState();
}

class _AddIpDialogState extends ConsumerState<_AddIpDialog> {
  final _ipController = TextEditingController();
  final _labelController = TextEditingController();
  final _reasonController = TextEditingController();
  final _expiryController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _ipController.dispose();
    _labelController.dispose();
    _reasonController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isAllowlist ? 'Add to Allowlist' : 'Block IP / CIDR'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(
              controller: _ipController,
              label: 'IP Address or CIDR',
              hint: 'e.g. 192.168.1.1 or 10.0.0.0/24',
            ),
            const SizedBox(height: AppSpacing.sm),
            PosTextField(
              controller: _labelController,
              label: widget.isAllowlist ? 'Label (optional)' : 'Reason',
              hint: widget.isAllowlist ? 'Describe this IP' : 'Why is this IP blocked?',
            ),
            const SizedBox(height: AppSpacing.sm),
            PosTextField(
              controller: _expiryController,
              label: 'Expiry Date (optional)',
              hint: 'YYYY-MM-DD',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        PosButton(
          label: _loading ? 'Adding…' : (widget.isAllowlist ? 'Add to Allowlist' : 'Block'),
          variant: widget.isAllowlist ? PosButtonVariant.primary : PosButtonVariant.danger,
          onPressed: _loading ? () {} : _submit,
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) {
      showPosErrorSnackbar(context, 'IP address is required');
      return;
    }

    setState(() => _loading = true);

    final data = <String, dynamic>{
      'ip_address': ip,
      if (_labelController.text.trim().isNotEmpty)
        widget.isAllowlist ? 'label' : 'reason': _labelController.text.trim(),
      if (_expiryController.text.trim().isNotEmpty) 'expires_at': _expiryController.text.trim(),
    };

    if (widget.isAllowlist) {
      await ref.read(securityIpActionProvider.notifier).addToAllowlist(data);
    } else {
      await ref.read(securityIpActionProvider.notifier).addToBlocklist(data);
    }

    final state = ref.read(securityIpActionProvider);
    if (mounted) {
      setState(() => _loading = false);
      if (state is SecurityIpActionSuccess) {
        showPosSuccessSnackbar(context, widget.isAllowlist ? 'IP added to allowlist' : 'IP blocked');
        Navigator.pop(context);
        widget.onAdded();
      } else if (state is SecurityIpActionError) {
        showPosErrorSnackbar(context, state.message);
      }
    }
  }
}
