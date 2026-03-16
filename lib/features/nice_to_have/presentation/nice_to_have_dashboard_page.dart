import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _NiceToHaveDashboardPageState extends ConsumerState<NiceToHaveDashboardPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    Future.microtask(() {
      ref.read(appointmentProvider.notifier).load();
      ref.read(cfdConfigProvider.notifier).load();
      ref.read(giftRegistryProvider.notifier).load();
      ref.read(signageProvider.notifier).load();
      ref.read(gamificationProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nice-to-Have Features'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.favorite), text: 'Wishlist'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Appointments'),
            Tab(icon: Icon(Icons.monitor), text: 'CFD'),
            Tab(icon: Icon(Icons.card_giftcard), text: 'Gift Registry'),
            Tab(icon: Icon(Icons.slideshow), text: 'Signage'),
            Tab(icon: Icon(Icons.emoji_events), text: 'Gamification'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WishlistWidget(),
          AppointmentsWidget(),
          CfdConfigWidget(),
          GiftRegistryWidget(),
          SignageWidget(),
          GamificationWidget(),
        ],
      ),
    );
  }
}
