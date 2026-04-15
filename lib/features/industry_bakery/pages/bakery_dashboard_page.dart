import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_bakery/providers/bakery_providers.dart';
import 'package:wameedpos/features/industry_bakery/providers/bakery_state.dart';
import 'package:wameedpos/features/industry_bakery/widgets/recipe_card.dart';
import 'package:wameedpos/features/industry_bakery/widgets/cake_order_card.dart';
import 'package:wameedpos/features/industry_bakery/widgets/production_schedule_card.dart';
import 'package:wameedpos/features/industry_bakery/pages/recipe_form_page.dart';
import 'package:wameedpos/features/industry_bakery/pages/cake_order_form_page.dart';
import 'package:wameedpos/features/industry_bakery/pages/production_schedule_form_page.dart';

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
    _tabController.addListener(() => setState(() {}));
    Future.microtask(() => ref.read(bakeryProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    final page = switch (_tabController.index) {
      0 => const RecipeFormPage(),
      1 => const ProductionScheduleFormPage(),
      _ => const CakeOrderFormPage(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      ref.read(bakeryProvider.notifier).load();
    });
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
      floatingActionButton: PosButton(onPressed: _onFabPressed, label: 'Add'),
      body: switch (state) {
        BakeryInitial() || BakeryLoading() => PosLoadingSkeleton.list(),
        BakeryError(:final message) => PosErrorState(message: message, onRetry: () => ref.read(bakeryProvider.notifier).load()),
        BakeryLoaded(:final recipes, :final productionSchedules, :final cakeOrders) => TabBarView(
          controller: _tabController,
          children: [
            recipes.isEmpty
                ? const PosEmptyState(title: 'No recipes yet', icon: Icons.bakery_dining)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: recipes.length,
                    itemBuilder: (context, i) {
                      final r = recipes[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RecipeCard(
                          recipe: r,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => RecipeFormPage(recipe: r)))
                                .then((_) => ref.read(bakeryProvider.notifier).load());
                          },
                        ),
                      );
                    },
                  ),
            productionSchedules.isEmpty
                ? const PosEmptyState(title: 'No production schedules', icon: Icons.schedule)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: productionSchedules.length,
                    itemBuilder: (context, i) {
                      final s = productionSchedules[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ProductionScheduleCard(
                          schedule: s,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => ProductionScheduleFormPage(schedule: s)))
                                .then((_) => ref.read(bakeryProvider.notifier).load());
                          },
                        ),
                      );
                    },
                  ),
            cakeOrders.isEmpty
                ? const PosEmptyState(title: 'No cake orders', icon: Icons.cake)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cakeOrders.length,
                    itemBuilder: (context, i) {
                      final c = cakeOrders[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CakeOrderCard(
                          order: c,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => CakeOrderFormPage(order: c)))
                                .then((_) => ref.read(bakeryProvider.notifier).load());
                          },
                          onStatusChange: (status) {
                            ref.read(bakeryProvider.notifier).updateCakeOrderStatus(c.id, status.name);
                          },
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
