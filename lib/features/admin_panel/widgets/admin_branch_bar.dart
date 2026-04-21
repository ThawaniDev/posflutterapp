import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// A lightweight branch selector bar for admin pages.
///
/// - Branch-scoped users: shows their locked branch (read-only).
/// - Organization-scoped users with 2+ stores: shows an "All Branches" +
///   per-branch dropdown.
/// - Single-store users: hidden.
///
/// Call [onBranchChanged] to reload data whenever the selected branch changes.
class AdminBranchBar extends ConsumerWidget {

  const AdminBranchBar({super.key, required this.selectedStoreId, required this.onBranchChanged});
  final String? selectedStoreId;
  final ValueChanged<String?> onBranchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final canSwitch = ref.watch(canSwitchBranchProvider);
    final branches = ref.watch(accessibleBranchIdsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Nothing to show for single-branch users
    if (branches.length <= 1 && !canSwitch) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceFor(context),
        border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Row(
        children: [
          Icon(Icons.store_rounded, size: 18, color: AppColors.mutedFor(context)),
          const SizedBox(width: 8),
          Text(
            'Branch:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedFor(context),
            ),
          ),
          const SizedBox(width: 8),
          if (canSwitch)
            Expanded(
              child: PosSearchableDropdown<String?>(
                items: branches
                    .map((id) => PosDropdownItem<String?>(value: id, label: id.length > 12 ? '${id.substring(0, 8)}…' : id))
                    .toList(),
                selectedValue: selectedStoreId,
                onChanged: (val) => onBranchChanged(val),
                showSearch: true,
                clearable: true,
                hint: l10n.commonAllBranches,
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
