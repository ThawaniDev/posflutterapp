import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class EnrollmentWizard extends StatefulWidget {
  final Future<void> Function(String otp, String environment) onEnroll;

  const EnrollmentWizard({super.key, required this.onEnroll});

  @override
  State<EnrollmentWizard> createState() => _EnrollmentWizardState();
}

class _EnrollmentWizardState extends State<EnrollmentWizard> {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingAll20,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_outlined,
                  color: AppColors.primary, size: 28),
              AppSpacing.gapH8,
              Text('ZATCA Enrollment',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
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
          Text('Environment',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w500)),
          AppSpacing.gapH4,
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'simulation',
                label: Text('Simulation'),
                icon: Icon(Icons.science_outlined),
              ),
              ButtonSegment(
                value: 'production',
                label: Text('Production'),
                icon: Icon(Icons.cloud_done_outlined),
              ),
            ],
            selected: {_environment},
            onSelectionChanged: (p0) =>
                setState(() => _environment = p0.first),
          ),
          AppSpacing.gapH20,
          // OTP input
          Text('ZATCA OTP',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w500)),
          AppSpacing.gapH4,
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: 'Enter 6-digit OTP',
              counterText: '',
              border: OutlineInputBorder(),
            ),
          ),
          AppSpacing.gapH20,
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _handleEnroll,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.verified_outlined),
              label: Text(_isLoading ? 'Enrolling...' : 'Enroll Now'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEnroll() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
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
