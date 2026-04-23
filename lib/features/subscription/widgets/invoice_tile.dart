import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// A list tile widget for displaying an invoice summary.
class InvoiceTile extends StatelessWidget {
  const InvoiceTile({super.key, required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusName = invoice.status?.name ?? 'unknown';
    return PosCard(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _statusColor(statusName).withValues(alpha: 0.15),
          child: Icon(_statusIcon(statusName), color: _statusColor(statusName), size: 20),
        ),
        title: Text(invoice.invoiceNumber ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.verticalXs,
            if (invoice.dueDate != null)
              Text(l10n.subDueColon(_formatDate(invoice.dueDate!)), style: Theme.of(context).textTheme.bodySmall),
            if (invoice.paidAt != null)
              Text(
                l10n.subPaidColon(_formatDate(invoice.paidAt!)),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${invoice.total.toStringAsFixed(2)} \u0081', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            AppSpacing.verticalXs,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _statusColor(statusName).withValues(alpha: 0.15),
                borderRadius: AppRadius.borderLg,
              ),
              child: Text(
                statusName,
                style: TextStyle(fontSize: 11, color: _statusColor(statusName), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'paid' => AppColors.success,
      'pending' => AppColors.warning,
      'overdue' => AppColors.error,
      'cancelled' || 'voided' => AppColors.textMutedLight,
      _ => AppColors.info,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status.toLowerCase()) {
      'paid' => Icons.check_circle,
      'pending' => Icons.schedule,
      'overdue' => Icons.warning,
      'cancelled' || 'voided' => Icons.cancel,
      _ => Icons.receipt,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
