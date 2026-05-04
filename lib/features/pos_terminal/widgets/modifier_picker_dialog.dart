import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/catalog/models/product.dart';

/// Pre-add modifier picker for restaurant-style products.
///
/// Shown when [Product.modifierGroups] is non-empty. Honours each group's
/// `is_required`, `min_select` and `max_select` constraints (radio for
/// max=1, checkboxes otherwise) and returns the selected options as a list
/// of payload maps ready to forward to the backend `modifier_selections`
/// field.
///
/// Returns `null` if the cashier cancels.
class ModifierPickerDialog extends StatefulWidget {
  const ModifierPickerDialog({required this.product, super.key});
  final Product product;

  static Future<List<Map<String, dynamic>>?> show(BuildContext context, Product product) {
    return showDialog<List<Map<String, dynamic>>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ModifierPickerDialog(product: product),
    );
  }

  @override
  State<ModifierPickerDialog> createState() => _ModifierPickerDialogState();
}

class _ModifierPickerDialogState extends State<ModifierPickerDialog> {
  /// Selected option ids per group id.
  final Map<String, Set<String>> _selected = {};

  @override
  void initState() {
    super.initState();
    final groups = widget.product.modifierGroups ?? const [];
    for (final g in groups) {
      final id = g['id']?.toString() ?? '';
      _selected[id] = {};
      // Pre-select defaults
      final opts = (g['options'] as List?) ?? const [];
      for (final o in opts) {
        if (o is Map && o['is_default'] == true) {
          _selected[id]!.add(o['id']?.toString() ?? '');
        }
      }
    }
  }

  bool _isValid() {
    final groups = widget.product.modifierGroups ?? const [];
    for (final g in groups) {
      final id = g['id']?.toString() ?? '';
      final required = g['is_required'] == true;
      final min = (g['min_select'] as num?)?.toInt() ?? (required ? 1 : 0);
      final count = _selected[id]?.length ?? 0;
      if (count < min) return false;
    }
    return true;
  }

  List<Map<String, dynamic>> _buildPayload() {
    final result = <Map<String, dynamic>>[];
    final groups = widget.product.modifierGroups ?? const [];
    for (final g in groups) {
      final groupId = g['id']?.toString() ?? '';
      final opts = (g['options'] as List?) ?? const [];
      for (final o in opts) {
        if (o is! Map) continue;
        final optId = o['id']?.toString() ?? '';
        if (!(_selected[groupId]?.contains(optId) ?? false)) continue;
        result.add({
          'modifier_group_id': groupId,
          'modifier_option_id': optId,
          'name': o['name']?.toString(),
          'price_adjustment': (o['price_adjustment'] as num?)?.toDouble() ?? 0,
          'quantity': 1,
        });
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final groups = widget.product.modifierGroups ?? const [];
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.modifierPickerTitle, style: AppTypography.headlineSmall),
              AppSpacing.gapH4,
              Text(
                isArabic ? (widget.product.nameAr ?? widget.product.name) : widget.product.name,
                style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
              ),
              AppSpacing.gapH16,
              Expanded(
                child: ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => AppSpacing.gapH16,
                  itemBuilder: (_, gi) => _buildGroup(context, groups[gi], l10n, isArabic),
                ),
              ),
              AppSpacing.gapH16,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(onPressed: () => Navigator.of(context).pop(null), child: Text(l10n.cancel)),
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isValid() ? () => Navigator.of(context).pop(_buildPayload()) : null,
                      child: Text(l10n.modifierAddSelected),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(BuildContext context, Map<String, dynamic> group, AppLocalizations l10n, bool isArabic) {
    final id = group['id']?.toString() ?? '';
    final name = (isArabic ? group['name_ar'] : group['name'])?.toString() ?? '';
    final required = group['is_required'] == true;
    final maxSelect = (group['max_select'] as num?)?.toInt() ?? 999;
    final minSelect = (group['min_select'] as num?)?.toInt() ?? (required ? 1 : 0);
    final isRadio = maxSelect == 1;
    final opts = (group['options'] as List?) ?? const [];
    final selected = _selected[id] ?? <String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(name, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600)),
            ),
            Text(
              required
                  ? l10n.modifierPickerRequired
                  : minSelect > 0
                  ? '$minSelect–$maxSelect'
                  : l10n.modifierPickerOptional,
              style: AppTypography.bodySmall.copyWith(color: required ? AppColors.error : AppColors.textSecondary),
            ),
          ],
        ),
        AppSpacing.gapH4,
        ...opts.whereType<Map>().map((opt) {
          final optId = opt['id']?.toString() ?? '';
          final optName = (isArabic ? opt['name_ar'] : opt['name'])?.toString() ?? '';
          final priceAdj = (opt['price_adjustment'] as num?)?.toDouble() ?? 0;
          final isSelected = selected.contains(optId);
          return InkWell(
            onTap: () => setState(() {
              if (isRadio) {
                _selected[id] = {optId};
              } else if (isSelected) {
                _selected[id]!.remove(optId);
              } else {
                if (_selected[id]!.length >= maxSelect) {
                  // Replace oldest selection so total stays within max
                  _selected[id]!.remove(_selected[id]!.first);
                }
                _selected[id]!.add(optId);
              }
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  isRadio
                      ? Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        )
                      : Icon(
                          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                  AppSpacing.gapW8,
                  Expanded(child: Text(optName, style: AppTypography.bodyMedium)),
                  if (priceAdj != 0)
                    Text(
                      (priceAdj > 0 ? '+' : '') + priceAdj.toStringAsFixed(3),
                      style: AppTypography.bodyMedium.copyWith(
                        color: priceAdj > 0 ? AppColors.warning : AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
