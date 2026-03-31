import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/branches/models/store.dart';
import 'package:thawani_pos/features/branches/providers/branch_providers.dart';
import 'package:thawani_pos/features/branches/providers/branch_state.dart';
import 'package:thawani_pos/features/staff/enums/employment_type.dart';
import 'package:thawani_pos/features/staff/enums/salary_type.dart';
import 'package:thawani_pos/features/staff/enums/staff_status.dart';
import 'package:thawani_pos/features/staff/enums/user_role.dart';
import 'package:thawani_pos/features/staff/models/staff_user.dart';
import 'package:thawani_pos/features/staff/providers/staff_providers.dart';
import 'package:thawani_pos/features/staff/providers/staff_state.dart';
import 'package:thawani_pos/features/staff/repositories/staff_repository.dart';

class StaffFormPage extends ConsumerStatefulWidget {
  final String? staffId;

  const StaffFormPage({super.key, this.staffId});

  @override
  ConsumerState<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends ConsumerState<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _hourlyRateController;
  late final TextEditingController _pinController;
  late final TextEditingController _passwordController;
  late EmploymentType _employmentType;
  late SalaryType _salaryType;
  late StaffStatus _status;
  DateTime _hireDate = DateTime.now();
  bool _dataLoaded = false;
  String? _selectedStoreId;
  bool _createUserAccount = true;
  UserRole _userRole = UserRole.cashier;

  bool get _isEditing => widget.staffId != null;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nationalIdController = TextEditingController();
    _hourlyRateController = TextEditingController();
    _pinController = TextEditingController();
    _passwordController = TextEditingController();
    _employmentType = EmploymentType.fullTime;
    _salaryType = SalaryType.monthly;
    _status = StaffStatus.active;

