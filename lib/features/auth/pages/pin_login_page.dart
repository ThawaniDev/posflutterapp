import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/auth/providers/auth_providers.dart';
import 'package:thawani_pos/features/auth/providers/auth_state.dart';
import 'package:thawani_pos/features/auth/repositories/auth_repository.dart';

class PinLoginPage extends ConsumerStatefulWidget {
  const PinLoginPage({super.key});

  @override
  ConsumerState<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends ConsumerState<PinLoginPage> {
  String _pin = '';
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _submitPin() async {
    if (_pin.length != 4) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Get stored store_id from local storage
    final storeId = await ref.read(authRepositoryProvider).getStoredStoreId();

    if (storeId == null) {
      setState(() {
        _errorMessage = 'No store session found. Please sign in with email.';
        _isLoading = false;
      });
      return;
    }

    await ref.read(authProvider.notifier).loginByPin(storeId: storeId, pin: _pin);

    setState(() => _isLoading = false);
  }

  void _addDigit(String digit) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin += digit;
      _errorMessage = null;
    });
    if (_pin.length == 4) {
      _submitPin();
    }
  }

  void _removeDigit() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _errorMessage = null;
    });
  }

  void _clearPin() {
    setState(() {
      _pin = '';
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next is AuthAuthenticated) {
        context.go(Routes.dashboard);
      } else if (next is AuthError) {
        setState(() {
          _errorMessage = next.message;
          _pin = '';
        });
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Icon(Icons.lock_rounded, size: 56, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.md),

                  Text('Enter PIN', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Quick switch — enter your 4-digit PIN',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // PIN Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final filled = index < _pin.length;
                      return Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? AppColors.primary : Colors.transparent,
                          border: Border.all(color: _errorMessage != null ? Colors.red : AppColors.primary, width: 2),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Error
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (_isLoading) const Padding(padding: EdgeInsets.all(AppSpacing.md), child: CircularProgressIndicator()),

                  const SizedBox(height: AppSpacing.lg),

                  // Numpad
                  _buildNumpad(),

                  const SizedBox(height: AppSpacing.xl),

                  // Switch to email login
                  TextButton(
                    onPressed: () => context.go(Routes.login),
                    child: Text('Sign in with email instead', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        _buildNumpadRow(['1', '2', '3']),
        const SizedBox(height: AppSpacing.sm),
        _buildNumpadRow(['4', '5', '6']),
        const SizedBox(height: AppSpacing.sm),
        _buildNumpadRow(['7', '8', '9']),
        const SizedBox(height: AppSpacing.sm),
        _buildNumpadRow(['C', '0', '⌫']),
      ],
    );
  }

  Widget _buildNumpadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: _buildNumpadKey(key));
      }).toList(),
    );
  }

  Widget _buildNumpadKey(String key) {
    final isSpecial = key == 'C' || key == '⌫';

    return SizedBox(
      width: 72,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSpecial
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Theme.of(context).colorScheme.surface,
          foregroundColor: isSpecial ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                if (key == 'C') {
                  _clearPin();
                } else if (key == '⌫') {
                  _removeDigit();
                } else {
                  _addDigit(key);
                }
              },
        child: Text(key, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
