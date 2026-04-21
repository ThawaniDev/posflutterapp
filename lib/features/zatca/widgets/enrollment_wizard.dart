import 'package:flutter/material.dart';

import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class EnrollmentWizard extends StatefulWidget {

  const EnrollmentWizard({super.key, required this.onEnroll});
  final Future<void> Function(String otp, String environment) onEnroll;

  @override
  State<EnrollmentWizard> createState() => _EnrollmentWizardState();
}

class _EnrollmentWizardState extends State<EnrollmentWizard> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _otpController = TextEditingController();
  String _environment = 'simulation';
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingAll20,
      decoration: BoxDecoration(
        color: AppColors.surfaceFor(context),
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_outlined, color: AppColors.primary, size: 28),
              AppSpacing.gapH8,
              Text(l10n.zatcaEnrollment, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          AppSpacing.gapH12,
          Text(
            'Enroll your store with ZATCA for e-invoicing compliance. '
            'Enter the OTP received from the ZATCA portal.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
          AppSpacing.gapH20,
          // Environment toggle
          Text(l10n.hwEnvironment, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
          AppSpacing.gapH4,
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'simulation', label: Text(l10n.zatcaSimulation), icon: const Icon(Icons.science_outlined)),
              ButtonSegment(value: 'production', label: Text(l10n.production), icon: const Icon(Icons.cloud_done_outlined)),
            ],
            selected: {_environment},
            onSelectionChanged: (p0) => setState(() => _environment = p0.first),
          ),
          AppSpacing.gapH20,
          // OTP input
          PosTextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            label: 'ZATCA OTP',
            hint: 'Enter 6-digit OTP',
          ),
          AppSpacing.gapH20,
          SizedBox(
            width: double.infinity,
            child: PosButton(
              onPressed: _isLoading ? null : _handleEnroll,
              isLoading: _isLoading,
              icon: Icons.verified_outlined,
              label: _isLoading ? 'Enrolling...' : 'Enroll Now',
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEnroll() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      showPosWarningSnackbar(context, AppLocalizations.of(context)!.pleaseEnterValidOtp);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await widget.onEnroll(otp, _environment);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
