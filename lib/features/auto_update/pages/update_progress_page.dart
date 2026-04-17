import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Full-screen update progress page showing step-by-step installation.
/// Steps: Backup -> Download -> Verify -> Install -> Migrate -> Complete
class UpdateProgressPage extends ConsumerStatefulWidget {
  const UpdateProgressPage({
    super.key,
    required this.version,
    required this.onComplete,
    required this.onError,
    required this.performUpdate,
  });

  final String version;
  final VoidCallback onComplete;
  final void Function(String error) onError;
  final Future<void> Function(void Function(UpdateStep, double) onProgress) performUpdate;

  @override
  ConsumerState<UpdateProgressPage> createState() => _UpdateProgressPageState();
}

enum UpdateStep { backup, download, verify, install, migrate, complete }

class _UpdateProgressPageState extends ConsumerState<UpdateProgressPage> {
  UpdateStep _currentStep = UpdateStep.backup;
  double _stepProgress = 0.0;
  String? _error;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _startUpdate();
  }

  Future<void> _startUpdate() async {
    try {
      await widget.performUpdate((step, progress) {
        if (mounted) {
          setState(() {
            _currentStep = step;
            _stepProgress = progress;
          });
        }
      });
      if (mounted) {
        setState(() {
          _currentStep = UpdateStep.complete;
          _stepProgress = 1.0;
          _done = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
        widget.onError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: AppSpacing.paddingAll24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _error != null
                        ? Icons.error_outline
                        : _done
                        ? Icons.check_circle
                        : Icons.system_update,
                    size: 64,
                    color: _error != null
                        ? AppColors.error
                        : _done
                        ? AppColors.success
                        : theme.colorScheme.primary,
                  ),
                  AppSpacing.gapH24,
                  Text(
                    _error != null
                        ? l10n.autoUpdateFailed
                        : _done
                        ? l10n.autoUpdateComplete
                        : l10n.autoUpdateInstalling,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapH8,
                  Text(
                    'v${widget.version}',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  AppSpacing.gapH32,
                  // Step indicators
                  ...UpdateStep.values.map(
                    (step) => _StepRow(
                      step: step,
                      currentStep: _currentStep,
                      progress: step == _currentStep ? _stepProgress : null,
                      hasError: _error != null && step == _currentStep,
                      label: _stepLabel(step, l10n),
                    ),
                  ),
                  if (_error != null) ...[
                    AppSpacing.gapH24,
                    Container(
                      padding: AppSpacing.paddingAll12,
                      decoration: BoxDecoration(color: AppColors.error.withAlpha(20), borderRadius: AppRadius.borderMd),
                      child: Text(_error!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error)),
                    ),
                    AppSpacing.gapH16,
                    PosButton(onPressed: () => Navigator.of(context).pop(), variant: PosButtonVariant.outline, label: l10n.close),
                  ],
                  if (_done) ...[
                    AppSpacing.gapH24,
                    PosButton(
                      onPressed: () {
                        widget.onComplete();
                        Navigator.of(context).pop();
                      },
                      variant: PosButtonVariant.soft,
                      label: l10n.autoUpdateRestart,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _stepLabel(UpdateStep step, AppLocalizations l10n) {
    switch (step) {
      case UpdateStep.backup:
        return l10n.autoUpdateStepBackup;
      case UpdateStep.download:
        return l10n.autoUpdateStepDownload;
      case UpdateStep.verify:
        return l10n.autoUpdateStepVerify;
      case UpdateStep.install:
        return l10n.autoUpdateStepInstall;
      case UpdateStep.migrate:
        return l10n.autoUpdateStepMigrate;
      case UpdateStep.complete:
        return l10n.autoUpdateStepComplete;
    }
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.currentStep, this.progress, required this.hasError, required this.label});

  final UpdateStep step;
  final UpdateStep currentStep;
  final double? progress;
  final bool hasError;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = step.index < currentStep.index || (step == UpdateStep.complete && currentStep == UpdateStep.complete);
    final isCurrent = step == currentStep && !isDone;
    final isPending = step.index > currentStep.index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          _StepIcon(isDone: isDone, isCurrent: isCurrent, hasError: hasError),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isPending ? theme.colorScheme.onSurfaceVariant : null,
                  ),
                ),
                if (isCurrent && progress != null && !hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: LinearProgressIndicator(value: progress),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon({required this.isDone, required this.isCurrent, required this.hasError});

  final bool isDone;
  final bool isCurrent;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return const Icon(Icons.error, color: AppColors.error, size: 24);
    }
    if (isDone) {
      return const Icon(Icons.check_circle, color: AppColors.success, size: 24);
    }
    if (isCurrent) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary),
      );
    }
    return Icon(Icons.circle_outlined, color: Theme.of(context).colorScheme.outlineVariant, size: 24);
  }
}
