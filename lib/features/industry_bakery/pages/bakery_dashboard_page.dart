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
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class BakeryDashboardPage extends ConsumerStatefulWidget {
  const BakeryDashboardPage({super.key});

  @override
  ConsumerState<BakeryDashboardPage> createState() => _BakeryDashboardPageState();
}

class _BakeryDashboardPageState extends ConsumerState<BakeryDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bakeryProvider.notifier).load());
  }

  void _onFabPressed() {
    final page = switch (_currentTab) {
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
    final isLoading = state is BakeryInitial || state is BakeryLoading;
    final hasError = state is BakeryError;

    final content = PosListPage(
      title: l10n.bakeryTitle,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(bakeryProvider.notifier).load(),
      actions: [PosButton(label: l10n.add, icon: Icons.add, onPressed: _onFabPressed)],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.bakeryRecipes),
              PosTabItem(label: l10n.production),
              PosTabItem(label: l10n.bakeryCakeOrders),
            ],
          ),
          Expanded(
            child: state is BakeryLoaded
                ? IndexedStack(
                    index: _currentTab,
                    children: [
                      state.recipes.isEmpty
                          ? PosEmptyState(title: l10n.bakeryNoRecipes, icon: Icons.bakery_dining)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.recipes.length,
                              itemBuilder: (context, i) {
                                final r = state.recipes[i];
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
                      state.productionSchedules.isEmpty
                          ? PosEmptyState(title: l10n.bakeryNoSchedules, icon: Icons.schedule)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.productionSchedules.length,
                              itemBuilder: (context, i) {
                                final s = state.productionSchedules[i];
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
                      state.cakeOrders.isEmpty
                          ? PosEmptyState(title: l10n.bakeryNoCakeOrders, icon: Icons.cake)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.cakeOrders.length,
                              itemBuilder: (context, i) {
                                final c = state.cakeOrders[i];
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
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
    return PermissionGuardPage(
      permission: Permissions.bakeryView,
      child: content,
    );
  }
}
