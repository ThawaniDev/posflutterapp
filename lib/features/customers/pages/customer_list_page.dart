import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customers)),
      body: switch (state) {
        CustomersInitial() || CustomersLoading() => const Center(child: CircularProgressIndicator()),
        CustomersError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: AppColors.error)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(customersProvider.notifier).load(), child: Text(l10n.commonRetry)),
            ],
          ),
        ),
        CustomersLoaded(:final customers) =>
          customers.isEmpty
              ? Center(child: Text(l10n.customersNoCustomersFound))
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: Text(customer.email ?? customer.phone),
                      trailing: customer.loyaltyPoints != null ? Text(l10n.customersPoints(customer.loyaltyPoints!)) : null,
                    );
                  },
                ),
      },
    );
  }
}
