import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_billing.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

class AIBillingInvoicesPage extends ConsumerStatefulWidget {
  const AIBillingInvoicesPage({super.key});

  @override
  ConsumerState<AIBillingInvoicesPage> createState() => _AIBillingInvoicesPageState();
}

class _AIBillingInvoicesPageState extends ConsumerState<AIBillingInvoicesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aiBillingInvoicesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiBillingInvoicesProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wameedAIBillingInvoices),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(aiBillingInvoicesProvider.notifier).load()),
        ],
      ),
      body: switch (state) {
        AIBillingInvoicesInitial() || AIBillingInvoicesLoading() => const Center(child: CircularProgressIndicator()),
        AIBillingInvoicesError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 16),
              PosButton(label: l10n.commonRetry, onPressed: () => ref.read(aiBillingInvoicesProvider.notifier).load()),
            ],
          ),
        ),
        AIBillingInvoicesLoaded(:final invoices, :final currentPage, :final lastPage, :final total, :final perPage) => Padding(
          padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
          child: isMobile
              ? _MobileInvoiceList(invoices: invoices, currentPage: currentPage, lastPage: lastPage, total: total)
              : PosDataTable<AIBillingInvoicePreview>(
                  columns: [
                    PosTableColumn(title: l10n.wameedAIBillingInvoiceNumber, flex: 2),
                    PosTableColumn(title: l10n.wameedAIBillingPeriod),
                    PosTableColumn(title: l10n.wameedAIBillingAmount, numeric: true),
                    PosTableColumn(title: l10n.wameedAIBillingStatus),
                    PosTableColumn(title: l10n.wameedAIBillingDueDate),
                  ],
                  items: invoices,
                  cellBuilder: (item, colIndex, _) => switch (colIndex) {
                    0 => Text(item.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w600)),
                    1 => Text('${_monthName(item.month)} ${item.year}'),
                    2 => Text(
                      '\$${item.billedAmountUsd.toStringAsFixed(3)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    3 => PosStatusBadge(
                      label: switch (item.status) {
                        'paid' => l10n.wameedAIBillingPaid,
                        'overdue' => l10n.wameedAIBillingOverdue,
                        _ => l10n.wameedAIBillingPending,
                      },
                      variant: switch (item.status) {
                        'paid' => PosStatusBadgeVariant.success,
                        'overdue' => PosStatusBadgeVariant.error,
                        _ => PosStatusBadgeVariant.warning,
                      },
                    ),
                    4 => Text(item.dueDate),
                    _ => const SizedBox.shrink(),
                  },
                  onRowTap: (item) => context.push('${Routes.wameedAIBillingInvoices}/${item.id}'),
                  currentPage: currentPage,
                  totalPages: lastPage,
                  totalItems: total,
                  itemsPerPage: perPage,
                  onPreviousPage: currentPage > 1
                      ? () => ref.read(aiBillingInvoicesProvider.notifier).load(page: currentPage - 1)
                      : null,
                  onNextPage: currentPage < lastPage
                      ? () => ref.read(aiBillingInvoicesProvider.notifier).load(page: currentPage + 1)
                      : null,
                  onPageChanged: (page) => ref.read(aiBillingInvoicesProvider.notifier).load(page: page),
                  emptyConfig: PosTableEmptyConfig(icon: Icons.receipt_long_outlined, title: l10n.wameedAIBillingNoInvoices),
                ),
        ),
      },
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month.clamp(1, 12) - 1];
  }
}

class _MobileInvoiceList extends ConsumerWidget {
  final List<AIBillingInvoicePreview> invoices;
  final int currentPage;
  final int lastPage;
  final int total;

  const _MobileInvoiceList({required this.invoices, required this.currentPage, required this.lastPage, required this.total});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(l10n.wameedAIBillingNoInvoices),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: invoices.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final inv = invoices[index];
              return ListTile(
                leading: Icon(
                  Icons.receipt_outlined,
                  color: switch (inv.status) {
                    'paid' => Colors.green,
                    'overdue' => Colors.red,
                    _ => Colors.orange,
                  },
                ),
                title: Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${_monthName(inv.month)} ${inv.year} · ${inv.dueDate}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${inv.billedAmountUsd.toStringAsFixed(3)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    PosStatusBadge(
                      label: switch (inv.status) {
                        'paid' => l10n.wameedAIBillingPaid,
                        'overdue' => l10n.wameedAIBillingOverdue,
                        _ => l10n.wameedAIBillingPending,
                      },
                      variant: switch (inv.status) {
                        'paid' => PosStatusBadgeVariant.success,
                        'overdue' => PosStatusBadgeVariant.error,
                        _ => PosStatusBadgeVariant.warning,
                      },
                    ),
                  ],
                ),
                onTap: () => context.push('${Routes.wameedAIBillingInvoices}/${inv.id}'),
              );
            },
          ),
        ),
        if (lastPage > 1)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ? () => ref.read(aiBillingInvoicesProvider.notifier).load(page: currentPage - 1)
                      : null,
                ),
                Text('$currentPage / $lastPage'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < lastPage
                      ? () => ref.read(aiBillingInvoicesProvider.notifier).load(page: currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month.clamp(1, 12) - 1];
  }
}
