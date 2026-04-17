import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/onboarding/enums/onboarding_step.dart';
import 'package:wameedpos/features/onboarding/models/business_type_template.dart';
import 'package:wameedpos/features/onboarding/providers/store_onboarding_providers.dart';
import 'package:wameedpos/features/onboarding/providers/store_onboarding_state.dart';

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

  // Tax
  final _taxLabelController = TextEditingController(text: 'VAT');
  final _taxRateController = TextEditingController(text: '15');
  bool _pricesIncludeTax = true;

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
        color: AppColors.surfaceLight,
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
              ),
              PosButton(onPressed: _isSubmitting ? null : _skipWizard, variant: PosButtonVariant.ghost, label: 'Skip Setup'),
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
          Text(_stepSubtitle(_step), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMutedLight)),
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
        return _buildPlaceholderStep(
          Icons.print_rounded,
          'Hardware Setup',
          'Connect your receipt printer, barcode scanner, and cash drawer. '
              'You can configure this later from Settings.',
        );
      case OnboardingStep.products:
        return _buildPlaceholderStep(
          Icons.inventory_2_rounded,
          'Add Products',
          'You can import products from a template, upload a CSV file, '
              'or add them manually later.',
        );
      case OnboardingStep.staff:
        return _buildPlaceholderStep(
          Icons.people_rounded,
          'Invite Staff',
          'Add team members and assign roles. You can do this later '
              'from Staff Management.',
        );
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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMutedLight),
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
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.borderLight),
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
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight)),
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
        TextFormField(
          controller: _nameController,
          decoration: _inputDecoration('e.g., My Store'),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Store Name (Arabic)'),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _nameArController,
          decoration: _inputDecoration('مثال: متجري'),
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('City'),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _cityController,
          decoration: _inputDecoration('e.g., Muscat'),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Phone'),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _phoneController,
          decoration: _inputDecoration('+968 xxxx xxxx'),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Email'),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
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
      return const Center(child: CircularProgressIndicator());
    }
    if (btState is BusinessTypesError) {
      return Center(child: Text('Error: ${btState.message}'));
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMutedLight),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...templates.map((t) => _buildBusinessTypeCard(t)),
      ],
    );
  }

  Widget _buildBusinessTypeCard(BusinessTypeTemplate template) {
    final isSelected = _selectedBusinessType == template.code;

    return GestureDetector(
      onTap: () => setState(() => _selectedBusinessType = template.code),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary10 : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
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
        TextFormField(controller: _taxLabelController, decoration: _inputDecoration('e.g., VAT, GST')),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel('Tax Rate (%)'),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _taxRateController,
          decoration: _inputDecoration('15'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          title: Text(l10n.settingsPricesIncludeTax),
          subtitle: const Text('When enabled, product prices are displayed with tax included.'),
          value: _pricesIncludeTax,
          activeColor: AppColors.primary,
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

  // ─── Step: Placeholder (Hardware, Products, Staff) ─────────────

  Widget _buildPlaceholderStep(IconData icon, String title, String message) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(color: AppColors.primary10, shape: BoxShape.circle),
          child: Icon(icon, size: 56, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.md),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMutedLight),
          textAlign: TextAlign.center,
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
        Text("You're all set!", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.md),
        Text(
          'You completed $completedCount of ${_steps.length} setup steps. '
          "Your POS is ready to use! You can always adjust settings later.",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMutedLight),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        // Summary cards
        _buildSummaryItem('Store Name', _nameController.text.isNotEmpty ? _nameController.text : 'Not set'),
        _buildSummaryItem('Business Type', _selectedBusinessType ?? 'Not set'),
        _buildSummaryItem('Tax Rate', '${_taxRateController.text}%'),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMutedLight)),
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
        color: AppColors.surfaceLight,
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
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.borderLight),
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
