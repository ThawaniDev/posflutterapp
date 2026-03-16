import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/pos_customization/providers/customization_providers.dart';
import 'package:thawani_pos/features/pos_customization/widgets/pos_settings_widget.dart';
import 'package:thawani_pos/features/pos_customization/widgets/receipt_template_widget.dart';
import 'package:thawani_pos/features/pos_customization/widgets/quick_access_widget.dart';

class CustomizationDashboardPage extends ConsumerStatefulWidget {
  const CustomizationDashboardPage({super.key});

  @override
  ConsumerState<CustomizationDashboardPage> createState() => _CustomizationDashboardPageState();
}

class _CustomizationDashboardPageState extends ConsumerState<CustomizationDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(customizationSettingsProvider.notifier).load();
      ref.read(receiptTemplateProvider.notifier).load();
      ref.read(quickAccessProvider.notifier).load();
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
        title: const Text('POS Customization'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.palette), text: 'Theme'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Receipt'),
            Tab(icon: Icon(Icons.grid_view), text: 'Quick Access'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [PosSettingsWidget(), ReceiptTemplateWidget(), QuickAccessWidget()],
      ),
    );
  }
}
