import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/security/models/security_policy.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Fully editable security policy form.
/// When [onSave] is null the form is display-only (no edit button shown).
class SecurityPolicyEditor extends ConsumerStatefulWidget {
  const SecurityPolicyEditor({super.key, required this.policy, this.onSave, this.isSaving = false});
  final SecurityPolicy policy;
  final ValueChanged<Map<String, dynamic>>? onSave;
  final bool isSaving;

  @override
  ConsumerState<SecurityPolicyEditor> createState() => _SecurityPolicyEditorState();
}

class _SecurityPolicyEditorState extends ConsumerState<SecurityPolicyEditor> {
  final _formKey = GlobalKey<FormState>();
  bool _editing = false;

  // ─── Integer field controllers ─────────────────
  late TextEditingController _pinMinLength;
  late TextEditingController _pinMaxLength;
  late TextEditingController _pinExpiryDays;
  late TextEditingController _autoLockSeconds;
  late TextEditingController _maxFailedAttempts;
  late TextEditingController _lockoutDurationMinutes;
  late TextEditingController _sessionMaxHours;
  late TextEditingController _discountThreshold;
  late TextEditingController _maxDevices;
  late TextEditingController _auditRetentionDays;
  late TextEditingController _passwordExpiryDays;

  // ─── Bool state ───────────────────────────────────
  late bool _require2faOwner;
  late bool _requirePinOverrideVoid;
  late bool _requirePinOverrideReturn;
  late bool _requirePinOverrideDiscount;
  late bool _biometricEnabled;
  late bool _requireUniquePins;
  late bool _forceLogoutOnRoleChange;
  late bool _requireStrongPassword;
  late bool _ipRestrictionEnabled;

