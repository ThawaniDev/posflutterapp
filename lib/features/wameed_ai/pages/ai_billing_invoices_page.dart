import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_billing.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/utils/ai_helpers.dart';

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

    return PosListPage(
  title: l10n.wameedAIBillingInvoices,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(aiBillingInvoicesProvider.notifier).load(),
  ),
],
  child: switch (state) {
        AIBillingInvoicesInitial() || AIBillingInvoicesLoading() => const PosLoading(),
        AIBillingInvoicesError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(aiBillingInvoicesProvider.notifier).load(),
        ),
        AIBillingInvoicesLoaded(:final invoices, :final currentPage, :final lastPage, :final total, :final perPage) => Padding(
          padding: context.responsivePagePadding,
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
                    1 => Text('${localizedMonthName(l10n, item.month)} ${item.year}'),
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
}

class _MobileInvoiceList extends ConsumerWidget {

  const _MobileInvoiceList({required this.invoices, required this.currentPage, required this.lastPage, required this.total});
  final List<AIBillingInvoicePreview> invoices;
  final int currentPage;
  final int lastPage;
  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textSecondary),
            AppSpacing.gapH12,
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
                    'paid' => AppColors.success,
                    'overdue' => AppColors.error,
                    _ => AppColors.warning,
                  },
                ),
                title: Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${localizedMonthName(l10n, inv.month)} ${inv.year} · ${inv.dueDate}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${inv.billedAmountUsd.toStringAsFixed(3)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    AppSpacing.gapH4,
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
}
