import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/zatca_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class VatReportCard extends StatelessWidget {
  final ZatcaVatReportLoaded data;

  const VatReportCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingAll20,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 24),
              AppSpacing.gapH8,
              Text(l10n.zatcaVatReport, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          AppSpacing.gapH20,
          // Total summary
          Container(
            padding: AppSpacing.paddingAll12,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: AppRadius.borderSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.totalRevenue, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    AppSpacing.gapH2,
                    Text(
                      '\u0081 ${data.totalAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total VAT', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    AppSpacing.gapH2,
                    Text(
                      '\u0081 ${data.totalVatCollected.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapH20,
          // Breakdown
          _InvoiceBreakdownRow(
            label: 'Standard Invoices',
            icon: Icons.description_outlined,
            color: AppColors.info,
            count: (data.standardInvoices['count'] as num?)?.toInt() ?? 0,
            amount: (data.standardInvoices['total_amount'] != null ? double.tryParse(data.standardInvoices['total_amount'].toString()) : null) ?? 0,
            vat: (data.standardInvoices['total_vat'] != null ? double.tryParse(data.standardInvoices['total_vat'].toString()) : null) ?? 0,
          ),
          AppSpacing.gapH12,
          _InvoiceBreakdownRow(
            label: 'Simplified Invoices',
            icon: Icons.receipt_outlined,
            color: AppColors.success,
            count: (data.simplifiedInvoices['count'] as num?)?.toInt() ?? 0,
            amount: (data.simplifiedInvoices['total_amount'] != null ? double.tryParse(data.simplifiedInvoices['total_amount'].toString()) : null) ?? 0,
            vat: (data.simplifiedInvoices['total_vat'] != null ? double.tryParse(data.simplifiedInvoices['total_vat'].toString()) : null) ?? 0,
          ),
        ],
      ),
    );
  }
}

class _InvoiceBreakdownRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int count;
  final double amount;
  final double vat;

  const _InvoiceBreakdownRow({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.amount,
    required this.vat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        AppSpacing.gapH8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              Text('$count invoices', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\u0081 ${amount.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            Text('VAT: \u0081 ${vat.toStringAsFixed(2)}', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ],
        ),
      ],
    );
  }
}
