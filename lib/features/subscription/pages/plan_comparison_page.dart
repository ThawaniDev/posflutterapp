import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_providers.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';
import 'package:thawani_pos/features/subscription/widgets/plan_comparison_table.dart';

/// Page that displays a side-by-side comparison of all available plans.
class PlanComparisonPage extends ConsumerStatefulWidget {
  const PlanComparisonPage({super.key});

  @override
  ConsumerState<PlanComparisonPage> createState() => _PlanComparisonPageState();
}

class _PlanComparisonPageState extends ConsumerState<PlanComparisonPage> {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.success));
        context.go(Routes.subscriptionStatus);
      } else if (next is SubscriptionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Plans'), centerTitle: true),
      body: _buildBody(plansState, subState),
    );
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
                const Text('Monthly'),
                AppSpacing.horizontalSm,
                Switch(value: _isAnnual, activeColor: AppColors.primary, onChanged: (v) => setState(() => _isAnnual = v)),
                AppSpacing.horizontalSm,
                Text(
                  'Annual',
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
                    child: Text(
                      'Save ~17%',
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

  void _onPlanSelected(plan) {
    final billingCycle = _isAnnual ? 'yearly' : 'monthly';
    final price = _isAnnual ? (plan.annualPrice ?? plan.monthlyPrice) : plan.monthlyPrice;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Subscribe to ${plan.name}?'),
        content: Text(
          'You will be subscribed to ${plan.name} on a $billingCycle basis.\n\n'
          'Price: ${price.toStringAsFixed(2)} \u0081/$billingCycle',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(subscriptionProvider.notifier).subscribe(planId: plan.id, billingCycle: billingCycle);
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}
