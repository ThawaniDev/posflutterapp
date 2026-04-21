import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminGatewayListPage extends ConsumerStatefulWidget {
  const AdminGatewayListPage({super.key});

  @override
  ConsumerState<AdminGatewayListPage> createState() => _AdminGatewayListPageState();
}

class _AdminGatewayListPageState extends ConsumerState<AdminGatewayListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String _envFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(gatewayListProvider.notifier).loadGateways(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(gatewayListProvider.notifier).loadGateways(environment: _envFilter == 'all' ? null : _envFilter, storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gatewayListProvider);

    return PosListPage(
  title: l10n.adminPaymentGateways,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.add,
    onPressed: _showCreateDialog,
    tooltip: l10n.adminAdd,
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // Environment filter
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                _filterChip('All', 'all'),
                const SizedBox(width: AppSpacing.xs),
                _filterChip('Production', 'production'),
                const SizedBox(width: AppSpacing.xs),
                _filterChip('Sandbox', 'sandbox'),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              GatewayListLoading() => const Center(child: CircularProgressIndicator()),
              GatewayListLoaded(gateways: final items) =>
                items.isEmpty
                    ? Center(child: Text(l10n.noGatewaysConfigured))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final gw = items[index];
                          return _gatewayCard(gw);
                        },
                      ),
              GatewayListError(message: final msg) => Center(child: Text(l10n.genericError(msg))),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
);
  }

  Widget _filterChip(String label, String value) {
    final selected = _envFilter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      onSelected: (_) {
        setState(() => _envFilter = value);
        ref.read(gatewayListProvider.notifier).loadGateways(environment: value == 'all' ? null : value, storeId: _storeId);
      },
    );
  }

  Widget _gatewayCard(Map<String, dynamic> gw) {
    final isActive = gw['is_active'] == true;
    final env = gw['environment'] ?? '';
    final hasCreds = gw['has_credentials'] == true;

    return PosCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(gw['gateway_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: env == 'production'
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderLg,
                  ),
                  child: Text(
                    env.toUpperCase(),
                    style: TextStyle(fontSize: 11, color: env == 'production' ? AppColors.successDark : AppColors.warningDark),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  color: isActive ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (gw['webhook_url'] != null)
              Text('Webhook: ${gw['webhook_url']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Row(
              children: [
                Icon(hasCreds ? Icons.key : Icons.key_off, size: 14, color: hasCreds ? AppColors.success : AppColors.error),
                const SizedBox(width: 4),
                Text(
                  hasCreds ? 'Credentials configured' : 'No credentials',
                  style: TextStyle(fontSize: 12, color: hasCreds ? AppColors.success : AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 4,
              runSpacing: 4,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.wifi_tethering, size: 16),
                  label: Text(l10n.testConnection),
                  onPressed: () => _testConnection(gw['id']),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(l10n.edit),
                  onPressed: () => _showEditDialog(gw),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 16, color: AppColors.error),
                  label: Text(l10n.delete, style: const TextStyle(color: AppColors.error)),
                  onPressed: () => _confirmDelete(gw['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _testConnection(int id) async {
    try {
      await ref.read(gatewayActionProvider.notifier).testConnection(id.toString());
      if (mounted) {
        showPosSuccessSnackbar(context, AppLocalizations.of(context)!.connectionTestSuccessful);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, AppLocalizations.of(context)!.connectionTestFailed(e.toString()));
      }
    }
  }

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    final webhookCtrl = TextEditingController();
    String env = 'sandbox';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminAddGateway),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Gateway Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: webhookCtrl,
                decoration: const InputDecoration(labelText: 'Webhook URL'),
              ),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setInnerState) => PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'sandbox', label: l10n.sandbox),
                    PosDropdownItem(value: 'production', label: l10n.production),
                  ],
                  selectedValue: env,
                  onChanged: (v) => setInnerState(() => env = v ?? env),
                  label: l10n.hwEnvironment,
                  hint: l10n.adminSelectEnvironment,
                  showSearch: false,
                  clearable: false,
                ),
              ),
            ],
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () async {
              await ref.read(gatewayActionProvider.notifier).createGateway({
                'gateway_name': nameCtrl.text,
                'webhook_url': webhookCtrl.text,
                'environment': env,
                'credentials': {'key': 'placeholder'},
                'is_active': true,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(gatewayListProvider.notifier).loadGateways(storeId: _storeId);
            },
            label: l10n.create,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> gw) {
    final nameCtrl = TextEditingController(text: gw['gateway_name']);
    final webhookCtrl = TextEditingController(text: gw['webhook_url']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminEditGateway),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Gateway Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: webhookCtrl,
                decoration: const InputDecoration(labelText: 'Webhook URL'),
              ),
            ],
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () async {
              await ref.read(gatewayActionProvider.notifier).updateGateway(gw['id'], {
                'gateway_name': nameCtrl.text,
                'webhook_url': webhookCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(gatewayListProvider.notifier).loadGateways(storeId: _storeId);
            },
            label: l10n.hwUpdate,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.adminDeleteGateway,
      message: l10n.adminDeleteGatewayConfirm,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed == true) {
      await ref.read(gatewayActionProvider.notifier).deleteGateway(id.toString());
      ref.read(gatewayListProvider.notifier).loadGateways(storeId: _storeId);
    }
  }
}
