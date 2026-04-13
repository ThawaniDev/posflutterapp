import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_billing.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

class AIBillingInvoiceDetailPage extends ConsumerStatefulWidget {
  final String invoiceId;

  const AIBillingInvoiceDetailPage({super.key, required this.invoiceId});

  @override
  ConsumerState<AIBillingInvoiceDetailPage> createState() => _AIBillingInvoiceDetailPageState();
}

class _AIBillingInvoiceDetailPageState extends ConsumerState<AIBillingInvoiceDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aiBillingInvoiceDetailProvider.notifier).load(widget.invoiceId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiBillingInvoiceDetailProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wameedAIBillingInvoiceDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(aiBillingInvoiceDetailProvider.notifier).load(widget.invoiceId),
          ),
        ],
      ),
      body: switch (state) {
        AIBillingInvoiceDetailInitial() || AIBillingInvoiceDetailLoading() =>
          const Center(child: CircularProgressIndicator()),
        AIBillingInvoiceDetailError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 16),
              PosButton(
                label: l10n.commonRetry,
                onPressed: () => ref.read(aiBillingInvoiceDetailProvider.notifier).load(widget.invoiceId),
              ),
            ],
          ),
        ),
        AIBillingInvoiceDetailLoaded(:final invoice) => _InvoiceDetailContent(invoice: invoice),
      },
    );
  }
}

class _InvoiceDetailContent extends StatelessWidget {
  final AIBillingInvoiceDetail invoice;

  const _InvoiceDetailContent({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isPhone;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice Header
          PosCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.invoiceNumber,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_monthName(invoice.month)} ${invoice.year}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    PosStatusBadge(
                      label: switch (invoice.status) {
                        'paid' => l10n.wameedAIBillingPaid,
                        'overdue' => l10n.wameedAIBillingOverdue,
                        _ => l10n.wameedAIBillingPending,
                      },
                      variant: switch (invoice.status) {
                        'paid' => PosStatusBadgeVariant.success,
                        'overdue' => PosStatusBadgeVariant.error,
                        _ => PosStatusBadgeVariant.warning,
                      },
                    ),
                  ],
                ),
                const Divider(height: 24),
                _DetailRow(label: l10n.wameedAIBillingPeriod, value: '${invoice.periodStart} – ${invoice.periodEnd}'),
                _DetailRow(label: l10n.wameedAIBillingDueDate, value: invoice.dueDate),
                if (invoice.paidAt != null)
                  _DetailRow(label: l10n.wameedAIBillingPaidAt, value: invoice.paidAt!),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Cost Summary KPIs
          PosKpiGrid(
            desktopCols: 4,
            mobileCols: 2,
            cards: [
              PosKpiCard(
                label: l10n.wameedAIBillingBilledCost,
                value: '\$${invoice.billedAmountUsd.toStringAsFixed(3)}',
                icon: Icons.receipt,
                iconColor: AppColors.primary,
              ),
              PosKpiCard(
                label: l10n.wameedAIBillingRawCost,
                value: '\$${invoice.rawCostUsd.toStringAsFixed(3)}',
                icon: Icons.attach_money,
                iconColor: Colors.green,
              ),
              PosKpiCard(
                label: l10n.wameedAIBillingMargin,
                value: '${invoice.marginPercentage.toStringAsFixed(1)}% (+\$${invoice.marginAmountUsd.toStringAsFixed(3)})',
                icon: Icons.trending_up,
                iconColor: Colors.orange,
              ),
              PosKpiCard(
                label: l10n.wameedAIBillingRequests,
                value: '${invoice.totalRequests}',
                icon: Icons.sync_alt,
                iconColor: Colors.blue,
                subtitle: '${_formatTokens(invoice.totalTokens)} ${l10n.wameedAIBillingTokens}',
              ),
            ],
          ),

          // Line Items
          if (invoice.items.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.wameedAIBillingLineItems,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (isMobile)
              ...invoice.items.map((item) => _MobileLineItem(item: item))
            else
              PosDataTable<AIBillingInvoiceItem>(
                columns: [
                  PosTableColumn(title: l10n.wameedAIBillingFeature, flex: 2),
                  PosTableColumn(title: l10n.wameedAIBillingRequests, numeric: true),
                  PosTableColumn(title: l10n.wameedAIBillingTokens, numeric: true),
                  PosTableColumn(title: l10n.wameedAIBillingRawCost, numeric: true),
                  PosTableColumn(title: l10n.wameedAIBillingBilledCost, numeric: true),
                ],
                items: invoice.items,
                cellBuilder: (item, colIndex, _) => switch (colIndex) {
                  0 => Text(item.featureName.isNotEmpty ? item.featureName : item.featureSlug.replaceAll('_', ' ')),
                  1 => Text('${item.requestCount}'),
                  2 => Text(_formatTokens(item.totalTokens)),
                  3 => Text('\$${item.rawCostUsd.toStringAsFixed(3)}'),
                  4 => Text('\$${item.billedCostUsd.toStringAsFixed(3)}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  _ => const SizedBox.shrink(),
                },
              ),
          ],

          // Payment History
          if (invoice.payments.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.wameedAIBillingPaymentHistory,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...invoice.payments.map((p) => _PaymentListTile(payment: p)),
          ],
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month.clamp(1, 12) - 1];
  }

  String _formatTokens(int tokens) {
    if (tokens >= 1000000) return '${(tokens / 1000000).toStringAsFixed(1)}M';
    if (tokens >= 1000) return '${(tokens / 1000).toStringAsFixed(1)}K';
    return '$tokens';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _MobileLineItem extends StatelessWidget {
  final AIBillingInvoiceItem item;

  const _MobileLineItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.featureName.isNotEmpty ? item.featureName : item.featureSlug.replaceAll('_', ' '),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _MiniStat(label: l10n.wameedAIBillingRequests, value: '${item.requestCount}')),
              Expanded(child: _MiniStat(label: l10n.wameedAIBillingRawCost, value: '\$${item.rawCostUsd.toStringAsFixed(3)}')),
              Expanded(
                child: _MiniStat(
                  label: l10n.wameedAIBillingBilledCost,
                  value: '\$${item.billedCostUsd.toStringAsFixed(3)}',
                  bold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _MiniStat({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        )),
      ],
    );
  }
}

class _PaymentListTile extends StatelessWidget {
  final AIBillingPayment payment;

  const _PaymentListTile({required this.payment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.payment, color: Colors.green),
      title: Text('\$${payment.amountUsd.toStringAsFixed(3)}'),
      subtitle: Text('${payment.paymentMethod}${payment.reference != null ? ' · ${payment.reference}' : ''}'),
      trailing: Text(
        payment.createdAt,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
    );
  }
}
