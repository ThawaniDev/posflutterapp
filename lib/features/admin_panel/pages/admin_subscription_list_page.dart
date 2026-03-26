import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminSubscriptionListPage extends ConsumerStatefulWidget {
  const AdminSubscriptionListPage({super.key});

  @override
  ConsumerState<AdminSubscriptionListPage> createState() => _AdminSubscriptionListPageState();
}

class _AdminSubscriptionListPageState extends ConsumerState<AdminSubscriptionListPage> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(subscriptionListProvider.notifier).loadSubscriptions());
  }

  void _onFilterChanged(String? status) {
    setState(() => _statusFilter = status);
    ref.read(subscriptionListProvider.notifier).loadSubscriptions(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Subscriptions')),
      body: Column(
        children: [
          // Status filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All', selected: _statusFilter == null, onSelected: () => _onFilterChanged(null)),
                  for (final s in ['active', 'trial', 'grace', 'cancelled'])
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: s[0].toUpperCase() + s.substring(1),
                        selected: _statusFilter == s,
                        onSelected: () => _onFilterChanged(s),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: switch (state) {
              SubscriptionListLoading() => const Center(child: CircularProgressIndicator()),
              SubscriptionListError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, style: const TextStyle(color: AppColors.error)),
                    AppSpacing.gapH16,
                    PosButton(
                      label: 'Retry',
                      variant: PosButtonVariant.outline,
                      onPressed: () => ref.read(subscriptionListProvider.notifier).loadSubscriptions(status: _statusFilter),
                    ),
                  ],
                ),
              ),
              SubscriptionListLoaded(:final subscriptions) =>
                subscriptions.isEmpty
                    ? const Center(child: Text('No subscriptions found'))
                    : ListView.builder(
                        padding: AppSpacing.paddingAll16,
                        itemCount: subscriptions.length,
                        itemBuilder: (context, index) {
                          final sub = subscriptions[index];
                          return _SubscriptionCard(subscription: sub);
                        },
                      ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> subscription;
  const _SubscriptionCard({required this.subscription});

  Color _statusColor(String status) {
    return switch (status) {
      'active' => AppColors.success,
      'trial' => AppColors.warning,
      'grace' => AppColors.warning,
      'cancelled' => AppColors.error,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final status = subscription['status'] ?? '';
    final plan = subscription['plan'] as Map<String, dynamic>?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(plan?['name'] ?? 'Unknown Plan', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Store: ${subscription['store_id']?.toString().substring(0, 8) ?? 'N/A'}',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(
            status.toUpperCase(),
            style: TextStyle(color: _statusColor(status), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
