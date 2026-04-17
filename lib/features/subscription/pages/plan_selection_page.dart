import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/widgets/plan_card.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Page that displays available subscription plans for the user to choose.
class PlanSelectionPage extends ConsumerStatefulWidget {
  const PlanSelectionPage({super.key});

  @override
  ConsumerState<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends ConsumerState<PlanSelectionPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool _isAnnual = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(plansProvider.notifier).loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plansState = ref.watch(plansProvider);
    final subscriptionState = ref.watch(subscriptionProvider);

    // Listen for subscription action results
    ref.listen<SubscriptionState>(subscriptionProvider, (prev, next) {
      if (next is SubscriptionActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        context.go(Routes.subscriptionStatus);
      } else if (next is SubscriptionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.subscriptionChooseYourPlan),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => context.go(Routes.planComparison),
            icon: const Icon(Icons.compare_arrows, size: 18),
            label: Text(l10n.subscriptionCompare),
          ),
        ],
      ),
      body: _buildBody(plansState, subscriptionState),
    );
  }

  Widget _buildBody(PlansState plansState, SubscriptionState subState) {
    if (plansState is PlansLoading || subState is SubscriptionLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (plansState is PlansError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error.withValues(alpha: 0.6)),
            AppSpacing.verticalMd,
            Text(
              plansState.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.error),
            ),
            AppSpacing.verticalMd,
            ElevatedButton(onPressed: () => ref.read(plansProvider.notifier).loadPlans(), child: Text(l10n.retry)),
          ],
        ),
      );
    }

    if (plansState is PlansLoaded) {
      return _buildPlansContent(plansState.plans);
    }

    return const SizedBox.shrink();
  }

  Widget _buildPlansContent(List<SubscriptionPlan> plans) {
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
              Text(l10n.subscriptionAnnual,
                style: TextStyle(
                  fontWeight: _isAnnual ? FontWeight.bold : FontWeight.normal,
                  color: _isAnnual ? AppColors.primary : null,
                ),
              ),
              if (_isAnnual)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(l10n.subscriptionSavePercent,
                    style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),

        // Plans list
        Expanded(
          child: ListView.builder(
            padding: AppSpacing.paddingHMd,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return PlanCard(plan: plan, isAnnual: _isAnnual, onSelect: () => _onPlanSelected(plan));
            },
          ),
        ),
      ],
    );
  }

  void _onPlanSelected(SubscriptionPlan plan) async {
    final billingCycle = _isAnnual ? 'yearly' : 'monthly';
    final price = _isAnnual ? (plan.annualPrice ?? plan.monthlyPrice * 12) : plan.monthlyPrice;

    final confirmed = await showPosConfirmDialog(
      context,
      title: 'Subscribe to ${plan.name}?',
      message:
          'You will be subscribed to ${plan.name} on a $billingCycle basis.\n\n'
          'Price: $price SAR/$billingCycle\n\n'
          'You will be redirected to complete the payment.',
      confirmLabel: 'Proceed to Payment',
      cancelLabel: 'Cancel',
    );
    if (confirmed == true) {
      context.go(
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
