import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/orders/providers/order_providers.dart';
import 'package:thawani_pos/features/orders/providers/order_state.dart';

class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override
  ConsumerState<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(ordersProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: switch (state) {
        OrdersInitial() || OrdersLoading() => const Center(child: CircularProgressIndicator()),
        OrdersError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: AppColors.error)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(ordersProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        OrdersLoaded(:final orders) =>
          orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text(order.orderNumber),
                      subtitle: Text('Status: ${order.status.name}'),
                      trailing: Text('\$${order.total.toStringAsFixed(2)}'),
                    );
                  },
                ),
      },
    );
  }
}
