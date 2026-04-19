import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/widgets/plan_comparison_table.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Page that displays a side-by-side comparison of all available plans.
class PlanComparisonPage extends ConsumerStatefulWidget {
  const PlanComparisonPage({super.key});

  @override
  ConsumerState<PlanComparisonPage> createState() => _PlanComparisonPageState();
}

class _PlanComparisonPageState extends ConsumerState<PlanComparisonPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool _isAnnual = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(plansProvider.notifier).loadPlans();
      ref.read(subscriptionProvider.notifier).loadCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plansState = ref.watch(plansProvider);
    final subState = ref.watch(subscriptionProvider);

    // Listen for subscription action results
    ref.listen<SubscriptionState>(subscriptionProvider, (prev, next) {
      if (next is SubscriptionActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        context.go(Routes.subscriptionStatus);
      } else if (next is SubscriptionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(title: l10n.subscriptionComparePlans, showSearch: false, child: _buildBody(plansState, subState));
  }

  Widget _buildBody(PlansState plansState, SubscriptionState subState) {
    if (plansState is PlansLoading) {
      return Center(child: PosLoadingSkeleton.list());
    }

    if (plansState is PlansError) {
      return PosErrorState(message: plansState.message, onRetry: () => ref.read(plansProvider.notifier).loadPlans());
    }

    if (plansState is PlansLoaded) {
      final currentPlanId = subState is SubscriptionLoaded ? subState.subscription?.subscriptionPlanId : null;

      return Column(
        children: [
          // Billing toggle
          Padding(
            padding: AppSpacing.paddingAllMd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.subscriptionMonthly),
                AppSpacing.horizontalSm,
                Switch(value: _isAnnual, activeColor: AppColors.primary, onChanged: (v) => setState(() => _isAnnual = v)),
                AppSpacing.horizontalSm,
                Text(
                  l10n.subscriptionAnnual,
                  style: TextStyle(
                    fontWeight: _isAnnual ? FontWeight.bold : FontWeight.normal,
                    color: _isAnnual ? AppColors.primary : null,
                  ),
                ),
                if (_isAnnual)
                  Container(
                    margin: const EdgeInsetsDirectional.only(start: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
                    child: Text(
                      l10n.subscriptionSavePercent,
                      style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),

          // Comparison table
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingHMd,
              child: PlanComparisonTable(
                plans: plansState.plans,
                currentPlanId: currentPlanId,
                isAnnual: _isAnnual,
                onSelectPlan: (plan) => _onPlanSelected(plan),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _onPlanSelected(plan) async {
    final billingCycle = _isAnnual ? l10n.subBillingCycleYearly : l10n.subBillingCycleMonthly;
    final price = _isAnnual ? (plan.annualPrice ?? plan.monthlyPrice) : plan.monthlyPrice;

    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.subSubscribeToPlan(plan.name),
      message: l10n.subConfirmSubscriptionMessage(plan.name, billingCycle, price.toStringAsFixed(2), 'SAR'),
      confirmLabel: l10n.subProceedToPayment,
      cancelLabel: l10n.commonCancel,
    );
    if (confirmed == true) {
      context.push(
        Routes.providerPaymentCheckout,
        extra: {
          'purpose': 'subscription',
          'purpose_label': '${plan.name} ($billingCycle)',
          'amount': price,
          'subscription_plan_id': plan.id,
          'notes': 'Subscription: ${plan.name} - $billingCycle',
        },
      );
    }
  }
}
