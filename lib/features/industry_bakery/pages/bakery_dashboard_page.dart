import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_bakery/providers/bakery_providers.dart';
import 'package:thawani_pos/features/industry_bakery/providers/bakery_state.dart';

class BakeryDashboardPage extends ConsumerStatefulWidget {
  const BakeryDashboardPage({super.key});

  @override
  ConsumerState<BakeryDashboardPage> createState() => _BakeryDashboardPageState();
}

class _BakeryDashboardPageState extends ConsumerState<BakeryDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(bakeryProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bakeryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bakery'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recipes'),
            Tab(text: 'Production'),
            Tab(text: 'Cake Orders'),
          ],
        ),
      ),
      body: switch (state) {
        BakeryInitial() || BakeryLoading() => const Center(child: CircularProgressIndicator()),
        BakeryError(:final message) => Center(child: Text(message)),
        BakeryLoaded(:final recipes, :final productionSchedules, :final cakeOrders) => TabBarView(
          controller: _tabController,
          children: [
            recipes.isEmpty
                ? const Center(child: Text('No recipes'))
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, i) {
                      final r = recipes[i];
                      return ListTile(
                        title: Text(r.name),
                        subtitle: Text(
                          'Yield: ${r.expectedYield}'
                          '${r.prepTimeMinutes != null ? ' • Prep: ${r.prepTimeMinutes}m' : ''}'
                          '${r.bakeTimeMinutes != null ? ' • Bake: ${r.bakeTimeMinutes}m' : ''}',
                        ),
                        trailing: r.bakeTemperatureC != null ? Text('${r.bakeTemperatureC}°C') : null,
                      );
                    },
                  ),
            productionSchedules.isEmpty
                ? const Center(child: Text('No production schedules'))
                : ListView.builder(
                    itemCount: productionSchedules.length,
                    itemBuilder: (context, i) {
                      final s = productionSchedules[i];
                      return ListTile(
                        title: Text('Planned: ${s.plannedBatches} batches • Yield: ${s.plannedYield}'),
                        subtitle: Text('Actual: ${s.actualBatches ?? '—'} batches • ${s.actualYield ?? '—'} yield'),
                        trailing: Chip(label: Text(s.status?.value ?? 'planned')),
                      );
                    },
                  ),
            cakeOrders.isEmpty
                ? const Center(child: Text('No cake orders'))
                : ListView.builder(
                    itemCount: cakeOrders.length,
                    itemBuilder: (context, i) {
                      final c = cakeOrders[i];
                      return ListTile(
                        title: Text(c.description),
                        subtitle: Text(
                          '${c.size ?? ''} ${c.flavor ?? ''}'
                          '${c.deliveryTime != null ? ' • ${c.deliveryTime}' : ''}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${c.price.toStringAsFixed(2)} OMR'),
                            Text(c.status?.value ?? 'ordered', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
