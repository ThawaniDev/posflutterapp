import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/installment_provider.dart';
import 'package:wameedpos/features/payments/providers/installment_providers.dart';
import 'package:wameedpos/features/payments/providers/installment_state.dart';

// ─── Brand colors for each provider ────────────────────────────
class _ProviderBrand {

  const _ProviderBrand({required this.primary, required this.light, required this.asset});
  final Color primary;
  final Color light;
  final String asset;
}

const _brandMap = <String, _ProviderBrand>{
  'tabby': _ProviderBrand(primary: Color(0xFF3DFAB4), light: Color(0xFFE8FFF5), asset: 'assets/images/tabby.png'),
  'tamara': _ProviderBrand(primary: Color(0xFFE88B5A), light: Color(0xFFFFF3EC), asset: 'assets/images/tamara.png'),
  'mispay': _ProviderBrand(primary: Color(0xFF7C3AED), light: Color(0xFFF3EEFF), asset: 'assets/images/mispay.png'),
  'madfu': _ProviderBrand(primary: Color.fromARGB(255, 30, 57, 189), light: Color(0xFFECEEF8), asset: 'assets/images/madfu.png'),
};

_ProviderBrand _getBrand(String provider) =>
    _brandMap[provider] ?? const _ProviderBrand(primary: AppColors.primary, light: Color(0xFFFFF7ED), asset: '');

const _registrationUrls = <String, String>{
  'tabby': 'https://tabby.ai/ar-SA/business',
  'tamara': 'https://partners.tamara.co/onboarding?locale=ar_SA',
  'mispay': 'https://www.mispay.co/business/',
  'madfu': 'https://madfu.com.sa/ar/be-partner',
};

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

    final isLoading = state is StoreInstallmentConfigInitial || state is StoreInstallmentConfigLoading;
    final hasError = state is StoreInstallmentConfigError;

    return PosListPage(
      title: l10n.installmentPayments,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(storeInstallmentConfigProvider.notifier).load(),
      child: switch (state) {
        StoreInstallmentConfigLoaded(:final availableProviders, :final configs) => _buildContent(
          availableProviders,
          configs,
          l10n,
          isDark,
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  // ─── Main content ─────────────────────────────────────────
  Widget _buildContent(List<Map<String, dynamic>> availableProviders, List configs, AppLocalizations l10n, bool isDark) {
    if (availableProviders.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: Icon(Icons.payment_rounded, size: 56, color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              AppSpacing.gapH16,
              Text(l10n.noInstallmentProvidersAvailable, style: AppTypography.bodyMedium),
            ],
          ),
        ),
      );
    }

    // Count stats
    final configuredCount = availableProviders.where((p) => p['is_configured'] == true).length;
    final activeCount = availableProviders.where((p) => p['is_store_enabled'] == true).length;

    return CustomScrollView(
      slivers: [
        // ── Summary header ──
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFFFF7ED), const Color(0xFFFEF3C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: isDark ? Colors.white10 : AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.installmentPayments, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        l10n.installmentCredentialsNote,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.mutedFor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _StatChip(value: '$activeCount', label: l10n.active, color: AppColors.success),
                const SizedBox(width: 8),
                _StatChip(value: '$configuredCount', label: l10n.configured, color: AppColors.info),
              ],
            ),
          ),
        ),

        // ── Provider cards ──
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList.separated(
            itemCount: availableProviders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _ProviderCard(
              data: availableProviders[index],
              l10n: l10n,
              isDark: isDark,
              onToggle: (providerValue) => ref.read(storeInstallmentConfigProvider.notifier).toggleConfig(providerValue),
              onSetup: (providerValue, providerData) => _showCredentialsDialog(providerValue, providerData, l10n),
              onDelete: (providerValue, name) => _confirmDelete(providerValue, name, l10n),
              onTest: (providerValue) => _testConnection(providerValue, l10n),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Credentials dialog ───────────────────────────────────
  void _showCredentialsDialog(String providerValue, Map<String, dynamic> providerData, AppLocalizations l10n) {
    final provider = InstallmentProvider.tryFromValue(providerValue);
    if (provider == null) return;

    final brand = _getBrand(providerValue);
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
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Dialog header with brand color ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: brand.primary.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.lg),
                      topRight: Radius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (brand.asset.isNotEmpty)
                        ClipRRect(
                          borderRadius: AppRadius.borderMd,
                          child: Image.asset(brand.asset, width: 40, height: 40, fit: BoxFit.contain),
                        ),
                      if (brand.asset.isNotEmpty) const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${provider.label} ${l10n.credentials}',
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.installmentCredentialsNote,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Form body ──
                Flexible(
                  child: SingleChildScrollView(
                    padding: AppSpacing.paddingAll24,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Environment selector
                        Text(l10n.sandbox, style: AppTypography.labelMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _EnvChip(
                              label: l10n.sandbox,
                              icon: Icons.science_rounded,
                              selected: selectedEnv == 'sandbox',
                              color: AppColors.warning,
                              onTap: () => setDialogState(() => selectedEnv = 'sandbox'),
                            ),
                            const SizedBox(width: 8),
                            _EnvChip(
                              label: l10n.production,
                              icon: Icons.rocket_launch_rounded,
                              selected: selectedEnv == 'production',
                              color: AppColors.success,
                              onTap: () => setDialogState(() => selectedEnv = 'production'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

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
                      ],
                    ),
                  ),
                ),

                // ── Actions ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
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
                ),
              ],
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

  // ─── Test connection ───────────────────────────────────────
  void _testConnection(String providerValue, AppLocalizations l10n) {
    final brand = _getBrand(providerValue);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _TestConnectionDialog(
        providerValue: providerValue,
        brand: brand,
        l10n: l10n,
        onTest: () => ref.read(storeInstallmentConfigProvider.notifier).testConnection(providerValue),
      ),
    );
  }

  // ─── Delete confirmation ──────────────────────────────────
  void _confirmDelete(String providerValue, String providerName, AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.removeProvider,
      message: l10n.removeProviderConfirm(providerName),
      confirmLabel: l10n.remove,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(storeInstallmentConfigProvider.notifier).deleteConfig(providerValue);
    }
  }
}

