import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';

/// A page-level permission guard that replaces the entire page content
/// with a "no access" message when the user lacks the required permission.
///
/// Accepts a single [permission] or a list [anyOf] (OR logic — access
/// is granted if the user holds **any** of the listed permissions).
///
/// While permissions are still loading, shows a centered spinner so the
/// page doesn't flash the forbidden screen before data arrives.
class PermissionGuardPage extends ConsumerWidget {
  const PermissionGuardPage({super.key, this.permission, this.anyOf, required this.child})
    : assert(permission != null || anyOf != null, 'Provide permission or anyOf');

  final String? permission;
  final List<String>? anyOf;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permsState = ref.watch(userPermissionsProvider);

    // Still loading — show spinner instead of flashing forbidden
    if (!permsState.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final allowed = permission != null ? permsState.hasPermission(permission!) : anyOf!.any((p) => permsState.hasPermission(p));

    if (allowed) return child;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.accessDenied, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.accessDeniedMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
                label: Text(AppLocalizations.of(context)!.goBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
