import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/widgets/add_on_card.dart';

/// Page that displays available and active add-ons for the store's subscription.
class AddOnsPage extends ConsumerStatefulWidget {
  const AddOnsPage({super.key});

  @override
  ConsumerState<AddOnsPage> createState() => _AddOnsPageState();
}

class _AddOnsPageState extends ConsumerState<AddOnsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addOnsProvider.notifier).loadAddOns();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addOnsProvider);

    return PosListPage(
      title: l10n.subscriptionAddOns,
      showSearch: false,
      isLoading: state is AddOnsLoading,
      hasError: state is AddOnsError,
      errorMessage: state is AddOnsError ? state.message : null,
      onRetry: () => ref.read(addOnsProvider.notifier).loadAddOns(),
      child: state is AddOnsLoaded
          ? Column(
              children: [
                PosTabs(
                  selectedIndex: _currentTab,
                  onChanged: (i) => setState(() => _currentTab = i),
                  tabs: [
                    PosTabItem(label: l10n.subscriptionAvailable),
                    PosTabItem(label: l10n.subscriptionMyAddOns),
                  ],
                ),
                Expanded(
                  child: IndexedStack(index: _currentTab, children: [_buildAvailableTab(state), _buildMyAddOnsTab(state)]),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildAvailableTab(AddOnsLoaded state) {
    final available = state.availableAddOns;
    if (available.isEmpty) {
      return PosEmptyState(title: l10n.subscriptionNoAddOnsAvailable, icon: Icons.extension_off);
    }

    final activeIds = state.storeAddOns.map((a) => a['plan_add_on_id']?.toString() ?? '').toSet();
    final langCode = Localizations.localeOf(context).languageCode;

    return RefreshIndicator(
      onRefresh: () async => ref.read(addOnsProvider.notifier).loadAddOns(),
      child: ListView.builder(
        padding: AppSpacing.paddingAllMd,
        itemCount: available.length,
        itemBuilder: (context, index) {
          final addOn = available[index];
          final addOnId = addOn['id']?.toString() ?? '';
          final isActive = activeIds.contains(addOnId);
          final name = (langCode == 'ar' && addOn['name_ar'] != null && addOn['name_ar'].toString().isNotEmpty)
              ? addOn['name_ar'].toString()
              : addOn['name']?.toString() ?? 'Add-On';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AddOnCard(
              name: name,
              description: addOn['description']?.toString(),
              price: (addOn['monthly_price'] != null ? double.tryParse(addOn['monthly_price'].toString()) : null) ?? 0,
              billingCycle: addOn['billing_cycle']?.toString() ?? 'monthly',
              isActive: isActive,
              onToggle: () => _toggleAddOn(addOn, isActive),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyAddOnsTab(AddOnsLoaded state) {
    final myAddOns = state.storeAddOns;
    if (myAddOns.isEmpty) {
      return PosEmptyState(title: l10n.subscriptionNoActiveAddOns, icon: Icons.extension);
    }

    final langCode = Localizations.localeOf(context).languageCode;

    return RefreshIndicator(
      onRefresh: () async => ref.read(addOnsProvider.notifier).loadAddOns(),
      child: ListView.builder(
        padding: AppSpacing.paddingAllMd,
        itemCount: myAddOns.length,
        itemBuilder: (context, index) {
          final storeAddOn = myAddOns[index];
          final addOnData = (storeAddOn['add_on'] ?? storeAddOn['plan_add_on']) as Map<String, dynamic>?;
          final expiresAtStr = storeAddOn['expires_at']?.toString();
          final expiresAt = expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

          final name = addOnData != null
              ? ((langCode == 'ar' && addOnData['name_ar'] != null && addOnData['name_ar'].toString().isNotEmpty)
                    ? addOnData['name_ar'].toString()
                    : addOnData['name']?.toString() ?? 'Add-On')
              : storeAddOn['plan_add_on_id']?.toString() ?? 'Add-On';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AddOnCard(
              name: name,
              description: addOnData?['description']?.toString(),
              price: (addOnData?['monthly_price'] != null ? double.tryParse(addOnData!['monthly_price'].toString()) : null) ?? 0,
              billingCycle: addOnData?['billing_cycle']?.toString() ?? 'monthly',
              isActive: true,
              expiresAt: expiresAt,
              onToggle: () => _confirmRemoveAddOn(storeAddOn),
            ),
          );
        },
      ),
    );
  }

  void _toggleAddOn(Map<String, dynamic> addOn, bool isActive) {
    if (isActive) {
      _confirmRemoveAddOn(addOn);
    } else {
      _confirmAddAddOn(addOn);
    }
  }

  String _localizedAddOnName(Map<String, dynamic> addOn) {
    final langCode = Localizations.localeOf(context).languageCode;
    if (langCode == 'ar' && addOn['name_ar'] != null && addOn['name_ar'].toString().isNotEmpty) {
      return addOn['name_ar'].toString();
    }
    return addOn['name']?.toString() ?? l10n.subThisAddOn;
  }

  void _confirmAddAddOn(Map<String, dynamic> addOn) async {
    final name = _localizedAddOnName(addOn);
    final price = (addOn['monthly_price'] != null ? double.tryParse(addOn['monthly_price'].toString()) : null) ?? 0;
    final cycle = addOn['billing_cycle']?.toString() ?? l10n.subBillingCycleMonthly;

    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.subAddNamedAddon(name),
      message: l10n.subAddOnConfirmMessage(name, price.toStringAsFixed(2), '', cycle),
      confirmLabel: l10n.subActionAdd,
      cancelLabel: l10n.commonCancel,
    );
    if (confirmed == true && mounted) {
      context.push(
        Routes.providerPaymentCheckout,
        extra: {
          'purpose': 'plan_addon',
          'purpose_label': name,
          'amount': price,
          'add_on_id': addOn['id']?.toString(),
          'notes': 'Add-on: $name',
        },
      );
    }
  }

  void _confirmRemoveAddOn(Map<String, dynamic> addOn) async {
    final addOnData = addOn['add_on'] ?? addOn['plan_add_on'];
    final nameSource = addOnData is Map<String, dynamic> ? addOnData : addOn;
    final name = _localizedAddOnName(nameSource);
    final addOnId = addOn['plan_add_on_id']?.toString() ?? addOn['id']?.toString();

    if (addOnId == null) {
      showPosErrorSnackbar(context, l10n.subUnableToIdentifyAddOn);
      return;
    }

    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.subRemoveNamedAddon(name),
      message: l10n.subRemoveConfirm(name),
      confirmLabel: l10n.subActionRemove,
      cancelLabel: l10n.subActionKeep,
      isDanger: true,
    );
    if (confirmed == true) {
      try {
        await ref.read(subscriptionApiServiceProvider).removeAddOn(addOnId);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.subAddOnRemovedSuccess(name));
          ref.read(addOnsProvider.notifier).loadAddOns();
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, l10n.subAddOnRemoveFailed(e.toString()));
        }
      }
    }
  }
}
