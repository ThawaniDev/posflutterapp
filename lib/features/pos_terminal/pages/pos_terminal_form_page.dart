import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      setState(() => _nameError = 'Name is required');
      valid = false;
    }
    if (_deviceIdController.text.trim().isEmpty) {
      setState(() => _deviceIdError = 'Device ID is required');
      valid = false;
    }
    if (_selectedPlatform == null) {
      setState(() => _platformError = 'Platform is required');
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
        showPosSuccessSnackbar(context, widget.isEditing ? 'Terminal updated successfully.' : 'Terminal created successfully.');
        context.pop();
      } else {
        showPosErrorSnackbar(context, widget.isEditing ? 'Failed to update terminal.' : 'Failed to create terminal.');
      }
    }
  }

  // ──────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.isEditing ? 'Edit Terminal' : 'Add Terminal';

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(title, style: AppTypography.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop()),
      ),
      body: _isLoadingInitial
          ? const PosLoading(message: 'Loading terminal...')
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
                                      Text('Terminal Information', style: AppTypography.titleLarge),
                                      Text(
                                        'Basic register details',
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
                                label: 'Terminal Name',
                                hint: 'e.g. Cashier 1, Front Desk',
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
                                label: 'Device ID',
                                hint: 'Unique identifier for this device',
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
                                label: 'Platform',
                                hint: 'Select platform',
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
                                label: 'App Version (optional)',
                                hint: 'e.g. 1.0.0',
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
                            PosButton(label: 'Cancel', variant: PosButtonVariant.outline, onPressed: () => context.pop()),
                            AppSpacing.gapW12,
                            PosButton(
                              label: widget.isEditing ? 'Save Changes' : 'Create Terminal',
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
