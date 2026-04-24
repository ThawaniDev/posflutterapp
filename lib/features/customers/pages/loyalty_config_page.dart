import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';

class LoyaltyConfigPage extends ConsumerStatefulWidget {
  const LoyaltyConfigPage({super.key});

  @override
  ConsumerState<LoyaltyConfigPage> createState() => _LoyaltyConfigPageState();
}

class _LoyaltyConfigPageState extends ConsumerState<LoyaltyConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _pointsPerSar = TextEditingController(text: '1');
  final _sarPerPoint = TextEditingController(text: '0.05');
  final _minRedemption = TextEditingController(text: '50');
  final _expiryMonths = TextEditingController(text: '12');
  bool _isActive = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(loyaltyConfigProvider.notifier).load());
  }

  @override
  void dispose() {
    for (final c in [_pointsPerSar, _sarPerPoint, _minRedemption, _expiryMonths]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'points_per_sar': double.tryParse(_pointsPerSar.text.trim()) ?? 1,
      'sar_per_point': double.tryParse(_sarPerPoint.text.trim()) ?? 0.05,
      'min_redemption_points': int.tryParse(_minRedemption.text.trim()) ?? 50,
      'points_expiry_months': int.tryParse(_expiryMonths.text.trim()) ?? 12,
      'is_active': _isActive,
    };
    await ref.read(loyaltyConfigProvider.notifier).save(data);
    final state = ref.read(loyaltyConfigProvider);
    if (!mounted) return;
    if (state is LoyaltyConfigLoaded) {
      showPosSuccessSnackbar(context, AppLocalizations.of(context)!.customersSaved);
    } else if (state is LoyaltyConfigError) {
      showPosErrorSnackbar(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(loyaltyConfigProvider);
    final isLoading = state is LoyaltyConfigInitial || state is LoyaltyConfigLoading;
    final isSaving = state is LoyaltyConfigSaving;

    if (!_initialized && state is LoyaltyConfigLoaded && state.config != null) {
      final cfg = state.config!;
      _pointsPerSar.text = (cfg.pointsPerSar ?? 1).toString();
      _sarPerPoint.text = (cfg.sarPerPoint ?? 0.05).toString();
      _minRedemption.text = (cfg.minRedemptionPoints ?? 50).toString();
      _expiryMonths.text = (cfg.pointsExpiryMonths ?? 12).toString();
      _isActive = cfg.isActive ?? true;
      _initialized = true;
    }

    return PosFormPage(
      title: l10n.customersLoyaltyConfig,
      onBack: () => context.pop(),
      isLoading: isLoading,
      bottomBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PosButton(
            label: l10n.commonSave,
            icon: Icons.save_outlined,
            isLoading: isSaving,
            onPressed: isSaving ? null : _save,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: PosFormCard(
          title: l10n.customersLoyaltyConfig,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosToggle(
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
                label: l10n.customersLoyaltyEnabled,
              ),
              AppSpacing.gapH12,
              PosTextField(
                controller: _pointsPerSar,
                label: l10n.customersPointsPerSar,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              AppSpacing.gapH12,
              PosTextField(
                controller: _sarPerPoint,
                label: l10n.customersSarPerPoint,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              AppSpacing.gapH12,
              PosTextField(
                controller: _minRedemption,
                label: l10n.customersMinRedemption,
                keyboardType: TextInputType.number,
              ),
              AppSpacing.gapH12,
              PosTextField(
                controller: _expiryMonths,
                label: l10n.customersPointsExpiry,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
