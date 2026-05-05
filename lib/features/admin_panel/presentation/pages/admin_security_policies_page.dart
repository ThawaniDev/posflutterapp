import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminSecurityPoliciesPage extends ConsumerStatefulWidget {
  const AdminSecurityPoliciesPage({super.key});

  @override
  ConsumerState<AdminSecurityPoliciesPage> createState() => _AdminSecurityPoliciesPageState();
}

class _AdminSecurityPoliciesPageState extends ConsumerState<AdminSecurityPoliciesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(securityPolicyListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityPolicyListProvider);

    return PosListPage(
      title: 'Security Policies',
      child: switch (state) {
        SecurityPolicyListLoading() => const PosLoading(),
        SecurityPolicyListError(message: final msg) => PosErrorState(
            message: msg,
            onRetry: () => ref.read(securityPolicyListProvider.notifier).load(),
          ),
        SecurityPolicyListLoaded(data: final data) => _buildPolicies(data),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildPolicies(Map<String, dynamic> data) {
    final items = (data['data'] as List<dynamic>?) ?? [];
    if (items.isEmpty) {
      return const PosEmptyState(title: 'No security policies found');
    }

    return RefreshIndicator(
      onRefresh: () async => ref.read(securityPolicyListProvider.notifier).load(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final policy = items[index] as Map<String, dynamic>;
          return _PolicyCard(
            policy: policy,
            onUpdated: () => ref.read(securityPolicyListProvider.notifier).load(),
          );
        },
      ),
    );
  }
}

// ── Policy Card ────────────────────────────────────────────────────────────

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.policy, required this.onUpdated});
  final Map<String, dynamic> policy;
  final VoidCallback onUpdated;

  @override
  Widget build(BuildContext context) {
    final name = _formatPolicyName(policy['policy_key']?.toString() ?? policy['name']?.toString() ?? 'Policy');
    final description = policy['description']?.toString();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      if (description != null)
                        Text(description, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Edit policy',
                  onPressed: () => _showEditDialog(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildPolicyValue(policy),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyValue(Map<String, dynamic> policy) {
    final value = policy['policy_value'] ?? policy['value'];
    if (value is bool) {
      return Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: value ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 6),
          Text(value ? 'Enabled' : 'Disabled', style: const TextStyle(fontSize: 13)),
        ],
      );
    }
    return Text(
      'Value: $value',
      style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
    );
  }

  String _formatPolicyName(String key) {
    return key.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  void _showEditDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _EditPolicyDialog(policy: policy, onUpdated: onUpdated),
    );
  }
}

// ── Edit Policy Dialog ────────────────────────────────────────────────────────

class _EditPolicyDialog extends ConsumerStatefulWidget {
  const _EditPolicyDialog({required this.policy, required this.onUpdated});
  final Map<String, dynamic> policy;
  final VoidCallback onUpdated;

  @override
  ConsumerState<_EditPolicyDialog> createState() => _EditPolicyDialogState();
}

class _EditPolicyDialogState extends ConsumerState<_EditPolicyDialog> {
  late TextEditingController _valueController;
  bool _boolValue = false;
  bool _isBool = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final rawValue = widget.policy['policy_value'] ?? widget.policy['value'];
    _isBool = rawValue is bool;
    if (_isBool) {
      _boolValue = rawValue as bool;
      _valueController = TextEditingController();
    } else {
      _valueController = TextEditingController(text: rawValue?.toString() ?? '');
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  String get _policyName {
    final key = widget.policy['policy_key']?.toString() ?? widget.policy['name']?.toString() ?? 'Policy';
    return key.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit: $_policyName'),
      content: SizedBox(
        width: 360,
        child: _isBool
            ? Row(
                children: [
                  Switch(
                    value: _boolValue,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _boolValue = v),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(_boolValue ? 'Enabled' : 'Disabled'),
                ],
              )
            : PosTextField(
                controller: _valueController,
                label: 'Value',
                hint: 'Enter new value',
                keyboardType: TextInputType.number,
              ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        PosButton(
          label: _loading ? 'Saving…' : 'Save',
          onPressed: _loading ? () {} : _save,
        ),
      ],
    );
  }

  Future<void> _save() async {
    final id = widget.policy['id']?.toString() ?? '';
    if (id.isEmpty) return;

    setState(() => _loading = true);
    final dynamic newValue = _isBool ? _boolValue : _valueController.text.trim();
    final data = <String, dynamic>{'policy_value': newValue};

    await ref.read(securityPolicyActionProvider.notifier).update(id, data);
    final state = ref.read(securityPolicyActionProvider);
    if (mounted) {
      setState(() => _loading = false);
      if (state is SecurityPolicyActionSuccess) {
        showPosSuccessSnackbar(context, 'Policy updated successfully');
        Navigator.pop(context);
        widget.onUpdated();
      } else if (state is SecurityPolicyActionError) {
        showPosErrorSnackbar(context, state.message);
      }
    }
  }
}
