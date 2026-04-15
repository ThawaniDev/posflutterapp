import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminInfraHealthPage extends ConsumerStatefulWidget {
  const AdminInfraHealthPage({super.key});

  @override
  ConsumerState<AdminInfraHealthPage> createState() => _State();
}

class _State extends ConsumerState<AdminInfraHealthPage> {
  String? _storeId;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(infraHealthChecksProvider.notifier).load();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_statusFilter != null && _statusFilter!.isNotEmpty) params['status'] = _statusFilter;
    ref.read(infraHealthChecksProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(infraHealthChecksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Health Checks'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'ok', label: 'OK'),
                PosDropdownItem(value: 'warning', label: 'WARNING'),
                PosDropdownItem(value: 'critical', label: 'CRITICAL'),
                PosDropdownItem(value: 'unknown', label: 'UNKNOWN'),
              ],
              selectedValue: _statusFilter,
              onChanged: (v) {
                setState(() => _statusFilter = v);
                _applyFilter();
              },
              label: 'Status',
              hint: 'All Statuses',
              showSearch: false,
              clearable: true,
            ),
          ),
          Expanded(
            child: switch (state) {
              InfraListLoading() => const Center(child: CircularProgressIndicator()),
              InfraListLoaded(data: final resp) => _buildList(resp),
              InfraListError(message: final msg) => Center(
                child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
              ),
              _ => const Center(child: Text('Loading...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No health checks'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final status = item['status']?.toString() ?? 'unknown';
          final (Color iconColor, Color bgColor, IconData icon) = switch (status) {
            'ok' => (AppColors.success, const Color(0xFFDCFCE7), Icons.check_circle),
            'warning' => (AppColors.warning, const Color(0xFFFEF3C7), Icons.warning_amber),
            'critical' => (AppColors.error, const Color(0xFFFEE2E2), Icons.cancel),
            _ => (AppColors.textSecondary, const Color(0xFFF3F4F6), Icons.help_outline),
          };
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: bgColor,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              title: Text(
                item['check_name']?.toString() ?? item['name']?.toString() ?? 'Check',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${item['service_name'] ?? item['service'] ?? ''}  •  ${item['message'] ?? status.toUpperCase()}',
                maxLines: 2,
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: iconColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item['checked_at']?.toString().substring(0, 10) ?? '', style: const TextStyle(fontSize: 10)),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
