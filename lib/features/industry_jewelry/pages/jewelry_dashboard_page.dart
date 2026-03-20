import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/industry_jewelry/providers/jewelry_providers.dart';
import 'package:thawani_pos/features/industry_jewelry/providers/jewelry_state.dart';
import 'package:thawani_pos/features/industry_jewelry/widgets/metal_rate_card.dart';
import 'package:thawani_pos/features/industry_jewelry/widgets/jewelry_detail_card.dart';
import 'package:thawani_pos/features/industry_jewelry/widgets/buyback_card.dart';
import 'package:thawani_pos/features/industry_jewelry/pages/metal_rate_form_page.dart';
import 'package:thawani_pos/features/industry_jewelry/pages/product_detail_form_page.dart';
import 'package:thawani_pos/features/industry_jewelry/pages/buyback_form_page.dart';

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
    _tabController.addListener(() => setState(() {}));
    Future.microtask(() => ref.read(jewelryProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    final page = switch (_tabController.index) {
      0 => const MetalRateFormPage(),
      1 => const ProductDetailFormPage(),
      _ => const BuybackFormPage(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      ref.read(jewelryProvider.notifier).load();
    });
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
      floatingActionButton: FloatingActionButton(onPressed: _onFabPressed, child: const Icon(Icons.add)),
      body: switch (state) {
        JewelryInitial() || JewelryLoading() => const PosLoadingSkeleton(),
        JewelryError(:final message) => PosErrorState(message: message, onRetry: () => ref.read(jewelryProvider.notifier).load()),
        JewelryLoaded(:final metalRates, :final productDetails, :final buybacks) => TabBarView(
          controller: _tabController,
          children: [
            metalRates.isEmpty
                ? const PosEmptyState(message: 'No metal rates set', icon: Icons.monetization_on)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: metalRates.length,
                    itemBuilder: (context, i) {
                      final r = metalRates[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MetalRateCard(
                          rate: r,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => MetalRateFormPage(rate: r)))
                                .then((_) => ref.read(jewelryProvider.notifier).load());
                          },
                        ),
                      );
                    },
                  ),
            productDetails.isEmpty
                ? const PosEmptyState(message: 'No product details', icon: Icons.diamond)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: productDetails.length,
                    itemBuilder: (context, i) {
                      final d = productDetails[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: JewelryDetailCard(
                          detail: d,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => ProductDetailFormPage(detail: d)))
                                .then((_) => ref.read(jewelryProvider.notifier).load());
                          },
                        ),
                      );
                    },
                  ),
            buybacks.isEmpty
                ? const PosEmptyState(message: 'No buyback transactions', icon: Icons.swap_horiz)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: buybacks.length,
                    itemBuilder: (context, i) {
                      final b = buybacks[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BuybackCard(transaction: b),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
