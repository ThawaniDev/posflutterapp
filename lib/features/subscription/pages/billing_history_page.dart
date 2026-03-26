import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_providers.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';
import 'package:thawani_pos/features/subscription/widgets/invoice_tile.dart';

/// Page showing invoice/billing history.
class BillingHistoryPage extends ConsumerStatefulWidget {
  const BillingHistoryPage({super.key});

  @override
  ConsumerState<BillingHistoryPage> createState() => _BillingHistoryPageState();
}

class _BillingHistoryPageState extends ConsumerState<BillingHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(invoicesProvider.notifier).loadInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoicesState = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Billing History'), centerTitle: true),
      body: _buildBody(invoicesState),
    );
  }

  Widget _buildBody(InvoicesState state) {
    if (state is InvoicesLoading) {
      return Center(child: PosLoadingSkeleton.list());
    }

    if (state is InvoicesError) {
      return PosErrorState(message: state.message, onRetry: () => ref.read(invoicesProvider.notifier).loadInvoices());
    }

    if (state is InvoicesLoaded) {
      if (state.invoices.isEmpty) {
        return const PosEmptyState(title: 'No invoices yet', icon: Icons.receipt_long);
      }

      return RefreshIndicator(
        onRefresh: () async {
          ref.read(invoicesProvider.notifier).loadInvoices();
        },
        child: ListView.separated(
          padding: AppSpacing.paddingAllMd,
          itemCount: state.invoices.length,
          separatorBuilder: (_, __) => AppSpacing.verticalSm,
          itemBuilder: (context, index) {
            return InvoiceTile(invoice: state.invoices[index]);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