  // ─── IP ranges (editable list) ─────────────────
  late List<String> _allowedIpRanges;
  final TextEditingController _ipInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFromPolicy(widget.policy);
  }

  @override
  void didUpdateWidget(SecurityPolicyEditor old) {
    super.didUpdateWidget(old);
    if (!_editing) {
      _disposeControllers();
      _populateFromPolicy(widget.policy);
    }
  }

  void _populateFromPolicy(SecurityPolicy p) {
    _pinMinLength = TextEditingController(text: '${p.pinMinLength ?? 4}');
    _pinMaxLength = TextEditingController(text: '${p.pinMaxLength ?? 6}');
    _pinExpiryDays = TextEditingController(text: '${p.pinExpiryDays ?? 0}');
    _autoLockSeconds = TextEditingController(text: '${p.autoLockSeconds ?? 300}');
    _maxFailedAttempts = TextEditingController(text: '${p.maxFailedAttempts ?? 5}');
    _lockoutDurationMinutes = TextEditingController(text: '${p.lockoutDurationMinutes ?? 15}');
    _sessionMaxHours = TextEditingController(text: '${p.sessionMaxHours ?? 12}');
    _discountThreshold = TextEditingController(text: '${p.discountOverrideThreshold ?? 20.0}');
    _maxDevices = TextEditingController(text: '${p.maxDevices ?? 5}');
    _auditRetentionDays = TextEditingController(text: '${p.auditRetentionDays ?? 90}');
    _passwordExpiryDays = TextEditingController(text: '${p.passwordExpiryDays ?? 0}');
    _require2faOwner = p.require2faOwner ?? false;
    _requirePinOverrideVoid = p.requirePinOverrideVoid ?? true;
    _requirePinOverrideReturn = p.requirePinOverrideReturn ?? true;
    _requirePinOverrideDiscount = p.requirePinOverrideDiscount ?? false;
    _biometricEnabled = p.biometricEnabled ?? false;
    _requireUniquePins = p.requireUniquePins ?? false;
    _forceLogoutOnRoleChange = p.forceLogoutOnRoleChange ?? true;
    _requireStrongPassword = p.requireStrongPassword ?? false;
    _ipRestrictionEnabled = p.ipRestrictionEnabled ?? false;
    _allowedIpRanges = List<String>.from(p.allowedIpRanges ?? []);
  }

  void _disposeControllers() {
    _pinMinLength.dispose();
    _pinMaxLength.dispose();
    _pinExpiryDays.dispose();
    _autoLockSeconds.dispose();
    _maxFailedAttempts.dispose();
    _lockoutDurationMinutes.dispose();
    _sessionMaxHours.dispose();
    _discountThreshold.dispose();
    _maxDevices.dispose();
    _auditRetentionDays.dispose();
    _passwordExpiryDays.dispose();
    _ipInput.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _startEditing() => setState(() => _editing = true);

  void _cancelEditing() {
    setState(() {
      _editing = false;
      _disposeControllers();
      _populateFromPolicy(widget.policy);
    });
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final data = <String, dynamic>{
      'pin_min_length': int.tryParse(_pinMinLength.text),
      'pin_max_length': int.tryParse(_pinMaxLength.text),
      'pin_expiry_days': int.tryParse(_pinExpiryDays.text),
      'auto_lock_seconds': int.tryParse(_autoLockSeconds.text),
      'max_failed_attempts': int.tryParse(_maxFailedAttempts.text),
      'lockout_duration_minutes': int.tryParse(_lockoutDurationMinutes.text),
      'session_max_hours': int.tryParse(_sessionMaxHours.text),
      'discount_override_threshold': double.tryParse(_discountThreshold.text),
      'max_devices': int.tryParse(_maxDevices.text),
      'audit_retention_days': int.tryParse(_auditRetentionDays.text),
      'password_expiry_days': int.tryParse(_passwordExpiryDays.text),
      'require_2fa_owner': _require2faOwner,
      'require_pin_override_void': _requirePinOverrideVoid,
      'require_pin_override_return': _requirePinOverrideReturn,
      'require_pin_override_discount': _requirePinOverrideDiscount,
      'biometric_enabled': _biometricEnabled,
      'require_unique_pins': _requireUniquePins,
      'force_logout_on_role_change': _forceLogoutOnRoleChange,
      'require_strong_password': _requireStrongPassword,
      'ip_restriction_enabled': _ipRestrictionEnabled,
      'allowed_ip_ranges': _allowedIpRanges,
    };
    widget.onSave?.call(data);
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canEdit = widget.onSave != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header row ─────────────────────────────
          if (canEdit)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _editing
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PosButton(
                          label: l10n.securityCancelEdit,
                          variant: PosButtonVariant.outline,
                          onPressed: widget.isSaving ? null : _cancelEditing,
                          icon: Icons.close_rounded,
                        ),
                        AppSpacing.gapW8,
                        PosButton(
                          label: l10n.securitySavePolicy,
                          onPressed: widget.isSaving ? null : _save,
                          isLoading: widget.isSaving,
                          icon: Icons.save_rounded,
                        ),
                      ],
                    )
                  : PosButton(
                      label: l10n.securityEditPolicy,
                      variant: PosButtonVariant.outline,
                      onPressed: _startEditing,
                      icon: Icons.edit_rounded,
                    ),
            ),

          AppSpacing.gapH16,

          // ─── PIN & Authentication ─────────────────────
          _buildSectionHeader(context, l10n.securityPinAuth, Icons.pin),
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                children: [
                  if (_editing) ...[
                    Row(
                      children: [
                        Expanded(
                          child: PosTextField(
                            controller: _pinMinLength,
                            label: l10n.securityPinMinLength,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: Icons.pin,
                            validator: _requiredIntValidator,
                          ),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: PosTextField(
                            controller: _pinMaxLength,
                            label: l10n.securityPinMaxLength,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: Icons.pin,
                            validator: _requiredIntValidator,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapH8,
                    PosTextField(
                      controller: _pinExpiryDays,
                      label: l10n.securityPinExpiryDays,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: Icons.schedule,
                      helperText: l10n.securityZeroMeansNeverExpires,
                      validator: _requiredIntValidator,
                    ),
                  ] else ...[
                    _buildRow(
                      context,
                      l10n.securityPinLength,
                      '${widget.policy.pinMinLength ?? 4} – ${widget.policy.pinMaxLength ?? 6} ${l10n.securityDigits}',
                      Icons.pin,
                    ),
                    _buildRow(
                      context,
                      l10n.securityPinExpiryDays,
                      '${widget.policy.pinExpiryDays ?? 0} ${l10n.securityDays}',
                      Icons.schedule,
                    ),
                  ],
                  AppSpacing.gapH4,
                  _buildSwitch(
                    context,
                    l10n.securityRequireUniquePins,
                    _requireUniquePins,
                    (v) => setState(() => _requireUniquePins = v),
                  ),
                  _buildSwitch(
                    context,
                    l10n.securityBiometricEnabled,
                    _biometricEnabled,
                    (v) => setState(() => _biometricEnabled = v),
                  ),
                  _buildSwitch(context, l10n.securityRequire2fa, _require2faOwner, (v) => setState(() => _require2faOwner = v)),
                ],
              ),
            ),
          ),

          AppSpacing.gapH16,

          // ─── Lockout & Sessions ───────────────────────
          _buildSectionHeader(context, l10n.securityLockoutSessions, Icons.lock_clock),
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                children: [
                  if (_editing) ...[
                    PosTextField(
                      controller: _autoLockSeconds,
                      label: l10n.securityAutoLock,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: Icons.lock_clock,
                      helperText: l10n.securityInSeconds,
                      validator: _requiredIntValidator,
                    ),
                    AppSpacing.gapH8,
                    Row(
                      children: [
                        Expanded(
                          child: PosTextField(
                            controller: _maxFailedAttempts,
                            label: l10n.securityMaxFailedAttempts,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: Icons.error_outline,
                            validator: _requiredIntValidator,
                          ),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: PosTextField(
                            controller: _lockoutDurationMinutes,
                            label: l10n.securityLockoutDuration,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: Icons.timer_off,
                            helperText: l10n.securityInMinutes,
                            validator: _requiredIntValidator,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapH8,
                    PosTextField(
                      controller: _sessionMaxHours,
                      label: l10n.securitySessionMaxHours,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: Icons.schedule,
                      helperText: l10n.securityInHours,
                      validator: _requiredIntValidator,
                    ),
                  ] else ...[
                    _buildRow(context, l10n.securityAutoLock, '${widget.policy.autoLockSeconds ?? 300}s', Icons.lock_clock),
                    _buildRow(
                      context,
                      l10n.securityMaxFailedAttempts,
                      '${widget.policy.maxFailedAttempts ?? 5}',
                      Icons.error_outline,
                    ),
                    _buildRow(
                      context,
                      l10n.securityLockoutDuration,
                      '${widget.policy.lockoutDurationMinutes ?? 15} ${l10n.securityMinutes}',
                      Icons.timer_off,
                    ),
                    _buildRow(context, l10n.securitySessionMaxHours, '${widget.policy.sessionMaxHours ?? 12}h', Icons.schedule),
                  ],
                  AppSpacing.gapH4,
                  _buildSwitch(
                    context,
                    l10n.securityForceLogoutOnRoleChange,
                    _forceLogoutOnRoleChange,
                    (v) => setState(() => _forceLogoutOnRoleChange = v),
                  ),
                ],
              ),
            ),
          ),

          AppSpacing.gapH16,

          // ─── PIN Override ─────────────────────────────
          _buildSectionHeader(context, l10n.securityPinOverrides, Icons.admin_panel_settings),
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                children: [
                  _buildSwitch(
                    context,
                    l10n.securityPinOverrideVoid,
                    _requirePinOverrideVoid,
                    (v) => setState(() => _requirePinOverrideVoid = v),
                  ),
                  _buildSwitch(
                    context,
                    l10n.securityPinOverrideReturn,
                    _requirePinOverrideReturn,
                    (v) => setState(() => _requirePinOverrideReturn = v),
                  ),
                  _buildSwitch(
                    context,
                    l10n.securityPinOverrideDiscount,
                    _requirePinOverrideDiscount,
                    (v) => setState(() => _requirePinOverrideDiscount = v),
                  ),
                  if (_editing)
                    PosTextField(
                      controller: _discountThreshold,
                      label: l10n.securityDiscountThreshold,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.percent,
                      validator: _requiredDoubleValidator,
                    )
                  else
                    _buildRow(
                      context,
                      l10n.securityDiscountThreshold,
                      '${widget.policy.discountOverrideThreshold ?? 20.0}%',
                      Icons.percent,
                    ),
                ],
              ),
            ),
          ),

          AppSpacing.gapH16,

          // ─── Password & Device ───────────────────────
          _buildSectionHeader(context, l10n.securityPasswordDevice, Icons.devices),
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                children: [
                  if (_editing) ...[
                    PosTextField(
                      controller: _passwordExpiryDays,
                      label: l10n.securityPasswordExpiryDays,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: Icons.key,
                      helperText: l10n.securityZeroMeansNeverExpires,
                      validator: _requiredIntValidator,
                    ),
                    AppSpacing.gapH8,
                    Row(
                      children: [
                        Expanded(
                          child: PosTextField(
                            controller: _maxDevices,
                            label: l10n.securityMaxDevices,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: Icons.devices,
                            validator: _requiredIntValidator,
                          ),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: PosTextField(
                            controller: _auditRetentionDays,
                            label: l10n.securityAuditRetentionDays,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: Icons.history,
                            helperText: l10n.securityInDays,
                            validator: _requiredIntValidator,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    _buildRow(
                      context,
                      l10n.securityPasswordExpiryDays,
                      '${widget.policy.passwordExpiryDays ?? 0} ${l10n.securityDays}',
                      Icons.key,
                    ),
                    _buildRow(context, l10n.securityMaxDevices, '${widget.policy.maxDevices ?? 5}', Icons.devices),
                    _buildRow(
                      context,
                      l10n.securityAuditRetentionDays,
                      '${widget.policy.auditRetentionDays ?? 90} ${l10n.securityDays}',
                      Icons.history,
                    ),
                  ],
                  AppSpacing.gapH4,
                  _buildSwitch(
                    context,
                    l10n.securityRequireStrongPassword,
                    _requireStrongPassword,
                    (v) => setState(() => _requireStrongPassword = v),
                  ),
                ],
              ),
            ),
          ),

          AppSpacing.gapH16,

          // ─── IP Restrictions ─────────────────────────
          _buildSectionHeader(context, l10n.securityIpRestrictions, Icons.language),
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSwitch(
                    context,
                    l10n.securityIpRestrictionEnabled,
                    _ipRestrictionEnabled,
                    (v) => setState(() => _ipRestrictionEnabled = v),
                  ),
                  if (_ipRestrictionEnabled) ...[
                    AppSpacing.gapH12,
                    Text(
                      l10n.securityAllowedIpRanges,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                    ),
                    AppSpacing.gapH8,
                    if (_allowedIpRanges.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _allowedIpRanges
                            .map(
                              (ip) => Chip(
                                label: Text(ip, style: const TextStyle(fontSize: 12)),
                                visualDensity: VisualDensity.compact,
                                onDeleted: _editing ? () => setState(() => _allowedIpRanges.remove(ip)) : null,
                                deleteIcon: _editing ? const Icon(Icons.close, size: 14) : null,
                              ),
                            )
                            .toList(),
                      ),
                    if (_editing) ...[
                      AppSpacing.gapH8,
                      Row(
                        children: [
                          Expanded(
                            child: PosTextField(
                              controller: _ipInput,
                              label: l10n.securityAddIpRange,
                              hint: '192.168.1.0/24',
                              keyboardType: TextInputType.text,
                              prefixIcon: Icons.add_circle_outline,
                              onSubmitted: _addIpRange,
                            ),
                          ),
                          AppSpacing.gapW8,
                          PosButton(
                            label: l10n.securityAddButton,
                            variant: PosButtonVariant.outline,
                            size: PosButtonSize.sm,
                            onPressed: () => _addIpRange(_ipInput.text),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          if (canEdit && _editing) ...[
            AppSpacing.gapH24,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PosButton(
                  label: l10n.securityCancelEdit,
                  variant: PosButtonVariant.outline,
                  onPressed: widget.isSaving ? null : _cancelEditing,
                  icon: Icons.close_rounded,
                ),
                AppSpacing.gapW12,
                PosButton(
                  label: l10n.securitySavePolicy,
                  onPressed: widget.isSaving ? null : _save,
                  isLoading: widget.isSaving,
                  icon: Icons.save_rounded,
                  size: PosButtonSize.lg,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _addIpRange(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || _allowedIpRanges.contains(trimmed)) return;
    setState(() {
      _allowedIpRanges.add(trimmed);
      _ipInput.clear();
    });
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

  Widget _buildSwitch(BuildContext context, String label, bool value, ValueChanged<bool>? onChanged) {
    return Padding(
      padding: AppSpacing.paddingV4,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Switch.adaptive(value: value, onChanged: _editing ? onChanged : null, activeThumbColor: AppColors.primary),
        ],
      ),
    );
  }

  String? _requiredIntValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (int.tryParse(value.trim()) == null) return 'Must be a whole number';
    return null;
  }

  String? _requiredDoubleValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (double.tryParse(value.trim()) == null) return 'Must be a number';
    return null;
  }
}
