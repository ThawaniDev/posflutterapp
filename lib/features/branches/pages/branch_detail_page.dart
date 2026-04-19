import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/branches/providers/branch_providers.dart';
import 'package:wameedpos/features/branches/providers/branch_state.dart';

class BranchDetailPage extends ConsumerWidget {
  final String branchId;
  const BranchDetailPage({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(branchDetailProvider(branchId));

    return PosListPage(
      title: l10n.branchesBranchDetail,
      showSearch: false,
      actions: [
        if (state is BranchDetailLoaded)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (v) => _onAction(context, ref, v, state.branch),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(l10n.branchesEditBranch)),
              PopupMenuItem(value: 'settings', child: Text(l10n.branchesSettings)),
              PopupMenuItem(value: 'working_hours', child: Text(l10n.branchesWorkingHours)),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'toggle',
                child: Text(state.branch.isActive ? l10n.branchesDeactivated : l10n.branchesActivated),
              ),
              if (!state.branch.isMainBranch)
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l10n.branchesDeleteBranch, style: const TextStyle(color: AppColors.error)),
                ),
            ],
          ),
      ],
      isLoading: state is BranchDetailInitial || state is BranchDetailLoading,
      hasError: state is BranchDetailError,
      errorMessage: state is BranchDetailError ? (state).message : null,
      onRetry: () => ref.read(branchDetailProvider(branchId).notifier).load(branchId),
      child: switch (state) {
        BranchDetailLoaded(:final branch) => _buildContent(context, branch),
        _ => const SizedBox.shrink(),
      },
    );
  }

  void _onAction(BuildContext context, WidgetRef ref, String action, Store branch) async {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case 'edit':
        context.push('${Routes.branches}/${branch.id}/edit');
        break;
      case 'settings':
        context.push('${Routes.storeSettings}/${branch.id}');
        break;
      case 'working_hours':
        context.push('${Routes.workingHours}/${branch.id}');
        break;
      case 'toggle':
        final success = await ref.read(branchListProvider.notifier).toggleActive(branch.id);
        if (success && context.mounted) {
          ref.read(branchDetailProvider(branchId).notifier).load(branchId);
          showPosInfoSnackbar(context, branch.isActive ? l10n.branchesDeactivated : l10n.branchesActivated);
        }
        break;
      case 'delete':
        final confirmed = await showPosConfirmDialog(
          context,
          title: l10n.branchesDeleteBranch,
          message: l10n.branchesDeleteConfirm,
          confirmLabel: l10n.commonDelete,
          cancelLabel: l10n.commonCancel,
          isDanger: true,
        );
        if (confirmed == true && context.mounted) {
          final success = await ref.read(branchListProvider.notifier).deleteBranch(branch.id);
          if (success && context.mounted) {
            showPosSuccessSnackbar(context, l10n.branchesDeleted);
            context.pop();
          }
        }
        break;
    }
  }

  Widget _buildContent(BuildContext context, Store branch) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        children: [
          // Header card
          _headerCard(context, branch, l10n),
          AppSpacing.gapH16,

          // Quick actions
          Row(
            children: [
              _actionButton(
                context,
                Icons.settings,
                l10n.branchesSettings,
                () => context.push('${Routes.storeSettings}/${branch.id}'),
              ),
              AppSpacing.gapW8,
              _actionButton(
                context,
                Icons.schedule,
                l10n.branchesWorkingHours,
                () => context.push('${Routes.workingHours}/${branch.id}'),
              ),
              AppSpacing.gapW8,
              _actionButton(
                context,
                Icons.edit,
                l10n.branchesEditBranch,
                () => context.push('${Routes.branches}/${branch.id}/edit'),
              ),
            ],
          ),
          AppSpacing.gapH16,

          // Info sections
          _infoSection(context, l10n.branchesBasicInfo, Icons.info_outline, [
            _infoRow(l10n.branchesBranchName, branch.name),
            if (branch.nameAr != null) _infoRow(l10n.branchesBranchNameAr, branch.nameAr!),
            if (branch.branchCode != null) _infoRow(l10n.branchesBranchCode, branch.branchCode!),
            if (branch.description != null) _infoRow(l10n.branchesDescription, branch.description!),
            if (branch.businessType != null) _infoRow(l10n.branchesBusinessType, branch.businessType!.value),
            if (branch.timezone != null) _infoRow(l10n.branchesTimezone, branch.timezone!),
            if (branch.currency != null) _infoRow(l10n.branchesCurrency, branch.currency!),
          ]),
          AppSpacing.gapH12,

          _infoSection(context, l10n.branchesLocationInfo, Icons.location_on_outlined, [
            if (branch.address != null) _infoRow(l10n.branchesAddress, branch.address!),
            if (branch.city != null) _infoRow(l10n.branchesCity, branch.city!),
            if (branch.region != null) _infoRow(l10n.branchesRegion, branch.region!),
            if (branch.postalCode != null) _infoRow(l10n.branchesPostalCode, branch.postalCode!),
            if (branch.country != null) _infoRow(l10n.branchesCountry, branch.country!),
            if (branch.latitude != null && branch.longitude != null)
              _infoRow(l10n.branchesLatitude, '${branch.latitude}, ${branch.longitude}'),
          ]),
          AppSpacing.gapH12,

          _infoSection(context, l10n.branchesContactInfo, Icons.phone_outlined, [
            if (branch.phone != null) _infoRow(l10n.branchesPhone, branch.phone!),
            if (branch.secondaryPhone != null) _infoRow(l10n.branchesSecondaryPhone, branch.secondaryPhone!),
            if (branch.email != null) _infoRow(l10n.branchesEmail, branch.email!),
            if (branch.contactPerson != null) _infoRow(l10n.branchesContactPerson, branch.contactPerson!),
            if (branch.manager != null) _infoRow(l10n.branchesManager, branch.manager!['name'] as String? ?? '-'),
          ]),
          AppSpacing.gapH12,

          _infoSection(context, l10n.branchesOperationalInfo, Icons.business_outlined, [
            if (branch.openingDate != null) _infoRow(l10n.branchesOpeningDate, branch.openingDate!),
            if (branch.closingDate != null) _infoRow(l10n.branchesClosingDate, branch.closingDate!),
            if (branch.maxRegisters != null) _infoRow(l10n.branchesMaxRegisters, '${branch.maxRegisters}'),
            if (branch.maxStaff != null) _infoRow(l10n.branchesMaxStaff, '${branch.maxStaff}'),
            if (branch.areaSqm != null) _infoRow(l10n.branchesAreaSqm, '${branch.areaSqm}'),
            if (branch.seatingCapacity != null) _infoRow(l10n.branchesSeatingCapacity, '${branch.seatingCapacity}'),
          ]),
          AppSpacing.gapH12,

          _infoSection(context, l10n.branchesFlags, Icons.flag_outlined, [
            _flagRow(l10n.branchesIsMainBranch, branch.isMainBranch),
            _flagRow(l10n.branchesIsWarehouse, branch.isWarehouse),
            _flagRow(l10n.branchesAcceptsOnlineOrders, branch.acceptsOnlineOrders),
            _flagRow(l10n.branchesAcceptsReservations, branch.acceptsReservations),
            _flagRow(l10n.branchesHasDelivery, branch.hasDelivery),
            _flagRow(l10n.branchesHasPickup, branch.hasPickup),
          ]),
          AppSpacing.gapH12,

          if (branch.crNumber != null || branch.vatNumber != null || branch.municipalLicense != null)
            _infoSection(context, l10n.branchesLegalInfo, Icons.gavel_outlined, [
              if (branch.crNumber != null) _infoRow(l10n.branchesCrNumber, branch.crNumber!),
              if (branch.vatNumber != null) _infoRow(l10n.branchesVatNumber, branch.vatNumber!),
              if (branch.municipalLicense != null) _infoRow(l10n.branchesMunicipalLicense, branch.municipalLicense!),
              if (branch.licenseExpiryDate != null) _infoRow(l10n.branchesLicenseExpiryDate, branch.licenseExpiryDate!),
            ]),

          if (branch.socialLinks != null && (branch.socialLinks!).isNotEmpty) ...[
            AppSpacing.gapH12,
            _infoSection(context, l10n.branchesSocialLinks, Icons.link, [
              for (final entry in branch.socialLinks!.entries) _infoRow(entry.key, entry.value as String? ?? ''),
            ]),
          ],

          AppSpacing.gapH32,
        ],
      ),
    );
  }

  Widget _headerCard(BuildContext context, Store branch, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: branch.isMainBranch ? AppColors.primary20 : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: branch.isActive ? AppColors.primary10 : AppColors.mutedFor(context).withValues(alpha: 0.12),
            child: Icon(
              branch.isWarehouse ? Icons.warehouse : (branch.isMainBranch ? Icons.store : Icons.storefront),
              size: 32,
              color: branch.isActive ? AppColors.primary : AppColors.mutedFor(context),
            ),
          ),
          AppSpacing.gapH12,
          Text(branch.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          if (branch.nameAr != null) ...[
            const SizedBox(height: 2),
            Text(branch.nameAr!, style: TextStyle(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          ],
          AppSpacing.gapH8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PosStatusBadge(
                label: branch.isActive ? l10n.branchesActive : l10n.branchesInactive,
                variant: branch.isActive ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.error,
              ),
              if (branch.isMainBranch) ...[
                const SizedBox(width: 8),
                PosStatusBadge(label: l10n.branchesMain, variant: PosStatusBadgeVariant.info),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoSection(BuildContext context, String title, IconData icon, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                AppSpacing.gapW8,
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  label,
                  style: TextStyle(fontSize: 13, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
              Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
            ],
          ),
        );
      },
    );
  }

  Widget _flagRow(String label, bool value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_circle : Icons.cancel,
              size: 16,
              color: value ? AppColors.success : AppColors.mutedFor(context).withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
