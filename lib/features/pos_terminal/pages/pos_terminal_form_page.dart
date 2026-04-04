import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:thawani_pos/features/pos_terminal/repositories/pos_terminal_repository.dart';

class PosTerminalFormPage extends ConsumerStatefulWidget {
  /// [terminalId] is non-null when editing an existing terminal.
  const PosTerminalFormPage({super.key, this.terminalId});

  final String? terminalId;

  bool get isEditing => terminalId != null;

  @override
  ConsumerState<PosTerminalFormPage> createState() => _PosTerminalFormPageState();
}

class _PosTerminalFormPageState extends ConsumerState<PosTerminalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _appVersionController = TextEditingController();

  String? _selectedPlatform;
  bool _isLoadingInitial = false;
  bool _isSaving = false;
  String? _nameError;
  String? _deviceIdError;
  String? _platformError;

  static const _platforms = ['windows', 'macos', 'ios', 'android'];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) _loadTerminal();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deviceIdController.dispose();
    _appVersionController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // Load existing terminal for editing
  // ──────────────────────────────────────────────────────────

  Future<void> _loadTerminal() async {
    setState(() => _isLoadingInitial = true);
    try {
      final terminal = await ref.read(posTerminalRepositoryProvider).getTerminal(widget.terminalId!);
      if (mounted) {
        _nameController.text = terminal.name;
        _deviceIdController.text = terminal.deviceId ?? '';
        _appVersionController.text = terminal.appVersion ?? '';
        setState(() {
          _selectedPlatform = terminal.platform;
          _isLoadingInitial = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingInitial = false);
        showPosErrorSnackbar(context, 'Failed to load terminal: $e');
        context.pop();
      }
    }
  }

  // ──────────────────────────────────────────────────────────
  // Submit
  // ──────────────────────────────────────────────────────────

  Future<void> _handleSubmit() async {
    setState(() {
      _nameError = null;
      _deviceIdError = null;
      _platformError = null;
    });

    // Client-side validation
    bool valid = true;
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = AppLocalizations.of(context)!.termFormNameRequired);
      valid = false;
    }
    if (_deviceIdController.text.trim().isEmpty) {
      setState(() => _deviceIdError = AppLocalizations.of(context)!.termFormDeviceIdRequired);
      valid = false;
    }
    if (_selectedPlatform == null) {
      setState(() => _platformError = AppLocalizations.of(context)!.termFormPlatformRequired);
      valid = false;
    }
    if (!valid) return;

    setState(() => _isSaving = true);

    final data = {
      'name': _nameController.text.trim(),
      'device_id': _deviceIdController.text.trim(),
      'platform': _selectedPlatform,
      if (_appVersionController.text.trim().isNotEmpty) 'app_version': _appVersionController.text.trim(),
    };

    bool ok;
    if (widget.isEditing) {
      ok = await ref.read(terminalsProvider.notifier).updateTerminal(widget.terminalId!, data);
    } else {
      ok = await ref.read(terminalsProvider.notifier).createTerminal(data);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (ok) {
        showPosSuccessSnackbar(
          context,
          widget.isEditing ? AppLocalizations.of(context)!.termFormUpdated : AppLocalizations.of(context)!.termFormCreated,
        );
        context.pop();
      } else {
        showPosErrorSnackbar(
          context,
          widget.isEditing
              ? AppLocalizations.of(context)!.termFormUpdateFailed
              : AppLocalizations.of(context)!.termFormCreateFailed,
        );
      }
    }
  }

  // ──────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.isEditing
        ? AppLocalizations.of(context)!.termFormEditTitle
        : AppLocalizations.of(context)!.termFormAddTitle;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(title, style: AppTypography.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop()),
      ),
      body: _isLoadingInitial
          ? PosLoading(message: AppLocalizations.of(context)!.termFormLoading)
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.xl),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSizes.maxWidthForm),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Section: Terminal Info ──────────────
                        PosCard(
                          padding: AppSpacing.paddingAll24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.10),
                                      borderRadius: AppRadius.borderMd,
                                    ),
                                    child: const Icon(Icons.point_of_sale_outlined, size: 20, color: AppColors.primary),
                                  ),
                                  AppSpacing.gapW12,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppLocalizations.of(context)!.termFormSectionTitle, style: AppTypography.titleLarge),
                                      Text(
                                        AppLocalizations.of(context)!.termFormSectionSubtitle,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AppSpacing.gapH24,

                              // Name
                              PosTextField(
                                controller: _nameController,
                                label: AppLocalizations.of(context)!.termFormNameLabel,
                                hint: AppLocalizations.of(context)!.termFormNameHint,
                                prefixIcon: Icons.label_outline,
                                errorText: _nameError,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) {
                                  if (_nameError != null) setState(() => _nameError = null);
                                },
                              ),
                              AppSpacing.gapH16,

                              // Device ID
                              PosTextField(
                                controller: _deviceIdController,
                                label: AppLocalizations.of(context)!.termFormDeviceIdLabel,
                                hint: AppLocalizations.of(context)!.termFormDeviceIdHint,
                                prefixIcon: Icons.fingerprint_outlined,
                                errorText: _deviceIdError,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) {
                                  if (_deviceIdError != null) setState(() => _deviceIdError = null);
                                },
                              ),
                              AppSpacing.gapH16,

                              // Platform dropdown
                              PosDropdown<String>(
                                label: AppLocalizations.of(context)!.termFormPlatformLabel,
                                hint: AppLocalizations.of(context)!.termFormPlatformHint,
                                value: _selectedPlatform,
                                errorText: _platformError,
                                items: _platforms
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p,
                                        child: Row(
                                          children: [Icon(_platformIcon(p), size: 16), AppSpacing.gapW8, Text(_platformLabel(p))],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _selectedPlatform = v;
                                    _platformError = null;
                                  });
                                },
                              ),
                              AppSpacing.gapH16,

                              // App version (optional)
                              PosTextField(
                                controller: _appVersionController,
                                label: AppLocalizations.of(context)!.termFormVersionLabel,
                                hint: AppLocalizations.of(context)!.termFormVersionHint,
                                prefixIcon: Icons.info_outline,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _handleSubmit(),
                              ),
                            ],
                          ),
                        ),

                        AppSpacing.gapH24,

                        // ── Actions ──────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PosButton(
                              label: AppLocalizations.of(context)!.posCancel,
                              variant: PosButtonVariant.outline,
                              onPressed: () => context.pop(),
                            ),
                            AppSpacing.gapW12,
                            PosButton(
                              label: widget.isEditing
                                  ? AppLocalizations.of(context)!.termFormSaveChanges
                                  : AppLocalizations.of(context)!.termFormCreate,
                              icon: widget.isEditing ? Icons.save_outlined : Icons.add_rounded,
                              isLoading: _isSaving,
                              onPressed: _handleSubmit,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  IconData _platformIcon(String platform) {
    switch (platform) {
      case 'windows':
        return Icons.laptop_windows_outlined;
      case 'macos':
        return Icons.laptop_mac_outlined;
      case 'ios':
        return Icons.phone_iphone_outlined;
      case 'android':
        return Icons.android_outlined;
      default:
        return Icons.device_unknown_outlined;
    }
  }

  String _platformLabel(String platform) {
    switch (platform) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'ios':
        return 'iOS';
      case 'android':
        return 'Android';
      default:
        return platform;
    }
  }
}
