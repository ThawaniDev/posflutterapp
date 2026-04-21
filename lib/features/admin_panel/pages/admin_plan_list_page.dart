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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(planListProvider);
    final isLoading = state is PlanListLoading;
    final hasError = state is PlanListError;
    final isEmpty = state is PlanListLoaded && state.plans.isEmpty;

    return PosListPage(
      title: l10n.adminSubscriptionPlans,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(planListProvider.notifier).loadPlans(),
      isEmpty: isEmpty,
      emptyTitle: 'No plans found',
      emptyIcon: Icons.workspace_premium_outlined,
      actions: [PosButton(label: l10n.add, icon: Icons.add, onPressed: () {})],
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              PlanListLoaded(:final plans) => ListView.builder(
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
  const _PlanCard({required this.plan});
  final Map<String, dynamic> plan;

  @override
  Widget build(BuildContext context) {
    final isActive = plan['is_active'] == true;
    final isHighlighted = plan['is_highlighted'] == true;

    return PosCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: AppRadius.borderLg,
      border: Border.fromBorderSide(
        isHighlighted ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide(color: AppColors.borderFor(context)),
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
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
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
                    borderRadius: AppRadius.borderLg,
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
                  Text('${plan['annual_price']}/yr', style: TextStyle(fontSize: 14, color: AppColors.mutedFor(context))),
                ],
              ],
            ),
            if (plan['trial_days'] != null && plan['trial_days'] > 0) ...[
              AppSpacing.gapH4,
              Text('${plan['trial_days']} day trial', style: TextStyle(fontSize: 13, color: AppColors.mutedFor(context))),
            ],
          ],
        ),
      ),
    );
  }
}
