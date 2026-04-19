#!/usr/bin/env python3
"""Add proper hint: parameters to all PosSearchableDropdown usages missing them."""

import os
import re

BASE = 'lib'

# ─── Mapping: (relative_file_path, line_number) → hint expression ───
# These are the dropdowns that need hints, mapped to their l10n hint expression.
HINT_MAP = {
    # core
    ('core/widgets/branch_selector.dart', 81): 'l10n.selectBranch',
    
    # accounting
    ('features/accounting/pages/auto_export_settings_page.dart', 174): 'l10n.selectDay',
    
    # payments
    ('features/payments/pages/cash_management_page.dart', 519): 'l10n.selectReason',
    ('features/payments/pages/expenses_page.dart', 146): 'l10n.selectCategory',
    
    # hardware
    ('features/hardware/widgets/device_setup_dialog.dart', 177): 'l10n.selectDeviceType',
    ('features/hardware/widgets/device_setup_dialog.dart', 293): 'l10n.selectBaudRate',
    
    # industry_florist
    ('features/industry_florist/pages/freshness_log_form_page.dart', 93): 'l10n.selectProduct',
    ('features/industry_florist/pages/subscription_form_page.dart', 113): 'l10n.selectCustomer',
    ('features/industry_florist/pages/subscription_form_page.dart', 127): 'l10n.selectFrequency',
    ('features/industry_florist/pages/subscription_form_page.dart', 138): 'l10n.selectDay',
    
    # auth
    ('features/auth/pages/register_page.dart', 169): 'l10n.selectCountry',
    
    # industry_electronics
    ('features/industry_electronics/pages/trade_in_form_page.dart', 103): 'l10n.selectGrade',
    ('features/industry_electronics/pages/trade_in_form_page.dart', 119): 'l10n.selectStaffMember',
    ('features/industry_electronics/pages/imei_record_form_page.dart', 132): 'l10n.selectProduct',
    ('features/industry_electronics/pages/imei_record_form_page.dart', 151): 'l10n.selectGrade',
    ('features/industry_electronics/pages/imei_record_form_page.dart', 168): 'l10n.selectStatus',
    ('features/industry_electronics/pages/repair_job_form_page.dart', 121): 'l10n.selectTechnician',
    
    # industry_jewelry
    ('features/industry_jewelry/pages/buyback_form_page.dart', 93): 'l10n.selectMetalType',
    ('features/industry_jewelry/pages/buyback_form_page.dart', 140): 'l10n.selectPaymentMethod',
    ('features/industry_jewelry/pages/buyback_form_page.dart', 151): 'l10n.selectStaffMember',
    ('features/industry_jewelry/pages/metal_rate_form_page.dart', 87): 'l10n.selectMetalType',
    ('features/industry_jewelry/pages/product_detail_form_page.dart', 121): 'l10n.selectProduct',
    ('features/industry_jewelry/pages/product_detail_form_page.dart', 129): 'l10n.selectMetalType',
    ('features/industry_jewelry/pages/product_detail_form_page.dart', 166): 'l10n.selectChargesType',
    
    # labels
    ('features/labels/pages/label_designer_page.dart', 844): 'l10n.selectFormat',
    ('features/labels/pages/label_print_queue_page.dart', 98): 'l10n.selectTemplate',
    ('features/labels/pages/label_print_queue_page.dart', 405): 'l10n.selectTemplate',
    
    # industry_pharmacy
    ('features/industry_pharmacy/pages/drug_schedule_form_page.dart', 103): 'l10n.selectProduct',
    ('features/industry_pharmacy/pages/drug_schedule_form_page.dart', 111): 'l10n.selectScheduleType',
    
    # debits
    ('features/debits/pages/debit_list_page.dart', 278): 'l10n.selectOrder',
    
    # industry_bakery
    ('features/industry_bakery/pages/recipe_form_page.dart', 105): 'l10n.selectProduct',
    
    # promotions (filter dropdowns)
    ('features/promotions/pages/promotion_list_page.dart', 136): 'l10n.allTypes',
    ('features/promotions/pages/promotion_list_page.dart', 145): 'l10n.allStatuses',
    ('features/promotions/pages/promotion_list_page.dart', 452): 'l10n.selectType',
    
    # support
    ('features/support/pages/create_ticket_page.dart', 73): 'l10n.selectCategory',
    ('features/support/pages/create_ticket_page.dart', 88): 'l10n.selectPriority',
    
    # inventory
    ('features/inventory/pages/purchase_orders_page.dart', 99): 'l10n.allStatuses',
    
    # staff (filter dropdowns)
    ('features/staff/pages/staff_list_page.dart', 152): 'l10n.commonAllBranches',
    ('features/staff/pages/staff_list_page.dart', 165): 'l10n.allStatuses',
    ('features/staff/pages/staff_list_page.dart', 178): 'l10n.allTypes',
    
    # staff (form dropdowns)
    ('features/staff/pages/shift_schedule_page.dart', 358): 'l10n.selectStaffMember',
    ('features/staff/pages/shift_schedule_page.dart', 366): 'l10n.selectTemplate',
    ('features/staff/pages/staff_form_page.dart', 236): 'l10n.selectEmploymentType',
    ('features/staff/pages/staff_form_page.dart', 248): 'l10n.selectSalaryType',
    ('features/staff/pages/staff_form_page.dart', 274): 'l10n.selectStatus',
    ('features/staff/pages/staff_form_page.dart', 398): 'l10n.selectStore',
    ('features/staff/pages/staff_form_page.dart', 446): 'l10n.selectRole',
    ('features/staff/pages/attendance_page.dart', 374): 'l10n.selectStaffMember',
    
    # branches
    ('features/branches/pages/branch_list_page.dart', 70): 'l10n.allStatuses',
    ('features/branches/pages/branch_form_page.dart', 575): 'l10n.selectBusinessType',
    
    # pos_terminal
    ('features/pos_terminal/pages/pos_terminal_form_page.dart', 280): 'l10n.selectPlatform',
    ('features/pos_terminal/pages/pos_terminal_form_page.dart', 390): 'l10n.selectMethod',
    ('features/pos_terminal/pages/pos_terminal_form_page.dart', 426): 'l10n.selectCycle',
    ('features/pos_terminal/pages/pos_open_shift_dialog.dart', 238): 'l10n.selectRegister',
    ('features/pos_terminal/pages/pos_payment_dialog.dart', 421): 'l10n.selectPaymentMethod',
    ('features/pos_terminal/pages/pos_return_dialog.dart', 215): 'l10n.selectPaymentMethod',
    
    # industry_restaurant
    ('features/industry_restaurant/pages/open_tab_form_page.dart', 78): 'l10n.selectOrder',
    ('features/industry_restaurant/pages/open_tab_form_page.dart', 86): 'l10n.selectTable',
    ('features/industry_restaurant/pages/reservation_form_page.dart', 164): 'l10n.selectTable',
    
    # notifications
    ('features/notifications/pages/notification_schedules_page.dart', 47): 'l10n.selectCategory',
    ('features/notifications/pages/notification_schedules_page.dart', 63): 'l10n.selectPriority',
    ('features/notifications/pages/notification_schedules_page.dart', 77): 'l10n.selectChannel',
    ('features/notifications/pages/notification_schedules_page.dart', 90): 'l10n.selectType',
}

