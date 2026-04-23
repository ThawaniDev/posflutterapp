import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';
import 'package:wameedpos/features/subscription/widgets/grace_period_banner.dart';

/// App-wide subscription status banner.
///
/// Reads cached entitlements from [FeatureGateService] and renders a
/// [GracePeriodBanner] whenever the subscription is in grace or expired.
/// Returns an empty widget otherwise.
class GlobalSubscriptionBanner extends ConsumerWidget {
  const GlobalSubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureGate = ref.watch(featureGateServiceProvider);
    final subscription = featureGate.subscriptionStatus;

    if (subscription == null) return const SizedBox.shrink();

    final status = subscription['status'] as String?;
    final graceEndsRaw =
        subscription['grace_period_ends_at'] as String? ?? subscription['expires_at'] as String?;
    if (graceEndsRaw == null) return const SizedBox.shrink();

    final endsAt = DateTime.tryParse(graceEndsRaw);
    if (endsAt == null) return const SizedBox.shrink();

    final isExpired = status == 'expired' || status == 'cancelled' || status == 'paused';
    final isGrace = status == 'grace';

    if (!isExpired && !isGrace) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: GracePeriodBanner(
        gracePeriodEndsAt: endsAt,
        isExpired: isExpired,
        onRenewPressed: () => context.go(Routes.planSelection),
      ),
    );
  }
}
