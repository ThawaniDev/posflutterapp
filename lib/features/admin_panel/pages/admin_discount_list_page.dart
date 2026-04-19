import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminDiscountListPage extends ConsumerStatefulWidget {
  const AdminDiscountListPage({super.key});

  @override
  ConsumerState<AdminDiscountListPage> createState() => _AdminDiscountListPageState();
}

class _AdminDiscountListPageState extends ConsumerState<AdminDiscountListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(discountListProvider.notifier).loadDiscounts();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discountListProvider);

    final isLoading = state is DiscountListLoading;
    final hasError = state is DiscountListError;
    final isEmpty = state is DiscountListLoaded && state.discounts.isEmpty;

    return PosListPage(
      title: l10n.discounts,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(discountListProvider.notifier).loadDiscounts(),
      isEmpty: isEmpty,
      emptyTitle: 'No discounts found',
      emptyIcon: Icons.local_offer_outlined,
      actions: [PosButton(label: l10n.add, icon: Icons.add, onPressed: () {})],
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              DiscountListLoaded(:final discounts) => ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: discounts.length,
                itemBuilder: (context, index) {
                  final discount = discounts[index];
                  return _DiscountCard(discount: discount);
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

class _DiscountCard extends StatelessWidget {
  final Map<String, dynamic> discount;
  const _DiscountCard({required this.discount});

  @override
  Widget build(BuildContext context) {
    final type = discount['type'] ?? '';
    final value = discount['value'];
    final code = discount['code'] ?? '';

    return PosCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
          alignment: Alignment.center,
          child: Text(
            type == 'percentage' ? '%' : '\u0081',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(
          type == 'percentage' ? '$value% off' : '\u0081$value off',
          style: TextStyle(color: AppColors.mutedFor(context)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (discount['max_uses'] != null)
              Text('${discount['times_used'] ?? 0}/${discount['max_uses']} used', style: const TextStyle(fontSize: 12)),
            Text(
              'Valid to: ${discount['valid_to']?.toString().substring(0, 10) ?? 'N/A'}',
              style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
            ),
          ],
        ),
      ),
    );
  }
}
