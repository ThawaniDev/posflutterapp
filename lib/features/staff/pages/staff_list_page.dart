import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/features/staff/enums/employment_type.dart';
import 'package:thawani_pos/features/staff/enums/salary_type.dart';
import 'package:thawani_pos/features/staff/enums/staff_status.dart';
import 'package:thawani_pos/features/staff/models/staff_user.dart';
import 'package:thawani_pos/features/staff/providers/staff_providers.dart';
import 'package:thawani_pos/features/staff/providers/staff_state.dart';
import 'package:thawani_pos/features/staff/repositories/staff_repository.dart';

class StaffListPage extends ConsumerStatefulWidget {
  const StaffListPage({super.key});

  @override
  ConsumerState<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends ConsumerState<StaffListPage> {
  final _searchController = TextEditingController();
  String? _statusFilter;
  String? _employmentTypeFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadStaff());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadStaff() {
    ref
        .read(staffListProvider.notifier)
        .load(
          search: _searchController.text.isNotEmpty ? _searchController.text : null,
          status: _statusFilter,
          employmentType: _employmentTypeFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Members'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadStaff)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStaffForm(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Staff'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search staff...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadStaff();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _loadStaff(),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip(
                  label: 'All Status',
                  selected: _statusFilter == null,
                  onSelected: () {
                    setState(() => _statusFilter = null);
                    _loadStaff();
                  },
                ),
                for (final status in StaffStatus.values) ...[
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: status.value.replaceAll('_', ' ').toUpperCase(),
                    selected: _statusFilter == status.value,
                    onSelected: () {
                      setState(() => _statusFilter = status.value);
                      _loadStaff();
                    },
                  ),
                ],
                const SizedBox(width: 16),
                const VerticalDivider(),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'All Types',
                  selected: _employmentTypeFilter == null,
                  onSelected: () {
                    setState(() => _employmentTypeFilter = null);
                    _loadStaff();
                  },
                ),
                for (final type in EmploymentType.values) ...[
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: type.value.replaceAll('_', ' ').toUpperCase(),
                    selected: _employmentTypeFilter == type.value,
                    onSelected: () {
                      setState(() => _employmentTypeFilter = type.value);
                      _loadStaff();
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Staff list
          Expanded(
            child: switch (state) {
              StaffListInitial() || StaffListLoading() => const Center(child: CircularProgressIndicator()),
              StaffListError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(msg),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _loadStaff, child: const Text('Retry')),
                  ],
                ),
              ),
              StaffListLoaded(staff: final staff) =>
                staff.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: colorScheme.outline),
                            const SizedBox(height: 16),
                            const Text('No staff members found'),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _loadStaff(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: staff.length,
                          itemBuilder: (context, index) => _StaffCard(
                            staff: staff[index],
                            onTap: () => context.push('/staff/members/${staff[index].id}'),
                            onDelete: () => _confirmDelete(context, staff[index]),
                          ),
                        ),
                      ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool selected, required VoidCallback onSelected}) {
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (_) => onSelected(),
      visualDensity: VisualDensity.compact,
    );
  }

  Future<void> _showStaffForm(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const StaffFormPage()));
    if (result == true) _loadStaff();
  }

  Future<void> _confirmDelete(BuildContext context, StaffUser staff) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Staff'),
        content: Text('Delete ${staff.firstName} ${staff.lastName}? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(staffListProvider.notifier).deleteStaff(staff.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff member deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Staff Card Widget
// ═══════════════════════════════════════════════════════════════

class _StaffCard extends StatelessWidget {
  final StaffUser staff;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _StaffCard({required this.staff, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: staff.photoUrl != null ? NetworkImage(staff.photoUrl!) : null,
                child: staff.photoUrl == null
                    ? Text(
                        '${staff.firstName[0]}${staff.lastName[0]}',
                        style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${staff.firstName} ${staff.lastName}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _StatusBadge(status: staff.status),
                        const SizedBox(width: 8),
                        Text(
                          staff.employmentType.value.replaceAll('_', ' ').toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                        ),
                      ],
                    ),
                    if (staff.email != null) ...[
                      const SizedBox(height: 2),
                      Text(staff.email!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onTap();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'), dense: true),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                      dense: true,
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
}

class _StatusBadge extends StatelessWidget {
  final StaffStatus? status;

  const _StatusBadge({this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      StaffStatus.active => (Colors.green, 'Active'),
      StaffStatus.inactive => (Colors.grey, 'Inactive'),
      StaffStatus.onLeave => (Colors.orange, 'On Leave'),
      null => (Colors.grey, 'Unknown'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Staff Form Page (Create / Edit)
// ═══════════════════════════════════════════════════════════════

class StaffFormPage extends ConsumerStatefulWidget {
  final StaffUser? staff;

  const StaffFormPage({super.key, this.staff});

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
  late EmploymentType _employmentType;
  late SalaryType _salaryType;
  late StaffStatus _status;
  bool _isSubmitting = false;

  bool get _isEditing => widget.staff != null;

  @override
  void initState() {
    super.initState();
    final s = widget.staff;
    _firstNameController = TextEditingController(text: s?.firstName ?? '');
    _lastNameController = TextEditingController(text: s?.lastName ?? '');
    _emailController = TextEditingController(text: s?.email ?? '');
    _phoneController = TextEditingController(text: s?.phone ?? '');
    _nationalIdController = TextEditingController(text: s?.nationalId ?? '');
    _hourlyRateController = TextEditingController(text: s?.hourlyRate?.toString() ?? '');
    _employmentType = s?.employmentType ?? EmploymentType.fullTime;
    _salaryType = s?.salaryType ?? SalaryType.monthly;
    _status = s?.status ?? StaffStatus.active;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Staff' : 'Add Staff Member')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name *', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name *', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Contact
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // National ID
            TextFormField(
              controller: _nationalIdController,
              decoration: const InputDecoration(
                labelText: 'National ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 24),

            // Employment section
            Text('Employment Details', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            DropdownButtonFormField<EmploymentType>(
              initialValue: _employmentType,
              decoration: const InputDecoration(labelText: 'Employment Type *', border: OutlineInputBorder()),
              items: EmploymentType.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.value.replaceAll('_', ' ').toUpperCase())))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _employmentType = v);
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<SalaryType>(
              initialValue: _salaryType,
              decoration: const InputDecoration(labelText: 'Salary Type *', border: OutlineInputBorder()),
              items: SalaryType.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.value.replaceAll('_', ' ').toUpperCase())))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _salaryType = v);
              },
            ),
            const SizedBox(height: 16),

            if (_salaryType == SalaryType.hourly)
              TextFormField(
                controller: _hourlyRateController,
                decoration: const InputDecoration(
                  labelText: 'Hourly Rate',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            if (_salaryType == SalaryType.hourly) const SizedBox(height: 16),

            DropdownButtonFormField<StaffStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status *', border: OutlineInputBorder()),
              items: StaffStatus.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.value.replaceAll('_', ' ').toUpperCase())))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            const SizedBox(height: 32),

            // Submit
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(_isEditing ? Icons.save : Icons.person_add),
              label: Text(_isEditing ? 'Save Changes' : 'Create Staff'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final data = {
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      if (_emailController.text.isNotEmpty) 'email': _emailController.text.trim(),
      if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text.trim(),
      if (_nationalIdController.text.isNotEmpty) 'national_id': _nationalIdController.text.trim(),
      'employment_type': _employmentType.value,
      'salary_type': _salaryType.value,
      'status': _status.value,
      if (_hourlyRateController.text.isNotEmpty) 'hourly_rate': double.tryParse(_hourlyRateController.text),
    };

    try {
      final repo = ref.read(staffRepositoryProvider);
      if (_isEditing) {
        await repo.updateStaff(widget.staff!.id, data);
      } else {
        await repo.createStaff(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_isEditing ? 'Staff updated successfully' : 'Staff created successfully')));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
