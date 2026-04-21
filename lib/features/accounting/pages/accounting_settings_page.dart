import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/accounting/providers/accounting_providers.dart';
import 'package:wameedpos/features/accounting/providers/accounting_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AccountingSettingsPage extends ConsumerStatefulWidget {
  const AccountingSettingsPage({super.key});

  @override
  ConsumerState<AccountingSettingsPage> createState() => _AccountingSettingsPageState();
}

class _AccountingSettingsPageState extends ConsumerState<AccountingSettingsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String _selectedProvider = 'quickbooks';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(accountingConnectionProvider.notifier).loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(accountingConnectionProvider);
    final actionState = ref.watch(accountingActionProvider);

    ref.listen<AccountingActionState>(accountingActionProvider, (prev, next) {
      if (next is AccountingActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(accountingConnectionProvider.notifier).loadStatus();
      } else if (next is AccountingActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosFormPage(
      title: l10n.accountingTitle,
      isLoading: connectionState is AccountingConnectionInitial || connectionState is AccountingConnectionLoading,
      child: switch (connectionState) {
        AccountingConnectionError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(accountingConnectionProvider.notifier).loadStatus(),
        ),
        AccountingConnectionLoaded(
          :final connected,
          :final provider,
          :final companyName,
          :final connectedAt,
          :final lastSyncAt,
          :final tokenExpiresAt,
          :final health,
        ) =>
          connected
              ? _buildConnectedView(
                  provider: provider,
                  companyName: companyName,
                  connectedAt: connectedAt,
                  lastSyncAt: lastSyncAt,
                  tokenExpiresAt: tokenExpiresAt,
                  health: health,
                  actionLoading: actionState is AccountingActionLoading,
                )
              : _buildDisconnectedView(actionLoading: actionState is AccountingActionLoading),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildConnectedView({
    String? provider,
    String? companyName,
    String? connectedAt,
    String? lastSyncAt,
    String? tokenExpiresAt,
    required String health,
    required bool actionLoading,
  }) {
    final Color healthColor = switch (health) {
      'healthy' => AppColors.success,
      'warning' => AppColors.warning,
      _ => AppColors.error,
    };

    final IconData healthIcon = switch (health) {
      'healthy' => Icons.check_circle,
      'warning' => Icons.warning,
      _ => Icons.error,
    };

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Connection status card
          PosCard(
            elevation: 0,
            borderRadius: AppRadius.borderMd,
            border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(healthIcon, color: healthColor, size: 28),
                      AppSpacing.gapW12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connected to ${_providerDisplayName(provider ?? '')}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            AppSpacing.gapH4,
                            Text(
                              'Status: ${health[0].toUpperCase()}${health.substring(1)}',
                              style: TextStyle(color: healthColor, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (companyName != null) _buildInfoRow('Company', companyName),
                  if (connectedAt != null) _buildInfoRow('Connected', _formatDate(connectedAt)),
                  if (lastSyncAt != null) _buildInfoRow('Last Sync', _formatDate(lastSyncAt)),
                  if (tokenExpiresAt != null) _buildInfoRow('Token Expires', _formatDate(tokenExpiresAt)),
                ],
              ),
            ),
          ),
          AppSpacing.gapH16,

          // Quick actions
          PosCard(
            elevation: 0,
            borderRadius: AppRadius.borderMd,
            border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.deliveryQuickActions, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  AppSpacing.gapH12,
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: Text(l10n.accountingMappings),
                    subtitle: Text(l10n.mapPosAccountsToProviderAccounts),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}, // Navigate to mapping page
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_download),
                    title: Text(l10n.accountingExportHistory),
                    subtitle: Text(l10n.viewAndManageExports),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}, // Navigate to export page
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Text(l10n.autoExportSettings),
                    subtitle: Text(l10n.scheduleAutomaticExports),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}, // Navigate to auto-export page
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapH24,

          // Disconnect button
          OutlinedButton.icon(
            onPressed: actionLoading ? null : _showDisconnectDialog,
            icon: const Icon(Icons.link_off, color: AppColors.error),
            label: Text(l10n.accountingDisconnect, style: const TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: AppSpacing.paddingV12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedView({required bool actionLoading}) {
    const providers = ['quickbooks', 'xero', 'qoyod'];

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Empty state
          AppSpacing.gapH32,
          const Icon(Icons.account_balance, size: 72, color: AppColors.textSecondary),
          AppSpacing.gapH16,
          const Text(
            'No Accounting Provider Connected',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          AppSpacing.gapH8,
          const Text(
            'Connect your accounting software to sync transactions, invoices, and reports.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          AppSpacing.gapH32,

          // Provider selection
          PosCard(
            elevation: 0,
            borderRadius: AppRadius.borderMd,
            border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Provider', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  AppSpacing.gapH12,
                  ...providers.map(
                    (p) => RadioListTile<String>(
                      value: p,
                      groupValue: _selectedProvider,
                      title: Text(_providerDisplayName(p)),
                      subtitle: Text(_providerDescription(p)),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedProvider = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapH16,

          // Connect button
          ElevatedButton.icon(
            onPressed: actionLoading ? null : _showConnectDialog,
            icon: actionLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.link),
            label: Text(l10n.acctConnectProvider(_providerDisplayName(_selectedProvider))),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showConnectDialog() {
    final accessTokenController = TextEditingController();
    final refreshTokenController = TextEditingController();
    final expiresAtController = TextEditingController();
    final companyController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Connect ${_providerDisplayName(_selectedProvider)}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: accessTokenController,
                decoration: const InputDecoration(labelText: 'Access Token', border: OutlineInputBorder()),
              ),
              AppSpacing.gapH12,
              TextField(
                controller: refreshTokenController,
                decoration: const InputDecoration(labelText: 'Refresh Token', border: OutlineInputBorder()),
              ),
              AppSpacing.gapH12,
              TextField(
                controller: expiresAtController,
                decoration: const InputDecoration(labelText: 'Token Expires At (YYYY-MM-DD)', border: OutlineInputBorder()),
              ),
              AppSpacing.gapH12,
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Company Name (optional)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.of(ctx).pop(), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(accountingActionProvider.notifier)
                  .connect(
                    provider: _selectedProvider,
                    accessToken: accessTokenController.text,
                    refreshToken: refreshTokenController.text,
                    tokenExpiresAt: expiresAtController.text,
                    companyName: companyController.text.isNotEmpty ? companyController.text : null,
                  );
            },
            label: l10n.connect,
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog() async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.acctDisconnectProvider,
      message:
          'Are you sure you want to disconnect your accounting provider? '
          'Existing mappings and export history will be preserved.',
      confirmLabel: l10n.acctDisconnect,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(accountingActionProvider.notifier).disconnect();
    }
  }

  String _providerDisplayName(String provider) {
    return switch (provider) {
      'quickbooks' => 'QuickBooks',
      'xero' => 'Xero',
      'qoyod' => 'Qoyod',
      _ => provider,
    };
  }

  String _providerDescription(String provider) {
    return switch (provider) {
      'quickbooks' => 'Intuit QuickBooks Online',
      'xero' => 'Xero Cloud Accounting',
      'qoyod' => 'Qoyod Arabic Accounting',
      _ => '',
    };
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
