import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminProviderPermissionsPage extends ConsumerStatefulWidget {
  const AdminProviderPermissionsPage({super.key});

  @override
  ConsumerState<AdminProviderPermissionsPage> createState() => _State();
}

class _State extends ConsumerState<AdminProviderPermissionsPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Permissions'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'orders', label: 'Orders'),
                PosDropdownItem(value: 'products', label: 'Products'),
                PosDropdownItem(value: 'stores', label: 'Stores'),
                PosDropdownItem(value: 'staff', label: 'Staff'),
                PosDropdownItem(value: 'reports', label: 'Reports'),
                PosDropdownItem(value: 'settings', label: 'Settings'),
                PosDropdownItem(value: 'customers', label: 'Customers'),
                PosDropdownItem(value: 'payments', label: 'Payments'),
              ],
              selectedValue: _groupFilter,
              onChanged: (v) {
                setState(() => _groupFilter = v);
                _applyFilter();
              },
              label: 'Group',
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
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      borderRadius: BorderRadius.circular(12),
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
