import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_app_bar.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/labels/models/label_template.dart';
import 'package:thawani_pos/features/labels/providers/label_providers.dart';
import 'package:thawani_pos/features/labels/providers/label_state.dart';

class LabelListPage extends ConsumerStatefulWidget {
  const LabelListPage({super.key});

  @override
  ConsumerState<LabelListPage> createState() => _LabelListPageState();
}

class _LabelListPageState extends ConsumerState<LabelListPage> {
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

    return Scaffold(
      appBar: PosAppBar(
        title: l10n.labelTemplates,
        actions: [
          PosButton(
            label: l10n.labelDesigner,
            icon: Icons.design_services_rounded,
            variant: PosButtonVariant.primary,
            size: PosButtonSize.sm,
            onPressed: () => context.push(Routes.labelDesigner),
          ),
          const SizedBox(width: AppSpacing.sm),
          PosButton(
            label: l10n.labelPrintHistory,
            icon: Icons.history_rounded,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.sm,
            onPressed: () => context.push(Routes.labelHistory),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: PosDataTable<LabelTemplate>(
          columns: const [
            PosTableColumn(title: 'Name'),
            PosTableColumn(title: 'Size'),
            PosTableColumn(title: 'Type'),
            PosTableColumn(title: 'Status'),
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
              onTap: (t) => context.push('${Routes.labelDesigner}?duplicate=${t.id}'),
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
                        borderRadius: BorderRadius.circular(8),
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

  Future<void> _handleDelete(LabelTemplate template) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.labelDeleteTitle),
        content: Text(l10n.labelDeleteConfirm(template.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.labelCancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.labelDelete, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      ref.read(labelTemplatesProvider.notifier).deleteTemplate(template.id);
    }
  }
}
