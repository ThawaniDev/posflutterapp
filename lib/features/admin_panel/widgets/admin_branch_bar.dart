import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';

/// A lightweight branch selector bar for admin pages.
///
/// - Branch-scoped users: shows their locked branch (read-only).
/// - Organization-scoped users with 2+ stores: shows an "All Branches" +
///   per-branch dropdown.
/// - Single-store users: hidden.
///
/// Call [onBranchChanged] to reload data whenever the selected branch changes.
class AdminBranchBar extends ConsumerWidget {
  final String? selectedStoreId;
  final ValueChanged<String?> onBranchChanged;

  const AdminBranchBar({super.key, required this.selectedStoreId, required this.onBranchChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSwitch = ref.watch(canSwitchBranchProvider);
    final branches = ref.watch(accessibleBranchIdsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Nothing to show for single-branch users
    if (branches.length <= 1 && !canSwitch) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(Icons.store_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          const SizedBox(width: 8),
          Text(
            'Branch:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(width: 8),
          if (canSwitch)
            Expanded(
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.hoverDark : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStoreId,
                    isExpanded: true,
                    isDense: true,
                    style: TextStyle(fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    icon: Icon(
                      Icons.expand_more_rounded,
                      size: 18,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Branches', style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      ...branches.map(
                        (id) => DropdownMenuItem<String>(value: id, child: Text(id.length > 12 ? '${id.substring(0, 8)}…' : id)),
                      ),
                    ],
                    onChanged: (val) => onBranchChanged(val),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                selectedStoreId ?? 'Your Branch',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
