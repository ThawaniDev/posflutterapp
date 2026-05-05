import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminStoreDetailPage extends ConsumerStatefulWidget {
  const AdminStoreDetailPage({super.key, required this.storeId});
  final String storeId;

  @override
  ConsumerState<AdminStoreDetailPage> createState() => _AdminStoreDetailPageState();
}

class _AdminStoreDetailPageState extends ConsumerState<AdminStoreDetailPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminStoreDetailProvider.notifier).load(widget.storeId);
      ref.read(limitOverrideProvider.notifier).load(widget.storeId);
      ref.read(adminStoreDetailProvider.notifier).loadMetrics(widget.storeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final storeState = ref.watch(adminStoreDetailProvider);
    final actionState = ref.watch(adminActionProvider);
    final theme = Theme.of(context);

    // Show snackbar on action success/error
    ref.listen<AdminActionState>(adminActionProvider, (prev, next) {
      if (next is AdminActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(adminStoreDetailProvider.notifier).load(widget.storeId);
      } else if (next is AdminActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    // Listen for impersonation events
    ref.listen<ImpersonationState>(impersonationProvider, (prev, next) {
      if (next is ImpersonationActive) {
        _showImpersonationActiveDialog(next);
      } else if (next is ImpersonationEnded) {
        showPosSuccessSnackbar(context, 'Impersonation session ended');
      } else if (next is ImpersonationError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    final isLoading = storeState is AdminStoreDetailLoading || actionState is AdminActionLoading;
    final hasError = storeState is AdminStoreDetailError;

    return PosListPage(
      title: l10n.adminStoreDetails,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? storeState.message : null,
      onRetry: () => ref.read(adminStoreDetailProvider.notifier).load(widget.storeId),
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.overview),
              PosTabItem(label: l10n.adminMetrics),
              PosTabItem(label: l10n.settingsPosLimits),
              PosTabItem(label: l10n.adminPosTerminals),
              PosTabItem(label: l10n.adminInternalNotes),
            ],
          ),
          Expanded(child: _buildContent(storeState, theme)),
        ],
      ),
    );
  }

  Widget _buildContent(AdminStoreDetailState storeState, ThemeData theme) {
    if (storeState is AdminStoreDetailLoaded) {
      return IndexedStack(
        index: _currentTab,
        children: [
          _buildOverviewTab(storeState.store, theme),
          _buildMetricsTab(theme),
          _buildLimitsTab(theme),
          _buildTerminalsTab(storeState.store, theme),
          _buildNotesTab(storeState.store, theme),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  // ─── Overview Tab ──────────────────────────────────────

  Widget _buildOverviewTab(Map<String, dynamic> store, ThemeData theme) {
    final isActive = store['is_active'] == true;
    final storeName = store['name'] as String? ?? 'Unnamed';
    final businessType = store['business_type'] as String? ?? '—';
    final currency = store['currency'] as String? ?? '—';
    final suspendReason = store['suspend_reason'] as String?;
    final org = store['organization'] as Map<String, dynamic>?;
    final subscription = store['active_subscription'] as Map<String, dynamic>?;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Status + Name Header ─────────────────────
          PosCard(
            elevation: 0,
            borderRadius: AppRadius.borderLg,

            border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
            child: Padding(
              padding: AppSpacing.paddingAll20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: AppRadius.borderFull,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: AppSizes.dotSm,
                              height: AppSizes.dotSm,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive ? AppColors.success : AppColors.error,
                              ),
                            ),
                            AppSpacing.gapW4,
                            Text(
                              isActive ? 'Active' : 'Suspended',
                              style: TextStyle(
                                color: isActive ? AppColors.successDark : AppColors.errorDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      PosButton(
                        label: 'Impersonate',
                        variant: PosButtonVariant.outline,
                        size: PosButtonSize.sm,
                        icon: Icons.manage_accounts_outlined,
                        onPressed: () => ref.read(impersonationProvider.notifier).start(widget.storeId),
                      ),
                      AppSpacing.gapW8,
                      if (isActive)
                        PosButton(
                          label: l10n.suspend,
                          variant: PosButtonVariant.danger,
                          size: PosButtonSize.sm,
                          icon: Icons.block,
                          onPressed: () => _showSuspendDialog(),
                        )
                      else
                        PosButton(
                          label: l10n.activate,
                          variant: PosButtonVariant.primary,
                          size: PosButtonSize.sm,
                          icon: Icons.check_circle_outline,
                          onPressed: () => ref.read(adminActionProvider.notifier).activateStore(widget.storeId),
                        ),
                    ],
                  ),
                  AppSpacing.gapH16,
                  Text(storeName, style: theme.textTheme.headlineSmall),
                  if (suspendReason != null) ...[
                    AppSpacing.gapH8,
                    Container(
                      padding: AppSpacing.paddingAll12,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.05),
                        borderRadius: AppRadius.borderMd,
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.error),
                          AppSpacing.gapW8,
                          Expanded(
                            child: Text(
                              'Suspended: $suspendReason',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.errorDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          AppSpacing.gapH16,

          // ─── Store Info ─────────────────────────────────
          _buildInfoSection(theme, 'Store Information', [
            _infoRow('Business Type', businessType),
            _infoRow('Currency', currency),
            _infoRow('Created', store['created_at']?.toString() ?? '—'),
          ]),
          AppSpacing.gapH16,

          // ─── Organization Info ──────────────────────────
          if (org != null)
            _buildInfoSection(theme, 'Organization', [
              _infoRow('Name', org['name']?.toString() ?? '—'),
              _infoRow('CR Number', org['cr_number']?.toString() ?? '—'),
              _infoRow('VAT Number', org['vat_number']?.toString() ?? '—'),
            ]),
          AppSpacing.gapH16,

          // ─── Subscription Info ─────────────────────────
          if (subscription != null)
            _buildInfoSection(theme, 'Active Subscription', [
              _infoRow(
                'Plan',
                subscription['plan_name']?.toString() ?? (subscription['plan'] as Map?)?['name']?.toString() ?? '—',
              ),
              _infoRow('Status', subscription['status']?.toString() ?? '—'),
              _infoRow('Billing Cycle', subscription['billing_cycle']?.toString() ?? '—'),
              _infoRow(
                'Period End',
                subscription['current_period_end']?.toString() ?? subscription['ends_at']?.toString() ?? '—',
              ),
            ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, String title, List<Widget> rows) {
    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,

      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            AppSpacing.gapH12,
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: AppColors.mutedFor(context), fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ─── Metrics Tab ───────────────────────────────────────

  Widget _buildMetricsTab(ThemeData theme) {
    return Consumer(
      builder: (context, ref, _) {
        final storeState = ref.watch(adminStoreDetailProvider);
        if (storeState is AdminStoreDetailLoaded) {
          final data = storeState.store;
          if (data.containsKey('usage')) {
            return _buildMetricsContent(data, theme);
          }
        }

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.analytics_outlined, size: 48, color: AppColors.mutedFor(context)),
              AppSpacing.gapH12,
              PosButton(
                label: l10n.adminLoadMetrics,
                onPressed: () => ref.read(adminStoreDetailProvider.notifier).loadMetrics(widget.storeId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricsContent(Map<String, dynamic> data, ThemeData theme) {
    final usage = data['usage'] as Map<String, dynamic>? ?? {};
    final branches = (data['branches'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final deliveryPlatforms = (data['delivery_platforms'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Usage Stats ──────────────────────────────
          Text('Usage Statistics', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          LayoutBuilder(
            builder: (ctx, constraints) {
              final w = (constraints.maxWidth - AppSpacing.md) / 2;
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _metricCard(
                    theme,
                    label: l10n.products,
                    value: '${usage['products_count'] ?? 0}',
                    icon: Icons.inventory_2_outlined,
                    color: AppColors.info,
                    width: w,
                  ),
                  _metricCard(
                    theme,
                    label: 'Orders (30d)',
                    value: '${usage['recent_orders_30d'] ?? 0}',
                    icon: Icons.receipt_outlined,
                    color: AppColors.success,
                    width: w,
                  ),
                  _metricCard(
                    theme,
                    label: l10n.staff,
                    value: '${usage['staff_count'] ?? 0}',
                    icon: Icons.people_outlined,
                    color: AppColors.purple,
                    width: w,
                  ),
                  _metricCard(
                    theme,
                    label: 'Registers',
                    value: '${usage['registers_count'] ?? 0}',
                    icon: Icons.point_of_sale_outlined,
                    color: AppColors.primary,
                    width: w,
                  ),
                  _metricCard(
                    theme,
                    label: 'Branches',
                    value: '${usage['branches_count'] ?? 0}',
                    icon: Icons.store_outlined,
                    color: AppColors.info,
                    width: w,
                  ),
                  _metricCard(
                    theme,
                    label: 'Delivery Platforms',
                    value: '${usage['delivery_platforms_count'] ?? 0}',
                    icon: Icons.delivery_dining_outlined,
                    color: AppColors.warning,
                    width: w,
                  ),
                ],
              );
            },
          ),
          AppSpacing.gapH24,

          // ─── Branches ────────────────────────────────
          if (branches.isNotEmpty) ...[
            Text('Branches', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            AppSpacing.gapH12,
            ...branches.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: PosCard(
                  elevation: 0,
                  borderRadius: AppRadius.borderMd,
                  border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
                  child: ListTile(
                    leading: Icon(
                      b['is_main_branch'] == true ? Icons.home_outlined : Icons.store_outlined,
                      color: b['is_main_branch'] == true ? AppColors.primary : AppColors.mutedFor(context),
                    ),
                    title: Text(b['name']?.toString() ?? '—', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${b['city'] ?? ''} • ${b['is_active'] == true ? 'Active' : 'Inactive'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: b['is_main_branch'] == true
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderFull,
                            ),
                            child: const Text(
                              'Main',
                              style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            AppSpacing.gapH8,
          ],

          // ─── Delivery Platforms ───────────────────────
          if (deliveryPlatforms.isNotEmpty) ...[
            Text('Delivery Platforms', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            AppSpacing.gapH12,
            ...deliveryPlatforms.map(
              (dp) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: PosCard(
                  elevation: 0,
                  borderRadius: AppRadius.borderMd,
                  border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
                  child: ListTile(
                    leading: const Icon(Icons.delivery_dining, color: AppColors.info),
                    title: Text(
                      dp['delivery_platform_id']?.toString() ?? dp['platform_slug']?.toString() ?? '—',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: dp['last_sync_at'] != null
                        ? Text('Last sync: ${dp['last_sync_at']}', style: const TextStyle(fontSize: 12))
                        : null,
                    trailing: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dp['is_active'] == true ? AppColors.success : AppColors.mutedFor(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metricCard(
    ThemeData theme, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    double? width,
  }) {
    return SizedBox(
      width: width ?? 150,
      child: PosCard(
        elevation: 0,
        borderRadius: AppRadius.borderLg,
        border: Border.fromBorderSide(BorderSide(color: color.withValues(alpha: 0.2))),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            children: [
              Icon(icon, size: 28, color: color),
              AppSpacing.gapH8,
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: color),
              ),
              AppSpacing.gapH4,
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context))),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Limits Tab ────────────────────────────────────────

  Widget _buildLimitsTab(ThemeData theme) {
    final state = ref.watch(limitOverrideProvider);

    if (state is LimitOverrideListLoading) {
      return const PosLoading();
    }
    if (state is LimitOverrideListError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH12,
            Text(state.message),
            AppSpacing.gapH16,
            PosButton(
              label: l10n.retry,
              variant: PosButtonVariant.outline,
              onPressed: () => ref.read(limitOverrideProvider.notifier).load(widget.storeId),
            ),
          ],
        ),
      );
    }
    if (state is LimitOverrideListLoaded) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.limitOverrides, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                PosButton(
                  label: l10n.adminAddOverride,
                  size: PosButtonSize.sm,
                  icon: Icons.add,
                  onPressed: () => _showLimitOverrideDialog(),
                ),
              ],
            ),
          ),
          if (state.overrides.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune_outlined, size: 48, color: AppColors.mutedFor(context)),
                    AppSpacing.gapH12,
                    Text(l10n.adminNoLimitOverrides, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.paddingH16,
                itemCount: state.overrides.length,
                separatorBuilder: (_, __) => AppSpacing.gapH8,
                itemBuilder: (context, index) {
                  final override = state.overrides[index];
                  return _buildLimitCard(override, theme);
                },
              ),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLimitCard(Map<String, dynamic> override, ThemeData theme) {
    final key = override['limit_key'] as String? ?? '';
    final value = override['override_value']?.toString() ?? '—';
    final reason = override['reason'] as String?;
    final expiresAt = override['expires_at'] as String?;

    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderMd,

      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
      child: ListTile(
        leading: const Icon(Icons.tune, color: AppColors.info),
        title: Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Value: $value'),
            if (reason != null) Text('Reason: $reason'),
            if (expiresAt != null) Text('Expires: $expiresAt', style: const TextStyle(color: AppColors.warning, fontSize: 12)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () => ref.read(limitOverrideProvider.notifier).removeOverride(widget.storeId, key),
        ),
      ),
    );
  }

  // ─── Terminals Tab ─────────────────────────────────────

  Widget _buildTerminalsTab(Map<String, dynamic> store, ThemeData theme) {
    final registers = (store['registers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (registers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.point_of_sale_outlined, size: 48, color: AppColors.mutedFor(context)),
            AppSpacing.gapH12,
            Text('No POS terminals registered', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context))),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: AppSpacing.paddingAll16,
      itemCount: registers.length,
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, i) {
        final reg = registers[i];
        final isOnline = reg['is_online'] == true;
        final isActive = reg['is_active'] == true;
        return PosCard(
          elevation: 0,
          borderRadius: AppRadius.borderLg,
          border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.point_of_sale, color: isOnline ? AppColors.success : AppColors.mutedFor(context), size: 20),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(reg['name']?.toString() ?? 'Terminal', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isOnline ? AppColors.success : AppColors.mutedFor(context)).withValues(alpha: 0.1),
                        borderRadius: AppRadius.borderFull,
                      ),
                      child: Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: isOnline ? AppColors.success : AppColors.mutedFor(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    if (!isActive) ...[
                      AppSpacing.gapW8,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: AppRadius.borderFull,
                        ),
                        child: const Text(
                          'Inactive',
                          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 11),
                        ),
                      ),
                    ],
                  ],
                ),
                AppSpacing.gapH8,
                if (reg['device_id'] != null) _infoRow('Device ID', reg['device_id'].toString()),
                if (reg['platform'] != null) _infoRow('Platform', reg['platform'].toString()),
                if (reg['app_version'] != null) _infoRow('App Version', reg['app_version'].toString()),
                if (reg['last_sync_at'] != null) _infoRow('Last Sync', reg['last_sync_at'].toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Notes Tab ─────────────────────────────────────────

  Widget _buildNotesTab(Map<String, dynamic> store, ThemeData theme) {
    final orgId = store['organization']?['id']?.toString() ?? store['organization_id']?.toString();
    if (orgId == null) return const Center(child: Text('Organization not found'));
    return _NotesTabContent(storeId: widget.storeId, organizationId: orgId);
  }

  // ─── Dialogs ───────────────────────────────────────────

  void _showSuspendDialog() {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminSuspendStore),
        content: PosTextField(controller: reasonCtrl, label: l10n.reason, hint: l10n.adminSuspensionReasonHint, maxLines: 3),
        actions: [
          PosButton(onPressed: () => Navigator.of(ctx).pop(), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            label: l10n.suspend,
            variant: PosButtonVariant.danger,
            onPressed: () {
              ref.read(adminActionProvider.notifier).suspendStore(widget.storeId, reason: reasonCtrl.text);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showLimitOverrideDialog() {
    final keyCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminAddLimitOverride),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(controller: keyCtrl, label: l10n.adminLimitKey, hint: 'e.g., max_products'),
            AppSpacing.gapH12,
            PosTextField(
              controller: valueCtrl,
              label: l10n.adminOverrideValue,
              hint: l10n.adminOverrideValueHint,
              keyboardType: TextInputType.number,
            ),
            AppSpacing.gapH12,
            PosTextField(controller: reasonCtrl, label: l10n.subscriptionCancelReasonLabel, hint: l10n.adminOverrideReasonHint),
          ],
        ),
        actions: [
          PosButton(onPressed: () => Navigator.of(ctx).pop(), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            label: l10n.adminSetOverride,
            onPressed: () {
              ref
                  .read(limitOverrideProvider.notifier)
                  .setOverride(
                    widget.storeId,
                    limitKey: keyCtrl.text,
                    overrideValue: int.tryParse(valueCtrl.text) ?? 0,
                    reason: reasonCtrl.text.isEmpty ? null : reasonCtrl.text,
                  );
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showImpersonationActiveDialog(ImpersonationActive session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.manage_accounts, color: AppColors.warning),
            AppSpacing.gapW8,
            Text('Impersonation Active'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are now impersonating:'),
            AppSpacing.gapH8,
            Container(
              padding: AppSpacing.paddingAll12,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.targetUser['name']?.toString() ?? '—', style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(session.targetUser['email']?.toString() ?? '—', style: const TextStyle(fontSize: 12)),
                  AppSpacing.gapH4,
                  Text('Store: ${session.storeName}', style: const TextStyle(fontSize: 12)),
                  Text('Expires: ${session.expiresAt}', style: const TextStyle(fontSize: 11, color: AppColors.warning)),
                ],
              ),
            ),
            AppSpacing.gapH8,
            SelectableText('Token: ${session.token}', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
          ],
        ),
        actions: [
          PosButton(
            label: 'Extend (30 min)',
            variant: PosButtonVariant.outline,
            size: PosButtonSize.sm,
            onPressed: () {
              ref.read(impersonationProvider.notifier).extend();
              Navigator.of(ctx).pop();
            },
          ),
          PosButton(
            label: 'End Session',
            variant: PosButtonVariant.danger,
            size: PosButtonSize.sm,
            onPressed: () {
              ref.read(impersonationProvider.notifier).end();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// Notes Tab Content Widget (embedded, loads org notes)
// ════════════════════════════════════════════════════════

class _NotesTabContent extends ConsumerStatefulWidget {
  const _NotesTabContent({required this.storeId, required this.organizationId});
  final String storeId;
  final String organizationId;

  @override
  ConsumerState<_NotesTabContent> createState() => _NotesTabContentState();
}

class _NotesTabContentState extends ConsumerState<_NotesTabContent> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(providerNotesProvider.notifier).load(widget.organizationId));
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerNotesProvider);
    final theme = Theme.of(context);

    ref.listen<ProviderNotesState>(providerNotesProvider, (prev, next) {
      if (next is ProviderNotesLoaded && prev is! ProviderNotesLoaded) {
        // refreshed
      }
    });

    return Column(
      children: [
        // Add note input
        Padding(
          padding: AppSpacing.paddingAll16,
          child: Row(
            children: [
              Expanded(
                child: PosTextField(
                  controller: _noteController,
                  label: 'Internal Note',
                  hint: 'Add a note visible only to admins...',
                  maxLines: 2,
                ),
              ),
              AppSpacing.gapW8,
              PosButton(
                label: 'Add',
                size: PosButtonSize.sm,
                icon: Icons.add,
                onPressed: () {
                  if (_noteController.text.trim().isNotEmpty) {
                    ref.read(providerNotesProvider.notifier).addNote(widget.organizationId, _noteController.text.trim());
                    _noteController.clear();
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: switch (state) {
            ProviderNotesLoading() => const PosLoading(),
            ProviderNotesError(:final message) => Center(child: Text(message)),
            ProviderNotesLoaded(:final notes) when notes.isEmpty => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sticky_note_2_outlined, size: 48, color: AppColors.mutedFor(context)),
                  AppSpacing.gapH8,
                  const Text('No internal notes yet'),
                ],
              ),
            ),
            ProviderNotesLoaded(:final notes) => ListView.separated(
              padding: AppSpacing.paddingH16,
              itemCount: notes.length,
              separatorBuilder: (_, __) => AppSpacing.gapH8,
              itemBuilder: (context, i) {
                final note = notes[i];
                final adminName = note['admin_user_name']?.toString() ?? note['admin_user_email']?.toString() ?? 'Admin';
                final createdAt = note['created_at']?.toString() ?? '';
                return PosCard(
                  elevation: 0,
                  borderRadius: AppRadius.borderMd,
                  border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
                  child: Padding(
                    padding: AppSpacing.paddingAll12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: AppColors.info),
                            AppSpacing.gapW4,
                            Text(
                              adminName,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.info),
                            ),
                            const Spacer(),
                            Text(
                              createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt,
                              style: TextStyle(fontSize: 11, color: AppColors.mutedFor(context)),
                            ),
                          ],
                        ),
                        AppSpacing.gapH8,
                        Text(note['note_text']?.toString() ?? '', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                );
              },
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }
}
