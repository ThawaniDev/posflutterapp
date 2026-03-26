import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_state.dart';

class DeliveryConfigPage extends ConsumerStatefulWidget {
  final String? configId;
  const DeliveryConfigPage({super.key, this.configId});

  @override
  ConsumerState<DeliveryConfigPage> createState() => _DeliveryConfigPageState();
}

class _DeliveryConfigPageState extends ConsumerState<DeliveryConfigPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPlatformSlug;
  bool _isEnabled = true;
  bool _autoAccept = false;
  bool _syncMenuOnProductChange = true;
  int _menuSyncIntervalHours = 24;
  int _maxDailyOrders = 0;
  final _apiKeyController = TextEditingController();
  final _apiSecretController = TextEditingController();
  final _merchantIdController = TextEditingController();
  bool _isSaving = false;

  bool get _isEditing => widget.configId != null;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(deliveryPlatformsProvider.notifier).load();
      if (_isEditing) _loadExistingConfig();
    });
  }

  void _loadExistingConfig() {
    final configsState = ref.read(deliveryConfigsProvider);
    if (configsState is DeliveryConfigsLoaded) {
      final config = configsState.configs.firstWhere(
        (c) => '${c['id']}' == widget.configId,
        orElse: () => <String, dynamic>{},
      );
      if (config.isNotEmpty) {
        setState(() {
          _selectedPlatformSlug = config['platform'] as String?;
          _isEnabled = config['is_enabled'] == true;
          _autoAccept = config['auto_accept'] == true;
          _syncMenuOnProductChange = config['sync_menu_on_product_change'] == true;
          _menuSyncIntervalHours = config['menu_sync_interval_hours'] as int? ?? 24;
          _maxDailyOrders = config['max_daily_orders'] as int? ?? 0;
          final credentials = config['credentials'] as Map<String, dynamic>? ?? {};
          _apiKeyController.text = credentials['api_key'] as String? ?? '';
          _apiSecretController.text = credentials['api_secret'] as String? ?? '';
          _merchantIdController.text = credentials['merchant_id'] as String? ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    _merchantIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.deliveryEditPlatform : l10n.deliveryAddPlatform),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.wifi_tethering),
              tooltip: l10n.deliveryTestConnection,
              onPressed: () => ref.read(deliveryConnectionTestProvider.notifier).test(widget.configId!),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            // Connection test banner
            if (_isEditing) _buildConnectionTestBanner(),

            // Platform selection
            Text(l10n.deliverySelectPlatform, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            AppSpacing.gapH12,
            _buildPlatformSelector(),
            AppSpacing.gapH24,

            // Credentials
            Text(l10n.deliveryCredentials, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            AppSpacing.gapH12,
            TextFormField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: l10n.deliveryApiKey,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.key),
              ),
              validator: (v) => v == null || v.isEmpty ? l10n.deliveryFieldRequired : null,
            ),
            AppSpacing.gapH12,
            TextFormField(
              controller: _apiSecretController,
              decoration: InputDecoration(
                labelText: l10n.deliveryApiSecret,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            AppSpacing.gapH12,
            TextFormField(
              controller: _merchantIdController,
              decoration: InputDecoration(
                labelText: l10n.deliveryMerchantId,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.store),
              ),
            ),
            AppSpacing.gapH24,

            // Settings
            Text(l10n.deliverySettings, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            AppSpacing.gapH12,
            SwitchListTile(
              title: Text(l10n.deliveryEnabled),
              subtitle: Text(l10n.deliveryEnabledDesc),
              value: _isEnabled,
              onChanged: (v) => setState(() => _isEnabled = v),
            ),
            SwitchListTile(
              title: Text(l10n.deliveryAutoAccept),
              subtitle: Text(l10n.deliveryAutoAcceptDesc),
              value: _autoAccept,
              onChanged: (v) => setState(() => _autoAccept = v),
            ),
            SwitchListTile(
              title: Text(l10n.deliverySyncOnChange),
              subtitle: Text(l10n.deliverySyncOnChangeDesc),
              value: _syncMenuOnProductChange,
              onChanged: (v) => setState(() => _syncMenuOnProductChange = v),
            ),
            AppSpacing.gapH12,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '$_menuSyncIntervalHours',
                    decoration: InputDecoration(
                      labelText: l10n.deliverySyncInterval,
                      border: const OutlineInputBorder(),
                      suffixText: 'hours',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _menuSyncIntervalHours = int.tryParse(v) ?? 24,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: TextFormField(
                    initialValue: '$_maxDailyOrders',
                    decoration: InputDecoration(
                      labelText: l10n.deliveryMaxDailyOrders,
                      border: const OutlineInputBorder(),
                      helperText: '0 = unlimited',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _maxDailyOrders = int.tryParse(v) ?? 0,
                  ),
                ),
              ],
            ),
            AppSpacing.gapH32,

            // Submit
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
              label: Text(_isSaving ? l10n.deliverySaving : l10n.deliverySave),
              style: FilledButton.styleFrom(padding: AppSpacing.paddingV16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    final platformsState = ref.watch(deliveryPlatformsProvider);

    return switch (platformsState) {
      DeliveryPlatformsLoading() || DeliveryPlatformsInitial() =>
        const Center(child: CircularProgressIndicator()),
      DeliveryPlatformsError(:final message) =>
        Text(message, style: TextStyle(color: AppColors.error)),
      DeliveryPlatformsLoaded(:final platforms) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: platforms.map((p) {
          final slug = p['value'] as String? ?? '';
          final label = p['label'] as String? ?? slug;
          final enumPlatform = DeliveryConfigPlatform.tryFromValue(slug);
          final isSelected = _selectedPlatformSlug == slug;
          final color = enumPlatform?.color ?? AppColors.primary;
          final icon = enumPlatform?.icon ?? Icons.delivery_dining;
          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            avatar: Icon(icon, size: 18, color: isSelected ? Colors.white : color),
            selectedColor: color,
            onSelected: _isEditing ? null : (selected) {
              if (selected) setState(() => _selectedPlatformSlug = slug);
            },
          );
        }).toList(),
      ),
    };
  }

  Widget _buildConnectionTestBanner() {
    final testState = ref.watch(deliveryConnectionTestProvider);

    return switch (testState) {
      DeliveryConnectionTestIdle() => const SizedBox.shrink(),
      DeliveryConnectionTestLoading() => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.paddingAll12,
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Row(
          children: [
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 12),
            Text('Testing connection...'),
          ],
        ),
      ),
      DeliveryConnectionTestSuccess(:final message) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.paddingAll12,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: TextStyle(color: AppColors.success))),
          ],
        ),
      ),
      DeliveryConnectionTestFailure(:final message) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.paddingAll12,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: TextStyle(color: AppColors.error))),
          ],
        ),
      ),
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPlatformSlug == null && !_isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a platform')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final data = <String, dynamic>{
      if (!_isEditing) 'platform': _selectedPlatformSlug!,
      'is_enabled': _isEnabled,
      'auto_accept': _autoAccept,
      'sync_menu_on_product_change': _syncMenuOnProductChange,
      'menu_sync_interval_hours': _menuSyncIntervalHours,
      'max_daily_orders': _maxDailyOrders,
      'credentials': {
        'api_key': _apiKeyController.text,
        if (_apiSecretController.text.isNotEmpty) 'api_secret': _apiSecretController.text,
        if (_merchantIdController.text.isNotEmpty) 'merchant_id': _merchantIdController.text,
      },
    };

    await ref.read(deliveryConfigsProvider.notifier).saveConfig(data);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration saved')),
      );
      context.pop();
    }
  }
}
