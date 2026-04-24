import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';

/// POS overlay for finding (or quick-adding) a customer to attach to a sale.
Future<Customer?> showCustomerLookup(BuildContext context) {
  return showPosBottomSheet<Customer>(
    context,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosBottomSheetHeader(title: AppLocalizations.of(ctx)!.customersLookupTitle),
        const Flexible(child: CustomerLookupSheet()),
      ],
    ),
  );
}

class CustomerLookupSheet extends ConsumerStatefulWidget {
  const CustomerLookupSheet({super.key});

  @override
  ConsumerState<CustomerLookupSheet> createState() => _CustomerLookupSheetState();
}

class _CustomerLookupSheetState extends ConsumerState<CustomerLookupSheet> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final auth = ref.read(authProvider);
      final orgId = auth is AuthAuthenticated ? (auth.user.organizationId ?? '') : '';
      ref.read(customerSearchProvider.notifier).search(orgId, value);
    });
  }

  Future<void> _quickAdd() async {
    final l10n = AppLocalizations.of(context)!;
    final name = TextEditingController();
    final phone = TextEditingController(text: _searchController.text);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customersQuickAdd),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(controller: name, label: l10n.customersName),
            AppSpacing.gapH8,
            PosTextField(controller: phone, label: l10n.customersPhone, keyboardType: TextInputType.phone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (ok != true) return;
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty) return;
    try {
      final repo = ref.read(customerRepositoryProvider);
      final created = await repo.createCustomer({'name': name.text.trim(), 'phone': phone.text.trim()});
      if (mounted) Navigator.of(context).pop(created);
    } catch (e) {
      if (mounted) showPosErrorSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customerSearchProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          PosSearchField(controller: _searchController, hint: l10n.commonSearch, autofocus: true, onChanged: _onChanged),
          AppSpacing.gapH12,
          SizedBox(
            height: 320,
            child: switch (state) {
              CustomerSearchIdle() => Center(
                child: Text(l10n.customersLookupTitle, style: Theme.of(context).textTheme.bodyMedium),
              ),
              CustomerSearchSearching() => const PosLoading(),
              CustomerSearchError(message: final m) => Center(child: Text(m)),
              CustomerSearchResults(results: final r) =>
                r.isEmpty
                    ? Center(child: Text(l10n.customersNoMatches))
                    : ListView.separated(
                        itemCount: r.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final c = r[i];
                          return ListTile(
                            leading: PosAvatar(name: c.name, radius: 16),
                            title: Text(c.name),
                            subtitle: Text(c.phone),
                            trailing: c.loyaltyPoints != null
                                ? PosBadge(label: '${c.loyaltyPoints} pts', variant: PosBadgeVariant.info)
                                : null,
                            onTap: () => Navigator.of(context).pop(c),
                          );
                        },
                      ),
            },
          ),
          AppSpacing.gapH12,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PosButton(
                label: l10n.customersQuickAdd,
                icon: Icons.person_add_alt_1,
                variant: PosButtonVariant.outline,
                onPressed: _quickAdd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
