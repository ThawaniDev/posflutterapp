import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';
import 'package:wameedpos/features/staff/widgets/pin_override_dialog.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// A widget that conditionally renders its [child] based on whether
/// the current user has the required [permission].
///
/// If the user lacks the permission, the widget can either:
/// - Show nothing (default)
/// - Show a disabled version of the child
/// - Show a custom [fallback] widget
///
/// Usage:
/// ```dart
/// PermissionGate(
///   permission: 'pos.apply_discount',
///   child: PosButton(label: 'Apply Discount', onPressed: _applyDiscount),
/// )
/// ```
class PermissionGate extends ConsumerWidget {

  const PermissionGate({super.key, required this.permission, required this.child, this.fallback, this.showDisabled = false});
  final String permission;
  final Widget child;
  final Widget? fallback;
  final bool showDisabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasPermission = ref.watch(hasPermissionProvider(permission));

    if (hasPermission) return child;

    if (fallback != null) return fallback!;

    if (showDisabled) {
      return IgnorePointer(child: Opacity(opacity: 0.4, child: child));
    }

    return const SizedBox.shrink();
  }
}

/// A button wrapper that first checks if the current user has the
/// specified [permission]. If the permission requires PIN override,
/// it will show the PIN dialog before executing [onAuthorized].
///
/// Usage:
/// ```dart
/// ProtectedAction(
///   permission: 'pos.void_transaction',
///   actionDescription: 'Void sale #123',
///   onAuthorized: (result) => _voidSale(),
///   child: PosButton(label: 'Void Sale', onPressed: null),
/// )
/// ```
class ProtectedAction extends ConsumerWidget {

  const ProtectedAction({
    super.key,
    required this.permission,
    required this.onAuthorized,
    required this.child,
    this.actionDescription,
  });
  final String permission;
  final String? actionDescription;
  final void Function(PinOverrideResult? result) onAuthorized;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasPermission = ref.watch(hasPermissionProvider(permission));
    final pinRequiredAsync = ref.watch(pinRequiredProvider(permission));

    if (!hasPermission) {
      return Tooltip(
        message: l10n.staffNoActionPermission,
        child: IgnorePointer(child: Opacity(opacity: 0.4, child: child)),
      );
    }

    final requiresPin = pinRequiredAsync.when(data: (val) => val, loading: () => false, error: (_, __) => false);

    return GestureDetector(
      onTap: () async {
        if (requiresPin) {
          final result = await PinOverrideDialog.show(
            context: context,
            ref: ref,
            permissionCode: permission,
            actionDescription: actionDescription,
          );
          if (result != null) {
            onAuthorized(result);
          }
        } else {
          onAuthorized(null);
        }
      },
      child: child,
    );
  }
}

/// Small indicator badge that shows a lock icon if the user doesn't
/// have the given permission, or a PIN icon if PIN override is required.
class PermissionBadge extends ConsumerWidget {

  const PermissionBadge({super.key, required this.permission});
  final String permission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasPermission = ref.watch(hasPermissionProvider(permission));
    final pinRequiredAsync = ref.watch(pinRequiredProvider(permission));

    if (!hasPermission) {
      return Tooltip(
        message: l10n.staffNoPermission,
        child: const Icon(Icons.lock, size: 16, color: AppColors.error),
      );
    }

    final requiresPin = pinRequiredAsync.when(data: (val) => val, loading: () => false, error: (_, __) => false);

    if (requiresPin) {
      return Tooltip(
        message: l10n.staffRequiresPinOverride,
        child: const Icon(Icons.pin, size: 16, color: AppColors.warning),
      );
    }

    return const SizedBox.shrink();
  }
}
