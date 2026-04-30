import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/onboarding/enums/onboarding_step.dart';
import 'package:wameedpos/features/onboarding/models/business_type_template.dart';
import 'package:wameedpos/features/onboarding/providers/store_onboarding_providers.dart';
import 'package:wameedpos/features/onboarding/providers/store_onboarding_state.dart';
import 'package:wameedpos/features/onboarding/repositories/store_repository.dart';

/// Multi-step onboarding wizard.
/// Displays one step at a time with Next/Back/Skip controls.
class OnboardingWizardPage extends ConsumerStatefulWidget {
  const OnboardingWizardPage({super.key});

  @override
  ConsumerState<OnboardingWizardPage> createState() => _OnboardingWizardPageState();
}

class _OnboardingWizardPageState extends ConsumerState<OnboardingWizardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  static const _steps = OnboardingStep.values;

  int _currentIndex = 0;
  bool _isSubmitting = false;

  // ─── Form data per step ──────────────────────────────────────
  // Business Info
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Business Type
  String? _selectedBusinessType;
  Map<String, dynamic>? _businessTypeDefaults;
  bool _loadingDefaults = false;

  // Tax
  final _taxLabelController = TextEditingController(text: 'VAT');
  final _taxRateController = TextEditingController(text: '15');
  bool _pricesIncludeTax = true;

  // Hardware
  bool _hasPrinter = false;
  bool _hasScanner = false;
  bool _hasCashDrawer = false;
  bool _hasCustomerDisplay = false;

  // Products
  static const String _productSetupNone = 'later';
  static const String _productSetupTemplate = 'template';
  static const String _productSetupCsv = 'csv';
  String _productSetupChoice = _productSetupNone;

  // Staff
  final _staffEmailController = TextEditingController();
  final _staffNameController = TextEditingController();
  String _staffRole = 'cashier';

  @override
  void initState() {
    super.initState();
    // Load onboarding progress + business types
    Future.microtask(() {
      ref.read(onboardingProvider.notifier).load();
      ref.read(businessTypesProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameArController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _taxLabelController.dispose();
    _taxRateController.dispose();
    _staffEmailController.dispose();
    _staffNameController.dispose();
    super.dispose();
  }

  OnboardingStep get _step => _steps[_currentIndex];

  void _next() {
    if (_currentIndex < _steps.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _back() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  Future<void> _completeCurrentStep() async {
    setState(() => _isSubmitting = true);
    try {
      final data = _collectStepData();
      await ref.read(onboardingProvider.notifier).completeStep(_step.value, data: data);
      if (_currentIndex < _steps.length - 1) {
        _next();
      } else {
        // All done — go to dashboard
        if (mounted) context.go(Routes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, AppLocalizations.of(context)!.genericError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _skipWizard() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(onboardingProvider.notifier).skip();
      if (mounted) context.go(Routes.dashboard);
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, AppLocalizations.of(context)!.genericError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Map<String, dynamic> _collectStepData() {
    switch (_step) {
      case OnboardingStep.businessInfo:
        return {
          if (_nameController.text.isNotEmpty) 'name': _nameController.text,
          if (_nameArController.text.isNotEmpty) 'name_ar': _nameArController.text,
          if (_cityController.text.isNotEmpty) 'city': _cityController.text,
          if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text,
          if (_emailController.text.isNotEmpty) 'email': _emailController.text,
        };
      case OnboardingStep.businessType:
        return {if (_selectedBusinessType != null) 'business_type': _selectedBusinessType};
      case OnboardingStep.tax:
        return {
          'tax_label': _taxLabelController.text,
          'tax_rate': double.tryParse(_taxRateController.text) ?? 15.0,
          'prices_include_tax': _pricesIncludeTax,
        };
      case OnboardingStep.hardware:
        return {
          'has_printer': _hasPrinter,
          'has_scanner': _hasScanner,
          'has_cash_drawer': _hasCashDrawer,
          'has_customer_display': _hasCustomerDisplay,
        };
      case OnboardingStep.products:
        return {'product_setup_choice': _productSetupChoice};
      case OnboardingStep.staff:
        if (_staffEmailController.text.isNotEmpty) {
          return {
            'staff_email': _staffEmailController.text,
            'staff_name': _staffNameController.text,
            'staff_role': _staffRole,
          };
        }
        return {};
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final businessTypesState = ref.watch(businessTypesProvider);

    // Sync current index to server progress when first loaded
    if (onboardingState is OnboardingLoaded) {
      final serverStep = onboardingState.progress.currentStep;
      if (serverStep != null && _currentIndex == 0) {
        final idx = _steps.indexOf(serverStep);
        if (idx > 0 && idx != _currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentIndex = idx);
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Progress Header ──────────────────────────
            _buildProgressHeader(),
            // ─── Step Content ─────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: _buildStepContent(businessTypesState),
              ),
            ),
            // ─── Bottom Actions ───────────────────────────
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    final progress = (_currentIndex + 1) / _steps.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentIndex + 1} of ${_steps.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
              ),
              PosButton(
                onPressed: _isSubmitting ? null : _skipWizard,
                variant: PosButtonVariant.ghost,
                label: l10n.onboardingSkipSetup,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.primary10,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(_stepTitle(_step), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text(_stepSubtitle(_step), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context))),
        ],
      ),
    );
  }

  Widget _buildStepContent(BusinessTypesState btState) {
    switch (_step) {
      case OnboardingStep.welcome:
        return _buildWelcomeStep();
      case OnboardingStep.businessInfo:
        return _buildBusinessInfoStep();
      case OnboardingStep.businessType:
        return _buildBusinessTypeStep(btState);
      case OnboardingStep.tax:
        return _buildTaxStep();
      case OnboardingStep.hardware:
        return _buildHardwareStep();
      case OnboardingStep.products:
        return _buildProductsStep();
      case OnboardingStep.staff:
        return _buildStaffStep();
      case OnboardingStep.review:
        return _buildReviewStep();
    }
  }

  // ─── Step: Welcome ─────────────────────────────────────────────

  Widget _buildWelcomeStep() {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(color: AppColors.primary10, shape: BoxShape.circle),
          child: const Icon(Icons.storefront_rounded, size: 64, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Welcome to Wameed POS',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Let's set up your store in a few simple steps.\n"
          'This usually takes about 5 minutes.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.mutedFor(context)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        _buildInfoCard(Icons.store, 'Store Info', 'Basic details about your business'),
        const SizedBox(height: AppSpacing.md),
        _buildInfoCard(Icons.category, 'Business Type', 'Choose your industry for smart defaults'),
        const SizedBox(height: AppSpacing.md),
        _buildInfoCard(Icons.receipt, 'Tax & Receipt', 'Configure tax rates and receipt format'),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.primary10, borderRadius: BorderRadius.circular(AppSpacing.sm)),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step: Business Info ───────────────────────────────────────

  Widget _buildBusinessInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Store Name (English)'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(
          controller: _nameController,
          decoration: _inputDecoration('e.g., My Store'),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Store Name (Arabic)'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(
          controller: _nameArController,
          decoration: _inputDecoration('مثال: متجري'),
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('City'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(
          controller: _cityController,
          decoration: _inputDecoration('e.g., Muscat'),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Phone'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(
          controller: _phoneController,
          decoration: _inputDecoration('+968 xxxx xxxx'),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Email'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(
          controller: _emailController,
          decoration: _inputDecoration('store@example.com'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  // ─── Step: Business Type ───────────────────────────────────────

  Widget _buildBusinessTypeStep(BusinessTypesState btState) {
    if (btState is BusinessTypesLoading) {
      return const PosLoading();
    }
    if (btState is BusinessTypesError) {
      return Center(child: Text(l10n.genericError(btState.message)));
    }
    if (btState is! BusinessTypesLoaded) {
      return const SizedBox.shrink();
    }

    final templates = btState.templates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose the type that best describes your business. '
          'This sets up smart defaults for tax, categories, and POS features.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context)),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...templates.map((t) => _buildBusinessTypeCard(t)),
        // ── Defaults Preview ────────────────────────────────────────
        if (_selectedBusinessType != null) ...[
          const SizedBox(height: AppSpacing.lg),
          if (_loadingDefaults)
            const Center(child: Padding(padding: EdgeInsets.all(AppSpacing.xl), child: CircularProgressIndicator()))
          else if (_businessTypeDefaults != null)
            _buildDefaultsPreview(_businessTypeDefaults!),
        ],
      ],
    );
  }

  Widget _buildDefaultsPreview(Map<String, dynamic> defaults) {
    final categories = (defaults['category_templates'] as List?)?.length ?? 0;
    final shifts = (defaults['shift_templates'] as List?)?.length ?? 0;
    final promotions = (defaults['promotion_templates'] as List?)?.length ?? 0;
    final badges = ((defaults['gamification_templates'] as Map?)?['badges'] as List?)?.length ?? 0;
    final loyaltyConfig = defaults['loyalty_config'];
    final returnPolicy = defaults['return_policy'];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.primary10,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'What gets set up for you:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              if (categories > 0) _defaultsChip('$categories Categories'),
              if (shifts > 0) _defaultsChip('$shifts Shifts'),
              if (promotions > 0) _defaultsChip('$promotions Promotions'),
              if (badges > 0) _defaultsChip('$badges Badges'),
              if (loyaltyConfig != null) _defaultsChip('Loyalty Config'),
              if (returnPolicy != null) _defaultsChip('Return Policy'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultsChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
      backgroundColor: Colors.white,
      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildBusinessTypeCard(BusinessTypeTemplate template) {
    final isSelected = _selectedBusinessType == template.code;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBusinessType = template.code;
          _businessTypeDefaults = null;
          _loadingDefaults = true;
        });
        // Fetch defaults for preview
        ref.read(storeRepositoryProvider).getBusinessTypeDefaults(template.code).then((defaults) {
          if (mounted) setState(() { _businessTypeDefaults = defaults; _loadingDefaults = false; });
        }).catchError((_) {
          if (mounted) setState(() => _loadingDefaults = false);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary10 : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(color: isSelected ? AppColors.primary : Theme.of(context).dividerColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary20 : AppColors.primary10,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Icon(_businessTypeIcon(template.code), color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(template.nameEn, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  if (template.descriptionEn != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      template.descriptionEn!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  // ─── Step: Tax ─────────────────────────────────────────────────

  Widget _buildTaxStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Tax Label'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(controller: _taxLabelController, decoration: _inputDecoration('e.g., VAT, GST')),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Tax Rate (%)'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(
          controller: _taxRateController,
          decoration: _inputDecoration('15'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          title: Text(l10n.settingsPricesIncludeTax),
          subtitle: Text(l10n.onboardingTaxIncludedNote),
          value: _pricesIncludeTax,
          activeThumbColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          onChanged: (v) => setState(() => _pricesIncludeTax = v),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'In Saudi Arabia and Oman, the standard VAT rate is 15%. '
                  'You can update this anytime from Settings.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.infoDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Step: Hardware ────────────────────────────────────────────

  Widget _buildHardwareStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us which hardware you plan to connect. '
          'You can change this anytime in Settings → Hardware.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context)),
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildHardwareToggle(
          icon: Icons.print_rounded,
          title: 'Receipt Printer',
          subtitle: 'Thermal or laser printer for receipts',
          value: _hasPrinter,
          onChanged: (v) => setState(() => _hasPrinter = v),
        ),
        _buildHardwareToggle(
          icon: Icons.qr_code_scanner_rounded,
          title: 'Barcode / QR Scanner',
          subtitle: 'USB or Bluetooth scanner',
          value: _hasScanner,
          onChanged: (v) => setState(() => _hasScanner = v),
        ),
        _buildHardwareToggle(
          icon: Icons.point_of_sale_rounded,
          title: 'Cash Drawer',
          subtitle: 'Connected via printer or USB',
          value: _hasCashDrawer,
          onChanged: (v) => setState(() => _hasCashDrawer = v),
        ),
        _buildHardwareToggle(
          icon: Icons.tv_rounded,
          title: 'Customer Display (CFD)',
          subtitle: 'Second screen showing items to customer',
          value: _hasCustomerDisplay,
          onChanged: (v) => setState(() => _hasCustomerDisplay = v),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Saying "no" now won\'t prevent you from connecting hardware later.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.infoDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHardwareToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: value ? AppColors.primary10 : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: value ? AppColors.primary : Theme.of(context).dividerColor, width: value ? 2 : 1),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(color: value ? AppColors.primary20 : AppColors.primary10, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context))),
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.xs),
      ),
    );
  }

  // ─── Step: Products ────────────────────────────────────────────

  Widget _buildProductsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you like to start your product catalog?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context)),
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildProductOption(
          value: _productSetupNone,
          icon: Icons.schedule_rounded,
          title: 'Set Up Later',
          subtitle: 'Skip for now — you can add products from the catalog anytime',
        ),
        _buildProductOption(
          value: _productSetupTemplate,
          icon: Icons.auto_awesome_rounded,
          title: 'Use Business Type Defaults',
          subtitle: _selectedBusinessType != null
              ? 'Import the pre-built catalog for your business type'
              : 'Select a business type first to unlock this option',
          enabled: _selectedBusinessType != null,
        ),
        _buildProductOption(
          value: _productSetupCsv,
          icon: Icons.upload_file_rounded,
          title: 'Upload CSV File',
          subtitle: 'Import products from your own spreadsheet',
        ),
        if (_productSetupChoice == _productSetupCsv) ...[
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            icon: const Icon(Icons.file_upload_outlined),
            label: const Text('Choose CSV File'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary),
            onPressed: () {
              // CSV import is handled in the catalog module — navigate there post-wizard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('CSV import is available in Catalog after setup.'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildProductOption({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
    bool enabled = true,
  }) {
    final isSelected = _productSetupChoice == value;
    final color = enabled ? AppColors.primary : AppColors.mutedFor(context);

    return GestureDetector(
      onTap: enabled ? () => setState(() => _productSetupChoice = value) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary10 : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: enabled ? (isSelected ? AppColors.primary20 : AppColors.primary10) : AppColors.mutedFor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: enabled ? null : AppColors.mutedFor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  // ─── Step: Staff ───────────────────────────────────────────────

  Widget _buildStaffStep() {
    const roles = ['cashier', 'supervisor', 'manager', 'inventory_officer'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invite your first team member or skip to set up staff later.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context)),
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildFieldLabel('Staff Name'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(controller: _staffNameController, decoration: _inputDecoration('e.g., Ahmed Al-Rashidi')),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Email Address'),
        const SizedBox(height: AppSpacing.sm),
        PosTextField(
          controller: _staffEmailController,
          decoration: _inputDecoration('staff@yourstore.com'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Role'),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _staffRole,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              onChanged: (v) => setState(() => _staffRole = v ?? 'cashier'),
              items: roles
                  .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' ')),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Leave the fields blank to skip. '
                  'You can add and manage staff from Staff Management after setup.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.infoDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Step: Review ──────────────────────────────────────────────

  Widget _buildReviewStep() {
    final onboardingState = ref.watch(onboardingProvider);
    final completedCount = onboardingState is OnboardingLoaded ? onboardingState.progress.completedSteps.length : 0;

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_outline, size: 56, color: AppColors.success),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.onboardingAllSet, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.md),
        Text(
          'You completed $completedCount of ${_steps.length} setup steps. '
          'Your POS is ready to use! You can always adjust settings later.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.mutedFor(context)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        // Summary cards
        _buildSummaryItem('Store Name', _nameController.text.isNotEmpty ? _nameController.text : 'Not set'),
        _buildSummaryItem('Business Type', _selectedBusinessType ?? 'Not set'),
        _buildSummaryItem('Tax Rate', '${_taxRateController.text}%'),
        _buildSummaryItem(
          'Hardware',
          [
            if (_hasPrinter) 'Printer',
            if (_hasScanner) 'Scanner',
            if (_hasCashDrawer) 'Cash Drawer',
            if (_hasCustomerDisplay) 'CFD',
          ].isEmpty
              ? 'None selected'
              : [
                  if (_hasPrinter) 'Printer',
                  if (_hasScanner) 'Scanner',
                  if (_hasCashDrawer) 'Cash Drawer',
                  if (_hasCustomerDisplay) 'CFD',
                ].join(', '),
        ),
        _buildSummaryItem(
          'Products',
          switch (_productSetupChoice) {
            _productSetupTemplate => 'Use business type defaults',
            _productSetupCsv     => 'CSV import (later)',
            _                    => 'Set up later',
          },
        ),
        _buildSummaryItem(
          'Staff',
          _staffEmailController.text.isNotEmpty
              ? '${_staffNameController.text.isNotEmpty ? _staffNameController.text : _staffEmailController.text} — $_staffRole'
              : 'Set up later',
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context))),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ─── Bottom Actions ────────────────────────────────────────────

  Widget _buildBottomActions() {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _steps.length - 1;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          if (!isFirst) ...[
            PosButton(
              label: l10n.back,
              variant: PosButtonVariant.outline,
              size: PosButtonSize.lg,
              onPressed: _isSubmitting ? null : _back,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: PosButton(
              label: isLast ? 'Finish Setup' : 'Continue',
              size: PosButtonSize.lg,
              isLoading: _isSubmitting,
              isFullWidth: true,
              onPressed: _isSubmitting ? null : _completeCurrentStep,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────

  Widget _buildFieldLabel(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
    );
  }

  String _stepTitle(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return 'Welcome';
      case OnboardingStep.businessInfo:
        return 'Business Information';
      case OnboardingStep.businessType:
        return 'Choose Business Type';
      case OnboardingStep.tax:
        return 'Tax Configuration';
      case OnboardingStep.hardware:
        return 'Hardware Setup';
      case OnboardingStep.products:
        return 'Add Products';
      case OnboardingStep.staff:
        return 'Staff & Roles';
      case OnboardingStep.review:
        return 'Review & Complete';
    }
  }

  String _stepSubtitle(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return "Let's get your store up and running.";
      case OnboardingStep.businessInfo:
        return 'Tell us about your store.';
      case OnboardingStep.businessType:
        return 'This sets up smart defaults for your industry.';
      case OnboardingStep.tax:
        return 'Configure tax rates for your region.';
      case OnboardingStep.hardware:
        return 'Connect printers and scanners.';
      case OnboardingStep.products:
        return 'Start building your catalog.';
      case OnboardingStep.staff:
        return 'Invite your team and set permissions.';
      case OnboardingStep.review:
        return 'Everything looks good — you\'re ready!';
    }
  }

  IconData _businessTypeIcon(String code) {
    switch (code) {
      case 'retail':
        return Icons.storefront_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'pharmacy':
        return Icons.local_pharmacy_rounded;
      case 'grocery':
        return Icons.shopping_cart_rounded;
      case 'jewelry':
        return Icons.diamond_rounded;
      case 'mobile_shop':
        return Icons.smartphone_rounded;
      case 'flower_shop':
        return Icons.local_florist_rounded;
      case 'bakery':
        return Icons.bakery_dining_rounded;
      case 'service':
        return Icons.room_service_rounded;
      case 'custom':
        return Icons.tune_rounded;
      default:
        return Icons.business_rounded;
    }
  }
}
