import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/subscription/models/subscription_plan.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_providers.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';
import 'package:thawani_pos/features/subscription/widgets/plan_card.dart';

/// Page that displays available subscription plans for the user to choose.
class PlanSelectionPage extends ConsumerStatefulWidget {
  const PlanSelectionPage({super.key});

  @override
  ConsumerState<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends ConsumerState<PlanSelectionPage> {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.success));
        context.go(Routes.subscriptionStatus);
      } else if (next is SubscriptionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Plan'), centerTitle: true),
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
            ElevatedButton(onPressed: () => ref.read(plansProvider.notifier).loadPlans(), child: const Text('Retry')),
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

  void _onPlanSelected(SubscriptionPlan plan) {
    final billingCycle = _isAnnual ? 'yearly' : 'monthly';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Subscribe to ${plan.name}?'),
        content: Text(
          'You will be subscribed to ${plan.name} on a $billingCycle basis.\n\n'
          'Price: ${_isAnnual ? plan.annualPrice : plan.monthlyPrice} SAR/$billingCycle',
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
