import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminPlanListPage extends ConsumerStatefulWidget {
  const AdminPlanListPage({super.key});

  @override
  ConsumerState<AdminPlanListPage> createState() => _AdminPlanListPageState();
}

class _AdminPlanListPageState extends ConsumerState<AdminPlanListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(planListProvider.notifier).loadPlans();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(planListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create plan
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              PlanListLoading() => const Center(child: CircularProgressIndicator()),
              PlanListError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, style: const TextStyle(color: AppColors.error)),
                    AppSpacing.gapH16,
                    PosButton(
                      label: l10n.retry,
                      variant: PosButtonVariant.outline,
                      onPressed: () => ref.read(planListProvider.notifier).loadPlans(),
                    ),
                  ],
                ),
              ),
              PlanListLoaded(:final plans) =>
                plans.isEmpty
                    ? const Center(child: Text('No plans found'))
                    : ListView.builder(
                        padding: AppSpacing.paddingAll16,
                        itemCount: plans.length,
                        itemBuilder: (context, index) {
                          final plan = plans[index];
                          return _PlanCard(plan: plan);
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

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final isActive = plan['is_active'] == true;
    final isHighlighted = plan['is_highlighted'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHighlighted ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide(color: AppColors.borderLight),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(plan['name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (isHighlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Highlighted',
                      style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                AppSpacing.gapW8,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: isActive ? AppColors.success : AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH8,
            Row(
              children: [
                Text(
                  '\u0081${plan['monthly_price']}/mo',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
                if (plan['annual_price'] != null) ...[
                  AppSpacing.gapW16,
                  Text('\u0081${plan['annual_price']}/yr', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ],
            ),
            if (plan['trial_days'] != null && plan['trial_days'] > 0) ...[
              AppSpacing.gapH4,
              Text('${plan['trial_days']} day trial', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ],
        ),
      ),
    );
  }
}
