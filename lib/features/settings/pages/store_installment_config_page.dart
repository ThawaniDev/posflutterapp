import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/payments/enums/installment_provider.dart';
import 'package:thawani_pos/features/payments/providers/installment_providers.dart';
import 'package:thawani_pos/features/payments/providers/installment_state.dart';

/// Store-level page for configuring installment payment provider credentials.
class StoreInstallmentConfigPage extends ConsumerStatefulWidget {
  const StoreInstallmentConfigPage({super.key});

  @override
  ConsumerState<StoreInstallmentConfigPage> createState() => _StoreInstallmentConfigPageState();
}

class _StoreInstallmentConfigPageState extends ConsumerState<StoreInstallmentConfigPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(storeInstallmentConfigProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeInstallmentConfigProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.installmentPayments), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: switch (state) {
        StoreInstallmentConfigInitial() || StoreInstallmentConfigLoading() => const Center(child: CircularProgressIndicator()),
        StoreInstallmentConfigError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              AppSpacing.gapH16,
              Text(message, style: AppTypography.bodyMedium),
              AppSpacing.gapH16,
              PosButton(label: l10n.retry, onPressed: () => ref.read(storeInstallmentConfigProvider.notifier).load()),
            ],
          ),
        ),
        StoreInstallmentConfigLoaded(:final availableProviders, :final configs) => _buildContent(
          availableProviders,
          configs,
          l10n,
          isDark,
        ),
      },
    );
  }

  Widget _buildContent(List<Map<String, dynamic>> availableProviders, List configs, AppLocalizations l10n, bool isDark) {
    if (availableProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.payment_rounded, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
            AppSpacing.gapH16,
            Text(l10n.noInstallmentProvidersAvailable, style: AppTypography.bodyMedium),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: AppSpacing.paddingAll16,
      itemCount: availableProviders.length,
      separatorBuilder: (_, __) => AppSpacing.gapH12,
      itemBuilder: (context, index) => _buildProviderTile(availableProviders[index], l10n, isDark),
    );
  }

  Widget _buildProviderTile(Map<String, dynamic> providerData, AppLocalizations l10n, bool isDark) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final providerMap = providerData['provider'] as Map<String, dynamic>? ?? {};
    final name = isAr ? (providerMap['name_ar'] ?? providerMap['name'] ?? '') : (providerMap['name'] ?? '');
    final providerValue = providerMap['provider'] as String? ?? '';
    final isConfigured = providerData['is_configured'] as bool? ?? false;
    final isStoreEnabled = providerData['is_store_enabled'] as bool? ?? false;
    final isUnderMaintenance = providerMap['is_under_maintenance'] as bool? ?? false;

    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), borderRadius: AppRadius.borderMd),
                  child: const Icon(Icons.payment, color: AppColors.primary, size: 22),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.toString(), style: AppTypography.titleMedium),
                      Row(
                        children: [
                          PosStatusBadge(
                            label: isConfigured ? l10n.configured : l10n.notConfigured,
                            variant: isConfigured ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.warning,
                          ),
                          AppSpacing.gapW4,
                          if (isStoreEnabled) PosStatusBadge(label: l10n.active, variant: PosStatusBadgeVariant.success),
                          if (isUnderMaintenance) PosStatusBadge(label: l10n.maintenance, variant: PosStatusBadgeVariant.warning),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isConfigured)
                  Switch(
                    value: isStoreEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      ref.read(storeInstallmentConfigProvider.notifier).toggleConfig(providerValue);
                    },
                  ),
              ],
            ),
            AppSpacing.gapH12,
            Row(
              children: [
                Expanded(
                  child: PosButton(
                    label: isConfigured ? l10n.editCredentials : l10n.setupCredentials,
                    variant: PosButtonVariant.outline,
                    size: PosButtonSize.sm,
                    icon: isConfigured ? Icons.edit_rounded : Icons.key_rounded,
                    onPressed: isUnderMaintenance ? null : () => _showCredentialsDialog(providerValue, providerData, l10n),
                  ),
                ),
                if (isConfigured) ...[
                  AppSpacing.gapW8,
                  PosButton(
                    label: l10n.remove,
                    variant: PosButtonVariant.outline,
                    size: PosButtonSize.sm,
                    icon: Icons.delete_outline_rounded,
                    onPressed: () => _confirmDelete(providerValue, name.toString(), l10n),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCredentialsDialog(String providerValue, Map<String, dynamic> providerData, AppLocalizations l10n) {
    final provider = InstallmentProvider.tryFromValue(providerValue);
    if (provider == null) return;

    final credentialFields = _getCredentialFields(provider, l10n);
    final controllers = <String, TextEditingController>{};
    final storeConfig = providerData['store_config'] as Map<String, dynamic>?;
    final maskedCreds = (storeConfig?['masked_credentials'] as Map<String, dynamic>?) ?? {};

    for (final field in credentialFields) {
      controllers[field['key']!] = TextEditingController(text: maskedCreds[field['key']] as String? ?? '');
    }

    String selectedEnv = (storeConfig?['environment'] as String?) ?? 'sandbox';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: AppSpacing.paddingAll24,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${provider.label} ${l10n.credentials}', style: AppTypography.headlineSmall),
                    AppSpacing.gapH8,
                    Text(
                      l10n.installmentCredentialsNote,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight),
                    ),
                    AppSpacing.gapH16,
                    // Environment selector
                    PosSearchableDropdown<String>(
                      items: [
                        PosDropdownItem(value: 'sandbox', label: l10n.sandbox),
                        PosDropdownItem(value: 'production', label: l10n.production),
                      ],
                      selectedValue: selectedEnv,
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedEnv = v);
                      },
                      showSearch: false,
                    ),
                    AppSpacing.gapH16,
                    // Credential fields
                    ...credentialFields.map(
                      (field) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PosTextField(
                          controller: controllers[field['key']]!,
                          label: field['label']!,
                          hint: field['hint'] ?? '',
                          obscureText: field['obscure'] == 'true',
                        ),
                      ),
                    ),
                    AppSpacing.gapH24,
                    Row(
                      children: [
                        Expanded(
                          child: PosButton(
                            label: l10n.cancel,
                            variant: PosButtonVariant.outline,
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: PosButton(
                            label: l10n.save,
                            onPressed: () {
                              final credentials = <String, String>{};
                              for (final entry in controllers.entries) {
                                final text = entry.value.text.trim();
                                // Only send if value was changed (not masked)
                                if (text.isNotEmpty && !text.startsWith('****')) {
                                  credentials[entry.key] = text;
                                }
                              }
                              Navigator.pop(ctx);
                              ref.read(storeInstallmentConfigProvider.notifier).upsertConfig({
                                'provider': providerValue,
                                'credentials': credentials,
                                'environment': selectedEnv,
                                'is_enabled': true,
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getCredentialFields(InstallmentProvider provider, AppLocalizations l10n) {
    switch (provider) {
      case InstallmentProvider.tabby:
        return [
          {'key': 'public_key', 'label': l10n.publicKey, 'hint': 'pk_...'},
          {'key': 'secret_key', 'label': l10n.secretKey, 'hint': 'sk_...', 'obscure': 'true'},
          {'key': 'merchant_code', 'label': l10n.merchantCode, 'hint': 'e.g. your_merchant_code'},
        ];
      case InstallmentProvider.tamara:
        return [
          {'key': 'api_token', 'label': l10n.apiToken, 'hint': 'Tamara API token', 'obscure': 'true'},
        ];
      case InstallmentProvider.mispay:
        return [
          {'key': 'app_id', 'label': l10n.appId, 'hint': 'MisPay App ID'},
          {'key': 'app_secret', 'label': l10n.appSecret, 'hint': 'MisPay App Secret', 'obscure': 'true'},
        ];
      case InstallmentProvider.madfu:
        return [
          {'key': 'api_key', 'label': l10n.apiKey, 'hint': 'Madfu API Key'},
          {'key': 'app_code', 'label': l10n.appCode, 'hint': 'Madfu App Code'},
          {'key': 'authorization', 'label': l10n.authorization, 'hint': 'Madfu Authorization', 'obscure': 'true'},
          {'key': 'username', 'label': l10n.username, 'hint': 'Madfu merchant username'},
          {'key': 'password', 'label': l10n.password, 'hint': 'Madfu merchant password', 'obscure': 'true'},
        ];
    }
  }

  void _confirmDelete(String providerValue, String providerName, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeProvider),
        content: Text(l10n.removeProviderConfirm(providerName)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(storeInstallmentConfigProvider.notifier).deleteConfig(providerValue);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
  }
}
