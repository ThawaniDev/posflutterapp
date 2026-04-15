import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/utils/validators.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/security/repositories/security_repository.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).login(email: _emailController.text.trim(), password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next is AuthAuthenticated) {
        // Fire-and-forget: create a security session for audit tracking
        if (next.user.storeId != null) {
          ref
              .read(securityRepositoryProvider)
              .startSession(data: {'store_id': next.user.storeId})
              .catchError((_) => <String, dynamic>{});
        }
        context.go(Routes.homeForRole(next.user.role));
      } else if (next is AuthError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo posflutterapp/assets/images/wameedlogo.png
                    // Icon(Icons.point_of_sale_rounded, size: 64, color: AppColors.primary),
                    // const SizedBox(height: AppSpacing.md),
                    Image.asset('assets/images/wameedlogo.png', height: 64),
                    const SizedBox(height: AppSpacing.md),

                    // Title
                    Text(
                      AppLocalizations.of(context)!.loginTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppLocalizations.of(context)!.loginSubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.loginEmail,
                        hintText: AppLocalizations.of(context)!.loginEmailHint,
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.loginPassword,
                        hintText: AppLocalizations.of(context)!.loginPasswordHint,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: (v) => Validators.required(v, 'Password'),
                      onFieldSubmitted: (_) => _handleLogin(),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Login Button
                    PosButton(
                      label: isLoading ? AppLocalizations.of(context)!.loginSigningIn : AppLocalizations.of(context)!.loginSignIn,
                      onPressed: isLoading ? null : _handleLogin,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.loginNoAccount, style: Theme.of(context).textTheme.bodyMedium),
                        TextButton(
                          onPressed: isLoading ? null : () => context.push(Routes.register),
                          child: Text(
                            AppLocalizations.of(context)!.loginRegister,
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Quick-fill dev buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  _emailController.text = 'owner@ostora.sa';
                                  _passwordController.text = 'password123';
                                },
                          icon: const Icon(Icons.admin_panel_settings, size: 16),
                          label: Text(AppLocalizations.of(context)!.loginAdmin),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  _emailController.text = 'kamal@gmail.com';
                                  _passwordController.text = 'Test@123';
                                },
                          icon: const Icon(Icons.point_of_sale, size: 16),
                          label: Text(AppLocalizations.of(context)!.loginCashier),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  _emailController.text = 'branchmanager@ostora.sa';
                                  _passwordController.text = 'password123';
                                },
                          icon: const Icon(Icons.store_rounded, size: 16),
                          label: const Text('Branch Mgr'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            textStyle: const TextStyle(fontSize: 12),
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
