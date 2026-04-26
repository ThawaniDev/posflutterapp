import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/expense_category.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  DateTime? _startDate;
  DateTime? _endDate;
  ExpenseCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(expensesProvider.notifier).load());
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _reload() {
    ref.read(expensesProvider.notifier).load(
          startDate: _startDate != null ? _fmt(_startDate!) : null,
          endDate: _endDate != null ? _fmt(_endDate!) : null,
          category: _selectedCategory?.value,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(expensesProvider);

    return PosListPage(
      title: l10n.expenses,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showExpensesInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.newExpense, icon: Icons.add, onPressed: () => _showCreateExpenseDialog(context)),
      ],
      isLoading: state is ExpensesInitial || state is ExpensesLoading,
      hasError: state is ExpensesError,
      errorMessage: state is ExpensesError ? (state).message : null,
      onRetry: _reload,
      isEmpty: state is ExpensesLoaded && (state).expenses.isEmpty,
      emptyTitle: l10n.noExpensesRecorded,
      emptySubtitle: l10n.tapToAddExpense,
      emptyIcon: Icons.receipt_long,
      child: Column(
        children: [
          // ── Filter bar ──
          _buildFilterBar(theme),

          // ── List ──
          Expanded(
            child: switch (state) {
              ExpensesLoaded(:final expenses, :final hasMore) => _buildExpenseList(theme, expenses, hasMore),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // Category filter
          Expanded(
            child: PosSearchableDropdown<ExpenseCategory>(
              hint: l10n.allCategories,
              items: ExpenseCategory.values
                  .map((c) => PosDropdownItem(value: c, label: c.value.replaceAll('_', ' '), icon: _categoryIcon(c)))
                  .toList(),
              selectedValue: _selectedCategory,
              onChanged: (v) {
                setState(() => _selectedCategory = v);
                _reload();
              },
              label: l10n.category,
              showSearch: false,
              clearable: true,
            ),
          ),
          AppSpacing.gapW8,
          // Date range
          GestureDetector(
            onTap: () => _pickDateRange(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: AppRadius.borderMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.date_range, size: 18, color: theme.hintColor),
                  AppSpacing.gapW8,
                  Text(
                    _startDate != null ? '${_fmt(_startDate!)} – ${_fmt(_endDate!)}' : l10n.paymentListDateRange,
                    style: theme.textTheme.bodySmall?.copyWith(color: _startDate != null ? null : theme.hintColor),
                  ),
                  if (_startDate != null) ...[
                    AppSpacing.gapW4,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                        _reload();
                      },
                      child: Icon(Icons.clear, size: 14, color: theme.hintColor),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList(ThemeData theme, List<Expense> expenses, bool hasMore) {
    // Group by date
    final grouped = <String, List<Expense>>{};
    for (final e in expenses) {
      final key = _fmt(e.expenseDate);
      grouped.putIfAbsent(key, () => []).add(e);
    }

    return ListView.builder(
      padding: AppSpacing.paddingAll16,
      itemCount: grouped.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == grouped.length) {
          return Padding(
            padding: AppSpacing.paddingAll16,
            child: Center(
              child: PosButton(
                label: 'Load more',
                variant: PosButtonVariant.outline,
                onPressed: () => ref.read(expensesProvider.notifier).loadMore(),
              ),
            ),
          );
        }
        final date = grouped.keys.elementAt(index);
        final items = grouped[date]!;
        final dayTotal = items.fold<double>(0, (sum, e) => sum + e.amount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date, style: theme.textTheme.titleSmall),
                  Text(
                    '${dayTotal.toStringAsFixed(2)} \u0631',
                    style: theme.textTheme.titleSmall?.copyWith(color: AppColors.error),
                  ),
                ],
              ),
            ),
            ...items.map(
              (expense) => Dismissible(
                key: ValueKey(expense.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: const Icon(Icons.delete_outline, color: AppColors.error),
                ),
                confirmDismiss: (_) => _confirmDelete(context, expense),
                child: PosCard(
                  borderRadius: AppRadius.borderMd,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _categoryColor(expense.category).withValues(alpha: 0.15),
                      child: Icon(_categoryIcon(expense.category), color: _categoryColor(expense.category), size: 20),
                    ),
                    title: Text(
                      expense.description ?? expense.category.value.replaceAll('_', ' '),
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      expense.category.value.replaceAll('_', ' '),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${expense.amount.toStringAsFixed(2)} \u0631',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.error),
                        ),
                        AppSpacing.gapW4,
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _showEditExpenseDialog(context, expense),
                          visualDensity: VisualDensity.compact,
                          tooltip: l10n.edit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (index < grouped.length - 1) const Divider(height: 24),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, Expense expense) async {
    return showPosConfirmDialog(
      context,
      title: l10n.expenseDeleteTitle,
      message: l10n.expenseDeleteConfirm,
      confirmLabel: l10n.delete,
      isDanger: true,
    );
  }

  void _showCreateExpenseDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    ExpenseCategory? selectedCategory;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.recordExpense),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  label: l10n.paymentsAmountSar,
                  autofocus: true,
                ),
                AppSpacing.gapH16,
                PosSearchableDropdown<ExpenseCategory>(
                  hint: l10n.selectCategory,
                  items: ExpenseCategory.values
                      .map((c) => PosDropdownItem(value: c, label: c.value.replaceAll('_', ' '), icon: _categoryIcon(c)))
                      .toList(),
                  selectedValue: selectedCategory,
                  onChanged: (v) => setDialogState(() => selectedCategory = v),
                  label: l10n.category,
                  showSearch: false,
                  clearable: false,
                ),
                AppSpacing.gapH16,
                PosTextField(controller: descriptionController, maxLines: 2, label: l10n.descriptionOptional),
                AppSpacing.gapH16,
                // Date picker row
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setDialogState(() => selectedDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(ctx).dividerColor),
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        AppSpacing.gapW8,
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: Theme.of(ctx).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
            PosButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0 || selectedCategory == null) return;
                ref.read(expensesProvider.notifier).createExpense({
                  'amount': amount,
                  'category': selectedCategory!.value,
                  'description': descriptionController.text.isEmpty ? null : descriptionController.text,
                  'expense_date': _fmt(selectedDate),
                });
                Navigator.pop(ctx);
              },
              variant: PosButtonVariant.soft,
              label: l10n.save,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditExpenseDialog(BuildContext context, Expense expense) {
    final amountController = TextEditingController(text: expense.amount.toStringAsFixed(2));
    final descriptionController = TextEditingController(text: expense.description ?? '');
    ExpenseCategory selectedCategory = expense.category;
    DateTime selectedDate = expense.expenseDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.expenseEditTitle),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  label: l10n.paymentsAmountSar,
                  autofocus: true,
                ),
                AppSpacing.gapH16,
                PosSearchableDropdown<ExpenseCategory>(
                  hint: l10n.selectCategory,
                  items: ExpenseCategory.values
                      .map((c) => PosDropdownItem(value: c, label: c.value.replaceAll('_', ' '), icon: _categoryIcon(c)))
                      .toList(),
                  selectedValue: selectedCategory,
                  onChanged: (v) => setDialogState(() => selectedCategory = v ?? selectedCategory),
                  label: l10n.category,
                  showSearch: false,
                  clearable: false,
                ),
                AppSpacing.gapH16,
                PosTextField(controller: descriptionController, maxLines: 2, label: l10n.descriptionOptional),
                AppSpacing.gapH16,
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setDialogState(() => selectedDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(ctx).dividerColor),
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        AppSpacing.gapW8,
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: Theme.of(ctx).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
            PosButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0) return;
                ref.read(expensesProvider.notifier).updateExpense(expense.id, {
                  'amount': amount,
                  'category': selectedCategory.value,
                  'description': descriptionController.text.isEmpty ? null : descriptionController.text,
                  'expense_date': _fmt(selectedDate),
                });
                Navigator.pop(ctx);
              },
              label: l10n.save,
            ),
          ],
        ),
      ),
    );
  }

  void _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _reload();
    }
  }

  IconData _categoryIcon(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.supplies => Icons.inventory_2,
      ExpenseCategory.food => Icons.restaurant,
      ExpenseCategory.transport => Icons.local_shipping,
      ExpenseCategory.maintenance => Icons.build,
      ExpenseCategory.utility => Icons.bolt,
      ExpenseCategory.cleaning => Icons.cleaning_services,
      ExpenseCategory.rent => Icons.home,
      ExpenseCategory.salary => Icons.payments,
      ExpenseCategory.marketing => Icons.campaign,
      ExpenseCategory.other => Icons.more_horiz,
    };
  }

  Color _categoryColor(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.supplies => AppColors.info,
      ExpenseCategory.food => AppColors.warning,
      ExpenseCategory.transport => AppColors.primary,
      ExpenseCategory.maintenance => const Color(0xFF8B5CF6),
      ExpenseCategory.utility => AppColors.success,
      ExpenseCategory.cleaning => const Color(0xFF06B6D4),
      ExpenseCategory.rent => const Color(0xFFEC4899),
      ExpenseCategory.salary => const Color(0xFF10B981),
      ExpenseCategory.marketing => const Color(0xFFF59E0B),
      ExpenseCategory.other => const Color(0xFF6B7280),
    };
  }
}

void showExpensesInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showPosInfoDialog(context, title: l10n.expenses, message: l10n.expensesInfoMessage);
}
