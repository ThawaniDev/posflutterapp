import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_state.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ReceiptTemplateWidget extends ConsumerWidget {
  const ReceiptTemplateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(receiptTemplateProvider);
    final theme = Theme.of(context);

    return switch (state) {
      ReceiptInitial() || ReceiptLoading() => const Center(child: CircularProgressIndicator()),
      ReceiptError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            AppSpacing.gapH8,
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ),
      ),
      final ReceiptLoaded s => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: PosCard(
          child: Column(
            children: [
              ListTile(leading: const Icon(Icons.image), title: const Text('Logo'), subtitle: Text(s.logoUrl ?? 'Not set')),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.title),
                title: const Text('Header Line 1'),
                subtitle: Text(s.headerLine1 ?? 'Not set'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.title),
                title: const Text('Header Line 2'),
                subtitle: Text(s.headerLine2 ?? 'Not set'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Footer'),
                subtitle: Text(s.footerText ?? 'Not set'),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.receipt),
                title: const Text('Show VAT Number'),
                value: s.showVatNumber,
                onChanged: (v) => ref.read(receiptTemplateProvider.notifier).update({'show_vat_number': v}),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.loyalty),
                title: const Text('Show Loyalty Points'),
                value: s.showLoyaltyPoints,
                onChanged: (v) => ref.read(receiptTemplateProvider.notifier).update({'show_loyalty_points': v}),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.qr_code),
                title: Text(l10n.settingsReceiptShowBarcode),
                value: s.showBarcode,
                onChanged: (v) => ref.read(receiptTemplateProvider.notifier).update({'show_barcode': v}),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.straighten),
                title: Text(l10n.hwPaperWidth),
                subtitle: Text('${s.paperWidthMm}mm'),
              ),
            ],
          ),
        ),
      ),
    };
  }
}