    Future.microtask(() {
      ref.read(branchListProvider.notifier).load();
      if (_isEditing) {
        ref.read(staffDetailProvider(widget.staffId!).notifier).load();
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _hourlyRateController.dispose();
    _pinController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _populateFromStaff(StaffUser staff) {
    if (_dataLoaded) return;
    _dataLoaded = true;
    _firstNameController.text = staff.firstName;
    _lastNameController.text = staff.lastName;
    _emailController.text = staff.email ?? '';
    _phoneController.text = staff.phone ?? '';
    _nationalIdController.text = staff.nationalId ?? '';
    _hourlyRateController.text = staff.hourlyRate?.toString() ?? '';
    _employmentType = staff.employmentType;
    _salaryType = staff.salaryType;
    _status = staff.status ?? StaffStatus.active;
    _hireDate = staff.hireDate;
    _selectedStoreId = staff.storeId;
    // When editing, user account already exists if linked
    _createUserAccount = staff.userId == null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Listen for staff detail loading when editing
    if (_isEditing) {
      final detailState = ref.watch(staffDetailProvider(widget.staffId!));
      if (detailState is StaffDetailLoaded) {
        _populateFromStaff(detailState.staff);
      }
      if (detailState is StaffDetailLoading) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            title: Text(l10n.staffEditMember),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
    }

    // Listen for form state
    ref.listen<StaffFormState>(staffFormProvider, (prev, next) {
      if (next is StaffFormSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEditing ? l10n.staffUpdated : l10n.staffCreated)));
        Navigator.of(context).pop(true);
      } else if (next is StaffFormError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    final formState = ref.watch(staffFormProvider);
    final isSaving = formState is StaffFormSaving;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(_isEditing ? l10n.staffEditMember : l10n.staffAddMember),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            // Store Selection Section
            _buildSectionTitle(context, l10n.staffStoreAssignment, Icons.store_outlined, isDark),
            AppSpacing.gapH12,
            _buildStoreDropdown(context, isDark, l10n),
            AppSpacing.gapH24,

            // Personal Info Section
            _buildSectionTitle(context, l10n.staffPersonalInfo, Icons.person, isDark),
            AppSpacing.gapH12,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: '${l10n.staffFirstName} *',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
                    ),
                    validator: (v) => v == null || v.isEmpty ? l10n.staffRequired : null,
                  ),
                ),
                AppSpacing.gapW16,
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: '${l10n.staffLastName} *',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
                    ),
                    validator: (v) => v == null || v.isEmpty ? l10n.staffRequired : null,
                  ),
                ),
              ],
            ),
            AppSpacing.gapH16,

            // Contact Section
            _buildSectionTitle(context, l10n.staffContactInfo, Icons.contact_phone, isDark),
            AppSpacing.gapH12,
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: _createUserAccount && !_isEditing ? '${l10n.email} *' : l10n.email,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (_createUserAccount && !_isEditing && (v == null || v.isEmpty)) {
                  return l10n.staffRequired;
                }
                return null;
              },
            ),
            AppSpacing.gapH16,
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: l10n.staffPhone,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone_outlined),
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              ),
              keyboardType: TextInputType.phone,
            ),
            AppSpacing.gapH16,
            TextFormField(
              controller: _nationalIdController,
              decoration: InputDecoration(
                labelText: l10n.staffNationalId,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.badge_outlined),
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              ),
            ),
            AppSpacing.gapH24,

            // Employment Section
            _buildSectionTitle(context, l10n.staffEmploymentDetails, Icons.work_outline, isDark),
            AppSpacing.gapH12,
            DropdownButtonFormField<EmploymentType>(
              value: _employmentType,
              decoration: InputDecoration(
                labelText: '${l10n.staffEmploymentType} *',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              ),
              items: EmploymentType.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.value.replaceAll('_', ' ').toUpperCase())))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _employmentType = v);
              },
            ),
            AppSpacing.gapH16,
            DropdownButtonFormField<SalaryType>(
              value: _salaryType,
              decoration: InputDecoration(
                labelText: '${l10n.staffSalaryType} *',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              ),
              items: SalaryType.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.value.replaceAll('_', ' ').toUpperCase())))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _salaryType = v);
              },
            ),
            AppSpacing.gapH16,
            if (_salaryType == SalaryType.hourly) ...[
              TextFormField(
                controller: _hourlyRateController,
                decoration: InputDecoration(
                  labelText: l10n.staffHourlyRate,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                  filled: true,
                  fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              AppSpacing.gapH16,
            ],
            DropdownButtonFormField<StaffStatus>(
              value: _status,
              decoration: InputDecoration(
                labelText: '${l10n.staffStatus} *',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              ),
              items: StaffStatus.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.value.replaceAll('_', ' ').toUpperCase())))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            AppSpacing.gapH16,
            // Hire Date Picker
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              tileColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.staffHireDate),
              subtitle: Text(
                DateFormat('MMM d, yyyy').format(_hireDate),
                style: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _hireDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _hireDate = picked);
              },
            ),
            AppSpacing.gapH24,

            // Security Section
            _buildSectionTitle(context, l10n.staffSecurity, Icons.security, isDark),
            AppSpacing.gapH12,
            if (!_isEditing)
              TextFormField(
                controller: _pinController,
                decoration: InputDecoration(
                  labelText: l10n.staffSetPin,
                  helperText: l10n.staffPinHelper,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.pin),
                  filled: true,
                  fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (v) {
                  if (v != null && v.isNotEmpty && v.length < 4) {
                    return l10n.staffPinMinLength;
                  }
                  return null;
                },
              ),
            if (_isEditing)
              Card(
                elevation: 0,
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: ListTile(
                  leading: const Icon(Icons.pin, color: AppColors.primary),
                  title: Text(l10n.staffChangePin),
                  subtitle: Text(
                    l10n.staffChangePinDesc,
                    style: TextStyle(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showChangePinDialog(context, l10n),
                ),
              ),
            AppSpacing.gapH24,

            // User Account Section
            _buildSectionTitle(context, l10n.staffUserAccount, Icons.account_circle_outlined, isDark),
            AppSpacing.gapH12,
            _buildUserAccountSection(context, isDark, l10n),
            AppSpacing.gapH32,

            // Submit button
            FilledButton.icon(
              onPressed: isSaving ? null : _submit,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 48)),
              icon: isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(_isEditing ? Icons.save : Icons.person_add),
              label: Text(_isEditing ? l10n.staffSaveChanges : l10n.staffCreateMember),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        AppSpacing.gapW8,
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreDropdown(BuildContext context, bool isDark, AppLocalizations l10n) {
    final branchState = ref.watch(branchListProvider);
    final stores = branchState is BranchListLoaded ? branchState.branches : <Store>[];

    return DropdownButtonFormField<String>(
      value: _selectedStoreId,
      decoration: InputDecoration(
        labelText: '${l10n.staffSelectStore} *',
        prefixIcon: const Icon(Icons.store_outlined),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
      ),
      isExpanded: true,
      items: stores
          .map(
            (s) => DropdownMenuItem<String>(
              value: s.id,
              child: Text(s.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      validator: (v) => v == null || v.isEmpty ? l10n.staffRequired : null,
      onChanged: (v) {
        if (v != null) setState(() => _selectedStoreId = v);
      },
    );
  }

  Widget _buildUserAccountSection(BuildContext context, bool isDark, AppLocalizations l10n) {
    // If editing and user already linked, show linked info
    if (_isEditing) {
      final detailState = ref.watch(staffDetailProvider(widget.staffId!));
      if (detailState is StaffDetailLoaded && detailState.staff.userId != null) {
        return Card(
          elevation: 0,
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: BorderSide(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: AppColors.success),
            title: Text(l10n.staffUserAccountLinked),
            subtitle: Text(
              detailState.staff.linkedUser?.email ?? detailState.staff.email ?? '',
              style: TextStyle(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: Text(l10n.staffCreateUserAccount),
          subtitle: Text(
            l10n.staffCreateUserAccountDesc,
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
          value: _createUserAccount,
          onChanged: (v) => setState(() => _createUserAccount = v),
        ),
        if (_createUserAccount) ...[
          AppSpacing.gapH12,
          DropdownButtonFormField<UserRole>(
            value: _userRole,
            decoration: InputDecoration(
              labelText: '${l10n.staffUserRole} *',
              prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
            ),
            items: UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _userRole = v);
            },
            validator: (v) => _createUserAccount && v == null ? l10n.staffRequired : null,
          ),
          AppSpacing.gapH16,
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: '${l10n.staffPassword} *',
              helperText: l10n.staffPasswordHelper,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              filled: true,
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
            ),
            obscureText: true,
            validator: (v) {
              if (!_createUserAccount) return null;
              if (v == null || v.isEmpty) return l10n.staffRequired;
              if (v.length < 8) return l10n.staffPasswordMinLength;
              return null;
            },
          ),
        ],
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'store_id': _selectedStoreId,
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      if (_emailController.text.isNotEmpty) 'email': _emailController.text.trim(),
      if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text.trim(),
      if (_nationalIdController.text.isNotEmpty) 'national_id': _nationalIdController.text.trim(),
      'employment_type': _employmentType.value,
      'salary_type': _salaryType.value,
      'status': _status.value,
      'hire_date': DateFormat('yyyy-MM-dd').format(_hireDate),
      if (_hourlyRateController.text.isNotEmpty) 'hourly_rate': double.tryParse(_hourlyRateController.text),
      if (_pinController.text.isNotEmpty) 'pin': _pinController.text,
      // User account creation fields
      if (!_isEditing && _createUserAccount) ...{
        'create_user_account': true,
        'password': _passwordController.text,
        'user_role': _userRole.value,
      },
    };

    if (_isEditing) {
      await ref.read(staffFormProvider.notifier).update(widget.staffId!, data);
    } else {
      await ref.read(staffFormProvider.notifier).create(data);
    }
  }

  void _showChangePinDialog(BuildContext context, AppLocalizations l10n) {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.staffChangePin),
        content: TextField(
          controller: pinController,
          decoration: InputDecoration(labelText: l10n.staffNewPin, border: const OutlineInputBorder()),
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              if (pinController.text.length >= 4) {
                Navigator.pop(ctx);
                try {
                  await ref.read(staffRepositoryProvider).setPin(widget.staffId!, pinController.text);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.staffPinUpdated)));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    // Dispose in tear-down
    pinController.addListener(() {});
  }
}
