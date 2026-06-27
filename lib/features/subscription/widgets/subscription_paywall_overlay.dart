import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';
import 'package:wameedpos/features/subscription/services/subscription_sync_service.dart';

/// Full-screen opaque overlay that blocks POS access when the subscription is
/// expired, cancelled, or paused.
///
/// The overlay is reactive: it disappears automatically as soon as
/// [FeatureGateService.isPosBlocked] becomes `false` after a successful sync.
///
/// Usage — wrap the cashier body in a [Stack]:
/// ```dart
/// Stack(
///   children: [
///     child,
///     if (featureGate.isPosBlocked) const SubscriptionPaywallOverlay(),
///   ],
/// )
/// ```
class SubscriptionPaywallOverlay extends ConsumerStatefulWidget {
  const SubscriptionPaywallOverlay({super.key});

  @override
  ConsumerState<SubscriptionPaywallOverlay> createState() => _SubscriptionPaywallOverlayState();
}

class _SubscriptionPaywallOverlayState extends ConsumerState<SubscriptionPaywallOverlay> {
  bool _isChecking = false;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  // ─── Helpers ────────────────────────────────────────────────────────

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return DateFormat('dd MMM yyyy').format(dt.toLocal());
  }

  String _statusMessage(String? status) {
    switch (status) {
      case 'cancelled':
        return l10n.subPaywallCancelledMessage;
      case 'paused':
        return l10n.subPaywallPausedMessage;
      case null:
        return l10n.subPaywallNoSubMessage;
      default: // expired or unknown
        return l10n.subExpiredRenewMessage;
    }
  }

  String _statusBadge(String? status) {
    switch (status) {
      case 'cancelled':
        return l10n.subscriptionCancelled;
      case 'paused':
        return l10n.subPaywallPausedMessage;
      default: // expired or unknown
        return l10n.subSubscriptionExpired;
    }
  }

  // ─── Actions ───────────────────────────────────────────────────────

  Future<void> _handleCheckStatus() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);
    try {
      await ref.read(subscriptionSyncServiceProvider).sync();
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  void _handleRenewNow() {
    context.go(Routes.planSelection);
  }

  // ─── Build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final featureGate = ref.watch(featureGateServiceProvider);
    final sub = featureGate.subscriptionStatus;
    final plan = featureGate.planDetails;
    final status = sub?['status'] as String?;
    final expiresAt = sub?['expires_at'] as String? ?? sub?['current_period_end'] as String?;
    final planName = plan?['name'] as String? ?? plan?['code'] as String?;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned.fill(
      child: Material(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Lock icon ──────────────────────────────────
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.lock_outline_rounded, color: AppColors.error, size: 48),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Title ──────────────────────────────────────
                    Text(
                      l10n.subPaywallTitle,
                      style: AppTypography.headlineMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Status badge ───────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: AppRadius.borderFull,
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        _statusBadge(status),
                        style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Info card ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: AppRadius.borderLg,
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plan name
                          if (planName != null) ...[
                            Row(
                              children: [
                                Icon(Icons.card_membership, size: 16, color: AppColors.mutedFor(context)),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.subPaywallPlanActive(planName),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.mutedFor(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                          ],

                          // Expiry date
                          if (expiresAt != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.error),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.subPaywallExpiredOn(_formatDate(expiresAt)),
                                  style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],

                          // Status-specific message
                          Text(
                            _statusMessage(status),
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Reassurance line
                          Text(
                            l10n.subPaywallRenewDescription,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context), height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Primary CTA: Renew Now ─────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: PosButton(
                        label: l10n.subscriptionRenewNow,
                        icon: Icons.refresh_rounded,
                        size: PosButtonSize.lg,
                        onPressed: _handleRenewNow,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Secondary CTA: Check Status ────────────────
                    SizedBox(
                      width: double.infinity,
                      child: _isChecking
                          ? const Center(child: CircularProgressIndicator())
                          : PosButton(
                              label: l10n.subPaywallCheckStatus,
                              icon: Icons.sync_rounded,
                              variant: PosButtonVariant.outline,
                              size: PosButtonSize.lg,
                              onPressed: _handleCheckStatus,
                            ),
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
