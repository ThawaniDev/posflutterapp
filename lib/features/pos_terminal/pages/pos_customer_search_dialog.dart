import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';

class PosCustomerSearchDialog extends ConsumerStatefulWidget {
  const PosCustomerSearchDialog({super.key});

  @override
  ConsumerState<PosCustomerSearchDialog> createState() => _PosCustomerSearchDialogState();
}

class _PosCustomerSearchDialogState extends ConsumerState<PosCustomerSearchDialog> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.length >= 2) {
      ref.read(posCustomersProvider.notifier).search(query);
    }
  }

  void _selectCustomer(Customer customer) {
    ref.read(cartProvider.notifier).setCustomer(customer);
    Navigator.pop(context);
    showPosSuccessSnackbar(context, 'Customer: ${customer.name}');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customersState = ref.watch(posCustomersProvider);
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.person_search_rounded, color: AppColors.info, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(child: Text(AppLocalizations.of(context)!.posFindCustomer, style: AppTypography.headlineSmall)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              AppSpacing.gapH16,

              // Search input
              PosSearchField(
                controller: _searchController,
                hint: AppLocalizations.of(context)!.posSearchCustomerHint,
                autofocus: true,
                onChanged: _onSearch,
              ),
              AppSpacing.gapH16,

              // Results
              Expanded(child: _buildResults(customersState, isDark, mutedColor)),

              AppSpacing.gapH12,
              PosButton(
                label: AppLocalizations.of(context)!.posCancel,
                variant: PosButtonVariant.outline,
                isFullWidth: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(PosCustomersState state, bool isDark, Color mutedColor) {
    if (state is PosCustomersInitial) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search_rounded, size: 48, color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight),
            AppSpacing.gapH8,
            Text(AppLocalizations.of(context)!.posSearchForCustomer, style: AppTypography.bodySmall.copyWith(color: mutedColor)),
          ],
        ),
      );
    }

    if (state is PosCustomersLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state is PosCustomersError) {
      return PosErrorState(message: state.message);
    }

    final customers = state is PosCustomersLoaded ? state.customers : <Customer>[];

    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined, size: 48, color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight),
            AppSpacing.gapH8,
            Text(AppLocalizations.of(context)!.posNoCustomersFound, style: AppTypography.bodySmall.copyWith(color: mutedColor)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: customers.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: isDark ? AppColors.borderLight : AppColors.borderLight),
      itemBuilder: (context, index) => _CustomerTile(
        customer: customers[index],
        onTap: () => _selectCustomer(customers[index]),
        isDark: isDark,
        mutedColor: mutedColor,
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer, required this.onTap, required this.isDark, required this.mutedColor});

  final Customer customer;
  final VoidCallback onTap;
  final bool isDark;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
              child: Center(
                child: Text(
                  customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name, style: AppTypography.labelMedium),
                  Text(customer.phone, style: AppTypography.bodySmall.copyWith(color: mutedColor)),
                ],
              ),
            ),
            if (customer.loyaltyPoints != null && customer.loyaltyPoints! > 0)
              PosBadge(label: '${customer.loyaltyPoints} pts', variant: PosBadgeVariant.primary, isSmall: true),
          ],
        ),
      ),
    );
  }
}
