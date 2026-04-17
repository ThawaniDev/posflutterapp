import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';

class SupplierListPage extends ConsumerStatefulWidget {
  const SupplierListPage({super.key});

  @override
  ConsumerState<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends ConsumerState<SupplierListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(suppliersProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showSupplierDialog({Supplier? supplier}) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final phoneController = TextEditingController(text: supplier?.phone ?? '');
    final emailController = TextEditingController(text: supplier?.email ?? '');
    final websiteController = TextEditingController(text: supplier?.website ?? '');
    final addressController = TextEditingController(text: supplier?.address ?? '');
    final cityController = TextEditingController(text: supplier?.city ?? '');
    final countryController = TextEditingController(text: supplier?.country ?? '');
    final postalCodeController = TextEditingController(text: supplier?.postalCode ?? '');
    final contactPersonController = TextEditingController(text: supplier?.contactPerson ?? '');
    final taxNumberController = TextEditingController(text: supplier?.taxNumber ?? '');
    final paymentTermsController = TextEditingController(text: supplier?.paymentTerms ?? '');
    final bankNameController = TextEditingController(text: supplier?.bankName ?? '');
    final bankAccountController = TextEditingController(text: supplier?.bankAccount ?? '');
    final ibanController = TextEditingController(text: supplier?.iban ?? '');
    final creditLimitController = TextEditingController(text: supplier?.creditLimit?.toString() ?? '');
    final categoryController = TextEditingController(text: supplier?.category ?? '');
    final notesController = TextEditingController(text: supplier?.notes ?? '');
    final isEditing = supplier != null;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? l10n.supplierEdit : l10n.supplierNew),
        content: SizedBox(
          width: context.isPhone ? double.maxFinite : 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.supplierBasicInfo, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(controller: nameController, label: '${l10n.supplierName} *', hint: l10n.supplierNameHint),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(
                        controller: contactPersonController,
                        label: l10n.supplierContactPerson,
                        hint: l10n.supplierContactPersonHint,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PosTextField(
                        controller: categoryController,
                        label: l10n.supplierCategory,
                        hint: l10n.supplierCategoryHint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.supplierContactInfo, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(
                        controller: phoneController,
                        label: l10n.supplierPhone,
                        hint: '+966 XXXX XXXX',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PosTextField(
                        controller: emailController,
                        label: l10n.supplierEmail,
                        hint: 'supplier@example.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  controller: websiteController,
                  label: l10n.supplierWebsite,
                  hint: 'https://...',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.supplierAddress, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(
                  controller: addressController,
                  label: l10n.supplierAddressLine,
                  hint: l10n.supplierAddressHint,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.sm),
                context.isPhone
                    ? Column(
                        children: [
                          PosTextField(controller: cityController, label: l10n.supplierCity),
                          const SizedBox(height: AppSpacing.sm),
                          PosTextField(controller: countryController, label: l10n.supplierCountry),
                          const SizedBox(height: AppSpacing.sm),
                          PosTextField(controller: postalCodeController, label: l10n.supplierPostalCode),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: PosTextField(controller: cityController, label: l10n.supplierCity),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: PosTextField(controller: countryController, label: l10n.supplierCountry),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: PosTextField(controller: postalCodeController, label: l10n.supplierPostalCode),
                          ),
                        ],
                      ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.supplierBankingInfo, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(controller: bankNameController, label: l10n.supplierBankName),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PosTextField(controller: bankAccountController, label: l10n.supplierBankAccount),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(controller: ibanController, label: l10n.supplierIban, hint: 'SA...'),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.supplierBusinessInfo, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                context.isPhone
                    ? Column(
                        children: [
                          PosTextField(controller: taxNumberController, label: l10n.supplierTaxNumber),
                          const SizedBox(height: AppSpacing.sm),
                          PosTextField(
                            controller: paymentTermsController,
                            label: l10n.supplierPaymentTerms,
                            hint: l10n.supplierPaymentTermsHint,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          PosTextField(
                            controller: creditLimitController,
                            label: l10n.supplierCreditLimit,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: PosTextField(controller: taxNumberController, label: l10n.supplierTaxNumber),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: PosTextField(
                              controller: paymentTermsController,
                              label: l10n.supplierPaymentTerms,
                              hint: l10n.supplierPaymentTermsHint,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: PosTextField(
                              controller: creditLimitController,
                              label: l10n.supplierCreditLimit,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: AppSpacing.sm),
                PosTextField(controller: notesController, label: l10n.commonNotes, hint: l10n.supplierNotesHint, maxLines: 2),
              ],
            ),
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.commonCancel),
          PosButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              final data = <String, dynamic>{
                'name': nameController.text.trim(),
                if (phoneController.text.trim().isNotEmpty) 'phone': phoneController.text.trim(),
                if (emailController.text.trim().isNotEmpty) 'email': emailController.text.trim(),
                if (websiteController.text.trim().isNotEmpty) 'website': websiteController.text.trim(),
                if (addressController.text.trim().isNotEmpty) 'address': addressController.text.trim(),
                if (cityController.text.trim().isNotEmpty) 'city': cityController.text.trim(),
                if (countryController.text.trim().isNotEmpty) 'country': countryController.text.trim(),
                if (postalCodeController.text.trim().isNotEmpty) 'postal_code': postalCodeController.text.trim(),
                if (contactPersonController.text.trim().isNotEmpty) 'contact_person': contactPersonController.text.trim(),
                if (taxNumberController.text.trim().isNotEmpty) 'tax_number': taxNumberController.text.trim(),
                if (paymentTermsController.text.trim().isNotEmpty) 'payment_terms': paymentTermsController.text.trim(),
                if (bankNameController.text.trim().isNotEmpty) 'bank_name': bankNameController.text.trim(),
                if (bankAccountController.text.trim().isNotEmpty) 'bank_account': bankAccountController.text.trim(),
                if (ibanController.text.trim().isNotEmpty) 'iban': ibanController.text.trim(),
                if (creditLimitController.text.trim().isNotEmpty)
                  'credit_limit': double.tryParse(creditLimitController.text.trim()),
                if (categoryController.text.trim().isNotEmpty) 'category': categoryController.text.trim(),
                if (notesController.text.trim().isNotEmpty) 'notes': notesController.text.trim(),
              };
              Navigator.pop(ctx, data);
            },
            variant: PosButtonVariant.ghost,
            label: isEditing ? l10n.commonUpdate : l10n.commonCreate,
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      try {
        if (isEditing) {
          await ref.read(suppliersProvider.notifier).updateSupplier(supplier.id, result);
          if (mounted) showPosSuccessSnackbar(context, l10n.supplierUpdated);
        } else {
          await ref.read(suppliersProvider.notifier).createSupplier(result);
          if (mounted) showPosSuccessSnackbar(context, l10n.supplierCreated);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  Future<void> _handleDelete(Supplier supplier) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.supplierDeleteTitle,
      message: l10n.supplierDeleteConfirm(supplier.name),
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(suppliersProvider.notifier).deleteSupplier(supplier.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.supplierDeleted(supplier.name));
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suppliersState = ref.watch(suppliersProvider);

    return PosListPage(
      title: l10n.supplierTitle,
      searchController: _searchController,
      searchHint: l10n.supplierSearchHint,
      onSearchSubmitted: (v) => ref.read(suppliersProvider.notifier).search(v),
      onSearchClear: () {
        _searchController.clear();
        ref.read(suppliersProvider.notifier).search(null);
      },
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showSupplierListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(suppliersProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.supplierNew, icon: Icons.add, onPressed: () => _showSupplierDialog()),
      ],
      child: _buildBody(suppliersState),
    );
  }

  void _showSupplierDetail(Supplier supplier) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(supplier.name),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (supplier.category != null) PosBadge(label: supplier.category!, variant: PosBadgeVariant.info),
                const SizedBox(height: AppSpacing.sm),
                if (supplier.contactPerson != null) _infoRow(l10n.supplierContactPerson, supplier.contactPerson!),
                if (supplier.phone != null) _infoRow(l10n.supplierPhone, supplier.phone!),
                if (supplier.email != null) _infoRow(l10n.supplierEmail, supplier.email!),
                if (supplier.website != null) _infoRow(l10n.supplierWebsite, supplier.website!),
                if (supplier.address != null) _infoRow(l10n.supplierAddressLine, supplier.address!),
                if (supplier.city != null || supplier.country != null)
                  _infoRow(l10n.supplierCity, [supplier.city, supplier.country].where((s) => s != null).join(', ')),
                if (supplier.taxNumber != null) _infoRow(l10n.supplierTaxNumber, supplier.taxNumber!),
                if (supplier.paymentTerms != null) _infoRow(l10n.supplierPaymentTerms, supplier.paymentTerms!),
                if (supplier.bankName != null) _infoRow(l10n.supplierBankName, supplier.bankName!),
                if (supplier.iban != null) _infoRow(l10n.supplierIban, supplier.iban!),
                if (supplier.creditLimit != null)
                  _infoRow(l10n.supplierCreditLimit, '${supplier.creditLimit!.toStringAsFixed(2)} \u0081'),
                if (supplier.outstandingBalance != null)
                  _infoRow(l10n.supplierOutstandingBalance, '${supplier.outstandingBalance!.toStringAsFixed(2)} \u0081'),
                if (supplier.rating != null)
                  _infoRow(l10n.supplierRating, '${'★' * supplier.rating!}${'☆' * (5 - supplier.rating!)}'),
                if (supplier.notes != null) _infoRow(l10n.commonNotes, supplier.notes!),
                if (supplier.returnsCount != null ||
                    supplier.purchaseOrdersCount != null ||
                    supplier.goodsReceiptsCount != null) ...[
                  const Divider(),
                  Text(l10n.supplierStatistics, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  if (supplier.purchaseOrdersCount != null)
                    _infoRow(l10n.inventoryPurchaseOrders, '${supplier.purchaseOrdersCount}'),
                  if (supplier.goodsReceiptsCount != null)
                    _infoRow(l10n.inventoryGoodsReceipts, '${supplier.goodsReceiptsCount}'),
                  if (supplier.returnsCount != null) _infoRow(l10n.supplierReturnsTitle, '${supplier.returnsCount}'),
                ],
              ],
            ),
          ),
        ),
        actions: [PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.commonClose)],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildBody(SuppliersState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is SuppliersLoading || state is SuppliersInitial;
    final error = state is SuppliersError ? state.message : null;
    final suppliers = state is SuppliersLoaded ? state.suppliers : <Supplier>[];
    final loaded = state is SuppliersLoaded ? state : null;

    return PosDataTable<Supplier>(
      columns: [
        PosTableColumn(title: l10n.supplierName),
        PosTableColumn(title: l10n.supplierContactPerson),
        PosTableColumn(title: l10n.supplierPhone),
        PosTableColumn(title: l10n.supplierEmail),
        PosTableColumn(title: l10n.supplierCategory),
      ],
      items: suppliers,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(suppliersProvider.notifier).load(),
      onRowTap: (s) => _showSupplierDetail(s),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.local_shipping_outlined,
        title: l10n.supplierNoSuppliers,
        subtitle: l10n.supplierNoSuppliersHint,
      ),
      actions: [
        PosTableRowAction<Supplier>(
          label: l10n.commonEdit,
          icon: Icons.edit_outlined,
          onTap: (s) => _showSupplierDialog(supplier: s),
        ),
        PosTableRowAction<Supplier>(
          label: l10n.commonDelete,
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: (s) => _handleDelete(s),
        ),
      ],
      cellBuilder: (supplier, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
                  child: Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.info),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(supplier.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            );
          case 1:
            return Text(supplier.contactPerson ?? '—');
          case 2:
            return Text(supplier.phone ?? '—');
          case 3:
            return Text(supplier.email ?? '—');
          case 4:
            return supplier.category != null
                ? PosBadge(label: supplier.category!, variant: PosBadgeVariant.info)
                : const Text('—');
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 10,
      onPreviousPage: loaded != null ? () => ref.read(suppliersProvider.notifier).load(page: loaded.currentPage - 1) : null,
      onNextPage: loaded != null ? () => ref.read(suppliersProvider.notifier).load(page: loaded.currentPage + 1) : null,
    );
  }
}
