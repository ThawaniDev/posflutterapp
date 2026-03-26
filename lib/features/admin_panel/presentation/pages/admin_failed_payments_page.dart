import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminFailedPaymentsPage extends ConsumerStatefulWidget {
  const AdminFailedPaymentsPage({super.key});

  @override
  ConsumerState<AdminFailedPaymentsPage> createState() => _AdminFailedPaymentsPageState();
}

class _AdminFailedPaymentsPageState extends ConsumerState<AdminFailedPaymentsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(failedPaymentsProvider.notifier).loadFailedPayments());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(failedPaymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Failed Payments'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(failedPaymentsProvider.notifier).loadFailedPayments(),
          ),
        ],
      ),
      body: switch (state) {
        BillingInvoiceListLoading() => const Center(child: CircularProgressIndicator()),
        BillingInvoiceListLoaded(invoices: final items) =>
          items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 64, color: AppColors.success),
                      SizedBox(height: 16),
                      Text('No failed payments', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _failedPaymentCard(items[index]),
                ),
        BillingInvoiceListError(message: final msg) => Center(child: Text('Error: $msg')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _failedPaymentCard(Map<String, dynamic> invoice) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice #${invoice['invoice_number'] ?? invoice['id']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (invoice['store_name'] != null)
                        Text('Store: ${invoice['store_name']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  '${invoice['total_amount'] ?? 0} SAR',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                if (invoice['due_date'] != null) ...[
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('Due: ${invoice['due_date']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const Spacer(),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'FAILED',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.errorDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                icon: const Icon(Icons.replay, size: 18),
                label: const Text('Retry Payment'),
                onPressed: () => _retryPayment(invoice['id']),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retryPayment(int invoiceId) async {
    try {
      await ref.read(billingInvoiceActionProvider.notifier).retryPayment(invoiceId.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment retry initiated'), backgroundColor: AppColors.success));
        ref.read(failedPaymentsProvider.notifier).loadFailedPayments();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Retry failed: $e'), backgroundColor: AppColors.error));
      }
    }
  }
}
