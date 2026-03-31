import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/orders/enums/order_status.dart';
import 'package:thawani_pos/features/orders/models/order.dart';
import 'package:thawani_pos/features/orders/providers/order_providers.dart';
import 'package:thawani_pos/features/orders/providers/order_state.dart';

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
    switch (status) {
      case OrderStatus.newValue:
        return 'New';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.voided:
        return 'Voided';
    }
  }

  Future<void> _handleVoid(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Void Order'),
        content: Text('Void order "${order.orderNumber}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Void'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(ordersProvider.notifier).voidOrder(order.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order voided.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by status',
            onSelected: (value) {
              ref.read(ordersProvider.notifier).filterByStatus(value);
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: null, child: Text('All')),
              const PopupMenuItem(value: 'new', child: Text('New')),
              const PopupMenuItem(value: 'confirmed', child: Text('Confirmed')),
              const PopupMenuItem(value: 'preparing', child: Text('Preparing')),
              const PopupMenuItem(value: 'ready', child: Text('Ready')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
              const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
              const PopupMenuItem(value: 'voided', child: Text('Voided')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(ordersProvider.notifier).load(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PosTextField(
              controller: _searchController,
              hint: 'Search by order number...',
              prefixIcon: Icons.search,
              onSubmitted: (value) => ref.read(ordersProvider.notifier).search(value),
            ),
          ),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(OrdersState state) {
    final isLoading = state is OrdersLoading || state is OrdersInitial;
    final error = state is OrdersError ? state.message : null;
    final orders = state is OrdersLoaded ? state.orders : <Order>[];
    final loaded = state is OrdersLoaded ? state : null;

    return PosDataTable<Order>(
      columns: const [
        PosTableColumn(title: 'Order #'),
        PosTableColumn(title: 'Source'),
        PosTableColumn(title: 'Status'),
        PosTableColumn(title: 'Subtotal', numeric: true),
        PosTableColumn(title: 'Tax', numeric: true),
        PosTableColumn(title: 'Total', numeric: true),
        PosTableColumn(title: 'Date'),
      ],
      items: orders,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(ordersProvider.notifier).load(),
      emptyConfig: const PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: 'No orders found',
        subtitle: 'Orders will appear here once transactions are made.',
      ),
      actions: [
        PosTableRowAction<Order>(
          label: 'Void',
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