// ═════════════════════════════════════════════════════════════════
// ── Provider Card Widget ────────────────────────────────────────
// ═════════════════════════════════════════════════════════════════

class _ProviderCard extends StatelessWidget {

  const _ProviderCard({
    required this.data,
    required this.l10n,
    required this.isDark,
    required this.onToggle,
    required this.onSetup,
    required this.onDelete,
    required this.onTest,
  });
  final Map<String, dynamic> data;
  final AppLocalizations l10n;
  final bool isDark;
  final ValueChanged<String> onToggle;
  final void Function(String providerValue, Map<String, dynamic> data) onSetup;
  final void Function(String providerValue, String name) onDelete;
  final ValueChanged<String> onTest;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final providerMap = data['provider'] as Map<String, dynamic>? ?? {};
    final name = isAr ? (providerMap['name_ar'] ?? providerMap['name'] ?? '') : (providerMap['name'] ?? '');
    final description = isAr
        ? (providerMap['description_ar'] ?? providerMap['description'] ?? '')
        : (providerMap['description'] ?? '');
    final providerValue = providerMap['provider'] as String? ?? '';
    final isConfigured = data['is_configured'] as bool? ?? false;
    final isStoreEnabled = data['is_store_enabled'] as bool? ?? false;
    final isUnderMaintenance = providerMap['is_under_maintenance'] as bool? ?? false;
    final brand = _getBrand(providerValue);

