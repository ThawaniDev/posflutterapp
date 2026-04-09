import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/utils/validators.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/auth/providers/auth_providers.dart';
import 'package:thawani_pos/features/auth/providers/auth_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _storeNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _selectedCountry = 'SA';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _orgNameController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
          organizationName: _orgNameController.text.trim().isNotEmpty ? _orgNameController.text.trim() : null,
          storeName: _storeNameController.text.trim().isNotEmpty ? _storeNameController.text.trim() : null,
          country: _selectedCountry,
          currency: 'SAR',
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next is AuthAuthenticated) {
        context.go(Routes.dashboard);
      } else if (next is AuthError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authCreateAccount), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section: Personal Info
                    Text(
                      l10n.authPersonalInformation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.authFullName,
                        hintText: l10n.authFullNameHint,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (v) => Validators.required(v, l10n.authFullName),
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.authEmail,
                        hintText: l10n.authEmailHint,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: l10n.authPhoneOptional,
                        hintText: '+968 XXXX XXXX',
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Section: Business Info
                    Text(
                      l10n.authBusinessInformation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _orgNameController,
                      decoration: InputDecoration(
                        labelText: l10n.authBusinessNameOptional,
                        hintText: l10n.authBusinessNameHint,
                        prefixIcon: const Icon(Icons.business_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _storeNameController,
                      decoration: InputDecoration(
                        labelText: l10n.authStoreNameOptional,
                        hintText: l10n.authStoreNameHint,
                        prefixIcon: const Icon(Icons.store_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Country Selector
                    PosSearchableDropdown<String>(
                      label: l10n.authCountry,
                      items: [
                        PosDropdownItem(value: 'OM', label: l10n.authCountryOman),
                        PosDropdownItem(value: 'SA', label: l10n.authCountrySaudiArabia),
                      ],
                      selectedValue: _selectedCountry,
                      onChanged: isLoading ? null : (v) => setState(() => _selectedCountry = v ?? 'SA'),
                      showSearch: false,
                      clearable: false,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Section: Security
                    Text(
                      l10n.authSecurity,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.authPassword,
                        hintText: l10n.authPasswordHintMinChars,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (v) => Validators.minLength(v, 8, l10n.authPassword),
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: l10n.authConfirmPassword,
                        hintText: l10n.authConfirmPasswordHint,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() => _obscureConfirm = !_obscureConfirm);
                          },
                        ),
                      ),
                      obscureText: _obscureConfirm,
                      validator: (v) {
                        if (v != _passwordController.text) {
                          return l10n.authPasswordsDoNotMatch;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleRegister(),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Register Button
                    PosButton(
                      label: isLoading ? l10n.authCreatingAccount : l10n.authCreateAccount,
                      onPressed: isLoading ? null : _handleRegister,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.authAlreadyHaveAccount, style: Theme.of(context).textTheme.bodyMedium),
                        TextButton(
                          onPressed: isLoading ? null : () => context.pop(),
                          child: Text(
                            l10n.authSignIn,
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