def find_constructor_end(lines, start_line_idx):
    """Find the closing ); of a PosSearchableDropdown constructor starting near start_line_idx.
    Returns the line index of the closing paren, or -1."""
    depth = 0
    in_constructor = False
    for i in range(start_line_idx, min(start_line_idx + 60, len(lines))):
        line = lines[i]
        for ch in line:
            if ch == '(':
                depth += 1
                in_constructor = True
            elif ch == ')':
                depth -= 1
                if in_constructor and depth == 0:
                    return i
    return -1


def already_has_hint(lines, start_idx, end_idx):
    """Check if the constructor already has a hint: parameter."""
    for i in range(start_idx, end_idx + 1):
        stripped = lines[i].strip()
        if stripped.startswith('hint:'):
            return True
        if re.search(r'\bhint:', lines[i]):
            return True
    return False


def add_hint_to_constructor(lines, start_idx, end_idx, hint_expr):
    """Add hint: parameter to the PosSearchableDropdown constructor.
    Inserts it right after the opening ( line or after items:/selectedValue: if present."""
    # Find the best insertion point: after the line with PosSearchableDropdown<...>(
    insert_after = start_idx
    
    # Try to find 'items:' or 'selectedValue:' to insert after constructor opening
    for i in range(start_idx, end_idx + 1):
        stripped = lines[i].strip()
        if 'PosSearchableDropdown' in stripped:
            insert_after = i
            break
    
    # Determine indentation from the next line
    if insert_after + 1 < len(lines):
        next_line = lines[insert_after + 1]
        # Match the indentation of existing parameters
        indent_match = re.match(r'^(\s+)', next_line)
        if indent_match:
            indent = indent_match.group(1)
        else:
            indent = '              '
    else:
        indent = '              '
    
    # Insert hint: line after the opening line
    hint_line = f'{indent}hint: {hint_expr},'
    lines.insert(insert_after + 1, hint_line)
    return 1  # number of lines inserted


