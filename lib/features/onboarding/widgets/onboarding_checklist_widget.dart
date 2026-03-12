import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/onboarding/providers/store_onboarding_providers.dart';
import 'package:thawani_pos/features/onboarding/providers/store_onboarding_state.dart';

/// Post-wizard checklist shown on the dashboard after the onboarding wizard
/// is completed. Displays 5 actionable tasks the merchant should accomplish
/// to fully set up their store (e.g. add first product, invite staff).
class OnboardingChecklistWidget extends ConsumerWidget {
  final String? storeId;
  final VoidCallback? onTaskTap;

  const OnboardingChecklistWidget({super.key, this.storeId, this.onTaskTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    if (state is! OnboardingLoaded) return const SizedBox.shrink();

    final progress = state.progress;
    if (!progress.isWizardCompleted || progress.isChecklistDismissed) {
      return const SizedBox.shrink();
    }

    final items = progress.checklistItems;
    if (items.isEmpty) return const SizedBox.shrink();

    final completedCount = items.values.where((v) => v == true).length;
    final totalCount = items.length;
    final allDone = completedCount == totalCount;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.primary20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.base, AppSpacing.md, 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: allDone ? AppColors.success : AppColors.primary10,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Icon(
                    allDone ? Icons.check_circle : Icons.rocket_launch,
                    size: 18,
                    color: allDone ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allDone ? 'Setup Complete!' : 'Finish Setting Up',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        allDone ? 'You\'re all set. Dismiss this card.' : '$completedCount of $totalCount tasks done',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: AppColors.textMutedLight,
                  onPressed: () {
                    ref.read(onboardingProvider.notifier).dismissChecklist(storeId: storeId);
                  },
                  tooltip: 'Dismiss',
                ),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.sm),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: totalCount > 0 ? completedCount / totalCount : 0,
                minHeight: 6,
                backgroundColor: AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(allDone ? AppColors.success : AppColors.primary),
              ),
            ),
          ),
          const Divider(height: 1),
          // Checklist items
          ...items.entries.map(
            (e) => _ChecklistItem(itemKey: e.key, completed: e.value == true, storeId: storeId, onTaskTap: onTaskTap),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _ChecklistItem extends ConsumerWidget {
  final String itemKey;
  final bool completed;
  final String? storeId;
  final VoidCallback? onTaskTap;

  const _ChecklistItem({required this.itemKey, required this.completed, this.storeId, this.onTaskTap});

  static const _itemLabels = <String, String>{
    'add_first_product': 'Add your first product',
    'configure_receipt': 'Configure receipt settings',
    'invite_staff': 'Invite a staff member',
    'make_first_sale': 'Make your first sale',
    'set_working_hours': 'Set working hours',
  };

  static const _itemIcons = <String, IconData>{
    'add_first_product': Icons.inventory_2_outlined,
    'configure_receipt': Icons.receipt_long_outlined,
    'invite_staff': Icons.person_add_outlined,
    'make_first_sale': Icons.point_of_sale_outlined,
    'set_working_hours': Icons.schedule_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = _itemLabels[itemKey] ?? itemKey.replaceAll('_', ' ');
    final icon = _itemIcons[itemKey] ?? Icons.check_circle_outline;

    return InkWell(
      onTap: () {
        if (!completed) {
          onTaskTap?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: () {
                ref.read(onboardingProvider.notifier).updateChecklistItem(itemKey, !completed, storeId: storeId);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: completed ? AppColors.success : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: completed ? AppColors.success : AppColors.borderLight, width: 2),
                ),
                child: completed ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(icon, size: 18, color: completed ? AppColors.textMutedLight : AppColors.textPrimaryLight),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: completed ? TextDecoration.lineThrough : null,
                  color: completed ? AppColors.textMutedLight : null,
                ),
              ),
            ),
            if (!completed) Icon(Icons.chevron_right, size: 18, color: AppColors.textMutedLight),
          ],
        ),
      ),
    );
  }
}
