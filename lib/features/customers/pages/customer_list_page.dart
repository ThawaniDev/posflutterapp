import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';

class CustomerListPage extends ConsumerStatefulWidget {
  const CustomerListPage({super.key});

  @override
  ConsumerState<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends ConsumerState<CustomerListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(customersProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isLoading = state is CustomersInitial || state is CustomersLoading;
    final hasError = state is CustomersError;
    final errorMessage = state is CustomersError ? state.message : null;
    final customers = state is CustomersLoaded ? state.customers : const [];

    return PosListPage(
      title: l10n.customers,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showCustomerListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
      ],
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: errorMessage,
      onRetry: () => ref.read(customersProvider.notifier).load(),
      isEmpty: customers.isEmpty,
      emptyTitle: l10n.customersNoCustomersFound,
      emptyIcon: Icons.people_outline_rounded,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: customers.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final customer = customers[index];
          return PosCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                PosAvatar(name: customer.name, radius: 20),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer.name, style: AppTypography.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        customer.email ?? customer.phone,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.mutedFor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                if (customer.loyaltyPoints != null)
                  PosBadge(label: l10n.customersPoints(customer.loyaltyPoints!), variant: PosBadgeVariant.info),
              ],
            ),
          );
        },
      ),
    );
  }
}