def process_file(filepath, entries):
    """Process a single file, adding hint: to specified dropdown locations."""
    with open(filepath, 'r') as f:
        content = f.read()
    lines = content.split('\n')
    
    # Sort entries by line number DESCENDING so insertions don't shift later line numbers
    entries_sorted = sorted(entries, key=lambda e: e[0], reverse=True)
    
    changes = 0
    for (target_line, hint_expr) in entries_sorted:
        # target_line is 1-indexed from grep; convert to 0-indexed
        idx = target_line - 1
        
        # Search nearby for the actual PosSearchableDropdown line (may have shifted)
        found_idx = None
        for offset in range(-3, 4):
            check_idx = idx + offset
            if 0 <= check_idx < len(lines) and 'PosSearchableDropdown' in lines[check_idx]:
                found_idx = check_idx
                break
        
        if found_idx is None:
            print(f'  ⚠ Could not find PosSearchableDropdown near line {target_line} in {filepath}')
            continue
        
        end_idx = find_constructor_end(lines, found_idx)
        if end_idx == -1:
            print(f'  ⚠ Could not find constructor end near line {target_line} in {filepath}')
            continue
        
        if already_has_hint(lines, found_idx, end_idx):
            print(f'  → Already has hint at line {target_line} in {filepath}')
            continue
        
        inserted = add_hint_to_constructor(lines, found_idx, end_idx, hint_expr)
        changes += inserted
        print(f'  ✓ Added hint: {hint_expr} at line {target_line}')
    
    if changes > 0:
        with open(filepath, 'w') as f:
            f.write('\n'.join(lines))
    
    return changes


def main():
    # Group entries by file
    file_entries = {}
    for (rel_path, line_num), hint_expr in HINT_MAP.items():
        full_path = os.path.join(BASE, rel_path)
        if full_path not in file_entries:
            file_entries[full_path] = []
        file_entries[full_path].append((line_num, hint_expr))
    
    total_changes = 0
    files_changed = 0
    
    for filepath, entries in sorted(file_entries.items()):
        if not os.path.exists(filepath):
            print(f'⚠ File not found: {filepath}')
            continue
        
        print(f'\n📄 {filepath}')
        changes = process_file(filepath, entries)
        if changes > 0:
            total_changes += changes
            files_changed += 1
    
    print(f'\n✅ Done: {total_changes} hints added across {files_changed} files')


if __name__ == '__main__':
    main()
