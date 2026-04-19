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

class RegistrationQueuePage extends ConsumerStatefulWidget {
  const RegistrationQueuePage({super.key});

  @override
  ConsumerState<RegistrationQueuePage> createState() => _RegistrationQueuePageState();
}

class _RegistrationQueuePageState extends ConsumerState<RegistrationQueuePage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _storeId;
  String? _statusFilter;
  int _currentPage = 1;

  static const _statusOptions = [null, 'pending', 'approved', 'rejected'];

  static const _statusLabels = {null: 'All', 'pending': 'Pending', 'approved': 'Approved', 'rejected': 'Rejected'};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    ref
        .read(registrationListProvider.notifier)
        .load(
          status: _statusFilter,
          search: _searchController.text.isEmpty ? null : _searchController.text,
          storeId: _storeId,
          page: _currentPage,
        );
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationListProvider);
    final actionState = ref.watch(adminActionProvider);
    final theme = Theme.of(context);

    ref.listen<AdminActionState>(adminActionProvider, (prev, next) {
      if (next is AdminActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        _load();
      } else if (next is AdminActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
      title: l10n.adminRegistrationQueue,
      searchController: _searchController,
      onSearchChanged: (_) {},
      isLoading: state is RegistrationListLoading || actionState is AdminActionLoading,
      hasError: state is RegistrationListError,
      errorMessage: state is RegistrationListError ? state.message : null,
      onRetry: _load,
      isEmpty: state is RegistrationListLoaded && state.registrations.isEmpty,
      emptyTitle: 'No registrations found',
      emptyIcon: Icons.how_to_reg_outlined,
      filters: _statusOptions.map((status) {
        return _buildStatusChip(
          label: _statusLabels[status]!,
          selected: _statusFilter == status,
          color: _statusColor(status),
          onTap: () => setState(() {
            _statusFilter = status;
            _currentPage = 1;
            _load();
          }),
        );
      }).toList(),
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(child: _buildBody(state, actionState, theme)),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    return switch (status) {
      'pending' => AppColors.warning,
      'approved' => AppColors.success,
      'rejected' => AppColors.error,
      _ => AppColors.textMutedLight,
    };
  }

  Widget _buildStatusChip({required String label, required bool selected, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: AppRadius.borderFull,
          border: Border.all(color: selected ? color : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppColors.textSecondaryLight,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(RegistrationListState state, AdminActionState actionState, ThemeData theme) {
    if (state is RegistrationListLoaded) {
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.paddingAll16,
              itemCount: state.registrations.length,
              separatorBuilder: (_, __) => AppSpacing.gapH8,
              itemBuilder: (context, index) {
                final reg = state.registrations[index];
                return _buildRegistrationCard(reg, theme);
              },
            ),
          ),
          _buildPagination(state, theme),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRegistrationCard(Map<String, dynamic> reg, ThemeData theme) {
    final businessName = reg['business_name'] as String? ?? 'Unknown';
    final contactName = reg['contact_name'] as String? ?? '—';
    final email = reg['email'] as String? ?? '—';
    final status = reg['status'] as String? ?? 'pending';
    final createdAt = reg['created_at'] as String? ?? '';

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,

      border: Border.fromBorderSide(BorderSide(color: AppColors.borderLight)),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(businessName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      AppSpacing.gapH4,
                      Text('$contactName • $email', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight)),
                    ],
                  ),
                ),
                _statusBadge(status),
              ],
            ),
            if (createdAt.isNotEmpty) ...[
              AppSpacing.gapH8,
              Text(
                'Submitted: $createdAt',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight, fontSize: 11),
              ),
            ],
            if (status == 'pending') ...[
              AppSpacing.gapH12,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PosButton(
                    label: l10n.deliveryReject,
                    variant: PosButtonVariant.outline,
                    size: PosButtonSize.sm,
                    onPressed: () => _showRejectDialog(reg['id']?.toString() ?? ''),
                  ),
                  AppSpacing.gapW8,
                  PosButton(
                    label: l10n.inventoryApprove,
                    size: PosButtonSize.sm,
                    icon: Icons.check,
                    onPressed: () => ref.read(adminActionProvider.notifier).approveRegistration(reg['id']?.toString() ?? ''),
                  ),
                ],
              ),
            ],
            if (status == 'rejected' && reg['rejection_reason'] != null) ...[
              AppSpacing.gapH8,
              Container(
                padding: AppSpacing.paddingAll8,
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.05), borderRadius: AppRadius.borderSm),
                child: Text(
                  'Rejection reason: ${reg['rejection_reason']}',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.errorDark),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderFull),
      child: Text(
        status.substring(0, 1).toUpperCase() + status.substring(1),
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _buildPagination(RegistrationListLoaded state, ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${state.registrations.length} of ${state.total}',
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: state.currentPage > 1
                    ? () {
                        _currentPage = state.currentPage - 1;
                        _load();
                      }
                    : null,
              ),
              Text('Page ${state.currentPage} of ${state.lastPage}', style: theme.textTheme.bodySmall),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: state.currentPage < state.lastPage
                    ? () {
                        _currentPage = state.currentPage + 1;
                        _load();
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(String registrationId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminRejectRegistration),
        content: PosTextField(
          controller: reasonCtrl,
          label: l10n.deliveryRejectionReason,
          hint: l10n.adminRejectReasonHint,
          maxLines: 3,
        ),
        actions: [
          PosButton(onPressed: () => Navigator.of(ctx).pop(), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            label: l10n.deliveryReject,
            variant: PosButtonVariant.danger,
            onPressed: () {
              ref.read(adminActionProvider.notifier).rejectRegistration(registrationId, reason: reasonCtrl.text);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
