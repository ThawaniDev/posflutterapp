import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_providers.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';
import 'package:thawani_pos/features/subscription/widgets/add_on_card.dart';

/// Page that displays available and active add-ons for the store's subscription.
class AddOnsPage extends ConsumerStatefulWidget {
  const AddOnsPage({super.key});

  @override
  ConsumerState<AddOnsPage> createState() => _AddOnsPageState();
}

class _AddOnsPageState extends ConsumerState<AddOnsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(addOnsProvider.notifier).loadAddOns();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addOnsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add-Ons'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My Add-Ons'),
          ],
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(AddOnsState state) {
    if (state is AddOnsLoading) {
      return Center(child: PosLoadingSkeleton.list());
    }

    if (state is AddOnsError) {
      return PosErrorState(message: state.message, onRetry: () => ref.read(addOnsProvider.notifier).loadAddOns());
    }

    if (state is AddOnsLoaded) {
      return TabBarView(controller: _tabController, children: [_buildAvailableTab(state), _buildMyAddOnsTab(state)]);
    }

    return const SizedBox.shrink();
  }

  Widget _buildAvailableTab(AddOnsLoaded state) {
    final available = state.availableAddOns;
    if (available.isEmpty) {
      return const PosEmptyState(title: 'No add-ons available', icon: Icons.extension_off);
    }

    final activeIds = state.storeAddOns.map((a) => a['plan_add_on_id']?.toString() ?? '').toSet();

    return RefreshIndicator(
      onRefresh: () async => ref.read(addOnsProvider.notifier).loadAddOns(),
      child: ListView.builder(
        padding: AppSpacing.paddingAllMd,
        itemCount: available.length,
        itemBuilder: (context, index) {
          final addOn = available[index];
          final addOnId = addOn['id']?.toString() ?? '';
          final isActive = activeIds.contains(addOnId);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AddOnCard(
              name: addOn['name']?.toString() ?? 'Add-On',
              description: addOn['description']?.toString(),
              price: (addOn['price'] != null ? double.tryParse(addOn['price'].toString()) : null) ?? 0,
              billingCycle: addOn['billing_cycle']?.toString() ?? 'monthly',
              isActive: isActive,
              onToggle: () => _toggleAddOn(addOn, isActive),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyAddOnsTab(AddOnsLoaded state) {
    final myAddOns = state.storeAddOns;
    if (myAddOns.isEmpty) {
      return const PosEmptyState(title: 'No active add-ons', icon: Icons.extension);
    }

    return RefreshIndicator(
      onRefresh: () async => ref.read(addOnsProvider.notifier).loadAddOns(),
      child: ListView.builder(
        padding: AppSpacing.paddingAllMd,
        itemCount: myAddOns.length,
        itemBuilder: (context, index) {
          final storeAddOn = myAddOns[index];
          final planAddOn = storeAddOn['plan_add_on'] as Map<String, dynamic>?;
          final expiresAtStr = storeAddOn['expires_at']?.toString();
          final expiresAt = expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AddOnCard(
              name: planAddOn?['name']?.toString() ?? storeAddOn['plan_add_on_id']?.toString() ?? 'Add-On',
              description: planAddOn?['description']?.toString(),
              price: (planAddOn?['price'] != null ? double.tryParse(planAddOn!['price'].toString()) : null) ?? 0,
              billingCycle: planAddOn?['billing_cycle']?.toString() ?? 'monthly',
              isActive: true,
              expiresAt: expiresAt,
              onToggle: () => _confirmRemoveAddOn(storeAddOn),
            ),
          );
        },
      ),
    );
  }

  void _toggleAddOn(Map<String, dynamic> addOn, bool isActive) {
    if (isActive) {
      _confirmRemoveAddOn(addOn);
    } else {
      _confirmAddAddOn(addOn);
    }
  }

  void _confirmAddAddOn(Map<String, dynamic> addOn) {
    final name = addOn['name']?.toString() ?? 'this add-on';
    final price = (addOn['price'] != null ? double.tryParse(addOn['price'].toString()) : null) ?? 0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add $name?'),
        content: Text(
          'This will add $name to your subscription.\n\n'
          'Cost: ${price.toStringAsFixed(2)} \u0081/${addOn['billing_cycle'] ?? 'month'}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Add-on feature coming soon'), backgroundColor: AppColors.info));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveAddOn(Map<String, dynamic> addOn) {
    final name = addOn['name']?.toString() ?? addOn['plan_add_on']?['name']?.toString() ?? 'this add-on';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove $name?'),
        content: Text('Are you sure you want to remove $name from your subscription?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Remove add-on feature coming soon'), backgroundColor: AppColors.info));
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
