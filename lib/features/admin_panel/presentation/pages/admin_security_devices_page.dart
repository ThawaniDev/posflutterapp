import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityDevicesPage extends ConsumerStatefulWidget {
  const AdminSecurityDevicesPage({super.key});

  @override
  ConsumerState<AdminSecurityDevicesPage> createState() => _AdminSecurityDevicesPageState();
}

class _AdminSecurityDevicesPageState extends ConsumerState<AdminSecurityDevicesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  String? _storeIdFilter;
  String? _statusFilter;
  String _searchQuery = '';
  int _currentPage = 1;

  static const _statuses = ['active', 'wiped', 'offline'];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  void _loadData() {
    final params = <String, dynamic>{
      'page': _currentPage,
      if (_storeIdFilter != null) 'store_id': _storeIdFilter!,
      if (_statusFilter != null) 'status': _statusFilter!,
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
    };
    ref.read(securityDeviceListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityDeviceListProvider);

    return PosListPage(
      title: 'Provider Devices',
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
              SecurityDeviceListLoading() => const PosLoading(),
              SecurityDeviceListError(message: final msg) => PosErrorState(message: msg, onRetry: _loadData),
              SecurityDeviceListLoaded(data: final data) => _buildContent(data),
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
      return const PosEmptyState(title: 'No devices found');
    }

    final rows = items.cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosDataTable<Map<String, dynamic>>(
          columns: const [
            PosTableColumn(title: 'Device Name', flex: 2),
            PosTableColumn(title: 'Store', flex: 1),
            PosTableColumn(title: 'Serial / IMEI', width: 140),
            PosTableColumn(title: 'Platform', width: 90),
            PosTableColumn(title: 'Status', width: 100),
            PosTableColumn(title: 'Last Seen', width: 140),
            PosTableColumn(title: 'Actions', width: 80),
          ],
          items: rows,
          cellBuilder: (item, colIndex, _) => switch (colIndex) {
            0 => _buildDeviceCell(item),
            1 => _buildStoreCell(item),
            2 => Text(item['serial_number']?.toString() ?? item['imei']?.toString() ?? '–', style: const TextStyle(fontSize: 12)),
            3 => Text(_capitalize(item['platform']?.toString() ?? '–'), style: const TextStyle(fontSize: 12)),
            4 => _buildStatusBadge(item['status']?.toString() ?? ''),
            5 => Text(_formatDate(item['last_seen_at']?.toString()), style: const TextStyle(fontSize: 12)),
            6 => _DeviceActions(device: item, onActionDone: _loadData),
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

  Widget _buildDeviceCell(Map<String, dynamic> item) {
    final name = item['device_name']?.toString() ?? item['name']?.toString() ?? '–';
    final model = item['device_model']?.toString() ?? item['model']?.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        if (model != null) Text(model, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStoreCell(Map<String, dynamic> item) {
    final store = item['store'] as Map<String, dynamic>?;
    final name = store?['name']?.toString() ?? item['store_id']?.toString() ?? '–';
    return Text(name, style: const TextStyle(fontSize: 12));
  }

  Widget _buildStatusBadge(String status) {
    final variant = switch (status) {
      'active' => PosBadgeVariant.success,
      'wiped' => PosBadgeVariant.error,
      'offline' => PosBadgeVariant.warning,
      _ => PosBadgeVariant.neutral,
    };
    return PosBadge(label: status.isEmpty ? '–' : _capitalize(status), variant: variant);
  }

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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _DeviceActions extends ConsumerWidget {
  const _DeviceActions({required this.device, required this.onActionDone});
  final Map<String, dynamic> device;
  final VoidCallback onActionDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = device['status']?.toString() ?? '';
    final id = device['id']?.toString() ?? '';

    if (status == 'wiped') {
      return const Icon(Icons.phonelink_erase, size: 18, color: AppColors.textSecondary);
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      onSelected: (action) async {
        if (action == 'wipe') {
          await _wipeDevice(context, ref, id);
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'wipe',
          child: Row(
            children: [
              Icon(Icons.phonelink_erase, size: 16, color: AppColors.error),
              SizedBox(width: 8),
              Text('Remote Wipe', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _wipeDevice(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remote Wipe Device'),
        content: const Text(
          'This will remotely wipe the device. This action cannot be undone. All POS data on the device will be erased.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Wipe Device'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(securityDeviceActionProvider.notifier).wipe(id);
    final state = ref.read(securityDeviceActionProvider);
    if (context.mounted) {
      if (state is SecurityDeviceActionSuccess) {
        showPosSuccessSnackbar(context, 'Remote wipe initiated successfully');
        onActionDone();
      } else if (state is SecurityDeviceActionError) {
        showPosErrorSnackbar(context, state.message);
      }
    }
  }
}
