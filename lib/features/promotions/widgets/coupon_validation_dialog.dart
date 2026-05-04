import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/features/promotions/providers/promotion_providers.dart';
import 'package:wameedpos/features/promotions/providers/promotion_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Dialog that validates a coupon code during POS checkout.
///
/// Returns a [CouponValidationValid] result when the user confirms
/// a valid coupon, or `null` if dismissed.
Future<CouponValidationValid?> showCouponValidationDialog(BuildContext context, {String? customerId, double? orderTotal}) async {
  return showDialog<CouponValidationValid>(
    context: context,
    builder: (_) => _CouponValidationDialog(customerId: customerId, orderTotal: orderTotal),
  );
}

class _CouponValidationDialog extends ConsumerStatefulWidget {
  const _CouponValidationDialog({this.customerId, this.orderTotal});
  final String? customerId;
  final double? orderTotal;

  @override
  ConsumerState<_CouponValidationDialog> createState() => _CouponValidationDialogState();
}

class _CouponValidationDialogState extends ConsumerState<_CouponValidationDialog> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _validate() {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    ref
        .read(couponValidationProvider.notifier)
        .validate(code: code, customerId: widget.customerId, orderTotal: widget.orderTotal);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(couponValidationProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.applyCoupon),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(
              controller: _codeController,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: l10n.couponCode,
                hintText: l10n.enterCouponCode,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(icon: const Icon(Icons.check), onPressed: _validate),
              ),
              onSubmitted: (_) => _validate(),
            ),
            const SizedBox(height: 16),
            // Validation result
            switch (state) {
              CouponValidationInitial() => const SizedBox.shrink(),
              CouponValidationLoading() => const Padding(padding: EdgeInsets.all(12), child: PosLoading()),
              CouponValidationValid(:final promotionName, :final discountAmount, :final type) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.08),
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.successDark, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(promotionName, style: theme.textTheme.titleSmall?.copyWith(color: AppColors.successDark)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.promotionsCouponType(type), style: theme.textTheme.bodySmall),
                        Text(
                          'Discount: ${discountAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CouponValidationInvalid(:final message) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: AppRadius.borderMd),
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: theme.colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
                    ),
                  ],
                ),
              ),
              CouponValidationError(:final message) => Text(message, style: TextStyle(color: theme.colorScheme.error)),
            },
          ],
        ),
      ),
      actions: [
        PosButton(
          onPressed: () {
            ref.read(couponValidationProvider.notifier).reset();
            Navigator.pop(context);
          },
          variant: PosButtonVariant.ghost,
          label: l10n.cancel,
        ),
        if (state is CouponValidationValid)
          PosButton(
            onPressed: () {
              Navigator.pop(context, state);
            },
            variant: PosButtonVariant.soft,
            label: l10n.apply,
          ),
      ],
    );
  }
}
