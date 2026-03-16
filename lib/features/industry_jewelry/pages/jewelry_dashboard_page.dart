import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_jewelry/providers/jewelry_providers.dart';
import 'package:thawani_pos/features/industry_jewelry/providers/jewelry_state.dart';

class JewelryDashboardPage extends ConsumerStatefulWidget {
  const JewelryDashboardPage({super.key});

  @override
  ConsumerState<JewelryDashboardPage> createState() => _JewelryDashboardPageState();
}

class _JewelryDashboardPageState extends ConsumerState<JewelryDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(jewelryProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jewelryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jewelry'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Metal Rates'),
            Tab(text: 'Product Details'),
            Tab(text: 'Buybacks'),
          ],
        ),
      ),
      body: switch (state) {
        JewelryInitial() || JewelryLoading() => const Center(child: CircularProgressIndicator()),
        JewelryError(:final message) => Center(child: Text(message)),
        JewelryLoaded(:final metalRates, :final productDetails, :final buybacks) => TabBarView(
          controller: _tabController,
          children: [
            metalRates.isEmpty
                ? const Center(child: Text('No metal rates'))
                : ListView.builder(
                    itemCount: metalRates.length,
                    itemBuilder: (context, i) {
                      final r = metalRates[i];
                      return ListTile(
                        title: Text('${r.metalType.value} ${r.karat ?? ''}'),
                        subtitle: Text('Rate: ${r.ratePerGram.toStringAsFixed(2)}/g'),
                        trailing: r.buybackRatePerGram != null
                            ? Text('Buyback: ${r.buybackRatePerGram!.toStringAsFixed(2)}/g')
                            : null,
                      );
                    },
                  ),
            productDetails.isEmpty
                ? const Center(child: Text('No product details'))
                : ListView.builder(
                    itemCount: productDetails.length,
                    itemBuilder: (context, i) {
                      final d = productDetails[i];
                      return ListTile(
                        title: Text('${d.metalType.value} ${d.karat ?? ''} — ${d.grossWeightG}g'),
                        subtitle: Text('Net: ${d.netWeightG}g • Making: ${d.makingChargesValue}'),
                        trailing: d.certificateNumber != null ? Text(d.certificateNumber!) : null,
                      );
                    },
                  ),
            buybacks.isEmpty
                ? const Center(child: Text('No buyback transactions'))
                : ListView.builder(
                    itemCount: buybacks.length,
                    itemBuilder: (context, i) {
                      final b = buybacks[i];
                      return ListTile(
                        title: Text('${b.metalType.value} ${b.karat} — ${b.weightG}g'),
                        subtitle: Text('${b.paymentMethod.value} • ${b.ratePerGram.toStringAsFixed(2)}/g'),
                        trailing: Text('${b.totalAmount.toStringAsFixed(2)} OMR'),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
