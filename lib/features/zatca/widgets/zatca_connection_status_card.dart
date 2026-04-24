import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/zatca/models/zatca_connection_status.dart';
import 'package:wameedpos/features/zatca/providers/zatca_providers.dart';
import 'package:wameedpos/features/zatca/providers/zatca_state.dart';

/// Provider-facing health card. Shows environment, certificate state,
/// queue depth, last success/error so the merchant can confirm at a
/// glance whether ZATCA is wired up and accepting submissions.
class ZatcaConnectionStatusCard extends ConsumerStatefulWidget {
  const ZatcaConnectionStatusCard({super.key});

  @override
  ConsumerState<ZatcaConnectionStatusCard> createState() => _ZatcaConnectionStatusCardState();
}

class _ZatcaConnectionStatusCardState extends ConsumerState<ZatcaConnectionStatusCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(zatcaConnectionProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(zatcaConnectionProvider);
    final theme = Theme.of(context);

    return PosCard(
      padding: AppSpacing.paddingAll20,
      child: switch (state) {
        ZatcaConnectionInitial() ||
        ZatcaConnectionLoading() => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
        ZatcaConnectionError(:final message) => Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            AppSpacing.gapH8,
            Expanded(child: Text(message)),
            IconButton(onPressed: () => ref.read(zatcaConnectionProvider.notifier).load(), icon: const Icon(Icons.refresh)),
          ],
        ),
        ZatcaConnectionLoaded(:final status) => _buildLoaded(context, theme, l10n, status),
      },
    );
  }

  Widget _buildLoaded(BuildContext context, ThemeData theme, AppLocalizations l10n, ZatcaConnectionStatus status) {
    final healthColor = status.isHealthy ? AppColors.success : (status.connected ? AppColors.warning : AppColors.error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              status.isHealthy ? Icons.check_circle : (status.connected ? Icons.warning_amber : Icons.cloud_off),
              color: healthColor,
              size: 28,
            ),
            AppSpacing.gapH8,
            Expanded(
              child: Text(l10n.zatcaConnectionStatus, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ),
            _envBadge(status.isProduction, l10n),
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'Refresh',
              onPressed: () => ref.read(zatcaConnectionProvider.notifier).load(),
              icon: const Icon(Icons.refresh, size: 20),
            ),
          ],
        ),
        AppSpacing.gapH12,
        Row(
          children: [
            _pill(
              status.connected ? l10n.zatcaConnected : l10n.zatcaDisconnected,
              status.connected ? AppColors.success : AppColors.error,
            ),
            const SizedBox(width: 8),
            _pill(status.isHealthy ? l10n.zatcaHealthy : l10n.zatcaUnhealthy, healthColor),
          ],
        ),
        AppSpacing.gapH16,
        if (status.certificate == null)
          Text(l10n.zatcaNoCertificate, style: TextStyle(color: AppColors.error))
        else
          _buildCertRow(theme, l10n, status.certificate!),
        AppSpacing.gapH12,
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _stat('${status.queueDepth}', l10n.zatcaQueueDepth, AppColors.info),
            _stat('${status.devices.active}', 'Active devices', AppColors.success),
            if (status.devices.tampered > 0)
              _stat('${status.devices.tampered}', l10n.zatcaTamperedDevices(status.devices.tampered), AppColors.error),
          ],
        ),
        if (status.lastSuccess != null) ...[
          AppSpacing.gapH12,
          _eventRow(
            theme,
            Icons.check_circle_outline,
            AppColors.success,
            l10n.zatcaLastSuccess,
            '${status.lastSuccess!.invoiceNumber ?? ''} • ${status.lastSuccess!.submittedAt?.toLocal().toString().split('.').first ?? ''}',
          ),
        ],
        if (status.lastError != null) ...[
          AppSpacing.gapH8,
          _eventRow(
            theme,
            Icons.error_outline,
            AppColors.error,
            l10n.zatcaLastError,
            '${status.lastError!.responseCode ?? ''} ${status.lastError!.message ?? ''}',
          ),
        ],
      ],
    );
  }

  Widget _envBadge(bool isProduction, AppLocalizations l10n) {
    final color = isProduction ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isProduction ? l10n.zatcaProductionMode : l10n.zatcaSandboxMode,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildCertRow(ThemeData theme, AppLocalizations l10n, ZatcaConnectionCertificate cert) {
    final days = cert.daysUntilExpiry;
    Color color = AppColors.success;
    String label;
    if (cert.expired) {
      color = AppColors.error;
      label = l10n.zatcaCertificateExpired;
    } else if (cert.expiringSoon) {
      color = AppColors.warning;
      label = days != null ? l10n.zatcaCertificateExpiresIn(days) : l10n.zatcaCertificateExpiringSoon;
    } else if (days != null) {
      label = l10n.zatcaCertificateExpiresIn(days);
    } else {
      label = '';
    }
    return Row(
      children: [
        Icon(Icons.shield_outlined, color: color, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '${cert.type.toUpperCase()} • $label',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _eventRow(ThemeData theme, IconData icon, Color color, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
