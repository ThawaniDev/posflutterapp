import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/staff/models/permission.dart';
import 'package:thawani_pos/features/staff/providers/roles_providers.dart';
import 'package:thawani_pos/features/staff/providers/roles_state.dart';

class RoleCreatePage extends ConsumerStatefulWidget {
  const RoleCreatePage({super.key});

  @override
  ConsumerState<RoleCreatePage> createState() => _RoleCreatePageState();
}

class _RoleCreatePageState extends ConsumerState<RoleCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<int> _selectedPermissionIds = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(permissionsCatalogProvider.notifier).load());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Auto-generate system name from display name
  void _onDisplayNameChanged(String value) {
    _nameController.text = value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(rolesProvider.notifier)
          .createRole(
            name: _nameController.text.trim(),
            displayName: _displayNameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            permissionIds: _selectedPermissionIds.toList(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Role created successfully.')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final permState = ref.watch(permissionsCatalogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Role'),
        actions: [
          PosButton(label: 'Create', icon: Icons.check, isLoading: _isSaving, onPressed: _handleCreate, size: PosButtonSize.sm),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // ─── Basic Info ────────────────────────────────
            Text('Role Information', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _displayNameController,
              decoration: const InputDecoration(labelText: 'Display Name *', hintText: 'e.g., Shift Supervisor'),
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              onChanged: _onDisplayNameChanged,
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'System Name', helperText: 'Auto-generated, must be unique lowercase'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(v.trim())) {
                  return 'Lowercase letters, numbers, underscores only';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description', hintText: 'What does this role do?'),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.xl),

            // ─── Permissions ───────────────────────────────
            Row(
              children: [
                Text('Permissions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  '${_selectedPermissionIds.length} selected',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            if (permState is PermissionsLoading)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (permState is PermissionsLoaded)
              ..._buildPermissionModules(permState.grouped)
            else if (permState is PermissionsError)
              Text('Failed to load permissions: ${permState.message}', style: TextStyle(color: AppColors.error)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPermissionModules(Map<String, List<Permission>> grouped) {
    return grouped.entries.map((entry) {
      final module = entry.key;
      final permissions = entry.value;
      final selected = permissions.where((p) => _selectedPermissionIds.contains(p.id));

      return Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.borderLight),
        ),
        child: ExpansionTile(
          leading: Icon(
            _moduleIcon(module),
            color: selected.length == permissions.length ? AppColors.primary : AppColors.textMutedLight,
          ),
          title: Text(_formatModule(module), style: Theme.of(context).textTheme.titleSmall),
          subtitle: Text(
            '${selected.length}/${permissions.length}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight),
          ),
          trailing: Checkbox(
            value: selected.length == permissions.length ? true : (selected.isNotEmpty ? null : false),
            tristate: true,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedPermissionIds.addAll(permissions.map((p) => p.id));
                } else {
                  _selectedPermissionIds.removeAll(permissions.map((p) => p.id));
                }
              });
            },
            activeColor: AppColors.primary,
          ),
          children: permissions.map((perm) {
            final isSelected = _selectedPermissionIds.contains(perm.id);
            return CheckboxListTile(
              value: isSelected,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedPermissionIds.add(perm.id);
                  } else {
                    _selectedPermissionIds.remove(perm.id);
                  }
                });
              },
              activeColor: AppColors.primary,
              title: Text(perm.displayName, style: Theme.of(context).textTheme.bodyMedium),
              subtitle: perm.requiresPin == true
                  ? Row(
                      children: [
                        Icon(Icons.pin, size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          'Requires PIN override',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.warning),
                        ),
                      ],
                    )
                  : null,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        ),
      );
    }).toList();
  }

  String _formatModule(String module) {
    return module.split('_').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w).join(' ');
  }

  IconData _moduleIcon(String module) {
    switch (module) {
      case 'pos':
        return Icons.point_of_sale;
      case 'orders':
        return Icons.receipt_long;
      case 'inventory':
        return Icons.inventory_2;
      case 'catalog':
        return Icons.category;
      case 'customers':
        return Icons.people;
      case 'reports':
        return Icons.bar_chart;
      case 'staff':
        return Icons.badge;
      case 'settings':
        return Icons.settings;
      case 'accounting':
        return Icons.account_balance;
      case 'kitchen':
        return Icons.restaurant;
      case 'promotions':
        return Icons.local_offer;
      default:
        return Icons.extension;
    }
  }
}
