import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/sync/providers/sync_providers.dart';
import 'package:wameedpos/features/sync/services/connectivity_service.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class InitialSyncScreen extends ConsumerStatefulWidget {

  const InitialSyncScreen({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  ConsumerState<InitialSyncScreen> createState() => _InitialSyncScreenState();
}

class _InitialSyncScreenState extends ConsumerState<InitialSyncScreen> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  _SyncPhase _phase = _SyncPhase.connecting;
  String _statusMessage = '';
  double _progress = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startInitialSync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_statusMessage.isEmpty && _error == null) {
      setState(() {
        _statusMessage = l10n.syncConnecting;
      });
    }
  }

  Future<void> _startInitialSync() async {
    final engine = ref.read(syncEngineProvider);

    setState(() {
      _phase = _SyncPhase.connecting;
      _statusMessage = l10n.syncCheckingConnectivity;
      _progress = 0.1;
    });

    // Check connectivity
    final connectivity = ref.read(connectivityServiceProvider);
    final status = await connectivity.checkNow();

    if (status != ConnectivityStatus.online) {
      setState(() {
        _phase = _SyncPhase.error;
        _error = l10n.syncNoInternet;
      });
      return;
    }

    setState(() {
      _phase = _SyncPhase.syncing;
      _statusMessage = l10n.syncDownloadingData;
      _progress = 0.3;
    });

    try {
      await engine.start();

      setState(() {
        _statusMessage = l10n.syncPerformingFullSync;
        _progress = 0.5;
      });

      final result = await engine.fullSync();

      if (result.hasError) {
        setState(() {
          _phase = _SyncPhase.error;
          _error = result.error;
        });
        return;
      }

      setState(() {
        _statusMessage = l10n.syncCompleteRecords(result.pulled);
        _progress = 1.0;
        _phase = _SyncPhase.complete;
      });

      await Future.delayed(const Duration(seconds: 1));
      widget.onComplete();
    } catch (e) {
      setState(() {
        _phase = _SyncPhase.error;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: PosCard(
            borderRadius: AppRadius.borderXl,
            child: Padding(
              padding: AppSpacing.paddingAll24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo / Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(
                      _phase == _SyncPhase.error
                          ? Icons.cloud_off
                          : _phase == _SyncPhase.complete
                          ? Icons.cloud_done
                          : Icons.cloud_sync,
                      size: 40,
                      color: _phase == _SyncPhase.error
                          ? AppColors.error
                          : _phase == _SyncPhase.complete
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                  ),
                  AppSpacing.gapH24,

                  Text(
                    _phase == _SyncPhase.error
                        ? l10n.syncFailed
                        : _phase == _SyncPhase.complete
                        ? l10n.syncReady
                        : l10n.syncSettingUp,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSpacing.gapH8,
                  Text(
                    _error ?? _statusMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _phase == _SyncPhase.error ? AppColors.error : theme.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapH24,

                  // Progress
                  if (_phase != _SyncPhase.error && _phase != _SyncPhase.complete) ...[
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: theme.dividerColor,
                      color: AppColors.primary,
                      minHeight: 6,
                      borderRadius: AppRadius.borderFull,
                    ),
                    AppSpacing.gapH8,
                    Text('${(_progress * 100).toInt()}%', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                  ],

                  if (_phase == _SyncPhase.error) ...[
                    AppSpacing.gapH16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PosButton(onPressed: widget.onComplete, variant: PosButtonVariant.outline, label: l10n.skipOffline),
                        AppSpacing.gapW12,
                        PosButton(
                          onPressed: () {
                            setState(() {
                              _phase = _SyncPhase.connecting;
                              _error = null;
                            });
                            _startInitialSync();
                          },
                          icon: Icons.refresh,
                          label: l10n.retry,
                        ),
                      ],
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
}

enum _SyncPhase { connecting, syncing, complete, error }
