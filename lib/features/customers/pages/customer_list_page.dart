import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/customers/providers/customer_providers.dart';
import 'package:thawani_pos/features/customers/providers/customer_state.dart';

class CustomerListPage extends ConsumerStatefulWidget {
  const CustomerListPage({super.key});

  @override
  ConsumerState<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends ConsumerState<CustomerListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(customersProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: switch (state) {
        CustomersInitial() || CustomersLoading() => const Center(child: CircularProgressIndicator()),
        CustomersError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(customersProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        CustomersLoaded(:final customers) =>
          customers.isEmpty
              ? const Center(child: Text('No customers found'))
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return ListTile(
                      title: Text(customer.name ?? 'Unnamed'),
                      subtitle: Text(customer.phone ?? customer.email ?? ''),
                      trailing: customer.loyaltyPoints != null ? Text('${customer.loyaltyPoints} pts') : null,
                    );
                  },
                ),
      },
    );
  }
}
