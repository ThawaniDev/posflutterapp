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

class AIBillingPage extends ConsumerStatefulWidget {
  const AIBillingPage({super.key});

  @override
  ConsumerState<AIBillingPage> createState() => _AIBillingPageState();
}

class _AIBillingPageState extends ConsumerState<AIBillingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aiBillingSummaryProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiBillingSummaryProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wameedAIBilling),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: l10n.wameedAIBillingInvoices,
            onPressed: () => context.push(Routes.wameedAIBillingInvoices),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(aiBillingSummaryProvider.notifier).load()),
        ],
      ),
      body: switch (state) {
        AIBillingSummaryInitial() || AIBillingSummaryLoading() => const PosLoading(),
        AIBillingSummaryError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(aiBillingSummaryProvider.notifier).load(),
        ),
        AIBillingSummaryLoaded(:final summary) => _BillingContent(summary: summary, isMobile: isMobile),
      },
    );
  }
}

class _BillingContent extends StatelessWidget {
  final AIBillingSummary summary;
  final bool isMobile;

  const _BillingContent({required this.summary, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final month = summary.currentMonth;
    final config = summary.config;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          if (!config.isAiEnabled)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.wameedAIBillingDisabled}${config.disabledReason != null ? ': ${config.disabledReason}' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),

          // KPI Cards
          Text(
            l10n.wameedAIBillingCurrentMonth,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          PosKpiGrid(
            desktopCols: 3,
            mobileCols: 2,
            cards: [
              PosKpiCard(
                label: l10n.wameedAIBillingBilledCost,
                value: '\$${month.billedCostUsd.toStringAsFixed(3)}',
                icon: Icons.receipt,
                iconColor: AppColors.primary,
              ),
              PosKpiCard(
                label: l10n.wameedAIBillingLimitUsage,
                value: month.limitUsd > 0 ? '${month.limitPercentage.toStringAsFixed(1)}%' : l10n.wameedAIBillingNoLimit,
                icon: Icons.speed,
                iconColor: month.limitPercentage >= 90
                    ? AppColors.error
                    : month.limitPercentage >= 70
                    ? AppColors.warning
                    : AppColors.success,
                subtitle: month.limitUsd > 0
                    ? '\$${month.billedCostUsd.toStringAsFixed(3)} / \$${month.limitUsd.toStringAsFixed(2)}'
                    : null,
              ),
              PosKpiCard(
                label: l10n.wameedAIBillingRequests,
                value: '${month.totalRequests}',
                icon: Icons.sync_alt,
                iconColor: Colors.blue,
                subtitle: '${formatTokens(month.totalTokens)} ${l10n.wameedAIBillingTokens}',
              ),
            ],
          ),

          // Feature Breakdown
          if (month.byFeature.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.wameedAIBillingByFeature,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (isMobile)
              ...month.byFeature.map((f) => _FeatureCard(feature: f))
            else
              PosDataTable<AIBillingFeatureUsage>(
                columns: [
                  PosTableColumn(title: l10n.wameedAIBillingFeature, flex: 2),
                  PosTableColumn(title: l10n.wameedAIBillingRequests, numeric: true),
                  PosTableColumn(title: l10n.wameedAIBillingTokens, numeric: true),
                  PosTableColumn(title: l10n.wameedAIBillingBilledCost, numeric: true),
                ],
                items: month.byFeature,
                cellBuilder: (item, colIndex, _) => switch (colIndex) {
                  0 => Text(item.featureSlug.replaceAll('_', ' ')),
                  1 => Text('${item.requestCount}'),
                  2 => Text(formatTokens(item.totalTokens)),
                  3 => Text('\$${item.billedCostUsd.toStringAsFixed(3)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  _ => const SizedBox.shrink(),
                },
              ),
          ],

          // Recent Invoices
          if (summary.recentInvoices.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.wameedAIBillingRecentInvoices,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () => context.push(Routes.wameedAIBillingInvoices),
                  child: Text(l10n.wameedAIBillingViewAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...summary.recentInvoices.map((inv) => _InvoiceListTile(invoice: inv)),
          ],
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final AIBillingFeatureUsage feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.auto_awesome, color: AppColors.primary),
      title: Text(feature.featureSlug.replaceAll('_', ' ')),
      subtitle: Text('${feature.requestCount} ${l10n.wameedAIBillingRequests}'),
      trailing: Text(
        '\$${feature.billedCostUsd.toStringAsFixed(3)}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InvoiceListTile extends StatelessWidget {
  final AIBillingInvoicePreview invoice;

  const _InvoiceListTile({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: Icon(
        Icons.receipt_outlined,
        color: switch (invoice.status) {
          'paid' => AppColors.success,
          'overdue' => AppColors.error,
          _ => AppColors.warning,
        },
      ),
      title: Text(invoice.invoiceNumber),
      subtitle: Text('${localizedMonthName(l10n, invoice.month)} ${invoice.year}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${invoice.billedAmountUsd.toStringAsFixed(3)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
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
      onTap: () => context.push('${Routes.wameedAIBillingInvoices}/${invoice.id}'),
    );
  }
}
