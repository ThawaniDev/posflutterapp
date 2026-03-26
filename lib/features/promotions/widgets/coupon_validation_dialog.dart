import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/promotions/providers/promotion_providers.dart';
import 'package:thawani_pos/features/promotions/providers/promotion_state.dart';

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
  final String? customerId;
  final double? orderTotal;

  const _CouponValidationDialog({this.customerId, this.orderTotal});

  @override
  ConsumerState<_CouponValidationDialog> createState() => _CouponValidationDialogState();
}

class _CouponValidationDialogState extends ConsumerState<_CouponValidationDialog> {
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
      title: const Text('Apply Coupon'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _codeController,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Coupon Code',
                hintText: 'Enter coupon code',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(icon: const Icon(Icons.check), onPressed: _validate),
              ),
              onSubmitted: (_) => _validate(),
            ),
            const SizedBox(height: 16),
            // Validation result
            switch (state) {
              CouponValidationInitial() => const SizedBox.shrink(),
              CouponValidationLoading() => const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
              CouponValidationValid(:final promotionName, :final discountAmount, :final type) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.successDark, size: 20),
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
                        Text('Type: $type', style: theme.textTheme.bodySmall),
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
                decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
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
        TextButton(
          onPressed: () {
            ref.read(couponValidationProvider.notifier).reset();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        if (state is CouponValidationValid)
          FilledButton(
            onPressed: () {
              Navigator.pop(context, state);
            },
            child: const Text('Apply'),
          ),
      ],
    );
  }
}
