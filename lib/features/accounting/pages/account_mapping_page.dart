import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/accounting/providers/accounting_providers.dart';
import 'package:wameedpos/features/accounting/providers/accounting_state.dart';

class AccountMappingPage extends ConsumerStatefulWidget {
  const AccountMappingPage({super.key});

  @override
  ConsumerState<AccountMappingPage> createState() => _AccountMappingPageState();
}

class _AccountMappingPageState extends ConsumerState<AccountMappingPage> {
  final Map<String, TextEditingController> _accountIdControllers = {};
  final Map<String, TextEditingController> _accountNameControllers = {};
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(accountMappingProvider.notifier).loadMappings();
    });
  }

  @override
  void dispose() {
    for (final c in _accountIdControllers.values) {
      c.dispose();
    }
    for (final c in _accountNameControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mappingState = ref.watch(accountMappingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Mappings'),
        actions: [
          if (_hasUnsavedChanges)
            TextButton.icon(
              onPressed: mappingState is AccountMappingLoading ? null : _saveMappings,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: switch (mappingState) {
        AccountMappingInitial() || AccountMappingLoading() => PosLoadingSkeleton.list(),
        AccountMappingError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(accountMappingProvider.notifier).loadMappings(),
        ),
        AccountMappingLoaded(:final mappings, :final posAccountKeys) => _buildMappingForm(mappings, posAccountKeys),
      },
    );
  }

  Widget _buildMappingForm(List<Map<String, dynamic>> existingMappings, Map<String, dynamic> posAccountKeys) {
    // Build a map of existing mappings by pos_account_key
    final existingByKey = <String, Map<String, dynamic>>{};
    for (final m in existingMappings) {
      existingByKey[m['pos_account_key'] as String] = m;
    }

    final keys = posAccountKeys.entries.toList();

    return Column(
      children: [
        // Info banner
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingAll12,
          color: AppColors.info.withValues(alpha: 0.08),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 20),
              AppSpacing.gapW8,
              Expanded(
                child: Text(
                  'Map your POS account categories to your accounting provider\'s chart of accounts.',
                  style: TextStyle(color: AppColors.infoDark, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: AppSpacing.paddingAll16,
            itemCount: keys.length,
            separatorBuilder: (_, __) => AppSpacing.gapH12,
            itemBuilder: (context, index) {
              final entry = keys[index];
              final key = entry.key;
              final meta = entry.value as Map<String, dynamic>;
              final existing = existingByKey[key];

              return _buildAccountKeyCard(
                posAccountKey: key,
                label: meta['label'] as String? ?? key,
                direction: meta['direction'] as String? ?? '',
                required: meta['required'] as bool? ?? false,
                existingMapping: existing,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAccountKeyCard({
    required String posAccountKey,
    required String label,
    required String direction,
    required bool required,
    Map<String, dynamic>? existingMapping,
  }) {
    _accountIdControllers.putIfAbsent(
      posAccountKey,
      () => TextEditingController(text: existingMapping?['provider_account_id'] as String? ?? ''),
    );
    _accountNameControllers.putIfAbsent(
      posAccountKey,
      () => TextEditingController(text: existingMapping?['provider_account_name'] as String? ?? ''),
    );

    final Color dirColor = switch (direction) {
      'debit' => AppColors.error,
      'credit' => AppColors.success,
      _ => AppColors.textSecondary,
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: dirColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    direction.toUpperCase(),
                    style: TextStyle(color: dirColor, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
                if (required) ...[AppSpacing.gapW8, const Text('*', style: TextStyle(color: AppColors.error, fontSize: 16))],
              ],
            ),
            Text(posAccountKey, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            AppSpacing.gapH12,
            TextField(
              controller: _accountIdControllers[posAccountKey],
              onChanged: (_) => setState(() => _hasUnsavedChanges = true),
              decoration: const InputDecoration(
                labelText: 'Provider Account ID',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            AppSpacing.gapH8,
            TextField(
              controller: _accountNameControllers[posAccountKey],
              onChanged: (_) => setState(() => _hasUnsavedChanges = true),
              decoration: const InputDecoration(
                labelText: 'Provider Account Name',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            if (existingMapping != null) ...[
              AppSpacing.gapH8,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _deleteMapping(existingMapping['id'] as String),
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                  label: const Text('Remove', style: TextStyle(color: AppColors.error, fontSize: 12)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _saveMappings() {
    final mappings = <Map<String, dynamic>>[];

    for (final entry in _accountIdControllers.entries) {
      final key = entry.key;
      final accountId = entry.value.text.trim();
      final accountName = _accountNameControllers[key]?.text.trim() ?? '';

      if (accountId.isNotEmpty && accountName.isNotEmpty) {
        mappings.add({'pos_account_key': key, 'provider_account_id': accountId, 'provider_account_name': accountName});
      }
    }

    if (mappings.isEmpty) {
      showPosWarningSnackbar(context, AppLocalizations.of(context)!.pleaseFillOneMapping);
      return;
    }

    ref.read(accountMappingProvider.notifier).saveMappings(mappings);
    setState(() => _hasUnsavedChanges = false);
  }

  void _deleteMapping(String id) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: 'Delete Mapping',
      message: 'Are you sure you want to remove this mapping?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(accountMappingProvider.notifier).deleteMapping(id);
    }
  }
}
