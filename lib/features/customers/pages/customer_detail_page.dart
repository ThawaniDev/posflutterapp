import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';
import 'package:wameedpos/features/customers/services/digital_receipt_service.dart';

class CustomerDetailPage extends ConsumerStatefulWidget {
  const CustomerDetailPage({super.key, required this.customerId});
  final String customerId;

  @override
  ConsumerState<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends ConsumerState<CustomerDetailPage> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(customerDetailProvider(widget.customerId).notifier).load();
      ref.read(customerOrdersProvider(widget.customerId).notifier).load();
      ref.read(loyaltyLogProvider(widget.customerId).notifier).load();
      ref.read(storeCreditLogProvider(widget.customerId).notifier).load();
    });
  }

  Future<void> _adjustLoyalty(Customer customer) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customersAdjustLoyalty),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(
              controller: controller,
              label: l10n.customersLoyaltyPoints,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
            ),
            AppSpacing.gapH8,
            PosTextField(controller: notes, label: l10n.customersNotes, maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (ok == true) {
      final pts = int.tryParse(controller.text.trim()) ?? 0;
      if (pts == 0) return;
      await ref
          .read(loyaltyLogProvider(widget.customerId).notifier)
          .adjust(points: pts, type: 'ManualAdjustment', notes: notes.text.trim());
      await ref.read(customerDetailProvider(widget.customerId).notifier).load();
    }
  }

  Future<void> _topUpCredit(Customer customer) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customersTopUpCredit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(
              controller: controller,
              label: l10n.customersAmount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            AppSpacing.gapH8,
            PosTextField(controller: notes, label: l10n.customersNotes, maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (ok == true) {
      final amt = double.tryParse(controller.text.trim()) ?? 0;
      if (amt <= 0) return;
      await ref.read(storeCreditLogProvider(widget.customerId).notifier).topUp(amount: amt, notes: notes.text.trim());
      await ref.read(customerDetailProvider(widget.customerId).notifier).load();
    }
  }

  Future<void> _sendReceiptForOrder(String orderId) async {
    if (orderId.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final detailState = ref.read(customerDetailProvider(widget.customerId));
    if (detailState is! CustomerDetailLoaded) return;
    final customer = detailState.customer;

    final channel = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(l10n.customersReceiptViaEmail),
              enabled: (customer.email ?? '').isNotEmpty,
              onTap: () => Navigator.pop(ctx, 'email'),
            ),
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: Text(l10n.customersReceiptViaWhatsapp),
              enabled: customer.phone.isNotEmpty,
              onTap: () => Navigator.pop(ctx, 'whatsapp'),
            ),
            ListTile(
              leading: const Icon(Icons.sms_outlined),
              title: Text(l10n.customersReceiptViaSms),
              enabled: customer.phone.isNotEmpty,
              onTap: () => Navigator.pop(ctx, 'sms'),
            ),
          ],
        ),
      ),
    );
    if (channel == null || !mounted) return;

    final svc = ref.read(digitalReceiptServiceProvider);
    try {
      switch (channel) {
        case 'email':
          await svc.sendEmail(customerId: widget.customerId, orderId: orderId, destination: customer.email);
          break;
        case 'whatsapp':
          await svc.sendWhatsApp(
            customerId: widget.customerId,
            orderId: orderId,
            phone: customer.phone,
            receiptUrl: 'order:$orderId',
          );
          break;
        case 'sms':
          await svc.sendSms(customerId: widget.customerId, orderId: orderId, phone: customer.phone, body: 'order:$orderId');
          break;
      }
      if (!mounted) return;
      showPosSuccessSnackbar(context, l10n.customersSaved);
    } catch (e) {
      if (!mounted) return;
      showPosErrorSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detail = ref.watch(customerDetailProvider(widget.customerId));
    if (detail is CustomerDetailLoading || detail is CustomerDetailInitial) {
      return PosDetailPage(title: l10n.customersDetail, onBack: () => context.pop(), isLoading: true, child: const SizedBox());
    }
    if (detail is CustomerDetailError) {
      return PosDetailPage(
        title: l10n.customersDetail,
        onBack: () => context.pop(),
        child: Center(child: Text(detail.message)),
      );
    }
    final customer = detail is CustomerDetailLoaded ? detail.customer : null;
    if (customer == null) {
      return PosDetailPage(title: l10n.customersDetail, onBack: () => context.pop(), child: const SizedBox());
    }

    return PosDetailPage(
      title: customer.name,
      subtitle: customer.phone,
      onBack: () => context.pop(),
      actions: [
        PosButton.icon(
          icon: Icons.edit_outlined,
          tooltip: l10n.customersEdit,
          onPressed: () => context.push('/customers/${customer.id}/edit'),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(
          label: l10n.customersAdjustLoyalty,
          icon: Icons.workspace_premium,
          variant: PosButtonVariant.outline,
          onPressed: () => _adjustLoyalty(customer),
        ),
        AppSpacing.gapW8,
        PosButton(
          label: l10n.customersTopUpCredit,
          icon: Icons.account_balance_wallet_outlined,
          onPressed: () => _topUpCredit(customer),
        ),
      ],
      tabs: [
        PosTabItem(label: l10n.customersHistoryTab, icon: Icons.receipt_long_outlined),
        PosTabItem(label: l10n.customersLoyaltyTab, icon: Icons.workspace_premium_outlined),
        PosTabItem(label: l10n.customersCreditTab, icon: Icons.account_balance_wallet_outlined),
      ],
      selectedTabIndex: _tabIndex,
      onTabChanged: (i) => setState(() => _tabIndex = i),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _kpiRow(customer, l10n),
          AppSpacing.gapH16,
          if (_tabIndex == 0) _ordersTab(l10n) else if (_tabIndex == 1) _loyaltyTab(l10n) else _creditTab(l10n),
        ],
      ),
    );
  }

  Widget _kpiRow(Customer c, AppLocalizations l10n) {
    final visits = c.visitCount ?? 0;
    final spend = c.totalSpend ?? 0;
    final avgBasket = visits > 0 ? (spend / visits) : 0.0;
    return PosStatsGrid(
      children: [
        PosKpiCard(label: l10n.customersTotalSpend, value: spend.toStringAsFixed(2), icon: Icons.payments_outlined),
        PosKpiCard(label: l10n.customersVisitCount, value: '$visits', icon: Icons.repeat),
        PosKpiCard(label: l10n.customersAvgBasket, value: avgBasket.toStringAsFixed(2), icon: Icons.shopping_basket_outlined),
        PosKpiCard(label: l10n.customersLoyaltyPoints, value: '${c.loyaltyPoints ?? 0}', icon: Icons.workspace_premium),
        PosKpiCard(
          label: l10n.customersStoreCredit,
          value: (c.storeCreditBalance ?? 0).toStringAsFixed(2),
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
    );
  }

  Widget _ordersTab(AppLocalizations l10n) {
    final state = ref.watch(customerOrdersProvider(widget.customerId));
    if (state is CustomerOrdersLoading || state is CustomerOrdersInitial) return const PosLoading();
    if (state is CustomerOrdersError) return Center(child: Text(state.message));
    final loaded = state as CustomerOrdersLoaded;
    if (loaded.orders.isEmpty) {
      return PosEmptyState(title: l10n.customersNoCustomersFound, icon: Icons.receipt_long_outlined);
    }
    return Column(
      children: loaded.orders.map((o) {
        final number = o['order_number'] ?? o['id'];
        final total = (o['total'] as num?)?.toStringAsFixed(2) ?? '-';
        final dateStr = (o['created_at'] as String?)?.substring(0, 10) ?? '-';
        final status = o['status']?.toString() ?? '-';
        return PosCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#$number', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              PosBadge(label: status, variant: PosBadgeVariant.neutral),
              AppSpacing.gapW8,
              Text(total, style: const TextStyle(fontWeight: FontWeight.w700)),
              AppSpacing.gapW8,
              IconButton(
                icon: const Icon(Icons.mail_outline),
                tooltip: l10n.customersOrderSendReceipt,
                onPressed: () => _sendReceiptForOrder(o['id']?.toString() ?? ''),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _loyaltyTab(AppLocalizations l10n) {
    final state = ref.watch(loyaltyLogProvider(widget.customerId));
    if (state is LoyaltyLogLoading || state is LoyaltyLogInitial) return const PosLoading();
    if (state is LoyaltyLogError) return Center(child: Text(state.message));
    final loaded = state as LoyaltyLogLoaded;
    if (loaded.transactions.isEmpty) {
      return PosEmptyState(title: l10n.customersNoCustomersFound, icon: Icons.workspace_premium_outlined);
    }
    return Column(
      children: loaded.transactions.map((t) {
        return PosCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.type.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (t.notes != null) Text(t.notes!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text(
                (t.points >= 0 ? '+' : '') + t.points.toString(),
                style: TextStyle(fontWeight: FontWeight.w700, color: t.points >= 0 ? Colors.green : Colors.red),
              ),
              AppSpacing.gapW8,
              Text('= ${t.balanceAfter}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _creditTab(AppLocalizations l10n) {
    final state = ref.watch(storeCreditLogProvider(widget.customerId));
    if (state is StoreCreditLogLoading || state is StoreCreditLogInitial) return const PosLoading();
    if (state is StoreCreditLogError) return Center(child: Text(state.message));
    final loaded = state as StoreCreditLogLoaded;
    if (loaded.transactions.isEmpty) {
      return PosEmptyState(title: l10n.customersNoCustomersFound, icon: Icons.account_balance_wallet_outlined);
    }
    return Column(
      children: loaded.transactions.map((t) {
        return PosCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.type.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (t.notes != null) Text(t.notes!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text(
                (t.amount >= 0 ? '+' : '') + t.amount.toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.w700, color: t.amount >= 0 ? Colors.green : Colors.red),
              ),
              AppSpacing.gapW8,
              Text('= ${t.balanceAfter.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }
}
