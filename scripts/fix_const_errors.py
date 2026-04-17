#!/usr/bin/env python3
"""
Fix const errors: remove 'const' from widgets/lists that contain l10n. calls.
Handles multi-line const constructs where const is on a different line than l10n.
"""
import os
import re
import sys

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def fix_const_errors(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    original = list(lines)
    fixes = 0
    
    # Build a map of which lines use l10n.
    l10n_lines = set()
    for i, line in enumerate(lines):
        if 'l10n.' in line:
            l10n_lines.add(i)
    
    if not l10n_lines:
        return 0
    
    # For each 'const' keyword, check if its construct spans any l10n. line
    # Strategy: find 'const' on a line, then trace the matching braces/brackets
    # to see if any enclosed line contains l10n.
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Find const keywords in this line
        for m in re.finditer(r'\bconst\b', line):
            const_pos = m.start()
            
            # Skip if this is a const variable declaration (const x = ...)
            after = line[const_pos + 5:].strip()
            if after and after[0] in '=;':
                continue
            
            # Find the opening bracket/paren after const
            rest = line[const_pos + 5:]
            
            # Find opening delimiter
            open_delim = None
            open_line = i
            open_col = None
            
            # Scan for opening delimiter
            for j in range(const_pos + 5, len(line)):
                if line[j] in '([':
                    open_delim = line[j]
                    open_col = j
                    break
            
            if open_delim is None:
                # Check next few lines
                for k in range(i + 1, min(i + 3, len(lines))):
                    for j in range(len(lines[k])):
                        if lines[k][j] in '([':
                            open_delim = lines[k][j]
                            open_line = k
                            open_col = j
                            break
                    if open_delim:
                        break
            
            if open_delim is None:
                continue
            
            close_delim = ')' if open_delim == '(' else ']'
            
            # Find matching closing delimiter
            depth = 0
            close_line = None
            for k in range(open_line, len(lines)):
                start_col = open_col if k == open_line else 0
                for j in range(start_col, len(lines[k])):
                    if lines[k][j] == open_delim:
                        depth += 1
                    elif lines[k][j] == close_delim:
                        depth -= 1
                        if depth == 0:
                            close_line = k
                            break
                if close_line is not None:
                    break
            
            if close_line is None:
                continue
            
            # Check if any line in the range uses l10n.
            has_l10n = False
            for k in range(open_line, close_line + 1):
                if k in l10n_lines:
                    has_l10n = True
                    break
            
            if has_l10n:
                # Remove the const keyword
                lines[i] = lines[i][:const_pos] + lines[i][const_pos + 5:]
                # If removed const leaves extra whitespace
                lines[i] = lines[i].replace('  \n', '\n')
                fixes += 1
                break  # Re-process this line in case there are more consts
        
        i += 1
    
    if fixes > 0:
        with open(filepath, 'w') as f:
            f.writelines(lines)
    
    return fixes


def main():
    # Files with const errors (from flutter analyze)
    files = [
        'lib/features/accounting/pages/auto_export_settings_page.dart',
        'lib/features/admin_panel/pages/admin_role_detail_page.dart',
        'lib/features/admin_panel/presentation/pages/admin_fin_ops_accounting_config_list_page.dart',
        'lib/features/admin_panel/presentation/pages/admin_provider_role_template_detail_page.dart',
        'lib/features/backup/widgets/backup_list_widget.dart',
        'lib/features/cashier_gamification/pages/gamification_badges_page.dart',
        'lib/features/hardware/widgets/device_setup_dialog.dart',
        'lib/features/payments/pages/installment_payment_dialog.dart',
        'lib/features/provider_payments/pages/payment_checkout_page.dart',
        'lib/features/reports/pages/dashboard_page.dart',
        'lib/features/reports/pages/sales_summary_page.dart',
        'lib/features/staff/pages/staff_list_page.dart',
        'lib/features/subscription/widgets/plan_comparison_table.dart',
        'lib/features/thawani_integration/pages/thawani_sync_logs_page.dart',
        'lib/features/zatca/widgets/enrollment_wizard.dart',
    ]
    
    total = 0
    for rel in files:
        filepath = os.path.join(PROJECT_ROOT, rel)
        if os.path.exists(filepath):
            n = fix_const_errors(filepath)
            if n:
                print(f"  {rel}: removed {n} const")
                total += n
    
    print(f"\nTotal: removed {total} const keywords")


if __name__ == '__main__':
    main()
