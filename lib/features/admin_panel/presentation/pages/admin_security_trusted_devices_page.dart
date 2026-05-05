import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityTrustedDevicesPage extends ConsumerStatefulWidget {
  const AdminSecurityTrustedDevicesPage({super.key});

  @override
  ConsumerState<AdminSecurityTrustedDevicesPage> createState() => _AdminSecurityTrustedDevicesPageState();
}

class _AdminSecurityTrustedDevicesPageState extends ConsumerState<AdminSecurityTrustedDevicesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentPage = 1;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  void _loadData() {
    final params = <String, dynamic>{'page': _currentPage, if (_searchQuery.isNotEmpty) 'search': _searchQuery};
    ref.read(securityTrustedDeviceListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityTrustedDeviceListProvider);

    return PosListPage(
      title: 'Trusted Devices',
      showSearch: true,
      onSearchChanged: (q) {
        _searchQuery = q;
        _currentPage = 1;
        _loadData();
      },
      child: switch (state) {
        SecurityTrustedDeviceListLoading() => const PosLoading(),
        SecurityTrustedDeviceListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadData),
        SecurityTrustedDeviceListLoaded(data: final data) => _buildContent(data),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    final meta = data['meta'] as Map<String, dynamic>?;

    if (items.isEmpty) {
      return const PosEmptyState(title: 'No trusted devices');
    }

    final rows = items.cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosDataTable<Map<String, dynamic>>(
          columns: const [
            PosTableColumn(title: 'Admin', flex: 2),
            PosTableColumn(title: 'Device Name', flex: 2),
            PosTableColumn(title: 'IP Address', width: 130),
            PosTableColumn(title: 'User Agent', flex: 2),
            PosTableColumn(title: 'Trusted At', width: 140),
            PosTableColumn(title: 'Last Used', width: 140),
            PosTableColumn(title: 'Actions', width: 80),
          ],
          items: rows,
          cellBuilder: (item, colIndex, _) => switch (colIndex) {
            0 => _buildAdminCell(item),
            1 => Text(item['device_name']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            2 => Text(item['ip_address']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            3 => Text(
              _truncate(item['user_agent']?.toString() ?? '–', 40),
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            4 => Text(_formatDate(item['created_at']?.toString()), style: const TextStyle(fontSize: 12)),
            5 => Text(_formatDate(item['last_used_at']?.toString()), style: const TextStyle(fontSize: 12)),
            6 => _RevokeTrustButton(deviceId: item['id']?.toString() ?? '', onRevoked: _loadData),
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

class _RevokeTrustButton extends ConsumerWidget {
  const _RevokeTrustButton({required this.deviceId, required this.onRevoked});
  final String deviceId;
  final VoidCallback onRevoked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.shield_outlined, size: 18, color: AppColors.error),
      tooltip: 'Revoke trust',
      onPressed: () => _revoke(context, ref),
    );
  }

  Future<void> _revoke(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Device Trust'),
        content: const Text('Remove trust for this device? The admin will need to re-verify on next login from this device.'),
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

    await ref.read(securityTrustedDeviceActionProvider.notifier).revokeTrust(deviceId);
    final state = ref.read(securityTrustedDeviceActionProvider);
    if (context.mounted) {
      if (state is SecurityDeviceActionSuccess) {
        showPosSuccessSnackbar(context, 'Device trust revoked');
        onRevoked();
      } else if (state is SecurityDeviceActionError) {
        showPosErrorSnackbar(context, state.message);
      }
    }
  }
}