    final supportedCurrencies = (providerMap['supported_currencies'] as List?)?.join(', ') ?? '';
    final minAmount = providerMap['min_amount'];
    final maxAmount = providerMap['max_amount'];
    final installmentCounts = (providerMap['supported_installment_counts'] as List?)?.join(', ') ?? '';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: isStoreEnabled ? brand.primary.withValues(alpha: 0.4) : (isDark ? Colors.white10 : Theme.of(context).dividerColor),
          width: isStoreEnabled ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isStoreEnabled ? brand.primary : Colors.black).withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card header with logo + toggle ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            decoration: BoxDecoration(
              color: brand.primary.withValues(alpha: isDark ? 0.08 : 0.05),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppRadius.lg), topRight: Radius.circular(AppRadius.lg)),
            ),
            child: Row(
              children: [
                // Logo
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
                    borderRadius: AppRadius.borderMd,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: brand.asset.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(brand.asset, fit: BoxFit.contain),
                        )
                      : Icon(Icons.payment, color: brand.primary, size: 28),
                ),
                const SizedBox(width: 12),

                // Name + status badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.toString(), style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (isUnderMaintenance)
                            _StatusPill(label: l10n.maintenance, color: AppColors.warning, icon: Icons.engineering_rounded)
                          else if (isStoreEnabled)
                            _StatusPill(label: l10n.active, color: AppColors.success, icon: Icons.check_circle_outline_rounded)
                          else
                            _StatusPill(
                              label: isConfigured ? l10n.configured : l10n.notConfigured,
                              color: isConfigured ? AppColors.info : AppColors.mutedFor(context),
                              icon: isConfigured ? Icons.settings_rounded : Icons.radio_button_unchecked,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Toggle
                if (isConfigured && !isUnderMaintenance)
                  Switch.adaptive(value: isStoreEnabled, activeColor: brand.primary, onChanged: (_) => onToggle(providerValue)),
              ],
            ),
          ),

          // ── Card body — details + actions ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                if (description.toString().isNotEmpty) ...[
                  Text(
                    description.toString(),
                    style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                ],

                // Info chips row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (supportedCurrencies.isNotEmpty)
                      _InfoChip(icon: Icons.monetization_on_outlined, label: supportedCurrencies),
                    if (minAmount != null && maxAmount != null)
                      _InfoChip(icon: Icons.straighten_rounded, label: '$minAmount – $maxAmount'),
                    if (installmentCounts.isNotEmpty)
                      _InfoChip(icon: Icons.calendar_today_rounded, label: '$installmentCounts ${l10n.months}'),
                  ],
                ),
                const SizedBox(height: 14),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: isConfigured ? l10n.editCredentials : l10n.setupCredentials,
                        icon: isConfigured ? Icons.edit_rounded : Icons.key_rounded,
                        color: brand.primary,
                        isDark: isDark,
                        onPressed: isUnderMaintenance ? null : () => onSetup(providerValue, data),
                      ),
                    ),
                    if (isConfigured) ...[
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: l10n.testConnection,
                        icon: Icons.wifi_tethering_rounded,
                        color: AppColors.info,
                        isDark: isDark,
                        onPressed: () => onTest(providerValue),
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: l10n.remove,
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.error,
                        isDark: isDark,
                        onPressed: () => onDelete(providerValue, name.toString()),
                      ),
                    ] else if (_registrationUrls.containsKey(providerValue)) ...[
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: l10n.registerOn(name.toString()),
                        icon: Icons.open_in_new_rounded,
                        color: brand.primary,
                        isDark: isDark,
                        onPressed: () =>
                            launchUrl(Uri.parse(_registrationUrls[providerValue]!), mode: LaunchMode.externalApplication),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════
// ── Small helper widgets ────────────────────────────────────────
// ═════════════════════════════════════════════════════════════════

class _StatChip extends StatelessWidget {

  const _StatChip({required this.value, required this.label, required this.color});
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(color: color, fontWeight: FontWeight.w800),
          ),
          Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {

  const _StatusPill({required this.label, required this.color, required this.icon});
  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderXxl),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {

  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.borderSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.mutedFor(context)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {

  const _ActionButton({required this.label, required this.icon, required this.color, required this.isDark, this.onPressed});
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null ? color.withValues(alpha: isDark ? 0.15 : 0.08) : Colors.grey.withValues(alpha: 0.08),
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: onPressed != null ? color : Colors.grey),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: onPressed != null ? color : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnvChip extends StatelessWidget {

  const _EnvChip({required this.label, required this.icon, required this.selected, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: AppRadius.borderMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderMd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: selected ? color : Theme.of(context).dividerColor, width: selected ? 1.5 : 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: selected ? color : AppColors.mutedFor(context)),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: selected ? color : AppColors.mutedFor(context),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════
// ── Test Connection Dialog ──────────────────────────────────────
// ═════════════════════════════════════════════════════════════════

class _TestConnectionDialog extends StatefulWidget {

  const _TestConnectionDialog({required this.providerValue, required this.brand, required this.l10n, required this.onTest});
  final String providerValue;
  final _ProviderBrand brand;
  final AppLocalizations l10n;
  final Future<Map<String, dynamic>> Function() onTest;

  @override
  State<_TestConnectionDialog> createState() => _TestConnectionDialogState();
}

class _TestConnectionDialogState extends State<_TestConnectionDialog> {
  bool _loading = true;
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _runTest();
  }

  Future<void> _runTest() async {
    setState(() {
      _loading = true;
      _result = null;
    });
    final result = await widget.onTest();
    if (mounted) {
      setState(() {
        _loading = false;
        _result = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final success = _result?['success'] == true;
    final message = _result?['message'] as String? ?? '';
    final env = _result?['environment'] as String? ?? '';
    final latency = _result?['latency_ms'];
    final statusCode = _result?['status_code'];
    final brand = widget.brand;
    final l10n = widget.l10n;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _loading
                    ? SizedBox(
                        key: const ValueKey('loading'),
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(strokeWidth: 3, color: brand.primary),
                      )
                    : Container(
                        key: ValueKey(success),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: (success ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          success ? Icons.check_circle_rounded : Icons.error_rounded,
                          size: 40,
                          color: success ? AppColors.success : AppColors.error,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // ── Title ──
              Text(
                _loading ? l10n.testingConnection : (success ? l10n.connectionSuccessful : l10n.connectionFailed),
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // ── Message ──
              if (!_loading && message.isNotEmpty)
                Text(
                  message,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                  textAlign: TextAlign.center,
                ),

              // ── Details chips ──
              if (!_loading) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    if (env.isNotEmpty) _InfoChip(icon: Icons.dns_rounded, label: env),
                    if (latency != null) _InfoChip(icon: Icons.speed_rounded, label: '${latency}ms'),
                    if (statusCode != null) _InfoChip(icon: Icons.http_rounded, label: 'HTTP $statusCode'),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // ── Actions ──
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: l10n.close,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  if (!_loading && !success) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: PosButton(label: l10n.retry, onPressed: _runTest),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
