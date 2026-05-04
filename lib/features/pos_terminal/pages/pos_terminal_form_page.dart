import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_terminal/models/register.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

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

  // ── Basic info controllers ────────────────────────────────
  final _nameController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _appVersionController = TextEditingController();
  String? _selectedPlatform;

  // ── Device hardware controllers ───────────────────────────
  final _deviceModelController = TextEditingController();
  final _osVersionController = TextEditingController();
  final _serialNumberController = TextEditingController();
  bool _nfcCapable = false;

  // ── SoftPOS controllers ───────────────────────────────────
  bool _softposEnabled = false;
  final _nearpayTidController = TextEditingController();
  final _nearpayMidController = TextEditingController();
  final _edfapayTokenController = TextEditingController();

  // ── Acquirer controllers ──────────────────────────────────
  String? _selectedAcquirerSource;
  final _acquirerNameController = TextEditingController();
  final _acquirerRefController = TextEditingController();

  // ── Settlement controllers ────────────────────────────────
  String? _selectedSettlementCycle;
  final _settlementBankController = TextEditingController();
  final _settlementIbanController = TextEditingController();

  // ── Notes controllers ─────────────────────────────────────
  final _adminNotesController = TextEditingController();

  bool _isLoadingInitial = false;
  bool _isSaving = false;
  String? _nameError;
  String? _deviceIdError;

  // Loaded terminal reference (for read-only billing display)
  Register? _loadedTerminal;

  static const _platforms = ['windows', 'macos', 'ios', 'android'];
  static const _acquirerSources = ['hala', 'bank_rajhi', 'bank_snb', 'geidea', 'other'];
  static const _settlementCycles = ['T+0', 'T+1', 'T+2', 'T+3', 'weekly'];

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
    _deviceModelController.dispose();
    _osVersionController.dispose();
    _serialNumberController.dispose();
    _edfapayTokenController.dispose();
    _nearpayTidController.dispose();
    _nearpayMidController.dispose();
    _acquirerNameController.dispose();
    _acquirerRefController.dispose();
    _settlementBankController.dispose();
    _settlementIbanController.dispose();
    _adminNotesController.dispose();
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
        _deviceModelController.text = terminal.deviceModel ?? '';
        _osVersionController.text = terminal.osVersion ?? '';
        _serialNumberController.text = terminal.serialNumber ?? '';
        _nearpayTidController.text = terminal.nearpayTid ?? '';
        _nearpayMidController.text = terminal.nearpayMid ?? '';
        _edfapayTokenController.text = terminal.edfapayToken ?? '';
        _acquirerNameController.text = terminal.acquirerName ?? '';
        _acquirerRefController.text = terminal.acquirerReference ?? '';
        _settlementBankController.text = terminal.settlementBankName ?? '';
        _settlementIbanController.text = terminal.settlementIban ?? '';
        _adminNotesController.text = terminal.adminNotes ?? '';
        setState(() {
          _selectedPlatform = terminal.platform;
          _nfcCapable = terminal.nfcCapable;
          _softposEnabled = terminal.softposEnabled;
          _selectedAcquirerSource = terminal.acquirerSource;
          _selectedSettlementCycle = terminal.settlementCycle;
          _isLoadingInitial = false;
          _loadedTerminal = terminal;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingInitial = false);
        showPosErrorSnackbar(context, AppLocalizations.of(context)!.genericError(e.toString()));
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
      valid = false;
    }
    if (!valid) return;

    setState(() => _isSaving = true);

    final data = {
      'name': _nameController.text.trim(),
      'device_id': _deviceIdController.text.trim(),
      'platform': _selectedPlatform,
      if (_appVersionController.text.trim().isNotEmpty) 'app_version': _appVersionController.text.trim(),
      // Device hardware
      if (_deviceModelController.text.trim().isNotEmpty) 'device_model': _deviceModelController.text.trim(),
      if (_osVersionController.text.trim().isNotEmpty) 'os_version': _osVersionController.text.trim(),
      'nfc_capable': _nfcCapable,
      if (_serialNumberController.text.trim().isNotEmpty) 'serial_number': _serialNumberController.text.trim(),
      // SoftPOS
      'softpos_enabled': _softposEnabled,
      if (_nearpayTidController.text.trim().isNotEmpty) 'nearpay_tid': _nearpayTidController.text.trim(),
      if (_nearpayMidController.text.trim().isNotEmpty) 'nearpay_mid': _nearpayMidController.text.trim(),
      if (_edfapayTokenController.text.trim().isNotEmpty) 'edfapay_token': _edfapayTokenController.text.trim(),
      // Acquirer
      if (_selectedAcquirerSource != null) 'acquirer_source': _selectedAcquirerSource,
      if (_acquirerNameController.text.trim().isNotEmpty) 'acquirer_name': _acquirerNameController.text.trim(),
      if (_acquirerRefController.text.trim().isNotEmpty) 'acquirer_reference': _acquirerRefController.text.trim(),
      // Settlement
      if (_selectedSettlementCycle != null) 'settlement_cycle': _selectedSettlementCycle,
      if (_settlementBankController.text.trim().isNotEmpty) 'settlement_bank_name': _settlementBankController.text.trim(),
      if (_settlementIbanController.text.trim().isNotEmpty) 'settlement_iban': _settlementIbanController.text.trim(),
      // Notes
      if (_adminNotesController.text.trim().isNotEmpty) 'admin_notes': _adminNotesController.text.trim(),
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
    final isMobile = context.isPhone;
    final title = widget.isEditing
        ? AppLocalizations.of(context)!.termFormEditTitle
        : AppLocalizations.of(context)!.termFormAddTitle;

    return PosFormPage(
      title: title,
      isLoading: _isLoadingInitial,
      onBack: () => context.pop(),
      maxWidth: AppSizes.maxWidthForm,
      bottomBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PosButton(
            label: AppLocalizations.of(context)!.posCancel,
            variant: PosButtonVariant.ghost,
            onPressed: _isSaving ? null : () => context.pop(),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section 1: Terminal Info ────────────
            _buildSectionCard(
              icon: Icons.point_of_sale_outlined,
              title: AppLocalizations.of(context)!.termFormSectionTitle,
              subtitle: AppLocalizations.of(context)!.termFormSectionSubtitle,
              children: [
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
                PosSearchableDropdown<String>(
                  hint: AppLocalizations.of(context)!.selectPlatform,
                  label: AppLocalizations.of(context)!.termFormPlatformLabel,
                  items: _platforms.map((p) => PosDropdownItem(value: p, label: _platformLabel(p))).toList(),
                  selectedValue: _selectedPlatform,
                  onChanged: (v) {
                    setState(() {
                      _selectedPlatform = v;
                    });
                  },
                  showSearch: false,
                ),
                AppSpacing.gapH16,
                PosTextField(
                  controller: _appVersionController,
                  label: AppLocalizations.of(context)!.termFormVersionLabel,
                  hint: AppLocalizations.of(context)!.termFormVersionHint,
                  prefixIcon: Icons.info_outline,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),

            AppSpacing.gapH24,

            // ── Section 2: Device Hardware ─────────
            _buildSectionCard(
              icon: Icons.devices_outlined,
              title: AppLocalizations.of(context)!.termFormDeviceSection,
              subtitle: AppLocalizations.of(context)!.termFormDeviceSectionSub,
              children: [
                _buildFieldPair(
                  isMobile: isMobile,
                  first: PosTextField(
                    controller: _deviceModelController,
                    label: AppLocalizations.of(context)!.termFormDeviceModelLabel,
                    hint: AppLocalizations.of(context)!.termFormDeviceModelHint,
                    prefixIcon: Icons.phone_android_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  second: PosTextField(
                    controller: _osVersionController,
                    label: AppLocalizations.of(context)!.termFormOsVersionLabel,
                    hint: AppLocalizations.of(context)!.termFormOsVersionHint,
                    prefixIcon: Icons.system_update_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                AppSpacing.gapH16,
                PosTextField(
                  controller: _serialNumberController,
                  label: AppLocalizations.of(context)!.termFormSerialNumberLabel,
                  hint: AppLocalizations.of(context)!.termFormSerialNumberHint,
                  prefixIcon: Icons.qr_code_outlined,
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.gapH16,
                PosToggle(
                  value: _nfcCapable,
                  onChanged: (v) => setState(() => _nfcCapable = v),
                  label: AppLocalizations.of(context)!.termFormNfcCapable,
                  subtitle: AppLocalizations.of(context)!.termFormNfcCapableSub,
                ),
              ],
            ),

            AppSpacing.gapH24,

            // ── Section 3: SoftPOS Configuration ───
            _buildSectionCard(
              icon: Icons.contactless_outlined,
              title: AppLocalizations.of(context)!.termFormSoftposSection,
              subtitle: AppLocalizations.of(context)!.termFormSoftposSectionSub,
              children: [
                PosToggle(
                  value: _softposEnabled,
                  onChanged: (v) => setState(() => _softposEnabled = v),
                  label: AppLocalizations.of(context)!.termFormSoftposEnabled,
                  subtitle: AppLocalizations.of(context)!.termFormSoftposEnabledSub,
                ),
                if (_softposEnabled) ...[
                  AppSpacing.gapH16,
                  _buildFieldPair(
                    isMobile: isMobile,
                    first: PosTextField(
                      controller: _nearpayTidController,
                      label: AppLocalizations.of(context)!.termFormNearpayTidLabel,
                      hint: AppLocalizations.of(context)!.termFormNearpayTidHint,
                      prefixIcon: Icons.confirmation_number_outlined,
                      textInputAction: TextInputAction.next,
                    ),
                    second: PosTextField(
                      controller: _nearpayMidController,
                      label: AppLocalizations.of(context)!.termFormNearpayMidLabel,
                      hint: AppLocalizations.of(context)!.termFormNearpayMidHint,
                      prefixIcon: Icons.store_outlined,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  AppSpacing.gapH16,
                  PosTextField(
                    controller: _edfapayTokenController,
                    label: AppLocalizations.of(context)!.termFormEdfapayTokenLabel,
                    hint: AppLocalizations.of(context)!.termFormEdfapayTokenHint,
                    prefixIcon: Icons.key_outlined,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                  ),
                ],
              ],
            ),

            AppSpacing.gapH24,

            // ── Section 4: Acquirer Details ────────
            _buildSectionCard(
              icon: Icons.account_balance_outlined,
              title: AppLocalizations.of(context)!.termFormAcquirerSection,
              subtitle: AppLocalizations.of(context)!.termFormAcquirerSectionSub,
              children: [
                PosSearchableDropdown<String>(
                  hint: AppLocalizations.of(context)!.selectMethod,
                  label: AppLocalizations.of(context)!.termFormAcquirerSourceLabel,
                  items: _acquirerSources.map((s) => PosDropdownItem(value: s, label: _acquirerSourceLabel(s))).toList(),
                  selectedValue: _selectedAcquirerSource,
                  onChanged: (v) => setState(() => _selectedAcquirerSource = v),
                  showSearch: false,
                ),
                if (_selectedAcquirerSource == 'other') ...[
                  AppSpacing.gapH16,
                  PosTextField(
                    controller: _acquirerNameController,
                    label: AppLocalizations.of(context)!.termFormAcquirerNameLabel,
                    hint: AppLocalizations.of(context)!.termFormAcquirerNameHint,
                    prefixIcon: Icons.business_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                ],
                AppSpacing.gapH16,
                PosTextField(
                  controller: _acquirerRefController,
                  label: AppLocalizations.of(context)!.termFormAcquirerRefLabel,
                  hint: AppLocalizations.of(context)!.termFormAcquirerRefHint,
                  prefixIcon: Icons.tag_outlined,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),

            AppSpacing.gapH24,

            // ── Section 5: Settlement ──────────────
            _buildSectionCard(
              icon: Icons.account_balance_wallet_outlined,
              title: AppLocalizations.of(context)!.termFormSettlementSection,
              subtitle: AppLocalizations.of(context)!.termFormSettlementSectionSub,
              children: [
                PosSearchableDropdown<String>(
                  hint: AppLocalizations.of(context)!.selectCycle,
                  label: AppLocalizations.of(context)!.termFormSettlementCycleLabel,
                  items: _settlementCycles.map((c) => PosDropdownItem(value: c, label: c)).toList(),
                  selectedValue: _selectedSettlementCycle,
                  onChanged: (v) => setState(() => _selectedSettlementCycle = v),
                  showSearch: false,
                ),
                AppSpacing.gapH16,
                _buildFieldPair(
                  isMobile: isMobile,
                  first: PosTextField(
                    controller: _settlementBankController,
                    label: AppLocalizations.of(context)!.termFormSettlementBankLabel,
                    hint: AppLocalizations.of(context)!.termFormSettlementBankHint,
                    prefixIcon: Icons.account_balance_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  second: PosTextField(
                    controller: _settlementIbanController,
                    label: AppLocalizations.of(context)!.termFormSettlementIbanLabel,
                    hint: AppLocalizations.of(context)!.termFormSettlementIbanHint,
                    prefixIcon: Icons.credit_card_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),

            AppSpacing.gapH24,

            // ── Section 6: Fee Schedule (read-only, softpos only) ──
            if (_softposEnabled && widget.isEditing) _buildBillingSection(context),

            if (_softposEnabled && widget.isEditing) AppSpacing.gapH24,

            // ── Section 7: Notes ───────────────────
            _buildSectionCard(
              icon: Icons.notes_outlined,
              title: AppLocalizations.of(context)!.termFormNotesSection,
              subtitle: AppLocalizations.of(context)!.termFormNotesSectionSub,
              children: [
                PosTextField(
                  controller: _adminNotesController,
                  label: AppLocalizations.of(context)!.termFormAdminNotesLabel,
                  hint: AppLocalizations.of(context)!.termFormAdminNotesHint,
                  prefixIcon: Icons.note_outlined,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
              ],
            ),

            AppSpacing.gapH24,
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // Billing section (read-only, shown when softposEnabled and editing)
  // ──────────────────────────────────────────────────────────

  Widget _buildBillingSection(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final terminal = _loadedTerminal;
    final madaRate = terminal?.softposMadaMerchantRate ?? 0.006;
    final cardFee = terminal?.softposCardMerchantFee ?? 1.000;
    final madaPct = terminal?.softposMadaRatePct ?? (madaRate * 100);

    return _buildSectionCard(
      icon: Icons.receipt_long_outlined,
      title: l.termFormBillingSection,
      subtitle: l.termFormBillingSectionSub,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildBillingTile(
                label: l.termFormBillingMadaRate,
                value: l.termFormBillingMadaRateValue(madaPct.toStringAsFixed(3)),
                icon: Icons.credit_card_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBillingTile(
                label: l.termFormBillingCardFee,
                value: l.termFormBillingCardFeeValue(cardFee.toStringAsFixed(3)),
                icon: Icons.payment_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(l.termFormBillingReadOnly, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildBillingTile({required String label, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
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

  String _acquirerSourceLabel(String source) {
    switch (source) {
      case 'hala':
        return 'HALA';
      case 'bank_rajhi':
        return 'Al Rajhi Bank';
      case 'bank_snb':
        return 'SNB';
      case 'geidea':
        return 'Geidea';
      case 'other':
        return 'Other';
      default:
        return source;
    }
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final isMobile = context.isPhone;
    return PosCard(
      padding: isMobile ? AppSpacing.paddingAll16 : AppSpacing.paddingAll24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isMobile ? 36 : 40,
                height: isMobile ? 36 : 40,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), borderRadius: AppRadius.borderMd),
                child: Icon(icon, size: isMobile ? 18 : 20, color: AppColors.primary),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: isMobile ? AppTypography.titleMedium : AppTypography.titleLarge),
                    Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context))),
                  ],
                ),
              ),
            ],
          ),
          isMobile ? AppSpacing.gapH16 : AppSpacing.gapH24,
          ...children,
        ],
      ),
    );
  }

  /// Renders two fields side-by-side on desktop, stacked on mobile.
  Widget _buildFieldPair({required bool isMobile, required Widget first, required Widget second}) {
    if (isMobile) {
      return Column(children: [first, AppSpacing.gapH16, second]);
    }
    return Row(
      children: [
        Expanded(child: first),
        AppSpacing.gapW16,
        Expanded(child: second),
      ],
    );
  }
}
