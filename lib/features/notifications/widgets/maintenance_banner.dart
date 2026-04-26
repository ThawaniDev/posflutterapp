import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/notifications/models/maintenance_status.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';

/// Top-of-screen banner shown when the platform is in scheduled maintenance.
/// Polls /maintenance-status every 60 seconds.
class MaintenanceBanner extends ConsumerStatefulWidget {
  const MaintenanceBanner({super.key});

  @override
  ConsumerState<MaintenanceBanner> createState() => _MaintenanceBannerState();
}

class _MaintenanceBannerState extends ConsumerState<MaintenanceBanner> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) ref.invalidate(maintenanceStatusProvider);
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(maintenanceStatusProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final muted = AppColors.mutedFor(context);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (data) {
        final status = MaintenanceStatus.fromJson(data);
        if (!status.shouldShow) return const SizedBox.shrink();

        final text = (isAr ? status.bannerAr : status.bannerEn) ?? l10n.notifMaintenanceBannerTitle;
        final endText = status.expectedEndAt != null
            ? l10n.notifMaintenanceUntil(
                DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_jm().format(status.expectedEndAt!.toLocal()),
              )
            : null;

        return Container(
          width: double.infinity,
          color: AppColors.warning.withValues(alpha: isDark ? 0.25 : 0.18),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              const Icon(Icons.build_rounded, size: 18, color: AppColors.warning),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    if (endText != null) Text(endText, style: AppTypography.bodySmall.copyWith(color: muted)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
