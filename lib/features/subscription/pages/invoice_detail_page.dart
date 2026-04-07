import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/subscription/models/invoice.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_providers.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';

/// Page that shows full invoice details with line items, totals, and PDF download.
class InvoiceDetailPage extends ConsumerStatefulWidget {
  final String invoiceId;

  const InvoiceDetailPage({super.key, required this.invoiceId});

  @override
  ConsumerState<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends ConsumerState<InvoiceDetailPage> {
  bool _isDownloadingPdf = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(invoiceDetailProvider(widget.invoiceId).notifier).loadInvoice();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceDetailProvider(widget.invoiceId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        centerTitle: true,
        actions: [
          if (state is InvoiceDetailLoaded)
            IconButton(
              icon: _isDownloadingPdf
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.picture_as_pdf),
              tooltip: 'Download PDF',
              onPressed: _isDownloadingPdf ? null : () => _downloadPdf(),
            ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(InvoiceDetailState state) {
    if (state is InvoiceDetailLoading) {
      return Center(child: PosLoadingSkeleton.list());
    }

    if (state is InvoiceDetailError) {
      return PosErrorState(
        message: state.message,
        onRetry: () => ref.read(invoiceDetailProvider(widget.invoiceId).notifier).loadInvoice(),
      );
    }

    if (state is InvoiceDetailLoaded) {
      return _buildInvoiceContent(state.invoice);
    }

    return const SizedBox.shrink();
  }

  Widget _buildInvoiceContent(Invoice invoice) {
    final statusName = invoice.status?.name ?? 'unknown';

    return ListView(
      padding: AppSpacing.paddingAllMd,
      children: [
        // Header Card
        Card(
          child: Padding(
            padding: AppSpacing.paddingAllMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invoice.invoiceNumber ?? 'Invoice',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(statusName),
                  ],
                ),
                AppSpacing.verticalMd,
                _buildInfoRow('Created', invoice.createdAt != null ? _formatDate(invoice.createdAt!) : '—'),
                _buildInfoRow('Due Date', invoice.dueDate != null ? _formatDate(invoice.dueDate!) : '—'),
                if (invoice.paidAt != null) _buildInfoRow('Paid On', _formatDate(invoice.paidAt!)),
              ],
            ),
          ),
        ),

        AppSpacing.verticalMd,

        // Line Items
        if (invoice.lineItems != null && invoice.lineItems!.isNotEmpty) ...[
          Text('Line Items', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          AppSpacing.verticalSm,
          Card(
            child: Padding(
              padding: AppSpacing.paddingAllMd,
              child: Builder(
                builder: (context) {
                  if (context.isPhone) {
                    return Column(
                      children: invoice.lineItems!
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.description, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Qty: ${item.quantity ?? 1}',
                                        style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                                      ),
                                      Text(
                                        'Unit: ${item.unitPrice.toStringAsFixed(2)}',
                                        style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                                      ),
                                      Text(
                                        '${item.total.toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }
                  return Column(
                    children: [
                      // Table header
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Description',
                              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight, fontSize: 12),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Qty',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight, fontSize: 12),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Unit Price',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight, fontSize: 12),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Total',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ...invoice.lineItems!.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(flex: 4, child: Text(item.description)),
                              Expanded(flex: 1, child: Text('${item.quantity ?? 1}', textAlign: TextAlign.center)),
                              Expanded(flex: 2, child: Text('${item.unitPrice.toStringAsFixed(2)}', textAlign: TextAlign.end)),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${item.total.toStringAsFixed(2)}',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],

        AppSpacing.verticalMd,

        // Totals Card
        Card(
          child: Padding(
            padding: AppSpacing.paddingAllMd,
            child: Column(
              children: [
                _buildTotalRow('Subtotal', invoice.amount),
                if (invoice.tax != null) ...[const Divider(), _buildTotalRow('VAT (15%)', invoice.tax!)],
                const Divider(thickness: 2),
                _buildTotalRow('Total', invoice.total, isBold: true, color: AppColors.primary),
              ],
            ),
          ),
        ),

        AppSpacing.verticalLg,

        // Download PDF button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isDownloadingPdf ? null : () => _downloadPdf(),
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(_isDownloadingPdf ? 'Downloading...' : 'Download PDF Invoice'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondaryLight)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: isBold ? 16 : 14, color: color),
          ),
          Text(
            '${amount.toStringAsFixed(2)} \u0081',
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: isBold ? 16 : 14, color: color),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPdf() async {
    setState(() => _isDownloadingPdf = true);
    try {
      final pdfUrl = await ref.read(invoiceDetailProvider(widget.invoiceId).notifier).getInvoicePdfUrl();
      if (pdfUrl != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDF URL: $pdfUrl'), backgroundColor: AppColors.success));
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PDF not available for this invoice'), backgroundColor: AppColors.warning));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to download PDF: $e'), backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) setState(() => _isDownloadingPdf = false);
    }
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'paid' => AppColors.success,
      'pending' => AppColors.warning,
      'overdue' => AppColors.error,
      'cancelled' || 'voided' => AppColors.textSecondaryLight,
      _ => AppColors.info,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
