import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'nice_to_have_providers.dart';
import 'widgets/wishlist_widget.dart';
import 'widgets/appointments_widget.dart';
import 'widgets/cfd_config_widget.dart';
import 'widgets/gift_registry_widget.dart';
import 'widgets/signage_widget.dart';
import 'widgets/gamification_widget.dart';

class NiceToHaveDashboardPage extends ConsumerStatefulWidget {
  const NiceToHaveDashboardPage({super.key});

  @override
  ConsumerState<NiceToHaveDashboardPage> createState() => _NiceToHaveDashboardPageState();
}

class _NiceToHaveDashboardPageState extends ConsumerState<NiceToHaveDashboardPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(appointmentProvider.notifier).load();
      ref.read(cfdConfigProvider.notifier).load();
      ref.read(giftRegistryProvider.notifier).load();
      ref.read(signageProvider.notifier).load();
      ref.read(gamificationProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: l10n.niceToHaveTitle,
      showSearch: false,
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.niceToHaveWishlist, icon: Icons.favorite),
              PosTabItem(label: l10n.niceToHaveAppointments, icon: Icons.calendar_today),
              PosTabItem(label: l10n.niceToHaveCfd, icon: Icons.monitor),
              PosTabItem(label: l10n.niceToHaveGiftRegistry, icon: Icons.card_giftcard),
              PosTabItem(label: l10n.niceToHaveSignage, icon: Icons.slideshow),
              PosTabItem(label: l10n.niceToHaveGamification, icon: Icons.emoji_events),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: const [
                WishlistWidget(),
                AppointmentsWidget(),
                CfdConfigWidget(),
                GiftRegistryWidget(),
                SignageWidget(),
                GamificationWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
