import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/models/permission.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';
import 'package:wameedpos/features/staff/providers/roles_state.dart';

class RoleDetailPage extends ConsumerStatefulWidget {

  const RoleDetailPage({super.key, required this.roleId});
  final int roleId;

  @override
  ConsumerState<RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends ConsumerState<RoleDetailPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _displayNameController;
  late TextEditingController _descriptionController;

  /// Set of currently selected permission IDs
  final Set<int> _selectedPermissionIds = {};
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _displayNameController = TextEditingController();
    _descriptionController = TextEditingController();

    Future.microtask(() {
      ref.read(roleDetailProvider(widget.roleId).notifier).load();
      ref.read(permissionsCatalogProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _populateForm() {
    final state = ref.read(roleDetailProvider(widget.roleId));
    if (state is RoleDetailLoaded) {
      _nameController.text = state.role.name;
      _displayNameController.text = state.role.displayName;
      _descriptionController.text = state.role.description ?? '';
      _selectedPermissionIds.clear();
      if (state.role.permissions != null) {
        _selectedPermissionIds.addAll(state.role.permissions!.map((p) => p.id));
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(roleDetailProvider(widget.roleId).notifier)
        .update(
          displayName: _displayNameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          permissionIds: _selectedPermissionIds.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final roleState = ref.watch(roleDetailProvider(widget.roleId));
    final permState = ref.watch(permissionsCatalogProvider);

    // Populate form when role loads
    ref.listen<RoleDetailState>(roleDetailProvider(widget.roleId), (prev, next) {
      if (next is RoleDetailLoaded && prev is! RoleDetailLoaded) {
        _populateForm();
      }
      if (next is RoleDetailSaved) {
        final l10n = AppLocalizations.of(context)!;
        showPosSuccessSnackbar(context, l10n.staffRoleUpdated);
        // Reload the detail to reflect new state
        ref.read(roleDetailProvider(widget.roleId).notifier).load();
        // Also refresh the roles list
        ref.read(rolesProvider.notifier).load();
        setState(() {
          _isEditing = false;
          _hasChanges = false;
        });
      }
      if (next is RoleDetailError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    final isPredefined = roleState is RoleDetailLoaded && roleState.role.isPredefined == true;
    final isSaving = roleState is RoleDetailSaving;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PosFormPage(
      title: roleState is RoleDetailLoaded
          ? roleState.role.localizedName(Localizations.localeOf(context).languageCode)
          : l10n.staffRoleDetails,
      actions: [
        if (!isPredefined && !_isEditing)
          PosButton.icon(
            icon: Icons.edit,
            tooltip: l10n.staffEditRole,
            onPressed: () => setState(() => _isEditing = true),
            variant: PosButtonVariant.ghost,
          ),
      ],
      bottomBar: _isEditing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PosButton(
                  label: l10n.cancel,
                  variant: PosButtonVariant.ghost,
                  onPressed: () {
                    _populateForm();
                    setState(() {
                      _isEditing = false;
                      _hasChanges = false;
                    });
                  },
                ),
                AppSpacing.gapW12,
                PosButton(label: l10n.save, isLoading: isSaving, onPressed: _hasChanges ? _handleSave : null),
              ],
            )
          : null,
      child: _buildBody(roleState, permState, isDark, l10n),
    );
  }

  Widget _buildBody(RoleDetailState roleState, PermissionsState permState, bool isDark, AppLocalizations l10n) {
    if (roleState is RoleDetailLoading || roleState is RoleDetailInitial) {
      return const PosLoading();
    }

    if (roleState is RoleDetailError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(roleState.message, style: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: l10n.retry,
              onPressed: () => ref.read(roleDetailProvider(widget.roleId).notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    final role = roleState is RoleDetailLoaded ? roleState.role : (roleState as RoleDetailSaved).role;
    final isPredefined = role.isPredefined == true;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Role Info Section ──────────────────────────────
            _SectionHeader(title: l10n.staffRoleInfo),
            const SizedBox(height: AppSpacing.sm),

            if (isPredefined)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.staffPredefinedRoleNote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),

            // Display Name
            TextFormField(
              controller: _displayNameController,
              enabled: _isEditing && !isPredefined,
              decoration: InputDecoration(labelText: l10n.staffDisplayName, hintText: l10n.staffDisplayNameHint),
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.staffRequired : null,
              onChanged: (_) => _markChanged(),
            ),
            const SizedBox(height: AppSpacing.md),

            // System Name (read-only)
            TextFormField(
              controller: _nameController,
              enabled: false,
              decoration: InputDecoration(labelText: l10n.staffSystemName, helperText: l10n.staffSystemNameNoChange),
            ),
            const SizedBox(height: AppSpacing.md),

            // Description
            TextFormField(
              controller: _descriptionController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: l10n.description, hintText: l10n.staffRoleDescHint),
              maxLines: 2,
              onChanged: (_) => _markChanged(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ─── Permissions Section ────────────────────────────
            _SectionHeader(
              title: l10n.staffPermissions,
              trailing: Text(
                l10n.staffCountSelected(_selectedPermissionIds.length),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            if (permState is PermissionsLoading)
              const Padding(padding: EdgeInsets.all(AppSpacing.xl), child: PosLoading())
            else if (permState is PermissionsLoaded)
              ..._buildPermissionModules(permState.grouped)
            else if (permState is PermissionsError)
              Text(l10n.staffFailedLoadPermissions(permState.message), style: const TextStyle(color: AppColors.error)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPermissionModules(Map<String, List<Permission>> grouped) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return grouped.entries.map((entry) {
      final module = entry.key;
      final permissions = entry.value;
      final moduleSelected = permissions.where((p) => _selectedPermissionIds.contains(p.id));

      return PosCard(
        elevation: 0,
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        borderRadius: AppRadius.borderMd,

        border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
        child: ExpansionTile(
          leading: Icon(
            _moduleIcon(module),
            color: moduleSelected.length == permissions.length ? AppColors.primary : AppColors.mutedFor(context),
          ),
          title: Text(_formatModule(module), style: Theme.of(context).textTheme.titleSmall),
          subtitle: Text(
            '${moduleSelected.length}/${permissions.length} ${l10n.staffActive}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedFor(context)),
          ),
          trailing: _isEditing
              ? Checkbox(
                  value: moduleSelected.length == permissions.length,
                  tristate: true,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedPermissionIds.addAll(permissions.map((p) => p.id));
                      } else {
                        _selectedPermissionIds.removeAll(permissions.map((p) => p.id));
                      }
                      _hasChanges = true;
                    });
                  },
                  activeColor: AppColors.primary,
                )
              : null,
          children: permissions.map((perm) {
            final isSelected = _selectedPermissionIds.contains(perm.id);
            return CheckboxListTile(
              value: isSelected,
              onChanged: _isEditing
                  ? (val) {
                      setState(() {
                        if (val == true) {
                          _selectedPermissionIds.add(perm.id);
                        } else {
                          _selectedPermissionIds.remove(perm.id);
                        }
                        _hasChanges = true;
                      });
                    }
                  : null,
              activeColor: AppColors.primary,
              title: Text(
                perm.localizedName(Localizations.localeOf(context).languageCode),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: perm.requiresPin == true
                  ? Row(
                      children: [
                        const Icon(Icons.pin, size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          l10n.staffRequiresPinOverride,
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

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
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

class _SectionHeader extends StatelessWidget {

  const _SectionHeader({required this.title, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        ?trailing,
      ],
    );
  }
}
