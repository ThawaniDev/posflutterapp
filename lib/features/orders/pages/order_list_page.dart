import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/core/widgets/pos_mobile_data_list.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/orders/enums/order_status.dart';
import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/providers/order_providers.dart';
import 'package:wameedpos/features/orders/providers/order_state.dart';

class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override
  ConsumerState<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(ordersProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  PosBadgeVariant _statusVariant(OrderStatus status) {
    switch (status) {
      case OrderStatus.newValue:
        return PosBadgeVariant.info;
      case OrderStatus.confirmed:
        return PosBadgeVariant.info;
      case OrderStatus.preparing:
        return PosBadgeVariant.warning;
      case OrderStatus.ready:
        return PosBadgeVariant.success;
      case OrderStatus.dispatched:
        return PosBadgeVariant.info;
      case OrderStatus.delivered:
      case OrderStatus.pickedUp:
      case OrderStatus.completed:
        return PosBadgeVariant.success;
      case OrderStatus.cancelled:
      case OrderStatus.voided:
        return PosBadgeVariant.error;
    }
  }

  String _statusLabel(OrderStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case OrderStatus.newValue:
        return l10n.ordersNew;
      case OrderStatus.confirmed:
        return l10n.ordersConfirmed;
      case OrderStatus.preparing:
        return l10n.ordersPreparing;
      case OrderStatus.ready:
        return l10n.ordersReady;
      case OrderStatus.dispatched:
        return l10n.ordersDispatched;
      case OrderStatus.delivered:
        return l10n.ordersDelivered;
      case OrderStatus.pickedUp:
        return l10n.ordersPickedUp;
      case OrderStatus.completed:
        return l10n.ordersCompleted;
      case OrderStatus.cancelled:
        return l10n.ordersCancelled;
      case OrderStatus.voided:
        return l10n.ordersVoided;
    }
  }

  Future<void> _handleVoid(Order order) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.ordersVoidOrder,
      message: l10n.ordersVoidConfirm(order.orderNumber),
      confirmLabel: l10n.ordersVoid,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(ordersProvider.notifier).voidOrder(order.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.ordersVoided2);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(ordersProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orders),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.featureInfoTooltip,
            onPressed: () => showOrderListInfo(context),
          ),
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.ordersFilterByStatus,
            onSelected: (value) {
              ref.read(ordersProvider.notifier).filterByStatus(value);
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: null, child: Text(l10n.ordersAll)),
              PopupMenuItem(value: 'new', child: Text(l10n.ordersNew)),
              PopupMenuItem(value: 'confirmed', child: Text(l10n.ordersConfirmed)),
              PopupMenuItem(value: 'preparing', child: Text(l10n.ordersPreparing)),
              PopupMenuItem(value: 'ready', child: Text(l10n.ordersReady)),
              PopupMenuItem(value: 'completed', child: Text(l10n.ordersCompleted)),
              PopupMenuItem(value: 'cancelled', child: Text(l10n.ordersCancelled)),
              PopupMenuItem(value: 'voided', child: Text(l10n.ordersVoided)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(ordersProvider.notifier).load(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.md),
            child: PosTextField(
              controller: _searchController,
              hint: l10n.ordersSearchByNumber,
              prefixIcon: Icons.search,
              onSubmitted: (value) => ref.read(ordersProvider.notifier).search(value),
            ),
          ),
          Expanded(child: isMobile ? _buildMobileBody(state) : _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildMobileBody(OrdersState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is OrdersLoading || state is OrdersInitial;
    final error = state is OrdersError ? state.message : null;
    final orders = state is OrdersLoaded ? state.orders : <Order>[];
    final loaded = state is OrdersLoaded ? state : null;

    return PosMobileDataList<Order>(
      items: orders,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(ordersProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: l10n.ordersNoOrders,
        subtitle: l10n.ordersNoOrdersSubtitle,
      ),
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      onPreviousPage: loaded != null ? () => ref.read(ordersProvider.notifier).previousPage() : null,
      onNextPage: loaded != null ? () => ref.read(ordersProvider.notifier).nextPage() : null,
      onRefresh: () async => ref.read(ordersProvider.notifier).load(),
      cardBuilder: (context, order, index) {
        return MobileListCard(
          title: Text(order.orderNumber, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          subtitle: Text(
            order.createdAt != null ? '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}' : '-',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          badges: [
            PosBadge(label: _statusLabel(order.status), variant: _statusVariant(order.status)),
            PosBadge(label: order.source.value, variant: PosBadgeVariant.neutral),
          ],
          infoRows: [
            MobileInfoRow(
              label: l10n.ordersSubtotal,
              value: '${order.subtotal.toStringAsFixed(2)} ﷼',
              icon: Icons.receipt_outlined,
            ),
            MobileInfoRow(label: l10n.ordersTax, value: '${order.taxAmount.toStringAsFixed(2)} ﷼', icon: Icons.percent),
            MobileInfoRow(
              label: l10n.ordersTotal,
              valueWidget: Text(
                '${order.total.toStringAsFixed(2)} ﷼',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              icon: Icons.payments_outlined,
            ),
          ],
          trailing: (order.status != OrderStatus.voided && order.status != OrderStatus.cancelled)
              ? IconButton(
                  icon: const Icon(Icons.block_outlined, size: 18),
                  onPressed: () => _handleVoid(order),
                  tooltip: l10n.ordersVoid,
                  color: AppColors.error,
                  visualDensity: VisualDensity.compact,
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(OrdersState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is OrdersLoading || state is OrdersInitial;
    final error = state is OrdersError ? state.message : null;
    final orders = state is OrdersLoaded ? state.orders : <Order>[];
    final loaded = state is OrdersLoaded ? state : null;

    return PosDataTable<Order>(
      columns: [
        PosTableColumn(title: l10n.ordersOrderNumberCol),
        PosTableColumn(title: l10n.ordersSource),
        PosTableColumn(title: l10n.ordersStatus),
        PosTableColumn(title: l10n.ordersSubtotal, numeric: true),
        PosTableColumn(title: l10n.ordersTax, numeric: true),
        PosTableColumn(title: l10n.ordersTotal, numeric: true),
        PosTableColumn(title: l10n.ordersDate),
      ],
      items: orders,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(ordersProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: l10n.ordersNoOrders,
        subtitle: l10n.ordersNoOrdersSubtitle,
      ),
      actions: [
        PosTableRowAction<Order>(
          label: l10n.ordersVoid,
          icon: Icons.block_outlined,
          isDestructive: true,
          isVisible: (o) => o.status != OrderStatus.voided && o.status != OrderStatus.cancelled,
          onTap: (o) => _handleVoid(o),
        ),
      ],
      cellBuilder: (order, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.w600));
          case 1:
            return Text(order.source.value);
          case 2:
            return PosBadge(label: _statusLabel(order.status), variant: _statusVariant(order.status));
          case 3:
            return Text(order.subtotal.toStringAsFixed(2));
          case 4:
            return Text(order.taxAmount.toStringAsFixed(2));
          case 5:
            return Text(order.total.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w600));
          case 6:
            return Text(
              order.createdAt != null ? '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}' : '-',
            );
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 25,
      onPreviousPage: loaded != null ? () => ref.read(ordersProvider.notifier).previousPage() : null,
      onNextPage: loaded != null ? () => ref.read(ordersProvider.notifier).nextPage() : null,
    );
  }
}
