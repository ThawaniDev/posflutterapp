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

class AdminProviderPermissionsPage extends ConsumerStatefulWidget {
  const AdminProviderPermissionsPage({super.key});

  @override
  ConsumerState<AdminProviderPermissionsPage> createState() => _State();
}

class _State extends ConsumerState<AdminProviderPermissionsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String? _groupFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(providerPermissionListProvider.notifier).load();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_groupFilter != null && _groupFilter!.isNotEmpty) params['group'] = _groupFilter;
    ref.read(providerPermissionListProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerPermissionListProvider);

    return PosListPage(
  title: l10n.adminProviderPermissions,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'orders', label: l10n.orders),
                PosDropdownItem(value: 'products', label: l10n.products),
                PosDropdownItem(value: 'stores', label: l10n.stores),
                PosDropdownItem(value: 'staff', label: l10n.staff),
                PosDropdownItem(value: 'reports', label: l10n.reports),
                PosDropdownItem(value: 'settings', label: l10n.settings),
                PosDropdownItem(value: 'customers', label: l10n.customers),
                PosDropdownItem(value: 'payments', label: l10n.sidebarPayments),
              ],
              selectedValue: _groupFilter,
              onChanged: (v) {
                setState(() => _groupFilter = v);
                _applyFilter();
              },
              label: l10n.group,
              hint: 'All Groups',
              showSearch: false,
              clearable: true,
            ),
          ),
          Expanded(
            child: switch (state) {
              ProviderPermissionListLoading() => const Center(child: CircularProgressIndicator()),
              ProviderPermissionListLoaded(data: final resp) => _buildList(resp),
              ProviderPermissionListError(message: final msg) => Center(
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
    if (items.isEmpty) return const Center(child: Text('No permissions found'));

    // Group by group field
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in items) {
      final group = item['group']?.toString() ?? 'other';
      grouped.putIfAbsent(group, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Text(
                entry.key.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary, letterSpacing: 1),
              ),
            ),
            ...entry.value.map((item) {
              final isActive = item['is_active'] == true || item['is_active'] == 1;
              return PosCard(
                borderRadius: BorderRadius.circular(10,),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
                    child: Icon(Icons.security, size: 20, color: isActive ? AppColors.success : AppColors.textSecondary),
                  ),
                  title: Text(item['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['description']?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isActive ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.sm),
          ],
        );
      }).toList(),
    );
  }
}
