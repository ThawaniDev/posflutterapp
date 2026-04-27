import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';

class DeliveryConfigPage extends ConsumerStatefulWidget {
  const DeliveryConfigPage({super.key, this.configId});
  final String? configId;

  @override
  ConsumerState<DeliveryConfigPage> createState() => _DeliveryConfigPageState();
}

class _DeliveryConfigPageState extends ConsumerState<DeliveryConfigPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPlatformSlug;
  bool _isEnabled = true;
  bool _autoAccept = false;
  int _autoAcceptTimeoutSeconds = 300;
  bool _syncMenuOnProductChange = true;
  int _menuSyncIntervalHours = 24;
  int _maxDailyOrders = 0;
  int _throttleLimit = 0;
  String? _webhookUrl;

  final _apiKeyController = TextEditingController();
  final _webhookSecretController = TextEditingController();
  final _merchantIdController = TextEditingController();
  final _branchIdController = TextEditingController();
  late final TextEditingController _menuIntervalController;
  late final TextEditingController _maxOrdersController;
  late final TextEditingController _throttleLimitController;
  late final TextEditingController _autoAcceptTimeoutController;
  bool _isSaving = false;
  bool _configLoaded = false;

  bool get _isEditing => widget.configId != null;

  @override
  void initState() {
    super.initState();
    _menuIntervalController = TextEditingController(text: '$_menuSyncIntervalHours');
    _maxOrdersController = TextEditingController(text: '$_maxDailyOrders');
    _throttleLimitController = TextEditingController(text: '0');
    _autoAcceptTimeoutController = TextEditingController(text: '$_autoAcceptTimeoutSeconds');
    Future.microtask(() {
      ref.read(deliveryPlatformsProvider.notifier).load();
      if (_isEditing) {
        // Ensure configs are loaded so we can find the one to edit
        ref.read(deliveryConfigsProvider.notifier).load();
      }
    });
  }

  void _tryLoadConfigFromState() {
    if (_configLoaded || !_isEditing) return;
    final configsState = ref.read(deliveryConfigsProvider);
    if (configsState is DeliveryConfigsLoaded) {
      final configs = configsState.configs;
      final config = configs.where((c) => '${c['id']}' == widget.configId).firstOrNull;
      if (config != null && config.isNotEmpty) {
        _applyConfigMap(config);
      }
    }
  }

  void _applyConfigMap(Map<String, dynamic> config) {
    if (_configLoaded) return;
    setState(() {
      _configLoaded = true;
      _selectedPlatformSlug = config['platform'] as String?;
      _isEnabled = config['is_enabled'] == true;
      _autoAccept = config['auto_accept'] == true;
      _autoAcceptTimeoutSeconds = (config['auto_accept_timeout_seconds'] as num?)?.toInt() ?? 300;
      _syncMenuOnProductChange = config['sync_menu_on_product_change'] == true;
      _menuSyncIntervalHours = (config['menu_sync_interval_hours'] as num?)?.toInt() ?? 24;
      _maxDailyOrders = (config['max_daily_orders'] as num?)?.toInt() ?? 0;
      _throttleLimit = (config['throttle_limit'] as num?)?.toInt() ?? 0;
      _webhookUrl = config['webhook_url'] as String?;
      // api_key is hidden by the server for security — always start blank
      _apiKeyController.text = '';
      _merchantIdController.text = config['merchant_id'] as String? ?? '';
      _branchIdController.text = config['branch_id_on_platform'] as String? ?? '';
      _menuIntervalController.text = '$_menuSyncIntervalHours';
      _maxOrdersController.text = '$_maxDailyOrders';
      _throttleLimitController.text = '$_throttleLimit';
      _autoAcceptTimeoutController.text = '$_autoAcceptTimeoutSeconds';
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _webhookSecretController.dispose();
    _merchantIdController.dispose();
    _branchIdController.dispose();
    _menuIntervalController.dispose();
    _maxOrdersController.dispose();
    _throttleLimitController.dispose();
    _autoAcceptTimeoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Watch config state and auto-populate when loaded
    if (_isEditing && !_configLoaded) {
      ref.listen<DeliveryConfigsState>(deliveryConfigsProvider, (_, next) {
        if (next is DeliveryConfigsLoaded) _tryLoadConfigFromState();
      });
      _tryLoadConfigFromState();
    }

    return PosFormPage(
      title: _isEditing ? l10n.deliveryEditPlatform : l10n.deliveryAddPlatform,
      actions: [
        if (_isEditing)
          PosButton.icon(
            icon: Icons.wifi_tethering,
            tooltip: l10n.deliveryTestConnection,
            variant: PosButtonVariant.ghost,
            onPressed: () => ref.read(deliveryConnectionTestProvider.notifier).test(widget.configId!),
          ),
      ],
      bottomBar: PosButton(
        label: _isSaving ? l10n.deliverySaving : l10n.deliverySave,
        icon: Icons.save,
        isLoading: _isSaving,
        isFullWidth: true,
        onPressed: _isSaving ? null : _save,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isEditing) ...[_buildConnectionTestBanner(), AppSpacing.gapH16],

            // Platform selection
            PosFormCard(title: l10n.deliverySelectPlatform, child: _buildPlatformSelector()),
            AppSpacing.gapH16,

            // Credentials
            PosFormCard(
              title: l10n.deliveryCredentials,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PosTextField(
                    controller: _apiKeyController,
                    label: l10n.deliveryApiKey,
                    prefixIcon: Icons.key,
                    helperText: _isEditing ? l10n.deliveryKeepCurrentKey : null,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: _webhookSecretController,
                    label: l10n.deliveryWebhookSecret,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    helperText: _isEditing ? l10n.deliveryWebhookSecretHint : null,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(controller: _merchantIdController, label: l10n.deliveryMerchantId, prefixIcon: Icons.store),
                  AppSpacing.gapH12,
                  PosTextField(controller: _branchIdController, label: l10n.deliveryBranchId, prefixIcon: Icons.business),
                ],
              ),
            ),
            AppSpacing.gapH16,

            // Settings
            PosFormCard(
              title: l10n.deliverySettings,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PosToggle(
                    value: _isEnabled,
                    onChanged: (v) => setState(() => _isEnabled = v),
                    label: l10n.deliveryEnabled,
                    subtitle: l10n.deliveryEnabledDesc,
                  ),
                  AppSpacing.gapH12,
                  PosToggle(
                    value: _autoAccept,
                    onChanged: (v) => setState(() => _autoAccept = v),
                    label: l10n.deliveryAutoAccept,
                    subtitle: l10n.deliveryAutoAcceptDesc,
                  ),
                  if (_autoAccept) ...[
                    AppSpacing.gapH12,
                    PosTextField(
                      controller: _autoAcceptTimeoutController,
                      label: l10n.deliveryAutoAcceptTimeout,
                      helperText: l10n.deliveryAutoAcceptTimeoutDesc,
                      prefixIcon: Icons.timer_outlined,
                      suffix: Padding(padding: const EdgeInsetsDirectional.only(end: 12), child: Text(l10n.deliverySeconds)),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _autoAcceptTimeoutSeconds = int.tryParse(v) ?? 300,
                    ),
                  ],
                  AppSpacing.gapH12,
                  PosToggle(
                    value: _syncMenuOnProductChange,
                    onChanged: (v) => setState(() => _syncMenuOnProductChange = v),
                    label: l10n.deliverySyncOnChange,
                    subtitle: l10n.deliverySyncOnChangeDesc,
                  ),
                  AppSpacing.gapH16,
                  Row(
                    children: [
                      Expanded(
                        child: PosTextField(
                          controller: _menuIntervalController,
                          label: l10n.deliverySyncInterval,
                          suffix: Padding(padding: const EdgeInsetsDirectional.only(end: 12), child: Text(l10n.deliveryHours)),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => _menuSyncIntervalHours = int.tryParse(v) ?? 24,
                        ),
                      ),
                      AppSpacing.gapW12,
                      Expanded(
                        child: PosTextField(
                          controller: _maxOrdersController,
                          label: l10n.deliveryMaxDailyOrders,
                          helperText: l10n.deliveryUnlimitedHint,
                          keyboardType: TextInputType.number,
                          onChanged: (v) => _maxDailyOrders = int.tryParse(v) ?? 0,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: _throttleLimitController,
                    label: l10n.deliveryThrottleLimit,
                    helperText: l10n.deliveryThrottleLimitDesc,
                    prefixIcon: Icons.speed,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _throttleLimit = int.tryParse(v) ?? 0,
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,

            // Webhook URL (read-only, shown only when editing and webhook_url is set)
            if (_isEditing && _webhookUrl != null && _webhookUrl!.isNotEmpty) ...[
              PosFormCard(
                title: l10n.deliveryWebhookUrl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.deliveryWebhookUrlDesc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    AppSpacing.gapH8,
                    Container(
                      padding: AppSpacing.paddingAll12,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: AppRadius.borderMd,
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link, size: 16, color: AppColors.textSecondary),
                          AppSpacing.gapW8,
                          Expanded(
                            child: SelectableText(_webhookUrl!, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            tooltip: 'Copy',
                            onPressed: () => Clipboard.setData(ClipboardData(text: _webhookUrl!)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapH16,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    final platformsState = ref.watch(deliveryPlatformsProvider);

    return switch (platformsState) {
      DeliveryPlatformsLoading() || DeliveryPlatformsInitial() => const PosLoading(),
      DeliveryPlatformsError(:final message) => Text(message, style: const TextStyle(color: AppColors.error)),
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
            onSelected: _isEditing
                ? null
                : (selected) {
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
        decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
        child: Row(
          children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.deliveryTestingConnection),
          ],
        ),
      ),
      DeliveryConnectionTestSuccess(:final message) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.paddingAll12,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: AppColors.success)),
            ),
          ],
        ),
      ),
      DeliveryConnectionTestFailure(:final message) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.paddingAll12,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ),
    };
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;

    // Platform required when creating
    if (!_isEditing && _selectedPlatformSlug == null) {
      showPosWarningSnackbar(context, l10n.deliverySelectPlatform);
      return;
    }

    // API key required when creating; optional when editing (leave blank = keep current)
    if (!_isEditing && _apiKeyController.text.trim().isEmpty) {
      showPosWarningSnackbar(context, l10n.deliveryFieldRequired);
      return;
    }

    setState(() => _isSaving = true);

    // Build flat payload — backend expects top-level fields, not nested credentials
    final data = <String, dynamic>{
      if (!_isEditing) 'platform': _selectedPlatformSlug!,
      'is_enabled': _isEnabled,
      'auto_accept': _autoAccept,
      'auto_accept_timeout_seconds': _autoAcceptTimeoutSeconds,
      'sync_menu_on_product_change': _syncMenuOnProductChange,
      'menu_sync_interval_hours': _menuSyncIntervalHours,
    };

    // Only send credential fields when they have a value
    if (_apiKeyController.text.trim().isNotEmpty) {
      data['api_key'] = _apiKeyController.text.trim();
    }
    if (_webhookSecretController.text.trim().isNotEmpty) {
      data['webhook_secret'] = _webhookSecretController.text.trim();
    }
    if (_merchantIdController.text.trim().isNotEmpty) {
      data['merchant_id'] = _merchantIdController.text.trim();
    }
    if (_branchIdController.text.trim().isNotEmpty) {
      data['branch_id_on_platform'] = _branchIdController.text.trim();
    }
    if (_maxDailyOrders > 0) {
      data['max_daily_orders'] = _maxDailyOrders;
    }
    if (_throttleLimit > 0) {
      data['throttle_limit'] = _throttleLimit;
    }

    await ref.read(deliveryConfigsProvider.notifier).saveConfig(data);

    if (mounted) {
      setState(() => _isSaving = false);
      showPosSuccessSnackbar(context, l10n.deliveryConfigSaved);
      context.pop();
    }
  }
}
