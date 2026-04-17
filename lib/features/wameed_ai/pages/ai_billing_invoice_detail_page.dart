import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_billing.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/utils/ai_helpers.dart';

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

    return PosListPage(
  title: l10n.wameedAIBillingInvoiceDetail,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(aiBillingInvoiceDetailProvider.notifier).load(widget.invoiceId),
  ),
],
  child: switch (state) {
        AIBillingInvoiceDetailInitial() || AIBillingInvoiceDetailLoading() => const PosLoading(),
        AIBillingInvoiceDetailError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(aiBillingInvoiceDetailProvider.notifier).load(widget.invoiceId),
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
      padding: context.responsivePagePadding,
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
                          AppSpacing.gapH4,
                          Text(
                            '${localizedMonthName(l10n, invoice.month)} ${invoice.year}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
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
                if (invoice.paidAt != null) _DetailRow(label: l10n.wameedAIBillingPaidAt, value: invoice.paidAt!),
              ],
            ),
          ),

          AppSpacing.gapH16,

          // Cost Summary KPIs
          PosKpiGrid(
            desktopCols: 2,
            mobileCols: 2,
            cards: [
              PosKpiCard(
                label: l10n.wameedAIBillingBilledCost,
                value: '\$${invoice.billedAmountUsd.toStringAsFixed(3)}',
                icon: Icons.receipt,
                iconColor: AppColors.primary,
              ),
              PosKpiCard(
                label: l10n.wameedAIBillingRequests,
                value: '${invoice.totalRequests}',
                icon: Icons.sync_alt,
                iconColor: Colors.blue,
                subtitle: '${formatTokens(invoice.totalTokens)} ${l10n.wameedAIBillingTokens}',
              ),
            ],
          ),

          // Line Items
          if (invoice.items.isNotEmpty) ...[
            AppSpacing.gapH24,
            Text(
              l10n.wameedAIBillingLineItems,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            AppSpacing.gapH12,
            if (isMobile)
              ...invoice.items.map((item) => _MobileLineItem(item: item))
            else
              PosDataTable<AIBillingInvoiceItem>(
                columns: [
                  PosTableColumn(title: l10n.wameedAIBillingFeature, flex: 2),
                  PosTableColumn(title: l10n.wameedAIBillingRequests, numeric: true),
                  PosTableColumn(title: l10n.wameedAIBillingTokens, numeric: true),
                  PosTableColumn(title: l10n.wameedAIBillingBilledCost, numeric: true),
                ],
                items: invoice.items,
                cellBuilder: (item, colIndex, _) => switch (colIndex) {
                  0 => Text(item.featureName.isNotEmpty ? item.featureName : item.featureSlug.replaceAll('_', ' ')),
                  1 => Text('${item.requestCount}'),
                  2 => Text(formatTokens(item.totalTokens)),
                  3 => Text('\$${item.billedCostUsd.toStringAsFixed(3)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  _ => const SizedBox.shrink(),
                },
              ),
          ],

          // Payment History
          if (invoice.payments.isNotEmpty) ...[
            AppSpacing.gapH24,
            Text(
              l10n.wameedAIBillingPaymentHistory,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            AppSpacing.gapH12,
            ...invoice.payments.map((p) => _PaymentListTile(payment: p)),
          ],

          // Pay Now button for unpaid invoices
          if (invoice.status != 'paid') ...[
            AppSpacing.gapH24,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go(
                    Routes.providerPaymentCheckout,
                    extra: {
                      'purpose': 'ai_billing',
                      'purpose_label': 'AI Billing — ${invoice.invoiceNumber}',
                      'amount': invoice.billedAmountUsd,
                      'currency': 'USD',
                      'purpose_reference_id': invoice.id,
                      'notes': 'AI Billing Invoice ${invoice.invoiceNumber}',
                      'on_success_route': Routes.wameedAIBillingInvoices,
                    },
                  );
                },
                icon: const Icon(Icons.payment),
                label: Text(l10n.posCompletePayment),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
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
            child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
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
          AppSpacing.gapH8,
          Row(
            children: [
              Expanded(
                child: _MiniStat(label: l10n.wameedAIBillingRequests, value: '${item.requestCount}'),
              ),
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
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 11)),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: bold ? FontWeight.w600 : FontWeight.normal),
        ),
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
      leading: const Icon(Icons.payment, color: AppColors.success),
      title: Text('\$${payment.amountUsd.toStringAsFixed(3)}'),
      subtitle: Text('${payment.paymentMethod}${payment.reference != null ? ' · ${payment.reference}' : ''}'),
      trailing: Text(payment.createdAt, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
    );
  }
}
