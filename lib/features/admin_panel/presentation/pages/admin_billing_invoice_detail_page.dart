import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminBillingInvoiceDetailPage extends ConsumerStatefulWidget {
  final String invoiceId;
  const AdminBillingInvoiceDetailPage({super.key, required this.invoiceId});

  @override
  ConsumerState<AdminBillingInvoiceDetailPage> createState() => _AdminBillingInvoiceDetailPageState();
}

class _AdminBillingInvoiceDetailPageState extends ConsumerState<AdminBillingInvoiceDetailPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(billingInvoiceDetailProvider.notifier).loadInvoice(widget.invoiceId));
  }

  Color _statusColor(String status) {
    return switch (status) {
      'paid' => AppColors.success,
      'pending' => AppColors.warning,
      'failed' => AppColors.error,
      'refunded' => AppColors.purple,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billingInvoiceDetailProvider);

    return PosListPage(
  title: l10n.invoiceDetail,
  showSearch: false,
    child: switch (state) {
        BillingInvoiceDetailLoading() => const Center(child: CircularProgressIndicator()),
        BillingInvoiceDetailLoaded(invoice: final inv) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              PosCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            inv['invoice_number'] ?? 'N/A',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _statusColor(inv['status'] ?? '').withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderXl,
                            ),
                            child: Text(
                              (inv['status'] as String? ?? '').toUpperCase(),
                              style: TextStyle(color: _statusColor(inv['status'] ?? ''), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      _infoRow('Amount', '${inv['amount']} \u0081'),
                      _infoRow('Tax', '${inv['tax']} \u0081'),
                      _infoRow('Total', '${inv['total']} \u0081'),
                      _infoRow('Due Date', inv['due_date'] ?? 'N/A'),
                      if (inv['paid_at'] != null) _infoRow('Paid At', inv['paid_at']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Line Items
              Text(l10n.wameedAILineItems, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              if (inv['line_items'] != null)
                ...List<Map<String, dynamic>>.from(inv['line_items'] as List).map(
                  (item) => PosCard(
                    child: ListTile(
                      title: Text(item['description'] ?? ''),
                      subtitle: Text('Qty: ${item['quantity']} × ${item['unit_price']} \u0081'),
                      trailing: Text('${item['total']} \u0081', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Actions
              if (inv['status'] == 'pending') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => ref.read(billingInvoiceActionProvider.notifier).markPaid(widget.invoiceId),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark as Paid'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                  ),
                ),
              ],
              if (inv['status'] == 'paid') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Show refund dialog
                    },
                    icon: const Icon(Icons.undo),
                    label: Text(l10n.adminFinOpsProcessRefund),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white),
                  ),
                ),
              ],
              if (inv['status'] == 'failed') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => ref.read(billingInvoiceActionProvider.notifier).retryPayment(widget.invoiceId),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Payment'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: PosButton(
                  onPressed: () {
                    // Download PDF
                  },
                  variant: PosButtonVariant.outline,
                  icon: Icons.picture_as_pdf,
                  label: l10n.subscriptionDownloadPdf,
                ),
              ),
            ],
          ),
        ),
        BillingInvoiceDetailError(message: final msg) => Center(child: Text('Error: $msg')),
        _ => Center(child: Text(l10n.loading)),
      },
);
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
