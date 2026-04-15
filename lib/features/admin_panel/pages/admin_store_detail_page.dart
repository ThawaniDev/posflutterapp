import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

class AdminStoreDetailPage extends ConsumerStatefulWidget {
  final String storeId;

  const AdminStoreDetailPage({super.key, required this.storeId});

  @override
  ConsumerState<AdminStoreDetailPage> createState() => _AdminStoreDetailPageState();
}

class _AdminStoreDetailPageState extends ConsumerState<AdminStoreDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(adminStoreDetailProvider.notifier).load(widget.storeId);
      ref.read(limitOverrideProvider.notifier).load(widget.storeId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Metrics'),
            Tab(text: 'Limits'),
          ],
        ),
      ),
      body: _buildContent(storeState, actionState, theme),
    );
  }

  Widget _buildContent(AdminStoreDetailState storeState, AdminActionState actionState, ThemeData theme) {
    if (storeState is AdminStoreDetailLoading || actionState is AdminActionLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (storeState is AdminStoreDetailError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH12,
            Text(storeState.message, style: theme.textTheme.bodyMedium),
            AppSpacing.gapH16,
            PosButton(
              label: 'Retry',
              variant: PosButtonVariant.outline,
              onPressed: () => ref.read(adminStoreDetailProvider.notifier).load(widget.storeId),
            ),
          ],
        ),
      );
    }
    if (storeState is AdminStoreDetailLoaded) {
      return TabBarView(
        controller: _tabController,
        children: [_buildOverviewTab(storeState.store, theme), _buildMetricsTab(theme), _buildLimitsTab(theme)],
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
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderLg,
              side: BorderSide(color: AppColors.borderLight),
            ),
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
                      if (isActive)
                        PosButton(
                          label: 'Suspend',
                          variant: PosButtonVariant.danger,
                          size: PosButtonSize.sm,
                          icon: Icons.block,
                          onPressed: () => _showSuspendDialog(),
                        )
                      else
                        PosButton(
                          label: 'Activate',
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
                          Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.error),
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
              _infoRow('Business Type', org['business_type']?.toString() ?? '—'),
              _infoRow('Country', org['country']?.toString() ?? '—'),
            ]),
          AppSpacing.gapH16,

          // ─── Subscription Info ─────────────────────────
          if (subscription != null)
            _buildInfoSection(theme, 'Active Subscription', [
              _infoRow('Plan', (subscription['plan'] as Map?)?['name']?.toString() ?? '—'),
              _infoRow('Status', subscription['status']?.toString() ?? '—'),
              _infoRow('Expires', subscription['ends_at']?.toString() ?? '—'),
            ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, String title, List<Widget> rows) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
        side: BorderSide(color: AppColors.borderLight),
      ),
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
            child: Text(label, style: TextStyle(color: AppColors.textMutedLight, fontSize: 13)),
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
        // Trigger loading metrics on first access
        final storeState = ref.watch(adminStoreDetailProvider);
        if (storeState is AdminStoreDetailLoaded) {
          final data = storeState.store;
          // Check if metrics data is present (from storeMetrics endpoint)
          if (data.containsKey('products_count')) {
            return _buildMetricsContent(data, theme);
          }
        }

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.analytics_outlined, size: 48, color: AppColors.textMutedLight),
              AppSpacing.gapH12,
              PosButton(
                label: 'Load Metrics',
                onPressed: () => ref.read(adminStoreDetailProvider.notifier).loadMetrics(widget.storeId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricsContent(Map<String, dynamic> data, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - AppSpacing.md * 2 - AppSpacing.md) / 2;
        return SingleChildScrollView(
          padding: AppSpacing.paddingAll16,
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _metricCard(
                theme,
                label: 'Products',
                value: '${data['products_count'] ?? 0}',
                icon: Icons.inventory_2_outlined,
                color: AppColors.info,
                width: cardWidth,
              ),
              _metricCard(
                theme,
                label: 'Orders',
                value: '${data['orders_count'] ?? 0}',
                icon: Icons.receipt_outlined,
                color: AppColors.success,
                width: cardWidth,
              ),
              _metricCard(
                theme,
                label: 'Staff',
                value: '${data['staff_count'] ?? 0}',
                icon: Icons.people_outlined,
                color: AppColors.purple,
                width: cardWidth,
              ),
              _metricCard(
                theme,
                label: 'Revenue',
                value: '${data['revenue'] ?? 0}',
                icon: Icons.attach_money,
                color: AppColors.primary,
                width: cardWidth,
              ),
            ],
          ),
        );
      },
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
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
          side: BorderSide(color: color.withValues(alpha: 0.2)),
        ),
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
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight)),
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
      return const Center(child: CircularProgressIndicator());
    }
    if (state is LimitOverrideListError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH12,
            Text(state.message),
            AppSpacing.gapH16,
            PosButton(
              label: 'Retry',
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
                Text('Limit Overrides', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                PosButton(
                  label: 'Add Override',
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
                    Icon(Icons.tune_outlined, size: 48, color: AppColors.textMutedLight),
                    AppSpacing.gapH12,
                    Text('No limit overrides set', style: theme.textTheme.bodyMedium),
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

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderMd,
        side: BorderSide(color: AppColors.borderLight),
      ),
      child: ListTile(
        leading: Icon(Icons.tune, color: AppColors.info),
        title: Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Value: $value'),
            if (reason != null) Text('Reason: $reason'),
            if (expiresAt != null) Text('Expires: $expiresAt', style: TextStyle(color: AppColors.warning, fontSize: 12)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () => ref.read(limitOverrideProvider.notifier).removeOverride(widget.storeId, key),
        ),
      ),
    );
  }

  // ─── Dialogs ───────────────────────────────────────────

  void _showSuspendDialog() {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Suspend Store'),
        content: PosTextField(controller: reasonCtrl, label: 'Reason', hint: 'Enter suspension reason', maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          PosButton(
            label: 'Suspend',
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
        title: const Text('Add Limit Override'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(controller: keyCtrl, label: 'Limit Key', hint: 'e.g., max_products'),
            AppSpacing.gapH12,
            PosTextField(controller: valueCtrl, label: 'Override Value', hint: 'Enter value', keyboardType: TextInputType.number),
            AppSpacing.gapH12,
            PosTextField(controller: reasonCtrl, label: 'Reason (optional)', hint: 'Why is this override needed?'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          PosButton(
            label: 'Set Override',
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
}
