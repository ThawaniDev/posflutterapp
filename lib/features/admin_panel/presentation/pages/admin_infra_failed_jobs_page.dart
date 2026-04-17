import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminInfraFailedJobsPage extends ConsumerStatefulWidget {
  const AdminInfraFailedJobsPage({super.key});

  @override
  ConsumerState<AdminInfraFailedJobsPage> createState() => _State();
}

class _State extends ConsumerState<AdminInfraFailedJobsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String? _queueFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilter();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilter();
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_queueFilter != null && _queueFilter!.isNotEmpty) params['queue'] = _queueFilter;
    ref.read(infraFailedJobsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(infraFailedJobsProvider);

    return PosListPage(
  title: l10n.adminInfraFailedJobs,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'default', label: 'default'),
                PosDropdownItem(value: 'high', label: 'high'),
                PosDropdownItem(value: 'notifications', label: 'notifications'),
                PosDropdownItem(value: 'billing', label: 'billing'),
                PosDropdownItem(value: 'sync', label: 'sync'),
                PosDropdownItem(value: 'reports', label: 'reports'),
              ],
              selectedValue: _queueFilter,
              onChanged: (v) {
                setState(() => _queueFilter = v);
                _applyFilter();
              },
              label: l10n.queue,
              hint: 'All Queues',
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
              _ => Center(child: Text(l10n.loading)),
            },
          ),
        ],
      ),
);
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No failed jobs'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          final exception = (item['exception'] ?? '').toString();
          final truncated = exception.length > 100 ? '${exception.substring(0, 100)}...' : exception;
          return PosCard(
            borderRadius: BorderRadius.circular(10,),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFEE2E2),
                child: Icon(Icons.error_outline, color: AppColors.error, size: 20),
              ),
              title: Text('Queue: ${item['queue'] ?? 'unknown'}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                truncated,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
              trailing: Text(item['failed_at']?.toString().substring(0, 10) ?? '', style: const TextStyle(fontSize: 10)),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
