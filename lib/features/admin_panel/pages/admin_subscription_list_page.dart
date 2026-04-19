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

class AdminSubscriptionListPage extends ConsumerStatefulWidget {
  const AdminSubscriptionListPage({super.key});

  @override
  ConsumerState<AdminSubscriptionListPage> createState() => _AdminSubscriptionListPageState();
}

class _AdminSubscriptionListPageState extends ConsumerState<AdminSubscriptionListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(subscriptionListProvider.notifier).loadSubscriptions(storeId: _storeId);
    });
  }

  void _onFilterChanged(String? status) {
    setState(() => _statusFilter = status);
    ref.read(subscriptionListProvider.notifier).loadSubscriptions(status: status, storeId: _storeId);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(subscriptionListProvider.notifier).loadSubscriptions(status: _statusFilter, storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionListProvider);
    final isLoading = state is SubscriptionListLoading;
    final hasError = state is SubscriptionListError;
    final isEmpty = state is SubscriptionListLoaded && state.subscriptions.isEmpty;

    return PosListPage(
      title: l10n.subscriptions,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(subscriptionListProvider.notifier).loadSubscriptions(status: _statusFilter, storeId: _storeId),
      isEmpty: isEmpty,
      emptyTitle: l10n.noSubscriptionsFound,
      emptyIcon: Icons.subscriptions_outlined,
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: l10n.all, selected: _statusFilter == null, onSelected: () => _onFilterChanged(null)),
                  for (final s in ['active', 'trial', 'grace', 'cancelled'])
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: _FilterChip(
                        label: s[0].toUpperCase() + s.substring(1),
                        selected: _statusFilter == s,
                        onSelected: () => _onFilterChanged(s),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: switch (state) {
              SubscriptionListLoaded(:final subscriptions) => ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final sub = subscriptions[index];
                  return _SubscriptionCard(subscription: sub);
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.mutedFor(context),
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> subscription;
  const _SubscriptionCard({required this.subscription});

  Color _statusColor(String status) {
    return switch (status) {
      'active' => AppColors.success,
      'trial' => AppColors.warning,
      'grace' => AppColors.warning,
      'cancelled' => AppColors.error,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final status = subscription['status'] ?? '';
    final plan = subscription['plan'] as Map<String, dynamic>?;

    return PosCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(plan?['name'] ?? 'Unknown Plan', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Store: ${subscription['store_id']?.toString().substring(0, 8) ?? 'N/A'}',
          style: TextStyle(color: AppColors.mutedFor(context), fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
          child: Text(
            status.toUpperCase(),
            style: TextStyle(color: _statusColor(status), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
