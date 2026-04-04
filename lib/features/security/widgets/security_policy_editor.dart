import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/security/models/security_policy.dart';

class SecurityPolicyEditor extends StatelessWidget {
  final SecurityPolicy policy;
  final ValueChanged<Map<String, dynamic>>? onSave;

  const SecurityPolicyEditor({super.key, required this.policy, this.onSave});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── PIN & Authentication ─────────────────
        _buildSectionHeader(context, l10n.securityPinAuth, Icons.pin),
        Card(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              children: [
                _buildRow(
                  context,
                  l10n.securityPinLength,
                  '${policy.pinMinLength ?? 4} – ${policy.pinMaxLength ?? 6} ${l10n.securityDigits}',
                  Icons.pin,
                ),
                _buildRow(
                  context,
                  l10n.securityPinExpiryDays,
                  '${policy.pinExpiryDays ?? 0} ${l10n.securityDays}',
                  Icons.schedule,
                ),
                _buildSwitch(context, l10n.securityRequireUniquePins, policy.requireUniquePins ?? false),
                _buildSwitch(context, l10n.securityBiometricEnabled, policy.biometricEnabled ?? false),
                _buildSwitch(context, l10n.securityRequire2fa, policy.require2faOwner ?? false),
              ],
            ),
          ),
        ),

        AppSpacing.gapH16,

        // ─── Lockout & Sessions ───────────────────
        _buildSectionHeader(context, l10n.securityLockoutSessions, Icons.lock_clock),
        Card(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              children: [
                _buildRow(context, l10n.securityAutoLock, '${policy.autoLockSeconds ?? 300}s', Icons.lock_clock),
                _buildRow(context, l10n.securityMaxFailedAttempts, '${policy.maxFailedAttempts ?? 5}', Icons.error_outline),
                _buildRow(
                  context,
                  l10n.securityLockoutDuration,
                  '${policy.lockoutDurationMinutes ?? 15} ${l10n.securityMinutes}',
                  Icons.timer_off,
                ),
                _buildRow(context, l10n.securitySessionMaxHours, '${policy.sessionMaxHours ?? 12}h', Icons.schedule),
                _buildSwitch(context, l10n.securityForceLogoutOnRoleChange, policy.forceLogoutOnRoleChange ?? false),
              ],
            ),
          ),
        ),

        AppSpacing.gapH16,

        // ─── PIN Override ─────────────────────────
        _buildSectionHeader(context, l10n.securityPinOverrides, Icons.admin_panel_settings),
        Card(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              children: [
                _buildSwitch(context, l10n.securityPinOverrideVoid, policy.requirePinOverrideVoid ?? true),
                _buildSwitch(context, l10n.securityPinOverrideReturn, policy.requirePinOverrideReturn ?? true),
                _buildSwitch(context, l10n.securityPinOverrideDiscount, policy.requirePinOverrideDiscount ?? false),
                _buildRow(context, l10n.securityDiscountThreshold, '${policy.discountOverrideThreshold ?? 20.0}%', Icons.percent),
              ],
            ),
          ),
        ),

        AppSpacing.gapH16,

        // ─── Password & Device ────────────────────
        _buildSectionHeader(context, l10n.securityPasswordDevice, Icons.devices),
        Card(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              children: [
                _buildRow(
                  context,
                  l10n.securityPasswordExpiryDays,
                  '${policy.passwordExpiryDays ?? 0} ${l10n.securityDays}',
                  Icons.key,
                ),
                _buildSwitch(context, l10n.securityRequireStrongPassword, policy.requireStrongPassword ?? false),
                _buildRow(context, l10n.securityMaxDevices, '${policy.maxDevices ?? 5}', Icons.devices),
                _buildRow(
                  context,
                  l10n.securityAuditRetentionDays,
                  '${policy.auditRetentionDays ?? 90} ${l10n.securityDays}',
                  Icons.history,
                ),
              ],
            ),
          ),
        ),

        AppSpacing.gapH16,

        // ─── IP Restrictions ──────────────────────
        _buildSectionHeader(context, l10n.securityIpRestrictions, Icons.language),
        Card(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSwitch(context, l10n.securityIpRestrictionEnabled, policy.ipRestrictionEnabled ?? false),
                if (policy.ipRestrictionEnabled == true &&
                    policy.allowedIpRanges != null &&
                    policy.allowedIpRanges!.isNotEmpty) ...[
                  AppSpacing.gapH8,
                  Text(
                    l10n.securityAllowedIpRanges,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                  AppSpacing.gapH4,
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: policy.allowedIpRanges!
                        .map(
                          (ip) => Chip(
                            label: Text(ip, style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          AppSpacing.gapW8,
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: AppSpacing.paddingV4,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          AppSpacing.gapW8,
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSwitch(BuildContext context, String label, bool value) {
    return Padding(
      padding: AppSpacing.paddingV4,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Switch.adaptive(value: value, onChanged: null),
        ],
      ),
    );
  }
}
