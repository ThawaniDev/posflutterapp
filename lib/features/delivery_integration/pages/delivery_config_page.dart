import 'package:flutter/material.dart';
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
  late final TextEditingController _menuIntervalController;
  late final TextEditingController _maxOrdersController;
  bool _isSaving = false;

  bool get _isEditing => widget.configId != null;

  @override
  void initState() {
    super.initState();
    _menuIntervalController = TextEditingController(text: '$_menuSyncIntervalHours');
    _maxOrdersController = TextEditingController(text: '$_maxDailyOrders');
    Future.microtask(() {
      ref.read(deliveryPlatformsProvider.notifier).load();
      if (_isEditing) _loadExistingConfig();
    });
  }

  void _loadExistingConfig() {
    final configsState = ref.read(deliveryConfigsProvider);
    if (configsState is DeliveryConfigsLoaded) {
      final config = configsState.configs.firstWhere((c) => '${c['id']}' == widget.configId, orElse: () => <String, dynamic>{});
      if (config.isNotEmpty) {
        setState(() {
          _selectedPlatformSlug = config['platform'] as String?;
          _isEnabled = config['is_enabled'] == true;
          _autoAccept = config['auto_accept'] == true;
          _syncMenuOnProductChange = config['sync_menu_on_product_change'] == true;
          _menuSyncIntervalHours = config['menu_sync_interval_hours'] as int? ?? 24;
          _maxDailyOrders = config['max_daily_orders'] as int? ?? 0;
          _menuIntervalController.text = '$_menuSyncIntervalHours';
          _maxOrdersController.text = '$_maxDailyOrders';
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
    _menuIntervalController.dispose();
    _maxOrdersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  PosTextField(controller: _apiKeyController, label: l10n.deliveryApiKey, prefixIcon: Icons.key),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: _apiSecretController,
                    label: l10n.deliveryApiSecret,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(controller: _merchantIdController, label: l10n.deliveryMerchantId, prefixIcon: Icons.store),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    final platformsState = ref.watch(deliveryPlatformsProvider);

    return switch (platformsState) {
      DeliveryPlatformsLoading() || DeliveryPlatformsInitial() => const PosLoading(),
      DeliveryPlatformsError(:final message) => Text(message, style: TextStyle(color: AppColors.error)),
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
            Icon(Icons.check_circle, color: AppColors.success, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: TextStyle(color: AppColors.success)),
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
            Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ),
    };
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_apiKeyController.text.trim().isEmpty) {
      showPosWarningSnackbar(context, l10n.deliveryFieldRequired);
      return;
    }
    if (_selectedPlatformSlug == null && !_isEditing) {
      showPosWarningSnackbar(context, l10n.deliverySelectPlatform);
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
      showPosSuccessSnackbar(context, l10n.deliveryConfigSaved);
      context.pop();
    }
  }
}
