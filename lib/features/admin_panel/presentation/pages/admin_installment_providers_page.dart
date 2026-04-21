import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/models/installment_provider_config.dart';
import 'package:wameedpos/features/payments/providers/installment_providers.dart';
import 'package:wameedpos/features/payments/providers/installment_state.dart';

/// Platform admin page for managing installment payment providers (Tabby, Tamara, MisPay, Madfu).
class AdminInstallmentProvidersPage extends ConsumerStatefulWidget {
  const AdminInstallmentProvidersPage({super.key});

  @override
  ConsumerState<AdminInstallmentProvidersPage> createState() => _AdminInstallmentProvidersPageState();
}

class _AdminInstallmentProvidersPageState extends ConsumerState<AdminInstallmentProvidersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(installmentAdminProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(installmentAdminProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
  title: l10n.installmentProviders,
  showSearch: false,
    child: switch (state) {
        InstallmentAdminInitial() || InstallmentAdminLoading() => const Center(child: CircularProgressIndicator()),
        InstallmentAdminError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              AppSpacing.gapH16,
              Text(message, style: AppTypography.bodyMedium),
              AppSpacing.gapH16,
              PosButton(label: l10n.retry, onPressed: () => ref.read(installmentAdminProvider.notifier).load()),
            ],
          ),
        ),
        InstallmentAdminLoaded(:final providers) => _buildProviderList(providers, l10n, isDark),
      },
);
  }

  Widget _buildProviderList(List<InstallmentProviderConfig> providers, AppLocalizations l10n, bool isDark) {
    if (providers.isEmpty) {
      return Center(child: Text(l10n.noInstallmentProviders, style: AppTypography.bodyMedium));
    }

    return ListView.separated(
      padding: AppSpacing.paddingAll16,
      itemCount: providers.length,
      separatorBuilder: (_, __) => AppSpacing.gapH12,
      itemBuilder: (context, index) => _buildProviderCard(providers[index], l10n, isDark),
    );
  }

  Widget _buildProviderCard(InstallmentProviderConfig provider, AppLocalizations l10n, bool isDark) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final name = isAr ? (provider.nameAr ?? provider.name) : provider.name;
    final description = isAr ? (provider.descriptionAr ?? provider.description) : provider.description;

    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: logo, name, toggles
            Row(
              children: [
                // Provider icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), borderRadius: AppRadius.borderMd),
                  child: provider.logoUrl != null
                      ? ClipRRect(
                          borderRadius: AppRadius.borderMd,
                          child: Image.network(
                            provider.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.payment, color: AppColors.primary),
                          ),
                        )
                      : const Icon(Icons.payment, color: AppColors.primary),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTypography.titleMedium),
                      if (description != null)
                        Text(
                          description,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.mutedFor(context),
                          ),
                        ),
                    ],
                  ),
                ),
                // Status badges
                _buildStatusBadges(provider, l10n),
              ],
            ),
            AppSpacing.gapH16,

            // Details
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _infoChip(l10n.currencies, provider.supportedCurrencies.join(', ')),
                if (provider.minAmount != null) _infoChip(l10n.minAmount, provider.minAmount!.toStringAsFixed(2)),
                if (provider.maxAmount != null) _infoChip(l10n.maxAmount, provider.maxAmount!.toStringAsFixed(2)),
                _infoChip(l10n.installments, provider.supportedInstallmentCounts.join(', ')),
              ],
            ),
            AppSpacing.gapH16,

            // Action buttons
            Row(
              children: [
                // Enable/Disable toggle
                Expanded(
                  child: PosButton(
                    label: provider.isEnabled ? l10n.disable : l10n.enable,
                    variant: provider.isEnabled ? PosButtonVariant.outline : PosButtonVariant.primary,
                    size: PosButtonSize.sm,
                    icon: provider.isEnabled ? Icons.toggle_on : Icons.toggle_off,
                    onPressed: () => ref.read(installmentAdminProvider.notifier).toggleProvider(provider.id),
                  ),
                ),
                AppSpacing.gapW8,
                // Maintenance toggle
                Expanded(
                  child: PosButton(
                    label: provider.isUnderMaintenance ? l10n.endMaintenance : l10n.setMaintenance,
                    variant: PosButtonVariant.outline,
                    size: PosButtonSize.sm,
                    icon: Icons.build_rounded,
                    onPressed: () => _showMaintenanceDialog(provider, l10n),
                  ),
                ),
                AppSpacing.gapW8,
                // Edit
                Expanded(
                  child: PosButton(
                    label: l10n.edit,
                    variant: PosButtonVariant.outline,
                    size: PosButtonSize.sm,
                    icon: Icons.edit_rounded,
                    onPressed: () => _showEditDialog(provider, l10n),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadges(InstallmentProviderConfig provider, AppLocalizations l10n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosStatusBadge(
          label: provider.isEnabled ? l10n.enabled : l10n.disabled,
          variant: provider.isEnabled ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.error,
        ),
        if (provider.isUnderMaintenance) ...[
          AppSpacing.gapW4,
          PosStatusBadge(label: l10n.maintenance, variant: PosStatusBadgeVariant.warning),
        ],
      ],
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: AppRadius.borderSm),
      child: Text('$label: $value', style: AppTypography.labelSmall),
    );
  }

  void _showMaintenanceDialog(InstallmentProviderConfig provider, AppLocalizations l10n) {
    final messageController = TextEditingController(text: provider.maintenanceMessage);
    final messageArController = TextEditingController(text: provider.maintenanceMessageAr);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider.isUnderMaintenance ? l10n.endMaintenance : l10n.setMaintenance, style: AppTypography.headlineSmall),
                AppSpacing.gapH16,
                if (!provider.isUnderMaintenance) ...[
                  PosTextField(
                    controller: messageController,
                    label: l10n.maintenanceMessage,
                    hint: l10n.maintenanceMessageHint,
                    maxLines: 2,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: messageArController,
                    label: l10n.maintenanceMessageAr,
                    hint: l10n.maintenanceMessageHintAr,
                    maxLines: 2,
                  ),
                  AppSpacing.gapH16,
                ],
                if (provider.isUnderMaintenance) Text(l10n.endMaintenanceConfirm, style: AppTypography.bodyMedium),
                AppSpacing.gapH16,
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
                        label: l10n.confirm,
                        onPressed: () {
                          Navigator.pop(ctx);
                          ref.read(installmentAdminProvider.notifier).setMaintenance(provider.id, {
                            'is_under_maintenance': !provider.isUnderMaintenance,
                            if (!provider.isUnderMaintenance) 'maintenance_message': messageController.text,
                            if (!provider.isUnderMaintenance) 'maintenance_message_ar': messageArController.text,
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
    );
  }

  void _showEditDialog(InstallmentProviderConfig provider, AppLocalizations l10n) {
    final nameController = TextEditingController(text: provider.name);
    final nameArController = TextEditingController(text: provider.nameAr);
    final descController = TextEditingController(text: provider.description);
    final descArController = TextEditingController(text: provider.descriptionAr);
    final minAmountController = TextEditingController(text: provider.minAmount?.toString() ?? '');
    final maxAmountController = TextEditingController(text: provider.maxAmount?.toString() ?? '');
    final logoUrlController = TextEditingController(text: provider.logoUrl ?? '');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.editProvider, style: AppTypography.headlineSmall),
                  AppSpacing.gapH16,
                  PosTextField(controller: nameController, label: l10n.name),
                  AppSpacing.gapH12,
                  PosTextField(controller: nameArController, label: l10n.nameAr),
                  AppSpacing.gapH12,
                  PosTextField(controller: descController, label: l10n.description, maxLines: 2),
                  AppSpacing.gapH12,
                  PosTextField(controller: descArController, label: l10n.descriptionAr, maxLines: 2),
                  AppSpacing.gapH12,
                  PosTextField(controller: logoUrlController, label: l10n.logoUrl),
                  AppSpacing.gapH12,
                  Row(
                    children: [
                      Expanded(
                        child: PosTextField(
                          controller: minAmountController,
                          label: l10n.minAmount,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      AppSpacing.gapW12,
                      Expanded(
                        child: PosTextField(
                          controller: maxAmountController,
                          label: l10n.maxAmount,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
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
                            Navigator.pop(ctx);
                            ref.read(installmentAdminProvider.notifier).updateProvider(provider.id, {
                              'name': nameController.text,
                              'name_ar': nameArController.text,
                              'description': descController.text,
                              'description_ar': descArController.text,
                              'logo_url': logoUrlController.text.isEmpty ? null : logoUrlController.text,
                              'min_amount': double.tryParse(minAmountController.text),
                              'max_amount': double.tryParse(maxAmountController.text),
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
    );
  }
}
