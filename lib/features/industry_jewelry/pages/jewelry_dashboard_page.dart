import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_jewelry/providers/jewelry_providers.dart';
import 'package:wameedpos/features/industry_jewelry/providers/jewelry_state.dart';
import 'package:wameedpos/features/industry_jewelry/widgets/metal_rate_card.dart';
import 'package:wameedpos/features/industry_jewelry/widgets/jewelry_detail_card.dart';
import 'package:wameedpos/features/industry_jewelry/widgets/buyback_card.dart';
import 'package:wameedpos/features/industry_jewelry/widgets/jewelry_price_calculator.dart';
import 'package:wameedpos/features/industry_jewelry/pages/metal_rate_form_page.dart';
import 'package:wameedpos/features/industry_jewelry/pages/product_detail_form_page.dart';
import 'package:wameedpos/features/industry_jewelry/pages/buyback_form_page.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class JewelryDashboardPage extends ConsumerStatefulWidget {
  const JewelryDashboardPage({super.key});

  @override
  ConsumerState<JewelryDashboardPage> createState() => _JewelryDashboardPageState();
}

class _JewelryDashboardPageState extends ConsumerState<JewelryDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(jewelryProvider.notifier).load());
  }

  void _onFabPressed() {
    final page = switch (_currentTab) {
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
    final isLoading = state is JewelryInitial || state is JewelryLoading;
    final hasError = state is JewelryError;

    final content = PosListPage(
      title: l10n.jewelryTitle,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(jewelryProvider.notifier).load(),
      actions: [
        PosButton(label: l10n.jewelryPriceCalculator, icon: Icons.calculate_outlined, onPressed: () => showJewelryPriceCalculator(context)),
        const SizedBox(width: 8),
        PosButton(label: l10n.add, icon: Icons.add, onPressed: _onFabPressed),
      ],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.jewelryMetalRates),
              PosTabItem(label: l10n.jewelryProductDetails),
              PosTabItem(label: l10n.jewelryBuybacks),
            ],
          ),
          Expanded(
            child: state is JewelryLoaded
                ? IndexedStack(
                    index: _currentTab,
                    children: [
                      state.metalRates.isEmpty
                          ? PosEmptyState(title: l10n.jewelryNoMetalRates, icon: Icons.monetization_on)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.metalRates.length,
                              itemBuilder: (context, i) {
                                final r = state.metalRates[i];
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
                      state.productDetails.isEmpty
                          ? PosEmptyState(title: l10n.jewelryNoProductDetails, icon: Icons.diamond)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.productDetails.length,
                              itemBuilder: (context, i) {
                                final d = state.productDetails[i];
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
                      state.buybacks.isEmpty
                          ? PosEmptyState(title: l10n.jewelryNoBuybacks, icon: Icons.swap_horiz)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.buybacks.length,
                              itemBuilder: (context, i) {
                                final b = state.buybacks[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: BuybackCard(buyback: b),
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
      permission: Permissions.jewelryView,
      child: content,
    );
  }
}
