import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/providers/label_providers.dart';
import 'package:wameedpos/features/labels/providers/label_state.dart';

class LabelListPage extends ConsumerStatefulWidget {
  const LabelListPage({super.key});

  @override
  ConsumerState<LabelListPage> createState() => _LabelListPageState();
}

class _LabelListPageState extends ConsumerState<LabelListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(labelTemplatesProvider.notifier).load();
      ref.read(labelTemplatesProvider.notifier).loadPresets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(labelTemplatesProvider);

    final templates = state is LabelTemplatesLoaded ? state.templates : <LabelTemplate>[];
    final isLoading = state is LabelTemplatesLoading || state is LabelTemplatesInitial;
    final error = state is LabelTemplatesError ? state.message : null;

    return PermissionGuardPage(
      permission: Permissions.labelsView,
      child: PosListPage(
        title: l10n.labelTemplates,
        showSearch: false,
        isLoading: isLoading,
        hasError: error != null,
        errorMessage: error,
        onRetry: () => ref.read(labelTemplatesProvider.notifier).load(),
        actions: [
          PosButton.icon(icon: Icons.info_outline, tooltip: l10n.featureInfoTooltip, onPressed: () => showLabelListInfo(context)),
          PosButton(
            label: l10n.labelDesigner,
            icon: Icons.design_services_rounded,
            variant: PosButtonVariant.primary,
            size: PosButtonSize.sm,
            onPressed: () => context.push(Routes.labelDesigner),
          ),
          PosButton(
            label: l10n.labelPrintHistory,
            icon: Icons.history_rounded,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.sm,
            onPressed: () => context.push(Routes.labelHistory),
          ),
        ],
        child: PosDataTable<LabelTemplate>(
          columns: [
            PosTableColumn(title: l10n.name),
            PosTableColumn(title: l10n.labelSize),
            PosTableColumn(title: l10n.txColType),
            PosTableColumn(title: l10n.status),
          ],
          items: templates,
          isLoading: isLoading,
          error: error,
          onRetry: () => ref.read(labelTemplatesProvider.notifier).load(),
          emptyConfig: PosTableEmptyConfig(
            icon: Icons.label_outlined,
            title: l10n.labelNoTemplates,
            subtitle: l10n.labelNoTemplatesSubtitle,
            actionLabel: l10n.labelCreateTemplate,
            action: () => context.push(Routes.labelDesigner),
          ),
          actions: [
            PosTableRowAction<LabelTemplate>(
              label: l10n.labelEdit,
              icon: Icons.edit_outlined,
              onTap: (t) => context.push('${Routes.labelDesigner}?id=${t.id}'),
            ),
            PosTableRowAction<LabelTemplate>(
              label: l10n.labelDuplicate,
              icon: Icons.copy_outlined,
              onTap: (t) => _handleDuplicate(t),
            ),
            PosTableRowAction<LabelTemplate>(
              label: l10n.labelSetAsDefault,
              icon: Icons.star_outline_rounded,
              isVisible: (t) => t.isDefault != true,
              onTap: (t) => _handleSetDefault(t),
            ),
            PosTableRowAction<LabelTemplate>(
              label: l10n.labelPrintQueue,
              icon: Icons.print_outlined,
              onTap: (t) => context.push('${Routes.labelPrintQueue}?templateId=${t.id}'),
            ),
            PosTableRowAction<LabelTemplate>(
              label: l10n.labelDelete,
              icon: Icons.delete_outline,
              isDestructive: true,
              isVisible: (t) => t.isPreset != true,
              onTap: (t) => _handleDelete(t),
            ),
          ],
          cellBuilder: (template, colIndex, col) {
            switch (colIndex) {
              case 0: // Name
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: const Icon(Icons.label_rounded, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        template.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              case 1: // Size
                return Text('${template.labelWidthMm.toStringAsFixed(0)} × ${template.labelHeightMm.toStringAsFixed(0)} mm');
              case 2: // Type
                return PosBadge(
                  label: template.isPreset == true ? l10n.labelPreset : l10n.labelCustom,
                  variant: template.isPreset == true ? PosBadgeVariant.info : PosBadgeVariant.neutral,
                );
              case 3: // Status
                return PosBadge(
                  label: template.isDefault == true ? l10n.labelDefault : l10n.labelActive,
                  variant: template.isDefault == true ? PosBadgeVariant.primary : PosBadgeVariant.success,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Future<void> _handleDuplicate(LabelTemplate template) async {
    final success = await ref.read(labelTemplatesProvider.notifier).duplicateTemplate(template.id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelDuplicateSuccess)));
    }
  }

  Future<void> _handleSetDefault(LabelTemplate template) async {
    final success = await ref.read(labelTemplatesProvider.notifier).setDefaultTemplate(template.id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelSetAsDefaultSuccess)));
    }
  }

  Future<void> _handleDelete(LabelTemplate template) async {
    final confirm = await showPosConfirmDialog(
      context,
      title: l10n.labelDeleteTitle,
      message: l10n.labelDeleteConfirm(template.name),
      confirmLabel: l10n.labelDelete,
      cancelLabel: l10n.labelCancel,
      isDanger: true,
    );
    if (confirm == true && mounted) {
      ref.read(labelTemplatesProvider.notifier).deleteTemplate(template.id);
    }
  }
}
