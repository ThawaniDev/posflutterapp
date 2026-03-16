import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/security/models/security_policy.dart';

class SecurityPolicyEditor extends StatelessWidget {
  final SecurityPolicy policy;
  final ValueChanged<Map<String, dynamic>>? onSave;

  const SecurityPolicyEditor({super.key, required this.policy, this.onSave});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Security Policy', style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            _buildRow(context, 'PIN Length', '${policy.pinMinLength ?? 4} – ${policy.pinMaxLength ?? 6} digits', Icons.pin),
            _buildRow(context, 'Auto-lock', '${policy.autoLockSeconds ?? 300}s', Icons.lock_clock),
            _buildRow(context, 'Max Failed Attempts', '${policy.maxFailedAttempts ?? 5}', Icons.error_outline),
            _buildRow(context, 'Lockout Duration', '${policy.lockoutDurationMinutes ?? 15} min', Icons.timer_off),
            _buildRow(context, 'Session Max Hours', '${policy.sessionMaxHours ?? 12}h', Icons.schedule),
            AppSpacing.gapH8,
            _buildSwitch(context, 'Require 2FA for Owner', policy.require2faOwner ?? false),
            _buildSwitch(context, 'PIN Override: Void', policy.requirePinOverrideVoid ?? true),
            _buildSwitch(context, 'PIN Override: Return', policy.requirePinOverrideReturn ?? true),
            _buildSwitch(context, 'PIN Override: Discount', policy.requirePinOverrideDiscount ?? false),
            AppSpacing.gapH8,
            _buildRow(context, 'Discount Override Threshold', '${policy.discountOverrideThreshold ?? 20.0}%', Icons.percent),
          ],
        ),
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
