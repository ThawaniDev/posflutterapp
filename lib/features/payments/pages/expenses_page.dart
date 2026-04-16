import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/expense_category.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(expensesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
            onPressed: () => showExpensesInfo(context),
          ),
          FilledButton.icon(
            onPressed: () => _showCreateExpenseDialog(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Expense'),
          ),
          AppSpacing.gapW12,
        ],
      ),
      body: switch (state) {
        ExpensesInitial() || ExpensesLoading() => const Center(child: CircularProgressIndicator()),
        ExpensesError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              AppSpacing.gapH12,
              Text(message),
              AppSpacing.gapH12,
              FilledButton(onPressed: () => ref.read(expensesProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        ExpensesLoaded(:final expenses) =>
          expenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long, size: 64, color: theme.hintColor),
                      AppSpacing.gapH12,
                      Text('No expenses recorded', style: theme.textTheme.titleSmall),
                      AppSpacing.gapH8,
                      Text('Tap + to add an expense', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    ],
                  ),
                )
              : _buildExpenseList(theme, expenses),
      },
    );
  }

  Widget _buildExpenseList(ThemeData theme, List expenses) {
    // Group by date
    final grouped = <String, List>{};
    for (final e in expenses) {
      final key = '${e.expenseDate.day}/${e.expenseDate.month}/${e.expenseDate.year}';
      grouped.putIfAbsent(key, () => []).add(e);
    }

    return ListView.builder(
      padding: AppSpacing.paddingAll16,
      itemCount: grouped.length,
      itemBuilder: (context, index) {
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
                    '${dayTotal.toStringAsFixed(2)} \u0081',
                    style: theme.textTheme.titleSmall?.copyWith(color: AppColors.error),
                  ),
                ],
              ),
            ),
            ...items.map(
              (expense) => Card(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
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
                  trailing: Text(
                    '${expense.amount.toStringAsFixed(2)} \u0081',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.error),
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

  void _showCreateExpenseDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    ExpenseCategory? selectedCategory;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Record Expense'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Amount (\u0081)',
                    border: OutlineInputBorder(),
                    prefixText: '\u0081 ',
                  ),
                  autofocus: true,
                ),
                AppSpacing.gapH16,
                PosSearchableDropdown<ExpenseCategory>(
                  items: ExpenseCategory.values
                      .map((c) => PosDropdownItem(value: c, label: c.value.replaceAll('_', ' '), icon: _categoryIcon(c)))
                      .toList(),
                  selectedValue: selectedCategory,
                  onChanged: (v) => setDialogState(() => selectedCategory = v),
                  label: 'Category',
                  showSearch: false,
                  clearable: false,
                ),
                AppSpacing.gapH16,
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description (optional)', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0 || selectedCategory == null) return;

                ref.read(expensesProvider.notifier).createExpense({
                  'amount': amount,
                  'category': selectedCategory!.value,
                  'description': descriptionController.text.isEmpty ? null : descriptionController.text,
                  'expense_date': DateTime.now().toIso8601String(),
                });
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
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
