import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/pos_badge.dart';
import '../models/zatca_invoice.dart';

class InvoiceListWidget extends StatelessWidget {
  final List<ZatcaInvoice> invoices;
  final void Function(ZatcaInvoice)? onTap;

  const InvoiceListWidget({
    super.key,
    required this.invoices,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (invoices.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 48, color: theme.hintColor),
              AppSpacing.gapH12,
              Text('No invoices found',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.hintColor)),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invoices.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.06),
      ),
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          onTap: onTap != null ? () => onTap!(invoice) : null,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _typeColor(invoice.invoiceType.value).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              _typeIcon(invoice.invoiceType.value),
              size: 20,
              color: _typeColor(invoice.invoiceType.value),
            ),
          ),
          title: Text(invoice.invoiceNumber,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          subtitle: Text(
            '${invoice.invoiceType.value.toUpperCase()} • ${_formatAmount(invoice.totalAmount)}',
            style: theme.textTheme.bodySmall,
          ),
          trailing: PosBadge(
            label: invoice.submissionStatus?.value ?? 'pending',
            variant: _statusVariant(invoice.submissionStatus?.value),
          ),
        );
      },
    );
  }

  Color _typeColor(String type) {
    return switch (type) {
      'standard' => AppColors.info,
      'simplified' => AppColors.success,
      'credit_note' => AppColors.warning,
      'debit_note' => AppColors.purple,
      _ => AppColors.info,
    };
  }

  IconData _typeIcon(String type) {
    return switch (type) {
      'standard' => Icons.description_outlined,
      'simplified' => Icons.receipt_outlined,
      'credit_note' => Icons.assignment_return_outlined,
      'debit_note' => Icons.add_circle_outline,
      _ => Icons.receipt_outlined,
    };
  }

  PosBadgeVariant _statusVariant(String? status) {
    return switch (status) {
      'accepted' => PosBadgeVariant.success,
      'rejected' => PosBadgeVariant.error,
      'pending' => PosBadgeVariant.warning,
      'submitted' => PosBadgeVariant.info,
      'warning' => PosBadgeVariant.warning,
      _ => PosBadgeVariant.neutral,
    };
  }

  String _formatAmount(double amount) {
    return 'SAR ${amount.toStringAsFixed(2)}';
  }
}
