import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/accounting/providers/accounting_providers.dart';
import 'package:thawani_pos/features/accounting/providers/accounting_state.dart';

class AccountingSettingsPage extends ConsumerStatefulWidget {
  const AccountingSettingsPage({super.key});

  @override
  ConsumerState<AccountingSettingsPage> createState() => _AccountingSettingsPageState();
}

class _AccountingSettingsPageState extends ConsumerState<AccountingSettingsPage> {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        ref.read(accountingConnectionProvider.notifier).loadStatus();
      } else if (next is AccountingActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: Colors.red));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Accounting Integration')),
      body: switch (connectionState) {
        AccountingConnectionInitial() || AccountingConnectionLoading() => const Center(child: CircularProgressIndicator()),
        AccountingConnectionError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 12),
              Text('Error: $message', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(accountingConnectionProvider.notifier).loadStatus(),
                child: const Text('Retry'),
              ),
            ],
          ),
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
      'healthy' => Colors.green,
      'warning' => Colors.orange,
      _ => Colors.red,
    };

    final IconData healthIcon = switch (health) {
      'healthy' => Icons.check_circle,
      'warning' => Icons.warning,
      _ => Icons.error,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Connection status card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(healthIcon, color: healthColor, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connected to ${_providerDisplayName(provider ?? '')}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
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
          const SizedBox(height: 16),

          // Quick actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('Account Mappings'),
                    subtitle: const Text('Map POS accounts to provider accounts'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}, // Navigate to mapping page
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_download),
                    title: const Text('Export History'),
                    subtitle: const Text('View and manage exports'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}, // Navigate to export page
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Auto Export Settings'),
                    subtitle: const Text('Schedule automatic exports'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}, // Navigate to auto-export page
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Disconnect button
          OutlinedButton.icon(
            onPressed: actionLoading ? null : _showDisconnectDialog,
            icon: const Icon(Icons.link_off, color: Colors.red),
            label: const Text('Disconnect', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedView({required bool actionLoading}) {
    const providers = ['quickbooks', 'xero', 'qoyod'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Empty state
          const SizedBox(height: 32),
          Icon(Icons.account_balance, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No Accounting Provider Connected',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Connect your accounting software to sync transactions, invoices, and reports.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),

          // Provider selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Provider', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
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
          const SizedBox(height: 16),

          // Connect button
          ElevatedButton.icon(
            onPressed: actionLoading ? null : _showConnectDialog,
            icon: actionLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.link),
            label: Text('Connect ${_providerDisplayName(_selectedProvider)}'),
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
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
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
              const SizedBox(height: 12),
              TextField(
                controller: refreshTokenController,
                decoration: const InputDecoration(labelText: 'Refresh Token', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: expiresAtController,
                decoration: const InputDecoration(labelText: 'Token Expires At (YYYY-MM-DD)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Company Name (optional)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
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
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect Provider'),
        content: const Text(
          'Are you sure you want to disconnect your accounting provider? '
          'Existing mappings and export history will be preserved.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(accountingActionProvider.notifier).disconnect();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Disconnect', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
