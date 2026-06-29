import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/models/register.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';
import 'package:wameedpos/features/softpos/providers/softpos_providers.dart';

class PosOpenShiftDialog extends ConsumerStatefulWidget {
  const PosOpenShiftDialog({super.key});

  @override
  ConsumerState<PosOpenShiftDialog> createState() => _PosOpenShiftDialogState();
}

class _PosOpenShiftDialogState extends ConsumerState<PosOpenShiftDialog> {
  final _amountController = TextEditingController(text: '0.00');
  String? _selectedRegisterId;
  bool _isLoading = false;
  String? _error;
  // True when the error is specifically about device-register assignment,
  // so we can show the device ID as a hint for the owner to use.
  bool _isDeviceError = false;

  @override
  void initState() {
    super.initState();
    // Invalidate so we get a fresh list of active registers (with device_id check).
    Future.microtask(() {
      ref.invalidate(activeRegistersProvider);
      ref.invalidate(myOpenSessionsProvider);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onQuickAmount(double amount) {
    final current = double.tryParse(_amountController.text) ?? 0;
    _amountController.text = (current + amount).toStringAsFixed(2);
  }

  /// When backend returns exactly one register (device matched or auto-claimed),
  /// the cashier doesn't need to pick anything — auto-set the selection.
  void _autoSelectIfSingle(List<Register> registers) {
    if (registers.length == 1 && _selectedRegisterId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedRegisterId = registers.first.id);
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedRegisterId == null) {
      setState(() => _error = AppLocalizations.of(context)!.posSelectRegisterError);
      return;
    }

    final openingCash = double.tryParse(_amountController.text) ?? 0;

    setState(() {
      _isLoading = true;
      _error = null;
      _isDeviceError = false;
    });

    final ctx = context; // capture before async gap
    try {
      // If the cashier manually selected one of the multi-unclaimed registers,
      // claim it now before opening the shift so device_id is recorded.
      final registers = ref.read(activeRegistersProvider).asData?.value ?? [];
      final selected = registers.where((r) => r.id == _selectedRegisterId).firstOrNull;
      if (selected != null && (selected.deviceId == null || selected.deviceId!.isEmpty)) {
        final deviceId = await ref.read(softPosDeviceIdProvider.future);
        if (deviceId != null && deviceId.isNotEmpty) {
          await ref.read(posTerminalRepositoryProvider).claimRegisterDevice(_selectedRegisterId!, deviceId: deviceId);
          ref.invalidate(activeRegistersProvider);
        }
      }

      await ref.read(activeSessionProvider.notifier).openSession(openingCash: openingCash, registerId: _selectedRegisterId!);

      // Auto-sync the EdfaPay token from the register to device secure storage so
      // the payment dialog can offer the SoftPOS option without the cashier having
      // to manually re-enter the token in Hardware Settings.
      final fresh = ref.read(activeRegistersProvider).asData?.value ?? [];
      final selectedRegister = fresh.where((r) => r.id == _selectedRegisterId).firstOrNull;
      if (selectedRegister != null && (selectedRegister.edfapayToken?.isNotEmpty ?? false)) {
        await ref.read(softPosProvider.notifier).saveConfig(token: selectedRegister.edfapayToken!, environment: 'production');
        ref.invalidate(softPosTokenProvider);
      }

      // ignore: use_build_context_synchronously
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      final msg = _friendlyError(e, ctx);
      final isDevice = e is DioException && (e.response?.statusCode == 422 || e.response?.statusCode == 409);
      // ignore: use_build_context_synchronously
      if (!mounted) return;
      setState(() {
        _error = msg;
        _isDeviceError = isDevice;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Translate backend/network errors into cashier-friendly messages.
  ///
  /// The backend returns a structured body for device/register problems:
  ///   { "message": "This device is not assigned to any register.",
  ///     "errors": { "device_id": ["All active registers are already ..."] } }
  /// We surface that human-readable text instead of the raw
  /// "DioException ... status code of 422" string.
  String _friendlyError(Object e, BuildContext ctx) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final message = data['message'];

        // Pull the first validation detail (e.g. errors.device_id[0]).
        String? detail;
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstField = errors.values.first;
          if (firstField is List && firstField.isNotEmpty) {
            detail = firstField.first?.toString();
          } else if (firstField is String) {
            detail = firstField;
          }
        }

        if (message is String && message.isNotEmpty) {
          // Headline message + actionable detail (when they differ).
          if (detail != null && detail.isNotEmpty && detail != message) {
            return '$message\n$detail';
          }
          return message;
        }
        if (detail != null && detail.isNotEmpty) return detail;
      }

      // No response body → network/timeout problem.
      if (e.response == null) {
        return 'Network error. Please check your connection and try again.';
      }
    }
    return e.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final registersAsync = ref.watch(activeRegistersProvider);
    final openSessionsAsync = ref.watch(myOpenSessionsProvider);

    // If the cashier already has one (or more) shifts open on other registers,
    // refuse to present the open-shift form and instead surface the existing
    // shifts so they can resume or close them. Mirrors the backend guard in
    // PosSessionService::open() which throws pos.session_user_has_other_open.
    final existingOpen = openSessionsAsync.asData?.value ?? const [];
    if (existingOpen.isNotEmpty) {
      return Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(padding: AppSpacing.paddingAll24, child: _buildExistingOpenSessionsBody(existingOpen)),
        ),
      );
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.point_of_sale_rounded, color: AppColors.primary, size: 24),
                  ),
                  AppSpacing.gapW16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.posOpenShift, style: AppTypography.headlineSmall),
                        Text(
                          AppLocalizations.of(context)!.posOpenShiftDescription,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              AppSpacing.gapH24,

              // Register selection
              Text(
                AppLocalizations.of(context)!.posRegister,
                style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              AppSpacing.gapH4,
              _buildRegisterDropdown(registersAsync, isDark),
              AppSpacing.gapH16,

              // Opening cash
              Text(
                AppLocalizations.of(context)!.posOpeningCash,
                style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              AppSpacing.gapH4,
              PosTextField(
                controller: _amountController,
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.attach_money_rounded,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                textAlign: TextAlign.end,
              ),
              AppSpacing.gapH12,

              // Quick amounts
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [50, 100, 200, 500].map((amount) {
                  return PosButton(
                    onPressed: () => _onQuickAmount(amount.toDouble()),
                    variant: PosButtonVariant.outline,
                    label: '+$amount',
                  );
                }).toList(),
              ),
              AppSpacing.gapH8,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: PosButton(
                  onPressed: () => _amountController.text = '0.00',
                  variant: PosButtonVariant.ghost,
                  label: AppLocalizations.of(context)!.posReset,
                ),
              ),

              if (_error != null) ...[
                AppSpacing.gapH12,
                Container(
                  padding: AppSpacing.paddingAll12,
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                          AppSpacing.gapW8,
                          Expanded(
                            child: Text(_error!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                          ),
                        ],
                      ),
                      // Show device ID when the error is about device assignment
                      // so the cashier can give it to the owner for configuration.
                      if (_isDeviceError) ...[
                        AppSpacing.gapH8,
                        const Divider(height: 1),
                        AppSpacing.gapH8,
                        Text(
                          'Your Device ID (share with the owner):',
                          style: AppTypography.micro.copyWith(color: AppColors.error),
                        ),
                        AppSpacing.gapH4,
                        ref
                            .watch(softPosDeviceIdProvider)
                            .when(
                              loading: () =>
                                  const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                              error: (err, st) => const SizedBox.shrink(),
                              data: (id) => id == null
                                  ? const SizedBox.shrink()
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: SelectableText(
                                            id,
                                            style: AppTypography.micro.copyWith(
                                              fontFamily: 'monospace',
                                              color: AppColors.error,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy_rounded, size: 16),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                          color: AppColors.error,
                                          tooltip: 'Copy',
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: id));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Device ID copied'), duration: Duration(seconds: 2)),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                            ),
                      ],
                    ],
                  ),
                ),
              ],

              AppSpacing.gapH24,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: AppLocalizations.of(context)!.posCancel,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(
                      label: AppLocalizations.of(context)!.posOpenShift,
                      icon: Icons.login_rounded,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingOpenSessionsBody(List<PosSession> sessions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: const Icon(Icons.lock_clock_rounded, color: AppColors.warning, size: 24),
            ),
            AppSpacing.gapW16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.posShiftAlreadyOpen, style: AppTypography.headlineSmall),
                  Text(
                    AppLocalizations.of(context)!.posShiftAlreadyOpenDesc,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
          ],
        ),
        AppSpacing.gapH16,
        ...sessions.map((s) {
          final registerLabel = s.registerName ?? s.registerId;
          final openedAt = s.openedAt;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: AppSpacing.paddingAll12,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.06),
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.point_of_sale_rounded, color: AppColors.warning, size: 20),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(registerLabel, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      if (openedAt != null)
                        Text(
                          'Opened ${openedAt.toLocal().toString().split('.').first}',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                        ),
                      Text(
                        'Opening cash: ${s.openingCash.toStringAsFixed(2)}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                      ),
                    ],
                  ),
                ),
                PosButton(
                  label: AppLocalizations.of(context)!.posShiftResume,
                  icon: Icons.login_rounded,
                  onPressed: () async {
                    // Sync EdfaPay token from the resumed register to secure
                    // storage so the cashier can use SoftPOS immediately.
                    final registers = ref.read(activeRegistersProvider).asData?.value ?? [];
                    final reg = registers.where((r) => r.id == s.registerId).firstOrNull;
                    if (reg != null && (reg.edfapayToken?.isNotEmpty ?? false)) {
                      await ref.read(softPosProvider.notifier).saveConfig(token: reg.edfapayToken!, environment: 'production');
                      ref.invalidate(softPosTokenProvider);
                    }
                    if (context.mounted) {
                      // ignore: use_build_context_synchronously
                      ref.read(activeSessionProvider.notifier).setSession(s);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        }),
        AppSpacing.gapH16,
        Row(
          children: [
            Expanded(
              child: PosButton(
                label: AppLocalizations.of(context)!.posCancel,
                variant: PosButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: PosButton(
                label: AppLocalizations.of(context)!.commonRefresh,
                icon: Icons.refresh_rounded,
                variant: PosButtonVariant.outline,
                onPressed: () => ref.invalidate(myOpenSessionsProvider),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterDropdown(AsyncValue<List<Register>> registersAsync, bool isDark) {
    return registersAsync.when(
      loading: () => Container(
        padding: AppSpacing.paddingAll12,
        child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
      ),
      error: (e, _) {
        final msg = _friendlyError(e, context);
        final isDeviceErr = e is DioException && (e.response?.statusCode == 422 || e.response?.statusCode == 409);
        return Container(
          padding: AppSpacing.paddingAll12,
          decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(msg, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                  ),
                ],
              ),
              if (isDeviceErr) ...[
                AppSpacing.gapH8,
                const Divider(height: 1),
                AppSpacing.gapH8,
                Text(
                  'Your Device ID — give this to the store owner:',
                  style: AppTypography.micro.copyWith(color: AppColors.error),
                ),
                AppSpacing.gapH4,
                ref
                    .watch(softPosDeviceIdProvider)
                    .when(
                      loading: () => const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                      error: (err, st) => const SizedBox.shrink(),
                      data: (id) => id == null
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    id,
                                    style: AppTypography.micro.copyWith(
                                      fontFamily: 'monospace',
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy_rounded, size: 16),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  color: AppColors.error,
                                  tooltip: 'Copy Device ID',
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: id));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Device ID copied'), duration: Duration(seconds: 2)),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
              ],
            ],
          ),
        );
      },
      data: (registers) {
        // Auto-select when the backend returned exactly one register
        // (device already claimed, or auto-claimed during this call).
        _autoSelectIfSingle(registers);

        if (registers.isEmpty) {
          return Container(
            padding: AppSpacing.paddingAll12,
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
                AppSpacing.gapW8,
                Expanded(child: Text(AppLocalizations.of(context)!.posNoRegistersFound, style: AppTypography.bodySmall)),
              ],
            ),
          );
        }

        // When only one register exists AND it was auto-selected,
        // show a read-only confirmation chip instead of a dropdown.
        if (registers.length == 1) {
          final r = registers.first;
          return Container(
            padding: AppSpacing.paddingAll12,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                AppSpacing.gapW8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        'Auto-assigned to this device',
                        style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return PosSearchableDropdown<String>(
          hint: AppLocalizations.of(context)!.selectRegister,
          label: AppLocalizations.of(context)!.posSelectRegister,
          items: registers.map((t) {
            return PosDropdownItem<String>(value: t.id, label: t.name);
          }).toList(),
          selectedValue: _selectedRegisterId,
          onChanged: (val) => setState(() => _selectedRegisterId = val),
          showSearch: true,
        );
      },
    );
  }
}
