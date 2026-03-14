import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminDiscountListPage extends ConsumerStatefulWidget {
  const AdminDiscountListPage({super.key});

  @override
  ConsumerState<AdminDiscountListPage> createState() => _AdminDiscountListPageState();
}

class _AdminDiscountListPageState extends ConsumerState<AdminDiscountListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(discountListProvider.notifier).loadDiscounts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discountListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create discount
            },
          ),
        ],
      ),
      body: switch (state) {
        DiscountListLoading() => const Center(child: CircularProgressIndicator()),
        DiscountListError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: AppColors.error)),
              AppSpacing.verticalGap16,
              PosButton(
                label: 'Retry',
                variant: PosButtonVariant.outline,
                onPressed: () => ref.read(discountListProvider.notifier).loadDiscounts(),
              ),
            ],
          ),
        ),
        DiscountListLoaded(:final discounts) =>
          discounts.isEmpty
              ? const Center(child: Text('No discounts found'))
              : ListView.builder(
                  padding: AppSpacing.paddingAll16,
                  itemCount: discounts.length,
                  itemBuilder: (context, index) {
                    final discount = discounts[index];
                    return _DiscountCard(discount: discount);
                  },
                ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _DiscountCard extends StatelessWidget {
  final Map<String, dynamic> discount;
  const _DiscountCard({required this.discount});

  @override
  Widget build(BuildContext context) {
    final type = discount['type'] ?? '';
    final value = discount['value'];
    final code = discount['code'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Text(
            type == 'percentage' ? '%' : '\$',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(type == 'percentage' ? '$value% off' : '\$$value off', style: TextStyle(color: AppColors.textSecondary)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (discount['max_uses'] != null)
              Text('${discount['times_used'] ?? 0}/${discount['max_uses']} used', style: const TextStyle(fontSize: 12)),
            Text(
              'Valid to: ${discount['valid_to']?.toString().substring(0, 10) ?? 'N/A'}',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
